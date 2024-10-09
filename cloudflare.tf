terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "~> 4"
    }
  }
}

provider "cloudflare" {
  api_token = "<REDACTED>"
}

variable "zone_id" {
  default = "<REDACTED>"
}

variable "account_id" {
  default = "<REDACTED>"
}

variable "domain" {
  default = "yourdomain.com"
}
