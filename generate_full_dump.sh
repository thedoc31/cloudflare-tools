#!/bin/bash

# if using API Token
unset CLOUDFLARE_API_TOKEN
export CLOUDFLARE_API_TOKEN='<your_api_token>'
export CLOUDFLARE_EMAIL='you@wherever.com'

# All the configs which require just the account id

unset CLOUDFLARE_ZONE_ID # force unset the zone ID because only zone or account can be specified at runtime
export CLOUDFLARE_ACCOUNT_ID='<your_account_id>'

# Lists and such are account-specific, should limit these to a proper list of resources
if [[ -s "${CLOUDFLARE_ACCOUNT_ID}_account_config.tf" ]]; then
    echo .
    echo .
    echo "  WARN:  ${CLOUDFLARE_ACCOUNT_ID}_account_config.tf already exists; skipping account export."
else
    echo "Generating ${CLOUDFLARE_ACCOUNT_ID}_account_config.tf..."
    while read resource || [[ -n $resource ]]; do
        cf-terraforming generate --resource-type "$resource" --account "$CLOUDFLARE_ACCOUNT_ID";
    done < cf_generate_account_resource_scopes.txt> "${CLOUDFLARE_ACCOUNT_ID}_account_config.tf"
fi

# specify zone IDs
unset CLOUDFLARE_ACCOUNT_ID # force unset the account ID because only zone or account can be specified at runtime
CLOUDFLARE_ZONE_IDS=('<your_zone_id_1>' '<your_zone_id_2>' '<your_zone_id_n>')

# Loop through each zone ID
for CLOUDFLARE_ZONE_ID in "${CLOUDFLARE_ZONE_IDS[@]}"; do
    # All the configs which require zone
    if [[ -s "${CLOUDFLARE_ZONE_ID}_zone_config.tf" ]]; then
        echo .
        echo .
        echo "  WARN:  ${CLOUDFLARE_ZONE_ID}_zone_config.tf already exists; it will be replaced."
        rm -f ${CLOUDFLARE_ZONE_ID}_zone_config.tf
    fi
    echo .
    echo .
    echo "Generating ${CLOUDFLARE_ZONE_ID}_zone_config.tf..."
    while read -r resource || [[ -n $resource ]]; do
        cf-terraforming generate --resource-type "$resource" --zone "$CLOUDFLARE_ZONE_ID";
    done < cf_generate_zone_required_resource_scopes.txt> "${CLOUDFLARE_ZONE_ID}_zone_config.tf"
done

