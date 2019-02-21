#!/bin/bash

wget $(wget --quiet "https://eosnode.tools/api/bundle" -O- | jq -r '.data.snapshot.s3') -O snapshot.tar.gz
wget $(wget --quiet "https://eosnode.tools/api/bundle" -O- | jq -r '.data.block.s3') -O blocks_backups.tar.gz

aws s3 cp blocks_backup.tar.gz s3://liquideos.mainnet.backup/latest/blocks_backup.tar.gz --acl public-read
aws s3 cp snapshot.tar.gz s3://liquideos.mainnet.backup/latest/snapshot.tar.gz --acl public-read
