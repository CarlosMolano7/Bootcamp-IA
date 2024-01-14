CREATE OR REPLACE TABLE keepcoding.ivr_detail AS

SELECT  calls.ivr_id AS calls_ivr_id
  , calls.phone_number AS calls_phone_number
  , calls.ivr_result AS calls_ivr_result
  , calls.vdn_label AS calls_vdn_label
  , calls.start_date AS calls_start_date
  , FORMAT_DATE('%Y%m%d', start_date) AS calls_start_date_id
  , calls.end_date AS calls_end_date
  , FORMAT_DATE('%Y%m%d', end_date) AS calls_end_date_id
  , calls.total_duration AS calls_total_duration
  , calls.customer_segment AS calls_customer_segment
  , calls.ivr_language AS calls_ivr_language
  , calls.steps_module AS calls_steps_module
  , calls.module_aggregation AS calls_module_aggregation
  , IFNULL(modules.module_sequece, -9999) AS module_sequence
  , IFNULL(modules.module_name, 'UNKNOWN') AS module_name
  , IFNULL(modules.module_duration, -9999) AS module_duration
  , IFNULL(modules.module_result, 'UNKNOWN') AS module_result
  , IFNULL(steps.step_sequence, -9999) AS step_sequence
  , IFNULL(steps.step_name, 'UNKNOWN') AS step_name
  , IFNULL(steps.step_result, 'UNKNOWN') AS step_result
  , IFNULL(steps.step_description_error, 'UNKNOWN') AS step_description_error
  , IFNULL(steps.document_type, 'UNKNOWN') AS document_type
  , IFNULL(steps.document_identification, 'UNKNOWN') AS document_identification
  , IFNULL(steps.customer_phone, 'UNKNOWN') AS customer_phone
  , IFNULL(steps.billing_account_id, 'UNKNOWN') AS billing_account_id

 FROM `keepcoding.ivr_calls` calls 
 LEFT
 JOIN `keepcoding.ivr_modules` modules 
 ON calls.ivr_id = modules.ivr_id
 LEFT
 JOIN `keepcoding.ivr_steps` steps 
 ON calls.ivr_id = steps.ivr_id AND modules.module_sequece = steps.module_sequece

ORDER BY calls_ivr_id DESC
