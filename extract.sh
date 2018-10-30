#!/bin/bash

echo -ne "extracting cases..."
xzcat $1 | jq -r '[.id, .name, .name_abbreviation, .decision_date, .docket_number, .first_page, .last_page, .volume.volume_number, .reporter.full_name, .court.id, .jurisdiction.id, .casbody.status, .casebody.data.head_matter] | @csv' > cases.csv
echo "done"

echo -ne "extracting citations..."
xzcat $1 | jq -r '{"id": .id, "citations": .citations[]} | [.id, .citations.type, .citations.cite] | @csv' > citations.csv
echo "done"

echo -ne "extracting courts..."
xzcat $1 | jq -r '.court | [.id, .name, .name_abbreviation, .jurisdiction.url, .slug] | @csv' | sort | uniq > courts.csv
echo "done"

echo -ne "extracting jurisdictions..."
xzcat $1 | jq -r '.jurisdiction | [.id, .slug, .name, .name_long, .whitelisted] | @csv' | sort | uniq > jurisdictions.csv
echo "done"

echo -ne "extracting opinions..."
xzcat $1 | jq -r '{"id": .id, "opinion": .casebody.data.opinions[]} | [.id, .opinion.type, .opinion.text, .opinion.author] | @csv' > opinions.csv
echo "done"

echo -ne "extracting parties..."
xzcat $1 | jq -r '{"id": .id, "obj": .casebody.data.parties[]} | [.id, .obj] | @csv' > parties.csv
echo "done"

echo -ne "extracting attorneys..."
xzcat $1 | jq -r '{"id": .id, "obj": .casebody.data.attorneys[]} | [.id, .obj] | @csv' > attorneys.csv
echo "done"

echo -ne "extracting judges"
xzcat $1 | jq -r '{"id": .id, "obj": .casebody.data.judges[]} | [.id, .obj] | @csv' > judges.csv
echo "done"

echo "Loading into caselaw.sqlite"
sqlite3 -bail -echo caselaw.sqlite ".read import.sql"
