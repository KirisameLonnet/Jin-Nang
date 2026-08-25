export async function touchStudyDay(db: D1Database, userId: number): Promise<void> {
  await db.prepare(`
    UPDATE users SET
      streak_days = CASE
        WHEN last_study_date = date('now') THEN streak_days
        WHEN last_study_date = date('now', '-1 day') THEN streak_days + 1
        ELSE 1
      END,
      last_study_date = date('now')
    WHERE id = ?
  `).bind(userId).run()
}

export async function refreshUserStats(db: D1Database, userId: number): Promise<void> {
  await db.prepare(`
    UPDATE users SET
      total_words_seen = (
        SELECT COUNT(*) FROM user_vocab_seen WHERE user_id = ?
      ),
      avg_score = COALESCE((
        SELECT ROUND(AVG(best_score), 2)
        FROM user_level_progress
        WHERE user_id = ? AND completed_at IS NOT NULL
      ), 0),
      rank = CASE
        WHEN (SELECT COUNT(*) FROM user_vocab_seen WHERE user_id = ?) >= 200 THEN 'Platinum'
        WHEN (SELECT COUNT(*) FROM user_vocab_seen WHERE user_id = ?) >= 50 THEN 'Gold'
        WHEN (SELECT COUNT(*) FROM user_vocab_seen WHERE user_id = ?) >= 6 THEN 'Silver'
        ELSE 'Bronze'
      END
    WHERE id = ?
  `).bind(userId, userId, userId, userId, userId, userId).run()
}
