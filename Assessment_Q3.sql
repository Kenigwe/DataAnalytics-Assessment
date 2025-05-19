SELECT * FROM (
    -- Investment Plans with no transaction in 1 year
    SELECT
        p.id AS plan_id,
        p.owner_id,
        'Investment' AS type,
        COALESCE(p.last_charge_date, p.created_on) AS last_transaction_date,
        DATEDIFF(CURDATE(), COALESCE(p.last_charge_date, p.created_on)) AS inactivity_days
    FROM plans_plan p
    WHERE 
        p.is_deleted = 0
        AND COALESCE(p.last_charge_date, p.created_on) <= (CURDATE() - INTERVAL 365 DAY)

    UNION

    -- Savings accounts with no inflow transaction in last 1 year
    SELECT
        s.id AS plan_id,
        s.owner_id,
        'Savings' AS type,
        MAX(s.transaction_date) AS last_transaction_date,
        DATEDIFF(CURDATE(), MAX(s.transaction_date)) AS inactivity_days
    FROM savings_savingsaccount s
    WHERE
        s.transaction_date IS NOT NULL
    GROUP BY s.id, s.owner_id
    HAVING MAX(s.transaction_date) <= (CURDATE() - INTERVAL 365 DAY)
) AS combined
ORDER BY inactivity_days DESC
LIMIT 25;
