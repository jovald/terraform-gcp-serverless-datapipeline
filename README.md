# Provisioning a Serverless data pipeline with Terraform in Google Cloud Platform

This project aims to show how to provision a serverless infrastructure for data processing with Terraform in Google Cloud.

## Introduction

The pipeline consists of a process that regularly gets data from an API and loads it into BigQuery. Considering its popularity, the current weather data API by **OpenWeatherMap** was chosen to exemplify the data gathering stage.

### Reference architecture

The next image shows the reference architecture for this project.

![Architecture](https://raw.githubusercontent.com/jovald/gcp-serverless-data-pipeline/assets/gcp-serverless-data-pipeline.jpg)

### About the pipeline

The process could be explained by the next steps:

1. Depending on the frequency, a job of Cloud Scheduler triggers a topic on Cloud Pub/Sub.
2. That action executes a Cloud Function (*loadDataIntoBigQuery*) that gets data from OpenWeatherMap.
3. Then, this data is loaded into BigQuery.

### System requirements

The following is needed to deploy the services:

1. A [GCP project](https://cloud.google.com/resource-manager/docs/creating-managing-projects) with a [linked billing account](https://cloud.google.com/billing/docs/how-to/modify-project)
2. Installed and initialized the [Google Cloud SDK](https://cloud.google.com/sdk/install)
3. Created an App Engine app in your project. [Why?](https://cloud.google.com/scheduler/docs/setup)
4. Enabled the Cloud Functions, Cloud Scheduler, and APP Engine APIs
5. An API Key from [OpenWeatherMap](https://openweathermap.org)
6. Have installed [Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html)

For pint 4, you can just create a project in GCP and run the `bootstrap.sh` file:

```sh
gcloud config set project <Your_Project_Name>
./bootstrap.sh
```

This will enable all the needed APIs in GCP and will intent to create an empty App Engine app.


### Costs

This pipeline uses billable components of Google Cloud Platform, including:

* Google Cloud Functions
* Google Cloud Pub/Sub
* Google Cloud Scheduler
* Google BigQuery

---

## Deployment

This section shows you how to deploy all the services needed to run the pipeline.

### Setting up variables

First you have to setup some variables. First, rename `terraform.tfvars.copy` to `terraform.tfvars` and fill the variables:

```sh
open_weather_map_api_key = "<OPEN_WEATHER_API>"
project_id = "<YOUR_GCP_PROJECT_ID>"
```

### Provisioning the infrastructure

Just use Terraform!

```sh
terraform apply
```

---

## What now

Just query your table! (maybe, wait some minutes)

If you run the next command, a BigQuery job will be executed that consist of a query to count all the records on your table. If you complete the steps above correctly, you will see at least one record counted. Remember to be logged with `gcloud`.

```sh
bq query --nouse_legacy_sql "SELECT COUNT(*) FROM <DATASET_ID>.<TABLE_ID>"
```

Second, BigQuery on the GCP Console is also an enjoyable manner to explore and analyze your data.

---

## Authors

* **[Jose Valdebenito](https://github.com/jovald)**

## Special thanks
* **[Luis Santana](https://github.com/lsantana486)**
* **[Chris Matteson](https://github.com/chrismatteson)**

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

## You may also like
[terraform-gcp-serverless-datapipeline](https://github.com/jovald/terraform-gcp-serverless-datapipeline)

## Further readings

* [Background Functions](https://cloud.google.com/functions/docs/writing/background)
* [Writing Cloud Functions](https://cloud.google.com/functions/docs/writing/)
* [Deploying from Your Local Machine](https://cloud.google.com/functions/docs/deploying/filesystem)
* [Using Pub/Sub to trigger a Cloud Function](https://cloud.google.com/scheduler/docs/tut-pub-sub)
* [Creating datasets](https://cloud.google.com/bigquery/docs/datasets)
