CREATE OR REPLACE TABLE keepcoding.ivr_summary AS

WITH vdn_aggregation_cte AS (
   SELECT calls_ivr_id
      , calls_vdn_label
      , CASE
         WHEN calls_vdn_label LIKE 'ATC%' THEN 'FRONT'
         WHEN calls_vdn_label LIKE 'TECH%' THEN 'TECH'
         WHEN calls_vdn_label = 'ABSORPTION' THEN 'ABSORPTION'
         ELSE 'RESTO'
         END AS vdn_aggregation
      FROM `keepcoding.ivr_detail`
)

, masiva_lg_cte AS (
  SELECT
    calls_ivr_id,
    MAX(CASE WHEN module_name = 'AVERIA_MASIVA' THEN 1 ELSE 0 END) AS masiva_lg
  FROM
    `keepcoding.ivr_detail`
  GROUP BY
    calls_ivr_id
)

, info_by_phone_lg_cte AS (
  SELECT calls_ivr_id 
    , MAX(CASE WHEN step_name = 'CUSTOMERINFOBYPHONE.TX' AND step_description_error = 'UNKNOWN' THEN 1 ELSE 0 END) AS         
     info_by_phone_lg
  FROM
    `keepcoding.ivr_detail`
  GROUP BY
    calls_ivr_id
)

, info_by_dni_lg_cte AS (
  SELECT calls_ivr_id
    , MAX(CASE WHEN step_name = 'CUSTOMERINFOBYDNI.TX' AND step_description_error = 'UNKNOWN' THEN 1 ELSE 0 END) AS     
     info_by_dni_lg
  FROM
    `keepcoding.ivr_detail`
  GROUP BY
    calls_ivr_id
)

, phone_activity_cte AS (
    SELECT calls_phone_number
    , calls_start_date
    , calls_end_date
    , LAG(calls_end_date) OVER (PARTITION BY calls_phone_number ORDER BY calls_end_date) AS previous_end_date
    , LEAD(calls_end_date) OVER (PARTITION BY calls_phone_number ORDER BY calls_end_date) AS next_end_date
    , IF(TIMESTAMP_DIFF(calls_end_date, LAG(calls_end_date) OVER (PARTITION BY calls_phone_number ORDER BY calls_end_date), HOUR) BETWEEN 0 AND 24, 1, 
        0) AS repeated_phone_24H
    , IF(TIMESTAMP_DIFF(LEAD(calls_start_date) OVER (PARTITION BY calls_phone_number ORDER BY calls_end_date), calls_end_date, HOUR) BETWEEN 0 AND 24, 
        1, 0) AS cause_recall_phone_24H
   
   FROM `keepcoding.ivr_detail`
   
   GROUP BY calls_phone_number
    , calls_start_date
    , calls_end_date
)

SELECT det.calls_ivr_id
    , det.calls_phone_number
    , det.calls_ivr_result
    , a.vdn_aggregation
    , det.calls_start_date
    , det.calls_end_date
    , det.calls_total_duration
    , det.calls_customer_segment
    , det.calls_ivr_language
    , det.calls_steps_module
    , det.calls_module_aggregation
    , COALESCE(MAX(CASE WHEN det.document_type <> 'UNKNOWN' THEN det.document_type END),'UNKNOWN')  AS document_type
    , COALESCE(MAX(CASE WHEN det.document_identification <> 'UNKNOWN' THEN det.document_identification END),'UNKNOWN') AS document_identification
    , COALESCE(MAX(IF(det.customer_phone <> 'UNKNOWN', det.customer_phone, NULL)), 'UNKNOWN') AS customer_phone
    , COALESCE(MAX(IF(det.billing_account_id <> 'UNKNOWN', det.billing_account_id, NULL)), 'UNKNOWN') AS billing_account_id
    , m.masiva_lg
    , ip.info_by_phone_lg
    , id.info_by_dni_lg
    , MAX(p.repeated_phone_24H) AS repeated_phone_24H
    , MAX(p.cause_recall_phone_24H) AS cause_recall_phone_24H

 FROM `keepcoding.ivr_detail` det
 LEFT JOIN
  vdn_aggregation_cte a
   ON
  det.calls_ivr_id = a.calls_ivr_id
 LEFT JOIN
  masiva_lg_cte m
   ON
  det.calls_ivr_id = m.calls_ivr_id
LEFT JOIN
  info_by_phone_lg_cte ip
   ON
  det.calls_ivr_id = ip.calls_ivr_id
 LEFT JOIN
  info_by_dni_lg_cte id
   ON
  det.calls_ivr_id = id.calls_ivr_id
 LEFT JOIN
  phone_activity_cte p
   ON
  det.calls_phone_number = p.calls_phone_number

 GROUP BY calls_ivr_id
    , calls_phone_number
    , calls_ivr_result
    , vdn_aggregation
    , calls_start_date
    , calls_end_date
    , calls_total_duration
    , calls_customer_segment
    , calls_ivr_language
    , calls_steps_module
    , calls_module_aggregation
    , masiva_lg
    , info_by_phone_lg
    , info_by_dni_lg
