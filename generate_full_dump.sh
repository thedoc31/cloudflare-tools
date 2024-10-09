#!/bin/bash

# if using API Token
export CLOUDFLARE_API_TOKEN='<your_user_API_token>'

# specify zone ID
export CLOUDFLARE_ZONE_ID='<your_old_cloudflare_zone_id>'

# loop through every resource in the cf_generate_resource_types.txt and redirect the output to a new .tf file
# If you get errors, your user API token may not have permissions to those resources
# Check https://github.com/cloudflare/cf-terraforming for current supported resource types for generate
while read resource || [[ -n $resource ]]; do cf-terraforming generate --resource-type $resource --zone $CLOUDFLARE_ZONE_ID; done < cf_generate_resource_types.txt> old_account_config.tf
