# mastodon-on-kubernetes
Collection of code to run [Mastodon](https://github.com/mastodon/mastodon) server on [Kubernetes](https://kubernetes.io/) with [Flux CD](https://fluxcd.io/) & [Terraform](https://www.terraform.io/).

See the whole configuration with instructions in the [article on SoftwareMill's blog](https://softwaremill.com/running-mastodon-server-on-kubernetes/).

## Prerequisites

## Structure
The structure is based on [Flux monorepo](https://fluxcd.io/flux/guides/repository-structure/#monorepo) approach:
- apps/base/mastodon - contains Mastodon Helm release with configuration
- modules/mastodon - re-usable Terraform module for the [Google Storage Bucket](https://cloud.google.com/storage/docs/creating-buckets) with HMAC keys and Service Account

## Mastodon server configuration
The `apps/base/mastodon` directory contains manifests for deploying Mastodon server. Provide the neccessary configuration for the Helm Chart in the `values.yaml` file.  

## Terraform module
To use Terraform module in your root module call the child module `mastodon` and provide the `bucket_name`: 
```
module "mastodon" {
  source      = "../modules/mastodon"
  bucket_name = "mastodon-production"
}
```
In the `source` argument specify the path to a local directory containing the Mastodon module's configuration files.
