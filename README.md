# iris-fhirsqlbuilder-dbt-integratedml

"ML on FHIR"

This repo demonstrates an end-to-end workflow to build an ML model for disease risk prediction starting from synthetic patient data in FHIR format, following these steps:
* Generate FHIR data using synthea
* Ingest that data into InterSystems IRIS FHIR Repository
* Project FHIR data to SQL using InterSystems FHIR SQL Builder
* Transform multiple SQL tables for Patient, Observation, etc. into a single ML-ready table using dbt
* Build Machine Learning model within InterSystems IRIS using IntegratedML

## Prepare FHIR data for ML

* Start environment with Docker Compose
  
```shell
docker-compose up -d --build
```

The start may take a while, until the FHIR server will be installed and activated

* Generate FHIR data with Synthea -- 100 patients, ages 30-100 years old, seed = 1234, clinician seed = 1234

```shell
./run_synthea.sh -p 100 -a 30-100 -s 1234 -cs 1234
```

* Load FHIR Data to FHIRServer

```shell
./load-data.sh
```

FHIR SQL Builder configured to expose FHIR data through SQL schema `fhir`

* Install dbt and dependencies

```shell
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
cd dbt
dbt deps
```

* Check connection to IRIS

```shell
dbt debug
```

* Load seeds and run data transformation with tests

```shell
dbt build
```

After all this steps IRIS will contain table `mlonfhir.summary` ready for ML
