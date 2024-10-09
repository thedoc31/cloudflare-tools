#!/bin/bash

# if using API Token
export CLOUDFLARE_API_TOKEN='<your_user_API_token>'

# specify zone ID
export CLOUDFLARE_ZONE_ID='<your_new_cloudflare_zone_id>'
export CLOUDFLARE_EMAIL='<your_account_email_id>'

# Terraform 1.5+ only
while read resource || [[ -n $resource ]]; do cf-terraforming import --resource-type $resource --modern-import-block --email $CLOUDFLARE_EMAIL --key $CLOUDFLARE_API_KEY --zone $CLOUDFLARE_ZONE_ID; done < cf_import_resource_types.txt 2>&1 | tee -a import_results.txt
