SELECT 
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS full_name,
    COALESCE(s.savings_count, 0) AS savings_count,
    COALESCE(p.investment_count, 0) AS investment_count,
    COALESCE(p.total_deposits, 0) AS total_deposits
FROM users_customuser u

// Subquery for savings count
JOIN (
    SELECT 
        owner_id,
        COUNT(*) AS savings_count
    FROM plans_plan
    WHERE is_regular_savings = 1 AND amount > 0
    GROUP BY owner_id
) s ON s.owner_id = u.id

// Subquery for investment count and deposit
JOIN (
    SELECT 
        owner_id,
        COUNT(*) AS investment_count,
        SUM(amount) AS total_deposits
    FROM plans_plan
    WHERE is_regular_savings = 0 AND amount > 0
    GROUP BY owner_id
) p ON p.owner_id = u.id

ORDER BY total_deposits DESC
LIMIT 25;
