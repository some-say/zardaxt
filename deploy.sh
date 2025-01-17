#!/bin/bash

# add your env variables into a file .env
source .env

# sync webapp
rsync --chown www-data:www-data --exclude-from "$LOCAL_DIR/exclude.txt" \
 -Pav -e "ssh -i $SSH_PRIV_KEY" $LOCAL_DIR $SERVER:$BASE_DIR

# copy Pipfile-Server pipfile
scp -i $SSH_PRIV_KEY Pipfile-Server $SERVER:$BASE_DIR/Pipfile

# copy environment file
scp -i $SSH_PRIV_KEY tcpip_fp.env $SERVER:$BASE_DIR/tcpip_fp.env

ssh -i $SSH_PRIV_KEY $SERVER << EOF
  cd tcp_fingerprint/;
  pipenv install
  ./restart.sh
EOF

echo "Deployed TCP/IP fingerprint"
