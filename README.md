# iris-fhirsqlbuilder-dbt-integratedml

"ML on FHIR"

This repo demonstrates an end-to-end workflow to build an ML model for disease risk prediction starting from synthetic patient data in FHIR format, roughly based upon this paper: Chen, A., Chen, D.O. Simulation of a machine learning enabled learning health system for risk prediction using synthetic patient data. Sci Rep 12, 17917 (2022). https://doi.org/10.1038/s41598-022-23011-4. That paper started from an export of Synthea synthetic data in CSV format, and used an undisclosed data processing pipeline to flatten and collate the SNOMED and LOINC codes from multiple tables into a single "ML-ready" table with one row per patient. The ML-ready table is ideal for using AutoML tabular machine learning techniques to predict risk of a disease or complication, and the authors developed machine learning models using Python and _scikit-learn_ and other libraries.

In contrast, this repository demonstrates a similar workflow with the following modifications:
* Start from synthetic patient data in FHIR format, loaded into InterSystems IRIS for Health FHIR repository
* Use FHIR SQL Builder feature to project SQL tables containing select information extracted from the FHIR repository
* Use _dbt_ to transform multiple SQL tables for Patient, Observation, etc. into a single ML-ready table
* Build Machine Learning model within InterSystems IRIS IntegratedML, which enables data analysts to build and manage in-database ML models with elegant SQL syntax

Therefore, we have provided an end-to-end demonstration of using InterSystems' unique capabilities in data management and Machine Learning, combined with open source projects Synthea and _dbt_, to process, analyze and develop machine learning models that are then accesses easily from SQL for instant viewing in dashboards like Superset!

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
./load-data.py
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
