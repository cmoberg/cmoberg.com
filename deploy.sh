#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="${SCRIPT_DIR}"

S3_BUCKET="${S3_BUCKET:-cmoberg.com}"
CLOUDFRONT_DISTRIBUTION_ID="${CLOUDFRONT_DISTRIBUTION_ID:-E1LJ06HIETFXKH}"
AWS_PROFILE="${AWS_PROFILE:-}"

DRY_RUN=false
SKIP_BUILD=false

usage() {
  cat <<'EOF'
Usage: ./deploy.sh [options]

Builds the Jekyll site, syncs _site/ to S3, then invalidates CloudFront.

Options:
  --dry-run        Run S3 sync with --dryrun; skip invalidation
  --no-build       Skip 'bundle exec jekyll build'
  -h, --help       Show this help

Environment overrides:
  S3_BUCKET                       (default: cmoberg.com)
  CLOUDFRONT_DISTRIBUTION_ID      (default: E1LJ06HIETFXKH)
  AWS_PROFILE                     (optional)

Examples:
  ./deploy.sh
  S3_BUCKET=my-bucket ./deploy.sh
  AWS_PROFILE=personal ./deploy.sh
  ./deploy.sh --dry-run
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    --no-build)
      SKIP_BUILD=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

cd "${REPO_ROOT}"

if ! command -v aws >/dev/null 2>&1; then
  echo "Missing dependency: aws (AWS CLI)" >&2
  exit 1
fi

if ! command -v bundle >/dev/null 2>&1; then
  echo "Missing dependency: bundle (Bundler)" >&2
  exit 1
fi

AWS_ARGS=()
if [[ -n "${AWS_PROFILE}" ]]; then
  AWS_ARGS+=(--profile "${AWS_PROFILE}")
fi

if [[ "${SKIP_BUILD}" == false ]]; then
  echo "Building Jekyll site..."
  bundle exec jekyll build
fi

if [[ ! -d "_site" ]]; then
  echo "Expected build output directory '_site' not found." >&2
  exit 1
fi

SYNC_ARGS=(--delete)
if [[ "${DRY_RUN}" == true ]]; then
  SYNC_ARGS+=(--dryrun)
fi

echo "Syncing _site/ to s3://${S3_BUCKET} ..."
aws "${AWS_ARGS[@]+"${AWS_ARGS[@]}"}" s3 sync "_site" "s3://${S3_BUCKET}" "${SYNC_ARGS[@]}"

if [[ "${DRY_RUN}" == true ]]; then
  echo "Dry run complete; skipping CloudFront invalidation."
  exit 0
fi

echo "Creating CloudFront invalidation for ${CLOUDFRONT_DISTRIBUTION_ID} ..."
aws "${AWS_ARGS[@]+"${AWS_ARGS[@]}"}" cloudfront create-invalidation \
  --distribution-id "${CLOUDFRONT_DISTRIBUTION_ID}" \
  --paths "/*"

echo "Deployment complete."
