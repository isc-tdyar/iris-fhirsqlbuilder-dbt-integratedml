import os
from os import listdir
from os.path import join
from concurrent.futures import ProcessPoolExecutor
from concurrent.futures import ThreadPoolExecutor
from concurrent.futures import as_completed
import multiprocessing
import time
import requests
import glob
import signal
import sys
import random
import json


def signal_handler(sig, frame):
    print("You pressed Ctrl+C!", frame)
    sys.exit(0)


signal.signal(signal.SIGINT, signal_handler)
fhir_endpoint = "http://localhost:33783/fhir/r4/"
headers = {
    "Accept": "application/fhir+json",
    "Content-Type": "application/fhir+json",
}


def resource_exists(resource_type, resource_id):
    response = requests.get(
        fhir_endpoint + resource_type,
        params={"identifier": resource_id},
        headers=headers,
    )
    result = response.json()
    return result["total"] > 0


# load a file and return the contents
def load_file(filepath):
    t0 = time.time()
    # open the file
    with open(filepath, "r") as handle:
        count = 0
        filedata = handle.read()
        data = json.loads(filedata)
        resource = data["entry"][0]["resource"]
        resource_type = resource["resourceType"]
        resource_id = resource["identifier"][0]["value"]
        if resource_exists(resource_type, resource_id):
            return 0, -1, filepath
        try:
            response = requests.post(fhir_endpoint, data=filedata, headers=headers)
            result = response.json()
            count = len(result["entry"])
        except Exception as ex:  # noqa
            print(ex)
        return time.time() - t0, count, filepath


def init_worker():
    signal.signal(signal.SIGINT, signal.SIG_IGN)


# load all files in a directory into memory
def main(path="tmp"):
    print(f"process {path}")
    n_workers = round(multiprocessing.cpu_count() * 0.8)
    # prepare all of the paths
    files = filter(os.path.isfile, glob.glob(path + "/*.json"))
    files = sorted(files)
    if len(files) > n_workers:
        # files = sorted(files, key=lambda x: os.stat(x).st_size)
        random.shuffle(files)
    print(f"files {len(files)}")
    # create the process pool
    with ProcessPoolExecutor(n_workers, initializer=init_worker) as executor:
        futures = [executor.submit(load_file, filepath) for filepath in files]
        # process all results
        counter = 0
        for future in as_completed(futures):
            # open the file and load the data
            elapsed, count, filepath = future.result()
            filename = filepath.split("/")[-1]
            counter += 1
            if count < 0:
                print(f"{counter}. skipped {filename}")
            else:
                per_res = round(elapsed / count, 5) if count > 0 else 0
                # report progress
                print(
                    "",
                    f"{counter}. loaded {filename} - {elapsed} - {count} - {per_res}",
                    "",
                )
    print("Done")


# entry poimt
if __name__ == "__main__":
    main("data/fhir/_before")
    main("data/fhir/data")
