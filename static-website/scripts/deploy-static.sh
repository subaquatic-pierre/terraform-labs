#!/bin/sh
set -e

BUCKET=$(terraform output -raw bucket_name)
DISTRIBUTION_ID=$(terraform output -raw cloudfront_id)

echo "Deploying to bucket: ${BUCKET}"

aws s3 sync ./apps/example-website/ "s3://${BUCKET}" --delete

echo "Creating CloudFront invalidation: ${DISTRIBUTION_ID}"

aws cloudfront create-invalidation \
	--distribution-id "${DISTRIBUTION_ID}" \
	--paths "/*" \
	--no-cli-pager
