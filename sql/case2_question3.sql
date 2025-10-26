WITH user_installs AS (
    SELECT 
        user_id,
        DATE(user_first_seen_date) AS install_date
    FROM `statfinity-project-464914.statfinity_sql_case.user1`
),

user_activity AS (
    SELECT 
        user_id,
        DATE(date) AS activity_date
    FROM `statfinity-project-464914.statfinity_sql_case.user2`
),

retention_base AS (
    SELECT 
        ui.user_id,
        ui.install_date,
        DATE_DIFF(ua.activity_date, ui.install_date, DAY) AS days_since_install
    FROM user_installs ui
    JOIN user_activity ua
    ON ui.user_id = ua.user_id
),

retention_counts AS (
    SELECT 
        COUNT(DISTINCT user_id) AS total_installs,
        COUNT(DISTINCT IF(days_since_install = 1, user_id, NULL)) AS day_1_retained,
        COUNT(DISTINCT IF(days_since_install = 3, user_id, NULL)) AS day_3_retained,
        COUNT(DISTINCT IF(days_since_install = 7, user_id, NULL)) AS day_7_retained
    FROM retention_base
)

SELECT 
    total_installs,
    ROUND(day_1_retained * 100 / total_installs, 2) AS day_1_retention_pct,
    ROUND(day_3_retained * 100 / total_installs, 2) AS day_3_retention_pct,
    ROUND(day_7_retained * 100 / total_installs, 2) AS day_7_retention_pct
FROM retention_counts;
