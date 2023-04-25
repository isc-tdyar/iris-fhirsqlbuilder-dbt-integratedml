# iris-fhirsqlbuilder-dbt-integratedml

ML on FHIR

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
