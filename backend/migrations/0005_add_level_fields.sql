-- Add points_reward and description columns to levels
ALTER TABLE levels ADD COLUMN points_reward INTEGER NOT NULL DEFAULT 0;
ALTER TABLE levels ADD COLUMN description TEXT NOT NULL DEFAULT '';
