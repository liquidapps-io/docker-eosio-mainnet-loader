#!/bin/sh
cd /eos.data
# rm -rf blocks/blocks.index  blocks/reversible state snapshot


# skip if exists
if [ ! -f /eos.data/blocks/blocks.log ]; then
        aws sts get-caller-identity && export HAVE_S3="true"
        if [ "$HAVE_S3" == "true" ]
        then
                aws s3 cp s3://liquideos.mainnet.backup/latest/snapshot.tar.gz snapshot.tar.gz --request-payer requester
                aws s3 cp s3://liquideos.mainnet.backup/latest/blocks_backup.tar.gz blocks_backup.tar.gz --request-payer requester
        else
                url=`wget -q 'https://eosnode.tools/api/snapshots?limit=24' -O - | jq -e '.data[].s3' -r | grep 07-00.tar | head -n 1`
                wget "$url" -O snapshot.tar.gz
                if [ ! -f /eos.data/blocks_backup.tar.gz ]; then
                        wget $(wget --quiet "https://eosnode.tools/api/blocks?limit=1" -O- | jq -r '.data[0].s3') -O blocks_backup.tar.gz
                fi
        fi
        tar xvzf blocks_backup.tar.gz
        tar xvzf snapshot.tar.gz
        rm /eos.data/snapshot.tar.gz
        rm /eos.data/blocks_backup.tar.gz
fi
