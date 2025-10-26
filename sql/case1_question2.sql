WITH latest_order1 AS (
    SELECT *,
           SAFE_CAST(itemprice AS FLOAT64) AS item_price_amount,
           SAFE_CAST(promotiondiscount AS FLOAT64) AS promo_discount_amount,
           SAFE_CAST(quantityordered AS INT64) AS quantity_ordered
    FROM (
        SELECT *,
               ROW_NUMBER() OVER (PARTITION BY orderid, orderitemid ORDER BY batch_id DESC) AS rn
        FROM `statfinity-project-464914.statfinity_sql_case.order1`
    )
    WHERE rn = 1
),

latest_order2 AS (
    SELECT *
    FROM (
        SELECT *,
               ROW_NUMBER() OVER (PARTITION BY orderid ORDER BY batch_id DESC) AS rn
        FROM `statfinity-project-464914.statfinity_sql_case.order2`
    )
    WHERE rn = 1
)

SELECT 
    SUM(quantity_ordered) AS total_order_quantity,
    SUM(item_price_amount) AS gmv,
    SUM(IFNULL(item_price_amount, 0) - IFNULL(promo_discount_amount, 0)) AS net_sales
FROM latest_order1 lo
JOIN latest_order2 l2
ON lo.orderid = l2.orderid
WHERE l2.orderstatus != 'Canceled'
AND EXTRACT(YEAR FROM l2.purchasedate) = 2022
AND EXTRACT(MONTH FROM l2.purchasedate) = 10;
