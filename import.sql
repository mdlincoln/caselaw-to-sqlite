PRAGMA foreign_keys = ON;
BEGIN;
CREATE TABLE IF NOT EXISTS courts (
  id INTEGER PRIMARY KEY NOT NULL,
  `name` TEXT NOT NULL,
  name_abbreviation TEXT NOT NULL,
  jurisdiction_url TEXT,
  slug TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS jurisdictions (
  id INTEGER PRIMARY KEY NOT NULL,
  slug TEXT NOT NULL,
  `name` TEXT NOT NULL,
  name_long TEXT NOT NULL,
  whitelisted TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS cases (
  id INTEGER PRIMARY KEY NOT NULL,
  `name` TEXT NOT NULL,
  name_abbreviation TEXT NOT NULL,
  decision_date TEXT NOT NULL,
  docket_number TEXT NOT NULL,
  first_page INTEGER NOT NULL,
  last_page INTEGER NOT NULL,
  volume_number INTEGER NOT NULL,
  reporter TEXT NOT NULL,
  court_id INTEGER NOT NULL,
  jurisdiction_id INTEGER NOT NULL,
  `status` TEXT NOT NULL,
  head_matter TEXT NOT NULL,
  FOREIGN KEY(court_id) REFERENCES courts(id),
  FOREIGN KEY(jurisdiction_id) REFERENCES jurisdictions(id)
);
CREATE TABLE IF NOT EXISTS opinions (
  id INTEGER NOT NULL,
  `type` TEXT NOT NULL,
  `text` TEXT NOT NULL,
  author TEXT NOT NULL,
  FOREIGN KEY (id) REFERENCES cases(id)
);
CREATE TABLE IF NOT EXISTS parties (
  id INTEGER NOT NULL,
  party TEXT NOT NULL,
  FOREIGN KEY (id) REFERENCES cases(id)
);
CREATE TABLE IF NOT EXISTS attorneys (
  id INTEGER NOT NULL,
  attorney TEXT NOT NULL,
  FOREIGN KEY (id) REFERENCES cases(id)
);
CREATE TABLE IF NOT EXISTS judges (
  id INTEGER NOT NULL,
  judge TEXT NOT NULL,
  FOREIGN KEY (id) REFERENCES cases(id)
);
.mode csv
.import courts.csv courts
.import jurisdictions.csv jurisdictions
.import cases.csv cases
.import opinions.csv opinions
.import parties.csv parties
.import judges.csv judges
.import attorneys.csv attorneys
CREATE INDEX IF NOT EXISTS case_court_id ON cases(court_id);
CREATE INDEX IF NOT EXISTS case_jurisdiction_id ON cases(jurisdiction_id);
CREATE INDEX IF NOT EXISTS opinion_case_id ON opinions(id);
CREATE INDEX IF NOT EXISTS parties_case_id ON parties(id);
CREATE INDEX IF NOT EXISTS attorneys_case_id ON attorneys(id);
CREATE INDEX IF NOT EXISTS judges_case_id ON judges(id);
COMMIT;
