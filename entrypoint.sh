#!/bin/sh

# todo, skip if exists
mkdir /eos.data.staging
cd /eos.data.staging
rm -rf blocks/blocks.index  blocks/reversible state snapshot

url=`wget -q 'https://eosnode.tools/api/snapshots?limit=24' -O - | jq -e '.data[].s3' -r | grep 07-00.tar | head -n 1`
wget "$url" -O - | tar xzf -

if [ ! -f /eos.data.staging/blocks/blocks.log ]; then
        if [ ! -f /eos.data.staging/blocks_backup.tar.gz ]; then
                wget $(wget --quiet "https://eosnode.tools/api/blocks?limit=1" -O- | jq -r '.data[0].s3') -O blocks_backup.tar.gz
        fi
        tar xvzf blocks_backup.tar.gz
fi

set -x
set -e

rm /eos.data.staging/blocks_backup.tar.gz
cp -a /eos.data.staging /eos.data
#rm /eos.data.staging/* -rf