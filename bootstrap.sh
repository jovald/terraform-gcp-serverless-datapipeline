#!/bin/bash

echo "Enabling APIs..."
gcloud services enable cloudfunctions.googleapis.com
gcloud services enable pubsub.googleapis.com
gcloud services enable cloudscheduler.googleapis.com
gcloud services enable appengine.googleapis.com

echo "Creating an App Engine App"
gcloud app create