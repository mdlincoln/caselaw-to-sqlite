case.law to sqlite
==================

This script parses multiple data export file(s) from the [Caselaw Access Project](https://case.law/) into a single structured sqlite database for easier access using analysis tools like R or Python.

## Requirements

- jq
- sqlite3 command line shell

## Usage

To run, pass the path of the unzipped export file you want to add to your database:

```sh
./extract Illinois-20180829-text/data/data.jsonl.xz
```

The script will first use jq to write out several CSV files to disk, and then load and index them into an sqlite database named `caselaw.sqlite`.
You may repeat this process with multiple different dumps from the project website, adding further data into `caselaw.sqlite`.

If you have downloaded multiple states' files into one directory - in this case, to a directory named `downloads/`, you can use this command to run the script over all dumps.

```sh
find downloads -name data.jsonl.xz -exec ./extract.sh {} \+
```

Note that the CSV files are only intermediaries, and will be overwritten every time you run the script with a new data file.
