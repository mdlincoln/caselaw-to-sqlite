case.law to sqlite
==================

This script parses multiple data export file(s) from the [Caselaw Access Project](https://case.law/) into a single structured sqlite database for easier access using analysis tools like R or Python.

## Requirements

- jq
- sqlite3 command line shell

## Usage

To run, pass the path of the unzipped export file you want to add to your database:

```sh
./extract Illinois-20180829/data/data.jsonl.xz
```

The script will first use jq to write out several CSV files to disk, and then load and index them into an sqlite database named `caselaw.sqlite`.
You may repeat this process with multiple different dumps from the project website, adding further data into `caselaw.sqlite`.

Note that the CSV files are only intermediaries, and will be overwritten every time you run the script with a new data file.
