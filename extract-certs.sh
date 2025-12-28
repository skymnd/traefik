#!/usr/bin/env bash

# This script is intended to loop through the
# acme.json provided by traefik and extract
# the certs for use in other services, e.g.
# authentik
# 
# It will be set to run as a cron once per day
# as certs will be updated 30 days before
# renewal.
#
# A separate helper will copy the certs to
# to relevant host.

# To fail correctly
set -euo pipefail

ACME_JSON="/home/md/letsencrypt/acme.json"
OUT_DIR="/home/md/extracted-certs"

mkdir -p "$OUT_DIR"

# use jq to extract field to tsv for easy
# parsing since tabs won't appear in domain,
# cert, or key
jq -r '
  .le.Certificates[] |
  [
    .domain.main,
    .certificate,
    .key
  ] | @tsv
' "$ACME_JSON" | while IFS=$'\t' read -r domain cert key; do
    cert_file="$OUT_DIR/${domain}.crt"
    key_file="$OUT_DIR/${domain}.key"

    echo "Extracting certificate for ${domain}"

    # Decode certificate
    echo "$cert" | base64 -d > "$cert_file"

    # Decode private key (not needed for authentik,
    # but sometimes needed elsewhere)
    echo "$key" | base64 -d > "$key_file"

    chmod 644 "$cert_file"
    chmod 600 "$key_file"
done
