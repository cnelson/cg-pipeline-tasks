#!/bin/bash
# vim: set ft=sh

set -e

#
# A little environment validation
#
if [ -z "$BOSH_TARGET" ]; then
  echo "must specify \$BOSH_TARGET" >&2
  exit 1
fi
if [ -z "$BOSH_USERNAME" ]; then
  echo "must specify \$BOSH_USERNAME" >&2
  exit 1
fi
if [ -z "$BOSH_PASSWORD" ]; then
  echo "must specify \$BOSH_PASSWORD" >&2
  exit 1
fi
if [ -z "$BOSH_DEPLOYMENT_NAME" ]; then
  echo "must specify \$BOSH_DEPLOYMENT_NAME" >&2
  exit 1
fi
if [ -z "$BOSH_ERRAND" ]; then
  echo "must specify \$BOSH_ERRAND" >&2
  exit 1
fi
if [ -z "$BOSH_CACERT" ]; then
  echo "must specify \$BOSH_CACERT" >&2
  exit 1
fi
#
# Run the errand for the appropriate deployment
#
bosh --ca-cert $BOSH_CACERT -n target $BOSH_TARGET
bosh login <<EOF 1>/dev/null
$BOSH_USERNAME
$BOSH_PASSWORD
EOF
bosh -n download manifest $BOSH_DEPLOYMENT_NAME ${BOSH_DEPLOYMENT_NAME}.yml
bosh -n deployment ${BOSH_DEPLOYMENT_NAME}.yml
bosh -n run errand $BOSH_ERRAND
