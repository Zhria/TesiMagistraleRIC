#!/usr/bin/env bash
set -euo pipefail

# ── configurazione principale ─────────────────────────────────────────────────
NAMESPACE="ricxapp"
APP_NAME="ho-control-xapp"
IMAGE_REPO="docker.io/zhria/handover_app"

CHARTMUSEUM_PORT="8090"
CHARTMUSEUM_URL="http://127.0.0.1:${CHARTMUSEUM_PORT}"
CHARTMUSEUM_CONTAINER="chartmuseum"
CHARTMUSEUM_IMAGE="chartmuseum/chartmuseum:latest"
CHARTMUSEUM_STORAGE="${HOME}/charts"

DMS_VENV="${HOME}/.venvs/dms"
BASE_ROOT="${HOME}/xDevSM-xapps-examples"
CONFIG_DIR="${BASE_ROOT}/ho_xapp/config"
CONFIG_FILE="${CONFIG_DIR}/config-file.json"
SCHEMA_FILE="${CONFIG_DIR}/schema.json"
WORK_ROOT="$(pwd)"

# ── utilità ───────────────────────────────────────────────────────────────────
log(){ printf '\n[%s] %s\n' "$(date +'%H:%M:%S')" "$*"; }
warn(){ printf '\n[%s] WARNING: %s\n' "$(date +'%H:%M:%S')" "$*" >&2; }
usage(){
  cat <<USAGE
Usage: restartXapps.sh
  Questo script reinstalla ho-control-xapp usando sempre l'immagine
  ${IMAGE_REPO} con il tag indicato nel config-file.json di ho_xapp.
  Non sono supportate altre opzioni.
USAGE
}

need(){
  if ! command -v "$1" >/dev/null 2>&1; then
    warn "Comando richiesto non trovato: $1"
    exit 1
  fi
}

ensure_chartmuseum_storage(){
  mkdir -p "${CHARTMUSEUM_STORAGE}"
  if [[ ! -w "${CHARTMUSEUM_STORAGE}" ]]; then
    need docker
    log "Adeguo permessi di ${CHARTMUSEUM_STORAGE}"
    docker run --rm \
      -v "${CHARTMUSEUM_STORAGE}:/charts" \
      alpine sh -c "chown -R $(id -u):$(id -g) /charts" >/dev/null 2>&1 || true
  fi
}

ensure_chartmuseum(){
  ensure_chartmuseum_storage
  need docker
  local desired_user="$(id -u):$(id -g)"
  local current_user=""
  if docker ps -a --format '{{.Names}}' | grep -Fxq "${CHARTMUSEUM_CONTAINER}"; then
    current_user="$(docker inspect -f '{{.Config.User}}' "${CHARTMUSEUM_CONTAINER}" 2>/dev/null || echo "")"
  fi

  log "Verifico ChartMuseum su ${CHARTMUSEUM_URL}"
  if curl -fsS "${CHARTMUSEUM_URL}/health" >/dev/null 2>&1; then
    if [[ "${current_user}" != "${desired_user}" ]]; then
      warn "ChartMuseum in esecuzione con utente ${current_user:-root}; lo riavvio con ${desired_user}"
      docker rm -f "${CHARTMUSEUM_CONTAINER}" >/dev/null 2>&1 || true
    else
      log "ChartMuseum risponde su ${CHARTMUSEUM_URL}"
      return
    fi
  fi

  if docker ps --format '{{.Names}}' | grep -Fxq "${CHARTMUSEUM_CONTAINER}"; then
    warn "Container ${CHARTMUSEUM_CONTAINER} in esecuzione ma non risponde; provo a riavviarlo"
    docker rm -f "${CHARTMUSEUM_CONTAINER}" >/dev/null 2>&1 || true
  elif docker ps -a --format '{{.Names}}' | grep -Fxq "${CHARTMUSEUM_CONTAINER}"; then
    docker rm "${CHARTMUSEUM_CONTAINER}" >/dev/null 2>&1 || true
  fi

  local publish_ids
  publish_ids="$(docker ps --filter "publish=${CHARTMUSEUM_PORT}" --format '{{.ID}}')"
  if [[ -n "${publish_ids}" ]]; then
    warn "Rilevati container sulla porta ${CHARTMUSEUM_PORT}, li rimuovo"
    while read -r cid; do
      [[ -n "${cid}" ]] || continue
      docker rm -f "${cid}" >/dev/null 2>&1 || true
    done <<< "${publish_ids}"
  fi

  log "Avvio ChartMuseum docker sulla porta ${CHARTMUSEUM_PORT}"
  docker run -d --restart unless-stopped \
    --name "${CHARTMUSEUM_CONTAINER}" \
    --user "$(id -u):$(id -g)" \
    -p "${CHARTMUSEUM_PORT}:8080" \
    -e STORAGE="local" \
    -e STORAGE_LOCAL_ROOTDIR="/charts" \
    -v "${CHARTMUSEUM_STORAGE}:/charts" \
    "${CHARTMUSEUM_IMAGE}" >/dev/null

  for _ in {1..10}; do
    sleep 1
    if curl -fsS "${CHARTMUSEUM_URL}/health" >/dev/null 2>&1; then
      log "ChartMuseum avviato correttamente"
      return
    fi
  done

  warn "ChartMuseum non risponde dopo l'avvio; verifica manualmente lo stato del container."
}

activate_venv(){
  if [[ -z "${VIRTUAL_ENV:-}" || "${VIRTUAL_ENV}" != "${DMS_VENV}" ]]; then
    if [[ ! -f "${DMS_VENV}/bin/activate" ]]; then
      warn "Virtualenv non trovata in ${DMS_VENV}"
      exit 1
    fi
    # shellcheck disable=SC1090
    source "${DMS_VENV}/bin/activate"
    log "Attivata la venv dms (${DMS_VENV})"
  else
    log "Venv già attiva (${VIRTUAL_ENV})"
  fi
}

prepare_helm_template_dir(){
  local app="$1"
  local dir="/tmp/helm_template"

  if [[ -d "${dir}" && ! -w "${dir}" ]]; then
    warn "Directory ${dir} non scrivibile; provo a cambiarne i permessi"
    need docker
    docker run --rm \
      -v "${dir}:/target" \
      alpine sh -c "chown -R $(id -u):$(id -g) /target" >/dev/null 2>&1 || {
        warn "Impossibile modificare ${dir}; rimuovi la directory manualmente."
        return 1
      }
  fi

  if [[ -d "${dir}/${app}" && ! -w "${dir}/${app}" ]]; then
    warn "Directory ${dir}/${app} non scrivibile; provo a cambiarne i permessi"
    need docker
    docker run --rm \
      -v "${dir}:/target" \
      alpine sh -c "chown -R $(id -u):$(id -g) \"/target/${app}\"" >/dev/null 2>&1 || warn "Impossibile modificare ${dir}/${app}"
  fi

  if [[ -d "${dir}/${app}" ]]; then
    rm -rf "${dir:?}/${app}"
  fi

  mkdir -p "${dir}"
}

ensure_local_chart_package(){
  local app="$1"
  local version="$2"
  local pkg="${WORK_ROOT}/${app}-${version}.tgz"

  if [[ -e "${pkg}" && ! -w "${pkg}" ]]; then
    warn "File ${pkg} non scrivibile; provo a cambiarne i permessi"
    need docker
    docker run --rm \
      -v "${WORK_ROOT}:/target" \
      alpine sh -c "chown $(id -u):$(id -g) \"/target/${app}-${version}.tgz\"" >/dev/null 2>&1 || warn "Impossibile correggere ${pkg}, lo elimino"
  fi

  if [[ -e "${pkg}" && ! -w "${pkg}" ]]; then
    rm -f "${pkg}" >/dev/null 2>&1 || warn "Non riesco a rimuovere ${pkg}; potrebbe dare errore in dms_cli"
  fi
}

delete_chart_from_repo(){
  local app="$1"
  local version="$2"
  local url="${CHARTMUSEUM_URL}/api/charts/${app}/${version}"
  local tmp status

  tmp="$(mktemp)"
  status="$(curl -sS -o "${tmp}" -w "%{http_code}" -X DELETE "${url}" || true)"

  case "${status}" in
    200|202|204)
      log "Rimosso chart ${app}-${version} da ChartMuseum"
      ;;
    404)
      log "Nessun chart precedente da rimuovere per ${app}-${version}"
      ;;
    0)
      warn "Impossibile contattare ChartMuseum per cancellare ${app}-${version}"
      ;;
    *)
      warn "Errore nel cancellare ${app}-${version} (HTTP ${status}): $(<"${tmp}")"
      ;;
  esac

  rm -f "${tmp}"
}

read_version_from_config(){
  python3 - "${CONFIG_FILE}" <<'PY'
import json
import sys
from pathlib import Path

config = Path(sys.argv[1])
if not config.exists():
    sys.exit(1)

data = json.loads(config.read_text())

containers = data.get("containers", [])
for container in containers:
    image = container.get("image") or {}
    tag = image.get("tag")
    if tag:
        print(tag)
        sys.exit(0)

tag = data.get("version")
if tag:
    print(tag)
PY
}

pull_app_image(){
  local version="$1"
  need docker
  log "Recupero immagine ${IMAGE_REPO}:${version} da Docker Hub"
  docker pull "${IMAGE_REPO}:${version}"
}

# ── esecuzione principale ─────────────────────────────────────────────────────
if [[ $# -gt 0 ]]; then
  case "$1" in
    -h|--help)
      usage
      exit 0
      ;;
    *)
      warn "Opzione non supportata: $1"
      usage >&2
      exit 1
      ;;
  esac
fi

need helm
need curl
need python3
need docker

if [[ ! -f "${CONFIG_FILE}" ]]; then
  warn "Config mancante: ${CONFIG_FILE}"
  exit 1
fi

if [[ ! -f "${SCHEMA_FILE}" ]]; then
  warn "Schema mancante: ${SCHEMA_FILE}"
  exit 1
fi

version="$(read_version_from_config || true)"
if [[ -z "${version}" ]]; then
  warn "Impossibile determinare il tag dal config ${CONFIG_FILE}"
  exit 1
fi

pull_app_image "${version}"

log "Disinstallo ${APP_NAME} tramite helm (ignoro errori)"
helm -n "${NAMESPACE}" uninstall "${APP_NAME}" >/dev/null 2>&1 || true

ensure_chartmuseum

if ! prepare_helm_template_dir "${APP_NAME}"; then
  warn "Impossibile preparare /tmp/helm_template"
  exit 1
fi

ensure_local_chart_package "${APP_NAME}" "${version}"

activate_venv
need dms_cli

export CHART_REPO_URL="${CHARTMUSEUM_URL}"
log "CHART_REPO_URL=${CHART_REPO_URL}"

log "Uninstall ${APP_NAME} tramite dms_cli (ignoro errori)"
dms_cli uninstall "${APP_NAME}" "${NAMESPACE}" >/dev/null 2>&1 || true

delete_chart_from_repo "${APP_NAME}" "${version}"

log "Onboard ${APP_NAME} (versione ${version})"
dms_cli onboard "${CONFIG_FILE}" "${SCHEMA_FILE}"

log "Install ${APP_NAME} su namespace ${NAMESPACE}"
dms_cli install "${APP_NAME}" "${version}" "${NAMESPACE}"

log "Operazione completata."
