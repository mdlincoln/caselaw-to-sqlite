PRAGMA foreign_keys = ON;
BEGIN;
CREATE TABLE IF NOT EXISTS courts (
  court_id INTEGER PRIMARY KEY NOT NULL,
  court_name TEXT NOT NULL,
  court_name_abbreviation TEXT NOT NULL,
  court_jurisdiction_url TEXT,
  court_slug TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS jurisdictions (
  jurisdiction_id INTEGER PRIMARY KEY NOT NULL,
  jurisdiction_slug TEXT NOT NULL,
  jurisdiction_name TEXT NOT NULL,
  jurisdiction_name_long TEXT NOT NULL,
  jurisdiction_whitelisted TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS cases (
  case_id INTEGER PRIMARY KEY NOT NULL,
  case_name TEXT NOT NULL,
  case_name_abbreviation TEXT NOT NULL,
  case_decision_date TEXT NOT NULL,
  case_docket_number TEXT NOT NULL,
  case_first_page INTEGER NOT NULL,
  case_last_page INTEGER NOT NULL,
  case_volume_number INTEGER NOT NULL,
  case_reporter TEXT NOT NULL,
  court_id INTEGER NOT NULL,
  jurisdiction_id INTEGER NOT NULL,
  case_status TEXT NOT NULL,
  case_head_matter TEXT NOT NULL,
  FOREIGN KEY(court_id) REFERENCES courts(court_id),
  FOREIGN KEY(jurisdiction_id) REFERENCES jurisdictions(jurisdiction_id)
);
CREATE TABLE IF NOT EXISTS opinions (
  case_id INTEGER NOT NULL,
  opinion_type TEXT NOT NULL,
  opinion_text TEXT NOT NULL,
  opinion_author TEXT NOT NULL,
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
CREATE INDEX IF NOT EXISTS opinion_case_id ON opinions(case_id);
CREATE INDEX IF NOT EXISTS parties_case_id ON parties(case_id);
CREATE INDEX IF NOT EXISTS attorneys_case_id ON attorneys(case_id);
CREATE INDEX IF NOT EXISTS judges_case_id ON judges(case_id);
COMMIT;
