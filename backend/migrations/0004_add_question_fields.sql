-- Add question type and role-play fields
ALTER TABLE questions ADD COLUMN question_type TEXT NOT NULL DEFAULT 'vocabulary_match';
ALTER TABLE questions ADD COLUMN main_text TEXT;
ALTER TABLE questions ADD COLUMN phonetic TEXT;
ALTER TABLE questions ADD COLUMN instruction TEXT;
ALTER TABLE questions ADD COLUMN audio_url TEXT;
ALTER TABLE questions ADD COLUMN current_question TEXT;
ALTER TABLE questions ADD COLUMN history TEXT; -- JSON array of DialogueTurn objects
