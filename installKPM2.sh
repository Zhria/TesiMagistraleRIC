#!/usr/bin/env bash
set -euo pipefail

### ── CONFIG ────────────────────────────────────────────────────────────────────
APP_NAME="kpm-basic-xapp"
APP_VERSION="1.0.0"
NAMESPACE="ricxapp"

DMS_VENV="${HOME}/.venvs/dms"
CONFIG_DIR="${HOME}/xDevSM-xapps-examples/kpm_basic_xapp/config"

export CHART_REPO_URL="http://127.0.0.1:8090"

# cartella dove salvo il .tgz del chart
DIST_DIR="./dist_charts"

### ── UTILS ─────────────────────────────────────────────────────────────────────
log(){ printf "\n\033[1;36m▶ %s\033[0m\n" "$*"; }
warn(){ printf "\n\033[1;33m! %s\033[0m\n" "$*"; }
die(){ printf "\n\033[1;31m✖ %s\033[0m\n" "$*" >&2; exit 1; }
need(){ command -v "$1" >/dev/null 2>&1 || die "Comando richiesto non trovato: $1"; }

### ── PRE-REQ ───────────────────────────────────────────────────────────────────
need python3; need curl; need helm; need kubectl
[[ -f "${CONFIG_DIR}/config-file.json" ]] || die "Manca ${CONFIG_DIR}/config-file.json"
[[ -f "${CONFIG_DIR}/schema.json"      ]] || die "Manca ${CONFIG_DIR}/schema.json"

### ── 1) VENV ───────────────────────────────────────────────────────────────────
if [[ -z "${VIRTUAL_ENV:-}" || "${VIRTUAL_ENV}" != "${DMS_VENV}" ]]; then
  log "Attivo venv: ${DMS_VENV}"
  [[ -f "${DMS_VENV}/bin/activate" ]] || die "Venv non trovata in ${DMS_VENV}"
  # shellcheck disable=SC1090
  source "${DMS_VENV}/bin/activate"
else
  log "Venv già attiva: ${VIRTUAL_ENV}"
fi
need dms_cli

### ── 2) ONBOARD & CHART_REPO_URL ───────────────────────────────────────────────
log "CHART_REPO_URL=${CHART_REPO_URL}"
if ! curl -fsS "${CHART_REPO_URL}/health" >/dev/null 2>&1; then
  warn "${CHART_REPO_URL}/health non risponde (continuo lo stesso, ma helm/pull fallirà se il repo non è up)."
fi

log "Eseguo: dms_cli onboard config-file.json schema.json"
pushd "${CONFIG_DIR}" >/dev/null
dms_cli onboard "config-file.json" "schema.json"
popd >/dev/null

### ── 3) RESET HARD di Helm repo/cache e chart locale ───────────────────────────
log "Pulizia repo Helm 'local-cm' e cache"
# rimuovi la repo se esiste (ignora errori)
helm repo remove local-cm >/dev/null 2>&1 || true

# pulisci cache helm relativa (path predefiniti)
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/helm"
rm -f  "${CACHE_DIR}/repository/local-cm-index.yaml" 2>/dev/null || true
rm -f  "${CACHE_DIR}/repository/cache/local-cm-index.yaml" 2>/dev/null || true
# a volte helm salva l’index con hostname-port nel nome:
rm -f  "${CACHE_DIR}/repository/"*127.0.0.1*8090* 2>/dev/null || true
rm -f  "${CACHE_DIR}/repository/cache/"*127.0.0.1*8090* 2>/dev/null || true

# ricrea la repo da zero
log "Aggiungo repo Helm: local-cm -> ${CHART_REPO_URL}"
helm repo add local-cm "${CHART_REPO_URL}"
helm repo update

# pulisci e ricrea la cartella dei pacchetti
rm -rf "${DIST_DIR}"
mkdir -p "${DIST_DIR}"

log "Scarico il chart: ${APP_NAME}-${APP_VERSION}.tgz"
helm pull "local-cm/${APP_NAME}" --version "${APP_VERSION}" -d "${DIST_DIR}"
CHART_TGZ="${DIST_DIR}/${APP_NAME}-${APP_VERSION}.tgz"
[[ -f "${CHART_TGZ}" ]] || die "Chart non scaricato: ${CHART_TGZ} non trovato"

### ── 4) DISINSTALL → INSTALL → ROLLOUT ─────────────────────────────────────────
log "Creo namespace se manca: ${NAMESPACE}"
kubectl get ns "${NAMESPACE}" >/dev/null 2>&1 || kubectl create namespace "${NAMESPACE}"

log "Disinstallo eventuale release esistente: ${APP_NAME}"
helm -n "${NAMESPACE}" uninstall "${APP_NAME}" --wait >/dev/null 2>&1 || true

log "Installo release: ${APP_NAME} ${APP_VERSION} su ${NAMESPACE}"
helm -n "${NAMESPACE}" install "${APP_NAME}" "${CHART_TGZ}" --wait

log "Rollout restart dei Deployment in ${NAMESPACE}"
kubectl -n "${NAMESPACE}" rollout restart deployment

log "Attendo i Deployment Ready…"
mapfile -t DEPLOYS < <(kubectl -n "${NAMESPACE}" get deploy -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}')
for d in "${DEPLOYS[@]}"; do
  [[ -n "$d" ]] || continue
  log "▶ rollout status: ${d}"
  kubectl -n "${NAMESPACE}" rollout status "deployment/${d}" --timeout=180s
done

log "FATTO ✅  App: ${APP_NAME}  Versione: ${APP_VERSION}  Namespace: ${NAMESPACE}"
