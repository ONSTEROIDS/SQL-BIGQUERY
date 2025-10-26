WITH user_active_days AS (
    SELECT 
        u1.user_id,
        COUNT(DISTINCT u2.date) AS active_days
    FROM `statfinity-project-464914.statfinity_sql_case.user1` u1
    JOIN `statfinity-project-464914.statfinity_sql_case.user2` u2
    ON u1.user_id = u2.user_id
    GROUP BY u1.user_id
)

SELECT 
    AVG(active_days) AS average_active_days
FROM user_active_days;
