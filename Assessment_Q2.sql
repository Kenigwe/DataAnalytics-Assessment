WITH monthly_txn AS (
    SELECT 
        owner_id,
        DATE_FORMAT(created_on, '%Y-%m') AS txn_month,
        COUNT(*) AS txn_count
    FROM savings_savingsaccount
    GROUP BY owner_id, txn_month
),
avg_txn_per_user AS (
    SELECT 
        owner_id,
        AVG(txn_count) AS avg_txn_per_month
    FROM monthly_txn
    GROUP BY owner_id
),
categorized_users AS (
    SELECT 
        CASE 
            WHEN avg_txn_per_month >= 10 THEN 'High Frequency'
            WHEN avg_txn_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        avg_txn_per_month
    FROM avg_txn_per_user
)
SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_txn_per_month), 2) AS avg_transactions_per_month
FROM categorized_users
GROUP BY frequency_category
ORDER BY FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');
