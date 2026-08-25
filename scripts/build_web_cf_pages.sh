#!/usr/bin/env bash
set -euo pipefail

cf_flutter_version="${FLUTTER_VERSION:-3.35.6}"
cf_flutter_sdk_dir="${CF_FLUTTER_SDK_DIR:-${HOME}/.cache/flutter-${cf_flutter_version}}"
cf_api_base_url="${API_BASE_URL:-https://jntest.lonnet.uk}"

if [[ ! -x "${cf_flutter_sdk_dir}/bin/flutter" ]]; then
  mkdir -p "${HOME}/.cache"
  git clone \
    --branch "${cf_flutter_version}" \
    --depth 1 \
    https://github.com/flutter/flutter.git \
    "${cf_flutter_sdk_dir}"
fi

export PATH="${cf_flutter_sdk_dir}/bin:${PATH}"

flutter config --no-analytics
flutter pub get
flutter build web \
  --release \
  --no-wasm-dry-run \
  --dart-define="API_BASE_URL=${cf_api_base_url}"
