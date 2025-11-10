-- Optional DB fixes for column mismatches observed on some setups
USE research_repo;

-- If you need a keywords column (not used by current DAO):
-- Run only if you want to store keywords
ALTER TABLE papers
    ADD COLUMN IF NOT EXISTS keywords VARCHAR(255) NULL AFTER abstract;

-- Compatibility view if some old code expects abstract_text
-- (Prefer updating old code to use `abstract` directly.)
CREATE OR REPLACE VIEW papers_compat AS
SELECT
    paper_id,
    title,
    abstract AS abstract_text,
    abstract,
    file_path,
    submitted_by,
    status,
    submission_date
FROM papers;
