#!/bin/bash
set -euo pipefail

log(){ printf '\n[%s] %s\n' "$(date +'%H:%M:%S')" "$*"; }
die(){ printf 'ERRORE: %s\n' "$*" >&2; exit 1; }
need(){ command -v "$1" >/dev/null 2>&1 || die "Comando richiesto non trovato: $1"; }
usage(){
  cat <<'EOF'
Uso: ./pusha.sh [-b] [messaggio commit]
  -b    Esegue anche il build/push della ho_xapp (default: solo git)
EOF
}

SEMVER_REGEX='^[0-9]+\.[0-9]+\.[0-9]+$'

increment_patch_version(){
  local version="$1"
  if [[ ! "${version}" =~ ${SEMVER_REGEX} ]]; then
    version="0.0.0"
  fi
  IFS='.' read -r major minor patch <<< "${version}"
  patch=$((patch + 1))
  printf '%d.%d.%d\n' "${major}" "${minor}" "${patch}"
}

read_config_version(){
  local config_file="$1"
  python3 - "$config_file" <<'PY' 2>/dev/null || true
import json
import sys
from pathlib import Path

config_path = Path(sys.argv[1])
try:
    data = json.loads(config_path.read_text())
except Exception:
    sys.exit(0)

version = data.get("version") or ""
for container in data.get("containers", []):
    image = container.get("image")
    if isinstance(image, dict):
        tag = image.get("tag")
        if tag:
            version = tag
            break

if version:
    print(version)
PY
}

write_config_version(){
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

BUILD_IMAGE=false
while getopts ":bh" opt; do
  case "${opt}" in
    b) BUILD_IMAGE=true ;;
    h)
      usage
      exit 0
      ;;
    \?)
      die "Opzione non valida: -${OPTARG}"
      ;;
  esac
done
shift $((OPTIND - 1))

COMMIT_MSG="${1:-push automatico}"
SCRIPT_DIR="$(cd -- "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_ROOT="${SCRIPT_DIR}/xDevSM-xapps-examples"
CONFIG_FILE="${BASE_ROOT}/ho_xapp/config/config-file.json"
DOCKERFILE="${BASE_ROOT}/docker/Dockerfile.rc_ho_control.dev"
IMAGE_REPO="zhria/handover_app"

if [[ "${BUILD_IMAGE}" == "true" ]]; then
  need docker
  need python3
  [[ -d "${BASE_ROOT}" ]] || die "Directory ${BASE_ROOT} non trovata."
  [[ -f "${CONFIG_FILE}" ]] || die "File ${CONFIG_FILE} non trovato."
  [[ -f "${DOCKERFILE}" ]] || die "File ${DOCKERFILE} non trovato."

  CURRENT_VERSION="$(read_config_version "${CONFIG_FILE}")"
  if [[ -z "${CURRENT_VERSION}" ]]; then
    CURRENT_VERSION="0.0.0"
    log "Versione non trovata in config, inizializzo a ${CURRENT_VERSION}"
  fi
  IMAGE_VERSION="$(increment_patch_version "${CURRENT_VERSION}")"
  write_config_version "${CONFIG_FILE}" "${IMAGE_VERSION}"
  log "Aggiornato config-file.json: ${CURRENT_VERSION} -> ${IMAGE_VERSION}"

  log "Build immagine ${IMAGE_REPO}:${IMAGE_VERSION}"
  docker build \
    -f "${DOCKERFILE}" \
    -t "${IMAGE_REPO}:${IMAGE_VERSION}" \
    -t "${IMAGE_REPO}:latest" \
    "${BASE_ROOT}"

  log "Carico immagine su Docker Hub"
  docker push "${IMAGE_REPO}:${IMAGE_VERSION}"
  docker push "${IMAGE_REPO}:latest"
else
  log "Build non richiesto (usa -b per abilitarlo)"
fi

need git
log "Aggiorno repository git"
git add .
if git diff --cached --quiet; then
  log "Nessuna modifica da committare."
else
  git commit -m "${COMMIT_MSG}"
fi
git push
