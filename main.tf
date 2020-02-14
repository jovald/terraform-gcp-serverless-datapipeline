# Provider configuration, in this case we are using Google Cloud Platform.
provider "google" {
  # Just the name of our service account credentials.
  credentials = file("account.json")

  project = var.project_id
  region  = var.region
}

# Random string generator for the bucket name.
resource "random_string" "random_function_name" {
  length           = 30
  special          = true
  min_lower        = 30
  override_special = ""
}

# Zip the functions folder.
data "archive_file" "function_zip" {
  type        = "zip"
  source_dir  = "${path.root}/${var.functions_folder_path}"
  output_path = "${path.root}/${var.output_zip_functions}"
}

# Create a bucket for storing the functions zip.
resource "google_storage_bucket" "functions_bucket" {
  name = random_string.random_function_name.result
}

# Upload the functions zip.
resource "google_storage_bucket_object" "function_zip" {
  name   = var.output_zip_functions
  bucket = google_storage_bucket.functions_bucket.name
  source = "${path.root}/${var.output_zip_functions}"
}

# Create a Pub Sub topic to call the function.
resource "google_pubsub_topic" "pubsub_topic" {
  name = var.gcp_pubsub_topic_name
}

# Schedule job.
resource "google_cloud_scheduler_job" "scheduler_job" {
  name        = var.gcp_cloud_scheduler_job_name
  description = "Execution topic"
  schedule    = var.gcp_cloud_scheduler_schedule_time

  pubsub_target {
    topic_name = google_pubsub_topic.pubsub_topic.id
    data       = base64encode("execute")
  }
}

# Bigquery dataset and table for storing data
resource "google_bigquery_dataset" "bq_dataset" {
  dataset_id = var.gcp_bq_dataset_id
  location   = "US"
}

resource "google_bigquery_table" "default" {
  dataset_id = google_bigquery_dataset.bq_dataset.dataset_id
  table_id   = var.gcp_bq_table_id
}

# The cloud function to be deployed.
resource "google_cloudfunctions_function" "crawl_function" {
  name                  = "crawl_function"
  runtime               = "nodejs10"
  entry_point           = var.function_name
  source_archive_bucket = google_storage_bucket.functions_bucket.name
  source_archive_object = google_storage_bucket_object.function_zip.name

  event_trigger {
    event_type = "google.pubsub.topic.publish"
    resource   = google_pubsub_topic.pubsub_topic.id
  }

  environment_variables = {
    OPEN_WEATHER_MAP_API_KEY = var.open_weather_map_api_key
    OPEN_WEATHER_LOCATION    = var.open_weather_location
    BQ_DATASET               = google_bigquery_dataset.bq_dataset.dataset_id
    BQ_TABLE                 = google_bigquery_table.default.table_id
  }
}