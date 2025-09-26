#!/usr/bin/env bash
set -euo pipefail

### ── CONFIGURAZIONE ─────────────────────────────────────────────────────────────
APP_NAME="kpm-basic-xapp"
APP_VERSION="1.0.0"
NAMESPACE="ricxapp"

# venv dms
DMS_VENV="${HOME}/.venvs/dms"

# directory con config-file.json e schema.json
CONFIG_DIR="${HOME}/xDevSM-xapps-examples/kpm_basic_xapp/config"

# chart repo locale
export CHART_REPO_URL="http://127.0.0.1:8090"

### ── UTILS ─────────────────────────────────────────────────────────────────────
log(){ printf "\n\033[1;36m▶ %s\033[0m\n" "$*"; }
die(){ printf "\n\033[1;31m✖ %s\033[0m\n" "$*" >&2; exit 1; }

need(){
  command -v "$1" >/dev/null 2>&1 || die "Comando richiesto non trovato: $1"
}

### ── CHECK PRE-REQUISITI ───────────────────────────────────────────────────────
need python3
need curl
need helm
need kubectl
# dms_cli sarà nel venv; lo verifichiamo dopo l’attivazione

[[ -f "${CONFIG_DIR}/config-file.json" ]] || die "Manca ${CONFIG_DIR}/config-file.json"
[[ -f "${CONFIG_DIR}/schema.json"      ]] || die "Manca ${CONFIG_DIR}/schema.json"

### ── 1) ATTIVA LA VENV DMS SE NON È GIÀ ATTIVA ────────────────────────────────
if [[ -z "${VIRTUAL_ENV:-}" || "${VIRTUAL_ENV}" != "${DMS_VENV}" ]]; then
  log "Attivo la venv: ${DMS_VENV}"
  [[ -f "${DMS_VENV}/bin/activate" ]] || die "Venv non trovata in ${DMS_VENV}"
  # shellcheck disable=SC1090
  source "${DMS_VENV}/bin/activate"
else
  log "Venv già attiva: ${VIRTUAL_ENV}"
fi

need dms_cli

### ── 2) ONBOARD CON dms_cli E IMPOSTA CHART_REPO_URL ──────────────────────────
log "CHART_REPO_URL=${CHART_REPO_URL}"
# (opzionale) verifica che il repo risponda
if ! curl -fsS "${CHART_REPO_URL}/health" >/dev/null 2>&1; then
  log "Avviso: ${CHART_REPO_URL}/health non risponde. Proseguo comunque con l'onboard."
fi

log "Eseguo: dms_cli onboard config-file.json schema.json"
pushd "${CONFIG_DIR}" >/dev/null
dms_cli onboard "config-file.json" "schema.json"
popd >/dev/null

### ── 3) SCARICA IL PACCHETTO DELL’APP (via Helm dal repo locale) ──────────────
# Useremo Helm perché ChartMuseum espone un repo compatibile Helm.
log "Aggiungo/aggiorno repo Helm locale: ${CHART_REPO_URL}"
helm repo add local-cm "${CHART_REPO_URL}" 2>/dev/null || helm repo add local-cm "${CHART_REPO_URL}"
helm repo update

DIST_DIR="./dist_charts"
mkdir -p "${DIST_DIR}"
log "Scarico il chart: ${APP_NAME}-${APP_VERSION}.tgz"
helm pull "local-cm/${APP_NAME}" --version "${APP_VERSION}" -d "${DIST_DIR}"

CHART_TGZ="${DIST_DIR}/${APP_NAME}-${APP_VERSION}.tgz"
[[ -f "${CHART_TGZ}" ]] || die "Chart non scaricato: ${CHART_TGZ} non trovato"

### ── 4) DISINSTALLA SE GIÀ PRESENTE, INSTALLA E ROLLOUT ───────────────────────
if helm -n "${NAMESPACE}" list -q | grep -Fxq "${APP_NAME}"; then
  log "Disinstallo release esistente: ${APP_NAME} (namespace: ${NAMESPACE})"
  helm -n "${NAMESPACE}" uninstall "${APP_NAME}" --wait
fi

log "Installo release: ${APP_NAME} ${APP_VERSION} su namespace ${NAMESPACE}"
helm -n "${NAMESPACE}" install "${APP_NAME}" "${CHART_TGZ}" --wait

# Rollout: riavvia tutti i deployment del namespace (o solo quelli dell’app, se preferisci)
log "Rollout restart dei Deployment in ${NAMESPACE}"
kubectl -n "${NAMESPACE}" rollout restart deployment

log "Attendo che i Deployment tornino in stato Ready…"
# Attende lo stato di tutti i deployment nel namespace
mapfile -t DEPLOYS < <(kubectl -n "${NAMESPACE}" get deploy -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}')
for d in "${DEPLOYS[@]}"; do
  [[ -n "$d" ]] || continue
  log "▶ rollout status: ${d}"
  kubectl -n "${NAMESPACE}" rollout status "deployment/${d}" --timeout=180s
done

log "FATTO ✅  App: ${APP_NAME}  Versione: ${APP_VERSION}  Namespace: ${NAMESPACE}"
