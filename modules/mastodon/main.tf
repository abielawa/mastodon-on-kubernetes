resource "google_storage_bucket" "mastodon" {
  name     = var.bucket_name
  location = "EU"
}

resource "google_service_account" "mastodon" {
  account_id   = "service-account-mastodon"
  display_name = "A service account for Mastodon server to access storage bucket"
}

/**
 * Binding role objectAdmin to service account and bucket
 */

resource "google_storage_bucket_iam_binding" "binding" {
  bucket = google_storage_bucket.mastodon.name
  role   = "roles/storage.admin"
  members = [
    "serviceAccount:${google_service_account.mastodon.email}"
  ]
}

resource "google_storage_hmac_key" "mastodon" {
  service_account_email = google_service_account.mastodon.email
}

resource "kubernetes_secret" "mastodon" {
  metadata {
    name = "mastodon-production-s3"
  }

  data = {
    AWS_ACCESS_KEY_ID     = google_storage_hmac_key.mastodon.access_id
    AWS_SECRET_ACCESS_KEY = google_storage_hmac_key.mastodon.secret
  }

  type = "Opaque"
}
