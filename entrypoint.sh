#!/bin/bash

aws sts get-caller-identity && export HAVE_S3="true"

cd /eos.data
if [ "$CLEAR_ALL" == "true" ]
then
        rm -rf /eos.data/* || true
fi

if [ "$DOWNLOAD_NEW" == "true" ]
then
        wget $(wget --quiet "https://eosnode.tools/api/bundle" -O- | jq -r '.data.snapshot.s3') -O snapshot.tar.gz
        wget $(wget --quiet "https://eosnode.tools/api/bundle" -O- | jq -r '.data.block.s3') -O blocks_backups.tar.gz
        aws s3 cp blocks_backup.tar.gz s3://liquideos.mainnet.backup/latest/blocks_backup.tar.gz --acl public-read
        aws s3 cp snapshot.tar.gz s3://liquideos.mainnet.backup/latest/snapshot.tar.gz --acl public-read
        rm -rf /eos.data/blocks/snapshots /eos.data/blocks /eos.data/state || true
else
        if [ "$CLEAR_DB" == "true" ]
        then
                rm -rf blocks/blocks.index  blocks/reversible state
        fi
fi

# skip if exists
if [ ! -f /eos.data/blocks/blocks.log ]; then
        if [ "$DOWNLOAD_NEW" == "true" ]
        then
                echo skip download
        else
                if [ "$HAVE_S3" == "true" ]
                then
                        aws s3 cp s3://liquideos.mainnet.backup/latest/snapshot.tar.gz /eos.data/snapshot.tar.gz --request-payer requester
                        aws s3 cp s3://liquideos.mainnet.backup/latest/blocks_backup.tar.gz /eos.data/blocks_backup.tar.gz --request-payer requester
                else
                        wget $(wget --quiet "https://eosnode.tools/api/bundle" -O- | jq -r '.data.snapshot.s3') -O /eos.data/snapshot.tar.gz
                        if [ ! -f /eos.data/blocks_backup.tar.gz ]; then
                                wget $(wget --quiet "https://eosnode.tools/api/blocks?limit=1" -O- | jq -r '.data[0].s3') -O /eos.data/blocks_backup.tar.gz
                        fi
                fi
        fi
        tar xvzf /eos.data/blocks_backup.tar.gz
        tar xvzf /eos.data/snapshot.tar.gz
        rm /eos.data/snapshot.tar.gz
        rm /eos.data/blocks_backup.tar.gz
fi
