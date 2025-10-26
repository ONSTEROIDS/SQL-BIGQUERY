WITH user_sessions AS (
    SELECT 
        u1.user_id,
        u1.country,
        u1.platform,
        u2.date,
        u2.sessionid
    FROM `statfinity-project-464914.statfinity_sql_case.user1` u1
    JOIN `statfinity-project-464914.statfinity_sql_case.user2` u2
    ON u1.user_id = u2.user_id
),

daily_unique_sessions AS (
    SELECT 
        country,
        platform,
        date,
        COUNT(DISTINCT sessionid) AS unique_sessions
    FROM user_sessions
    GROUP BY country, platform, date
)

SELECT 
    country,
    platform,
    date,
    unique_sessions,
    SUM(unique_sessions) OVER (PARTITION BY country, platform ORDER BY date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS running_sum_3_day,
    SUM(unique_sessions) OVER (PARTITION BY country, platform ORDER BY date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS running_sum_7_day,
    SUM(unique_sessions) OVER (PARTITION BY country, platform ORDER BY date) AS running_sum_total
FROM daily_unique_sessions
ORDER BY country, platform, date;
