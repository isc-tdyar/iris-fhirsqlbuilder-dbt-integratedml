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


# load a file and return the contents
def load_file(filepath):
    t0 = time.time()
    fhir_endpoint = "http://localhost:33783/fhir/r4/"
    headers = {
        "Accept": "application/fhir+json",
        "Content-Type": "application/fhir+json",
    }
    # open the file
    with open(filepath, "r") as handle:
        data = handle.read()
        response = requests.post(fhir_endpoint, data=data, headers=headers)
        result = response.json()
        return time.time() - t0, len(result["entry"]), filepath


# return the contents of many files
def load_files(filepaths):
    # create a thread pool
    with ThreadPoolExecutor(len(filepaths)) as exe:
        # load files
        futures = [exe.submit(load_file, name) for name in filepaths]
        # collect data
        data_list = [future.result() for future in futures]
        # return data and file paths
        return (data_list, filepaths)


# load all files in a directory into memory
def main(path="tmp"):
    print(f"process {path}")
    n_workers = multiprocessing.cpu_count()
    # prepare all of the paths
    list_of_files = filter(os.path.isfile, glob.glob(path + "/*.json"))
    list_of_files = sorted(list_of_files, key=lambda x: os.stat(x).st_size)
    print(f"files {len(list_of_files)}")
    # create the process pool
    with ProcessPoolExecutor(n_workers) as executor:
        futures = []
        for filepath in list_of_files:
            future = executor.submit(load_file, filepath)
            futures.append(future)
        # process all results
        counter = 0
        for future in as_completed(futures):
            # open the file and load the data
            elapsed, count, filepath = future.result()
            per_res = round(elapsed / count, 5)
            # report progress
            counter += 1
            print(
                "",
                f"{counter}. loaded {filepath} - {elapsed} - {count} - {per_res}",
                "",
            )
    print("Done")


# entry poimt
if __name__ == "__main__":
    main("data/fhir/_before")
    main("data/fhir/data")
