#!/usr/bin/env bash
set -euo pipefail

S3_BUCKET="${S3_BUCKET:-cmoberg.com}"
CLOUDFRONT_DISTRIBUTION_ID="${CLOUDFRONT_DISTRIBUTION_ID:-E1LJ06HIETFXKH}"
DRY_RUN=false
NO_BUILD=false

for arg in "$@"; do
  case $arg in
    --dry-run) DRY_RUN=true ;;
    --no-build) NO_BUILD=true ;;
    *) echo "Unknown option: $arg"; exit 1 ;;
  esac
done

if [ "$NO_BUILD" = false ]; then
  echo "Building site..."
  npm run build
fi

SYNC_OPTS="--delete"
if [ "$DRY_RUN" = true ]; then
  SYNC_OPTS="$SYNC_OPTS --dryrun"
fi

AWS_CMD="aws"
if [ -n "${AWS_PROFILE:-}" ]; then
  AWS_CMD="aws --profile $AWS_PROFILE"
fi

echo "Syncing to s3://$S3_BUCKET ..."
$AWS_CMD s3 sync dist/ "s3://$S3_BUCKET" $SYNC_OPTS --exclude "*.DS_Store"

if [ "$DRY_RUN" = false ]; then
  echo "Invalidating CloudFront distribution $CLOUDFRONT_DISTRIBUTION_ID ..."
  $AWS_CMD cloudfront create-invalidation \
    --distribution-id "$CLOUDFRONT_DISTRIBUTION_ID" \
    --paths "/*"
fi

echo "Done."
