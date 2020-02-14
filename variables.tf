# Azure Location
variable "project" {
  default = "terraform-251319"
}

variable "open_weather_map_api_key" {
  default = ""
}

variable "project_id" {
  default = ""
}

variable "region" {
  default = "us-central1"
}

variable "functions_folder_path" {
  default = "functions/"
}

variable "output_zip_functions" {
  default = "functions.zip"
}

variable "gcp_pubsub_topic_name" {
  default = "weather_crawl_tpc"
}

variable "gcp_cloud_scheduler_job_name" {
  default = "weather_crawl_jb"
}

variable "gcp_cloud_scheduler_schedule_time" {
  default = "*/2 * * * *"
}

variable "gcp_bq_dataset_id" {
  default = "weather_dataset"
}

variable "gcp_bq_table_id" {
  default = "weather_data"
}

variable "function_name" {
  default = "loadDataIntoBigQuery"
}

variable "open_weather_location" {
  default = "Sao+Paulo,br"
}