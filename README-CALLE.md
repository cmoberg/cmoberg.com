# Here's how we do it

## Deploy script

Use `./deploy.sh` to build the site, sync `_site/` to S3, and invalidate CloudFront.

```shell
./deploy.sh
```

### Options

```shell
./deploy.sh --dry-run   # s3 sync --dryrun, no invalidation
./deploy.sh --no-build  # skip bundle exec jekyll build
```

### Environment overrides

```shell
S3_BUCKET=cmoberg.com \
CLOUDFRONT_DISTRIBUTION_ID=E1LJ06HIETFXKH \
AWS_PROFILE=personal \
./deploy.sh
```

## Manual steps (old school)

Build...

```shell
bundle exec jekyll build
```

..and sync

```shell
cd _site
aws s3 sync . s3://cmoberg.com

aws cloudfront create-invalidation --distribution-id E1LJ06HIETFXKH --paths "/*"
```
