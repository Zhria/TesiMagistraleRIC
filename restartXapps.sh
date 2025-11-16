#!/usr/bin/env bash
set -euo pipefail

# ── costanti principali ─────────────────────────────────────────────────────────
NAMESPACE="ricxapp"
CHARTMUSEUM_PORT="8090"
CHARTMUSEUM_URL="http://127.0.0.1:${CHARTMUSEUM_PORT}"
CHARTMUSEUM_CONTAINER="chartmuseum"
CHARTMUSEUM_IMAGE="chartmuseum/chartmuseum:latest"
CHARTMUSEUM_STORAGE="${HOME}/charts"

DMS_VENV="${HOME}/.venvs/dms"
BASE_ROOT="${HOME}/xDevSM-xapps-examples"
WORK_ROOT="$(pwd)"

declare -A APP_CONFIGS=(
 # ["kpm-basic-xapp"]="${BASE_ROOT}/kpm_basic_xapp/config"
  ["ho-control-xapp"]="${BASE_ROOT}/ho_xapp/config"
)
declare -A APP_IMAGES=(
#  ["kpm-basic-xapp"]="zhria/kpm_app"
  ["ho-control-xapp"]="zhria/handover_app"
)
declare -A APP_DOCKERFILES=(
#  ["kpm-basic-xapp"]="${BASE_ROOT}/docker/Dockerfile.kpm_basic_xapp"
  ["ho-control-xapp"]="${BASE_ROOT}/docker/Dockerfile.rc_ho_control.dev"
)
#ALL_APPS=("kpm-basic-xapp" "ho-control-xapp")
ALL_APPS=("ho-control-xapp")

SEMVER_REGEX='^[0-9]+\.[0-9]+\.[0-9]+$'

# ── utils ───────────────────────────────────────────────────────────────────────
log(){ printf '\n[%s] %s\n' "$(date +'%H:%M:%S')" "$*"; }
warn(){ printf '\n[%s] WARNING: %s\n' "$(date +'%H:%M:%S')" "$*" >&2; }
usage(){
  cat <<'USAGE'
Usage: restartXapps.sh [options]
  -kpm   Riavvia solo kpm-basic-xapp
  -ho    Riavvia solo ho-control-xapp
  -n     Non esegue il build/push delle immagini (riusa la versione attuale)
  -v X   Forza la versione X (es. 0.0.70)
  -h     Mostra questo messaggio
Se non vengono passate opzioni, verranno gestite entrambe le xApp.
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

version_gt(){
  local left="$1"
  local right="$2"
  [[ "${left}" == "${right}" ]] && return 1
  local highest
  highest="$(printf '%s\n%s\n' "${left}" "${right}" | sort -V | tail -n 1)"
  [[ "${highest}" == "${left}" ]]
}

extract_tag_from_config(){
  local config_file="$1"
  python3 - "$config_file" <<'PY' 2>/dev/null || true
import json
import sys
from pathlib import Path

path = Path(sys.argv[1])
if not path.exists():
    sys.exit(0)

try:
    data = json.loads(path.read_text())
except Exception:
    sys.exit(0)

for container in data.get("containers", []):
    image = container.get("image") or {}
    tag = image.get("tag")
    if tag:
        print(tag)
        break
PY
}

determine_current_version(){
  local apps=("$@")
  if [[ ${#apps[@]} -eq 0 ]]; then
    apps=("${ALL_APPS[@]}")
  fi
  local latest="0.0.0"
  local app config_dir config_file tag
  for app in "${apps[@]}"; do
    config_dir="${APP_CONFIGS[$app]}"
    config_file="${config_dir}/config-file.json"
    [[ -f "${config_file}" ]] || continue
    tag="$(extract_tag_from_config "${config_file}" | head -n1 || true)"
    if [[ "${tag}" =~ ${SEMVER_REGEX} ]] && version_gt "${tag}" "${latest}"; then
      latest="${tag}"
    fi
  done
  printf '%s\n' "${latest}"
}

determine_latest_available_image_version(){
  local apps=("$@")
  if [[ ${#apps[@]} -eq 0 ]]; then
    apps=("${ALL_APPS[@]}")
  fi

  need docker
  local total="${#apps[@]}"
  local -A tag_counts=()
  local app repo tag
  for app in "${apps[@]}"; do
    repo="${APP_IMAGES[$app]:-}"
    if [[ -z "${repo}" ]]; then
      warn "Repository immagine non configurato per ${app}; impossibile cercare la versione disponibile."
      printf '\n'
      return
    fi
    local -A seen_tag=()
    while IFS= read -r tag; do
      [[ -n "${tag}" && "${tag}" != "<none>" ]] || continue
      [[ "${tag}" =~ ${SEMVER_REGEX} ]] || continue
      if [[ -z "${seen_tag[$tag]:-}" ]]; then
        seen_tag["${tag}"]=1
        tag_counts["${tag}"]=$(( ${tag_counts["${tag}"]:-0} + 1 ))
      fi
    done < <(docker images "${repo}" --format '{{.Tag}}' 2>/dev/null || true)
  done

  local best=""
  for tag in "${!tag_counts[@]}"; do
    if [[ "${tag_counts[$tag]:-0}" -eq "${total}" ]]; then
      if [[ -z "${best}" ]] || version_gt "${tag}" "${best}"; then
        best="${tag}"
      fi
    fi
  done

  printf '%s\n' "${best}"
}

increment_patch_version(){
  local version="$1"
  if [[ ! "${version}" =~ ${SEMVER_REGEX} ]]; then
    version="0.0.0"
  fi
  IFS='.' read -r major minor patch <<< "${version}"
  patch=$((patch + 1))
  printf '%d.%d.%d\n' "${major}" "${minor}" "${patch}"
}

update_app_config(){
  local config_file="$1"
  local version="$2"
  python3 - "$config_file" "$version" <<'PY'
import json
import sys
from pathlib import Path

config_path = Path(sys.argv[1])
version = sys.argv[2]

data = json.loads(config_path.read_text())
data["version"] = version
for container in data.get("containers", []):
    image = container.get("image")
    if isinstance(image, dict):
        image["tag"] = version

config_path.write_text(json.dumps(data, indent=4) + "\n")
PY
}

cleanup_old_local_images(){
  local keep_version="$1"
  shift || true
  local apps=("$@")
  if [[ ${#apps[@]} -eq 0 ]]; then
    apps=("${ALL_APPS[@]}")
  fi
  need docker
  local app repo
  for app in "${apps[@]}"; do
    repo="${APP_IMAGES[$app]}"
    while IFS=' ' read -r image_id tag; do
      [[ -n "${image_id}" && -n "${tag}" ]] || continue
      if [[ "${tag}" == "<none>" ]]; then
        docker rmi "${image_id}" >/dev/null 2>&1 || warn "Impossibile rimuovere immagine dangling ${image_id}"
        continue
      fi
      if [[ "${tag}" =~ ${SEMVER_REGEX} && "${tag}" != "${keep_version}" ]]; then
        docker rmi "${repo}:${tag}" >/dev/null 2>&1 || warn "Impossibile rimuovere ${repo}:${tag}"
      fi
    done < <(docker images "${repo}" --format '{{.ID}} {{.Tag}}' || true)
  done
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

  need docker

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

  # attende che risponda
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
      warn "Errore nel cancellare ${app}-${version} (HTTP ${status}): $(<\"${tmp}\")"
      ;;
  esac

  rm -f "${tmp}"
}

build_and_push_images(){
  local version="$1"
  shift || true
  local apps=("$@")
  if [[ ${#apps[@]} -eq 0 ]]; then
    apps=("${ALL_APPS[@]}")
  fi
  need docker

  local app image dockerfile
  for app in "${apps[@]}"; do
    image="${APP_IMAGES[$app]}"
    dockerfile="${APP_DOCKERFILES[$app]}"
    log "Build & push immagine ${app} (tag ${version})"
    docker build --no-cache \
      -f "${dockerfile}" \
      -t "${image}:${version}" \
      -t "${image}:latest" \
      "${BASE_ROOT}"
    docker push "${image}:${version}"
    done
}

# ── flusso principale ───────────────────────────────────────────────────────────
SKIP_BUILD=false
FORCED_VERSION=""
TARGET_APPS=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    -kpm) TARGET_APPS+=("kpm-basic-xapp") ;;
    -ho) TARGET_APPS+=("ho-control-xapp") ;;
    -n) SKIP_BUILD=true ;;
    -v)
      shift
      FORCED_VERSION="${1:-}"
      if [[ -z "${FORCED_VERSION}" ]]; then
        warn "Opzione -v richiede una versione (es. 0.0.70)"
        usage
        exit 1
      fi
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      warn "Opzione non riconosciuta: $1"
      usage >&2
      exit 1
      ;;
  esac
  shift
done

if [[ ${#TARGET_APPS[@]} -eq 0 ]]; then
  TARGET_APPS=("${ALL_APPS[@]}")
else
  # dedup
  declare -A _seen=()
  filtered_apps=()
  for app in "${TARGET_APPS[@]}"; do
    if [[ -z "${_seen[$app]:-}" ]]; then
      _seen[$app]=1
      filtered_apps+=("${app}")
    fi
  done
  TARGET_APPS=("${filtered_apps[@]}")
fi

if [[ ${#TARGET_APPS[@]} -eq 0 ]]; then
  warn "Nessuna xApp selezionata."
  exit 1
fi

need helm
need curl
need python3

log "Disinstallo le xApps selezionate (ignoro errori)"
for app in "${TARGET_APPS[@]}"; do
  helm -n "${NAMESPACE}" uninstall "${app}" >/dev/null 2>&1 || true
done

ensure_chartmuseum

current_version="$(determine_current_version "${TARGET_APPS[@]}")"
next_version="${current_version}"

if [[ -n "${FORCED_VERSION}" ]]; then
  if [[ ! "${FORCED_VERSION}" =~ ${SEMVER_REGEX} ]]; then
    warn "Versione non valida specificata con -v: ${FORCED_VERSION}"
    exit 1
  fi
  next_version="${FORCED_VERSION}"
  if [[ "${SKIP_BUILD}" == "true" ]]; then
    log "Build saltato (-n), uso versione specificata ${next_version}"
  else
    log "Uso versione specificata ${next_version} per build/push"
  fi
elif [[ "${SKIP_BUILD}" == "true" ]]; then
  available_version="$(determine_latest_available_image_version "${TARGET_APPS[@]}")"
  if [[ -n "${available_version}" && version_gt "${available_version}" "${current_version}" ]]; then
    next_version="${available_version}"
    log "Versione precedente: ${current_version}; build saltato (-n), uso la versione disponibile ${next_version}"
  else
    log "Versione precedente: ${current_version}; build saltato (-n), nessuna versione piu' recente rilevata (uso ${next_version})"
  fi
else
  next_version="$(increment_patch_version "${current_version}")"
  log "Versione precedente: ${current_version}; nuova versione: ${next_version}"
fi

if [[ "${SKIP_BUILD}" != "true" ]]; then
  build_and_push_images "${next_version}" "${TARGET_APPS[@]}"
  log "Rimuovo immagini locali obsolete"
  cleanup_old_local_images "${next_version}" "${TARGET_APPS[@]}"
fi

activate_venv
need dms_cli

export CHART_REPO_URL="${CHARTMUSEUM_URL}"
log "CHART_REPO_URL=${CHART_REPO_URL}"

for app in "${TARGET_APPS[@]}"; do
  config_dir="${APP_CONFIGS[$app]}"
  version="${next_version}"
  config_file="${config_dir}/config-file.json"
  schema_file="${config_dir}/schema.json"
  if [[ ! -f "${config_file}" || ! -f "${schema_file}" ]]; then
    warn "Config o schema mancanti per ${app} in ${config_dir}, salto."
    continue
  fi

  update_app_config "${config_file}" "${version}"
  if ! prepare_helm_template_dir "${app}"; then
    warn "Salto install per ${app} finché /tmp/helm_template non è sistemata."
    continue
  fi

  ensure_local_chart_package "${app}" "${version}"

  log "Uninstall ${app} tramite dms_cli (ignoro errori)"
  dms_cli uninstall "${app}" "${NAMESPACE}" >/dev/null 2>&1 || true

  delete_chart_from_repo "${app}" "${version}"

  log "Onboard ${app} (versione ${version})"
  dms_cli onboard "${config_file}" "${schema_file}"

  log "Install ${app} su namespace ${NAMESPACE}"
  dms_cli install "${app}" "${version}" "${NAMESPACE}"
done

log "Operazione completata."
