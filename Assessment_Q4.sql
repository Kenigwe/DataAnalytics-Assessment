SELECT 
    u.id AS customer_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    
    TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,
    
    COUNT(s.id) AS total_transactions,
    
    AVG(s.confirmed_amount) * 0.001 / 100 AS avg_profit_per_transaction

FROM users_customuser u

LEFT JOIN savings_savingsaccount s ON s.owner_id = u.id AND s.confirmed_amount > 0

GROUP BY u.id, u.first_name, u.last_name, u.date_joined

ORDER BY 
    CASE 
      WHEN TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) > 0 THEN
        (COUNT(s.id) / TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE())) * 12 * (AVG(s.confirmed_amount) * 0.001 / 100)
      ELSE 0
    END DESC

LIMIT 25;
