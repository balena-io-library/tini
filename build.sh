#!/bin/bash
set -ex
set -o pipefail

# set env var
TAR_FILE=tini$TINI_VERSION.linux-$ARCH.tar.gz

cd /usr/src/tini
git checkout "$TINI_COMMIT"
cmake . && make
tar -cvzf $TAR_FILE tini

curl -SLO "http://resin-packages.s3.amazonaws.com/SHASUMS256.txt"
sha256sum $TAR_FILE >> SHASUMS256.txt

# Upload to S3 (using AWS CLI)
printf "$ACCESS_KEY\n$SECRET_KEY\n$REGION_NAME\n\n" | aws configure
aws s3 cp $TAR_FILE s3://$BUCKET_NAME/tini/v$TINI_VERSION/
aws s3 cp SHASUMS256.txt s3://$BUCKET_NAME/
