# cloudflare-tools
Cloudflare cf-terraforming scripts and support files for dumping an entire config set from one Cloudflare account and reloading it into a completely new Cloudflare account.

I could not find a comprehensive way to do this in any online forums, so I created one. It's simple and likely has problems I can't predict with my use case, but it works for my needs. PRs welcome. Please direct questions about the tools themselves to their respective owners.

## Prerequisites 

[Terraform installed and initialized](https://developer.hashicorp.com/terraform/install)

[Cloudflare cf-terraforming installed](https://github.com/cloudflare/cf-terraforming#installation)

**The resource type text files are current as of October 09, 2024. You probably want to double-check the list below to make sure they're still accurate.**

## Resources
Terraform Cloudflare Provider API Docs: https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs

Current list of supported providers: https://github.com/cloudflare/cf-terraforming#supported-resources
