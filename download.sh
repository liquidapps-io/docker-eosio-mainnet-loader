#!/bin/bash
url=`wget -q 'https://eosnode.tools/api/snapshots?limit=24' -O - | jq -e '.data[].s3' -r | grep 07-00.tar | head -n 1`
wget "$url" -O snapshot.tar.gz

wget $(wget --quiet "https://eosnode.tools/api/blocks?limit=1" -O- | jq -r '.data[0].s3') -O blocks_backup.tar.gz
aws s3 cp blocks_backup.tar.gz s3://liquideos.mainnet.backup/latest/blocks_backup.tar.gz --acl public-read
aws s3 cp snapshot.tar.gz s3://liquideos.mainnet.backup/latest/snapshot.tar.gz --acl public-read