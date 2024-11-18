#!/bin/bash

# if using API Token
unset CLOUDFLARE_API_TOKEN
export CLOUDFLARE_API_TOKEN='<your_api_token>'

# specify IDs
unset CLOUDFLARE_ACCOUNT_ID
unset CLOUDFLARE_ZONE_IDS
export CLOUDFLARE_NEW_ACCOUNT_ID='<your_new_account_id>'
export CLOUDFLARE_NEW_ZONE_IDS=('<your_zone_id_1>' '<your_zone_id_2>' '<your_zone_id_n>')
export CLOUDFLARE_EMAIL='you@wherever.com'

echo "Removing old tfstate files from current path..."
rm -f *.tfstate

# Because the original generated file contains resources with the old zone and account IDs, we need to replace them with the new zone/account IDs.
# You can note this step out if you aren't migrating the configuration to a new account.
for accountfile in $(ls -1 *_account_config.tf); do
    if [[ -s $accountfile ]]; then
        CLOUDFLARE_ACCOUNT_ID=$(echo "$accountfile" | cut -d'_' -f1)
        echo "Attempting import of account $CLOUDFLARE_ACCOUNT_ID..."
        echo "Transforming $CLOUDFLARE_ACCOUNT_ID to $CLOUDFLARE_NEW_ACCOUNT_ID..."
        if [[ -f /opt/homebrew/opt/gnu-sed/libexec/gnubin/sed ]]; then
            /opt/homebrew/opt/gnu-sed/libexec/gnubin/sed -i "s/$CLOUDFLARE_ACCOUNT_ID/$CLOUDFLARE_NEW_ACCOUNT_ID/g" "$accountfile"
        else
            sed -i "s/$CLOUDFLARE_ACCOUNT_ID/$CLOUDFLARE_NEW_ACCOUNT_ID/g" "$accountfile"
        fi
    else
        echo "WARN: Account file is empty or does not exist."
    fi
    echo .
    echo .
    echo "Beginning import of resources for account $CLOUDFLARE_NEW_ACCOUNT_ID..."
    while read resource || [[ -n "$resource" ]]; do cf-terraforming import --resource-type "$resource" --modern-import-block --email "$CLOUDFLARE_EMAIL" --key "$CLOUDFLARE_API_KEY" --token "$CLOUDFLARE_API_TOKEN" --account "$CLOUDFLARE_NEW_ACCOUNT_ID"; done < cf_import_resource_types.txt >"${accountfile}_account_blocks.tfstate"
done

counter=0
for zonefile in $(ls -1 *_zone_config.tf); do
    if [[ -s $zonefile ]]; then
        CLOUDFLARE_ZONE_ID=$(echo "$zonefile" | cut -d'_' -f1)
        CLOUDFLARE_NEW_ZONE_ID=${CLOUDFLARE_NEW_ZONE_IDS[$counter]}
        echo "Attempting import of zone $CLOUDFLARE_ZONE_ID..."
        echo "Transforming $CLOUDFLARE_ZONE_ID to $CLOUDFLARE_NEW_ZONE_ID..."
        if [[ -f /opt/homebrew/opt/gnu-sed/libexec/gnubin/sed ]]; then
            /opt/homebrew/opt/gnu-sed/libexec/gnubin/sed -i "s/$CLOUDFLARE_ZONE_ID/$CLOUDFLARE_NEW_ZONE_ID/g" "$zonefile"
        else
            sed -i "s/$CLOUDFLARE_ZONE_ID/$CLOUDFLARE_NEW_ZONE_ID/g" "$zonefile"
        fi
    else
        echo "WARN: Zone file $zonefile is empty or does not exist."
    fi
    echo .
    echo .
    echo "Beginning import of resources for zone $CLOUDFLARE_NEW_ZONE_ID..."
    while read resource || [[ -n "$resource" ]]; do cf-terraforming import --resource-type "$resource" --modern-import-block --email "$CLOUDFLARE_EMAIL" --key "$CLOUDFLARE_API_KEY" --zone "$CLOUDFLARE_NEW_ZONE_ID" --token "$CLOUDFLARE_API_TOKEN"; done < cf_import_resource_types.txt >"${zonefile}_zone_blocks.tfstate"
    counter=$((counter + 1))
done

echo "Now you need to correct any errors during the cf-terraforming imports, make any necessary adjustments to the generated configs, then run terraform plan and terraform apply to see what happens."
