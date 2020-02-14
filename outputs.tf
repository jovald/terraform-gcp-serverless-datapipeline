output "query_your_table" {
  value = "bq query --nouse_legacy_sql \"SELECT * FROM ${google_bigquery_dataset.bq_dataset.dataset_id}.${google_bigquery_table.bq_table.table_id}\""
}