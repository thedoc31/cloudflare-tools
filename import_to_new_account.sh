#!/bin/bash

# if using API Token
unset CLOUDFLARE_API_TOKEN
export CLOUDFLARE_API_TOKEN='<your_user_API_token>'

# specify IDs
unset CLOUDFLARE_ACCOUNT_ID
unset CLOUDFLARE_ZONE_ID
export CLOUDFLARE_ACCOUNT_ID='<your_new_cloudflare_account_id>'
export CLOUDFLARE_OLD_ACCOUNT_ID='<your_old_cloudflare_account_id>'
export CLOUDFLARE_ZONE_ID='<your_new_cloudflare_zone_id>'
export CLOUDFLARE_OLD_ZONE_ID='<your_old_cloudflare_zone_id>'
export CLOUDFLARE_EMAIL='<your_account_email_id>'



# Because the original generated file contains resources with the old zone ID, we need to replace it with the new zone ID.
# You can note this step out if you aren't migrating the configuration to a new account.

# If using homebrew on MacOS, you need to install gnu-sed for this command to work. Default sed on MacOS is not the same as on Linux.
if [[ -f /opt/homebrew/opt/gnu-sed/libexec/gnubin/sed ]]; then
    /opt/homebrew/opt/gnu-sed/libexec/gnubin/sed -i "s/$CLOUDFLARE_OLD_ZONE_ID/$CLOUDFLARE_ZONE_ID/g" old_account_config.tf
else
    sed -i "s/$CLOUDFLARE_OLD_ZONE_ID/$CLOUDFLARE_ZONE_ID/g" old_account_config.tf
    sed -i "s/$CLOUDFLARE_OLD_ZONE_ID/$CLOUDFLARE_ZONE_ID/g" old_account_zone_config.tf
    sed -i "s/$CLOUDFLARE_OLD_ACCOUNT_ID/$CLOUDFLARE_ACCOUNT_ID/g" old_account_config.tf
    sed -i "s/$CLOUDFLARE_OLD_ACCOUNT_ID/$CLOUDFLARE_ACCOUNT_ID/g" old_account_zone_config.tf
fi

# Terraform 1.5+ only
while read resource || [[ -n $resource ]]; do cf-terraforming import --resource-type $resource --modern-import-block --email $CLOUDFLARE_EMAIL --key $CLOUDFLARE_API_KEY --zone $CLOUDFLARE_ZONE_ID; done < cf_import_resource_types.txt >cloudflare_import_blocks.tfstate

terraform plan -generate-config-out=generated.tf

terraform apply
