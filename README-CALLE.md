# Here's how we do it

Build...

```shell
bundle exec jekyll build
```

..and sync

```shell
cd _site
aws s3 sync  . s3://cmoberg.com

aws cloudfront create-invalidation --distribution-id E1LJ06HIETFXKH --paths "/*"
```
