PRAGMA foreign_keys = ON;
.mode csv
BEGIN;
CREATE TABLE IF NOT EXISTS temporary_courts (
  court_id INTEGER NOT NULL,
  `name` TEXT NOT NULL,
  name_abbreviation TEXT NOT NULL,
  jurisdiction_url TEXT,
  slug TEXT NOT NULL
);
.import courts.csv temporary_courts
CREATE TABLE IF NOT EXISTS courts (
  court_id INTEGER PRIMARY KEY NOT NULL,
  `name` TEXT NOT NULL,
  name_abbreviation TEXT NOT NULL,
  jurisdiction_url TEXT,
  slug TEXT NOT NULL
);
INSERT OR IGNORE INTO courts SELECT DISTINCT * from temporary_courts;
DROP TABLE temporary_courts;
CREATE TABLE IF NOT EXISTS temporary_jurisdictions (
  jurisdiction_id INTEGER NOT NULL,
  slug TEXT NOT NULL,
  `name` TEXT NOT NULL,
  name_long TEXT NOT NULL,
  whitelisted TEXT NOT NULL
);
.import jurisdictions.csv temporary_jurisdictions
CREATE TABLE IF NOT EXISTS jurisdictions (
  jurisdiction_id INTEGER PRIMARY KEY NOT NULL,
  slug TEXT NOT NULL,
  `name` TEXT NOT NULL,
  name_long TEXT NOT NULL,
  whitelisted TEXT NOT NULL
);
INSERT OR IGNORE INTO jurisdictions SELECT DISTINCT * from temporary_jurisdictions;
DROP TABLE temporary_jurisdictions;
CREATE TABLE IF NOT EXISTS cases (
  case_id INTEGER PRIMARY KEY NOT NULL,
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
  FOREIGN KEY(court_id) REFERENCES courts(court_id),
  FOREIGN KEY(jurisdiction_id) REFERENCES jurisdictions(jurisdiction_id)
);
CREATE TABLE IF NOT EXISTS opinions (
  case_id INTEGER NOT NULL,
  `type` TEXT NOT NULL,
  `text` TEXT NOT NULL,
  author TEXT NOT NULL,
  FOREIGN KEY (case_id) REFERENCES cases(case_id)
);
CREATE TABLE IF NOT EXISTS parties (
  case_id INTEGER NOT NULL,
  party TEXT NOT NULL,
  FOREIGN KEY (case_id) REFERENCES cases(case_id)
);
CREATE TABLE IF NOT EXISTS attorneys (
  case_id INTEGER NOT NULL,
  attorney TEXT NOT NULL,
  FOREIGN KEY (case_id) REFERENCES cases(case_id)
);
CREATE TABLE IF NOT EXISTS judges (
  case_id INTEGER NOT NULL,
  judge TEXT NOT NULL,
  FOREIGN KEY (case_id) REFERENCES cases(case_id)
);
.import cases.csv cases
.import opinions.csv opinions
.import parties.csv parties
.import judges.csv judges
.import attorneys.csv attorneys
CREATE INDEX IF NOT EXISTS case_court_id ON cases(court_id);
CREATE INDEX IF NOT EXISTS case_jurisdiction_id ON cases(jurisdiction_id);
CREATE INDEX IF NOT EXISTS opinion_case_id ON opinions(case_id);
CREATE INDEX IF NOT EXISTS parties_case_id ON parties(case_id);
CREATE INDEX IF NOT EXISTS attorneys_case_id ON attorneys(case_id);
CREATE INDEX IF NOT EXISTS judges_case_id ON judges(case_id);
COMMIT;
