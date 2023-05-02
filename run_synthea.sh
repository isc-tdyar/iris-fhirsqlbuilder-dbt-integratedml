#!/bin/bash

mkdir -p ./data/fhir/_before
mkdir -p ./data/fhir/data

rm -rf ./data/fhir/_before/*
rm -rf ./data/fhir/data/*
rm -rf ./data/fhir/fhir

docker-compose run synthea java -jar synthea.jar "$@" --exporter.baseDirectory="./output/"

mv ./data/fhir/fhir/hospital*.json ./data/fhir/_before/
mv ./data/fhir/fhir/practitioner*.json ./data/fhir/_before/
mv ./data/fhir/fhir/*.json ./data/fhir/data/
