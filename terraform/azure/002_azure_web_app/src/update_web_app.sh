#!/bin/bash

dirname=$(dirname "$0")

cd $dirname

echo "Creating app.zip from the current directory $dirname..."

zip -r app.zip .

echo "Uploading app.zip to Azure Web App $2 in resource group $1..."

az webapp deploy --resource-group $1 --name $2 --src-path app.zip --type zip
