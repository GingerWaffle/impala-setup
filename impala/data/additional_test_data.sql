-- Views
CREATE VIEW IF NOT EXISTS tpcds_raw.v_web_sales_summary AS
SELECT ws_sold_date_sk, SUM(ws_net_profit) AS total_profit
FROM tpcds_raw.web_sales
GROUP BY ws_sold_date_sk;

CREATE VIEW IF NOT EXISTS tpcds_raw.v_top_customers AS
SELECT c_customer_id, c_first_name, c_last_name, SUM(ss_net_profit) AS total_spent
FROM tpcds_raw.customer
JOIN tpcds_raw.store_sales ON c_customer_sk = ss_customer_sk
GROUP BY c_customer_id, c_first_name, c_last_name
ORDER BY total_spent DESC
LIMIT 10;

CREATE VIEW IF NOT EXISTS tpcds_raw.v_promotion_impact AS
SELECT p_promo_id, p_channel_email, p_channel_dmail, SUM(ss_quantity) AS total_quantity
FROM tpcds_raw.promotion
JOIN tpcds_raw.store_sales ON ss_promo_sk = p_promo_sk
GROUP BY p_promo_id, p_channel_email, p_channel_dmail;

CREATE VIEW IF NOT EXISTS tpcds_raw.v_customer_demographics AS
SELECT cd_demo_sk, cd_gender, cd_marital_status, cd_education_status, COUNT(*) AS count
FROM tpcds_raw.customer_demographics
GROUP BY cd_demo_sk, cd_gender, cd_marital_status, cd_education_status;

CREATE VIEW IF NOT EXISTS tpcds_raw.v_yearly_sales_by_category AS
SELECT i_category, i_class, YEAR(FROM_UNIXTIME(ss_sold_date_sk)) AS year, SUM(ss_net_paid) AS total_sales
FROM tpcds_raw.store_sales
JOIN tpcds_raw.item ON ss_item_sk = i_item_sk
GROUP BY i_category, i_class, YEAR(FROM_UNIXTIME(ss_sold_date_sk));

-- User Defined Functions (UDFs)
DROP FUNCTION IF EXISTS tpcds_raw.lower_case(STRING);
CREATE FUNCTION tpcds_raw.lower_case(STRING) RETURNS STRING
LOCATION '/user/hive/warehouse/external/udfs/impala-udfs-1.jar'
SYMBOL='com.epam.mv.ToLower';

DROP FUNCTION IF EXISTS tpcds_raw.calculate_tax(DOUBLE);
CREATE FUNCTION tpcds_raw.calculate_tax(DOUBLE) RETURNS DOUBLE
LOCATION '/user/hive/warehouse/external/udfs/impala-udfs-1.jar'
SYMBOL='com.epam.mv.CalculateTax';

DROP FUNCTION IF EXISTS tpcds_raw.parse_date(STRING);
CREATE FUNCTION tpcds_raw.parse_date(STRING) RETURNS STRING
LOCATION '/user/hive/warehouse/external/udfs/impala-udfs-1.jar'
SYMBOL='com.epam.mv.ParseDate';

DROP FUNCTION IF EXISTS tpcds_raw.days_between(STRING, STRING);
CREATE FUNCTION tpcds_raw.days_between(STRING, STRING) RETURNS INT
LOCATION '/user/hive/warehouse/external/udfs/impala-udfs-1.jar'
SYMBOL='com.epam.mv.DaysBetween';

DROP FUNCTION IF EXISTS tpcds_raw.format_currency(DOUBLE);
CREATE FUNCTION tpcds_raw.format_currency(DOUBLE) RETURNS STRING
LOCATION '/user/hive/warehouse/external/udfs/impala-udfs-1.jar'
SYMBOL='com.epam.mv.FormatCurrency';

DROP FUNCTION IF EXISTS tpcds_raw.HasVowels(String);
CREATE FUNCTION tpcds_raw.HasVowels(String) RETURNS BOOLEAN
LOCATION '/user/hive/warehouse/external/udfs/libmyudf.so' SYMBOL='HasVowels';

DROP FUNCTION IF EXISTS tpcds_raw.CountVowels(String);
CREATE FUNCTION tpcds_raw.CountVowels(String) RETURNS INT
LOCATION '/user/hive/warehouse/external/udfs/libmyudf.so' SYMBOL='CountVowels';

-- User Defined Aggregate Functions (UDAFs)
DROP AGGREGATE FUNCTION IF EXISTS tpcds_raw.SumOfSquares(BIGINT);
CREATE AGGREGATE FUNCTION tpcds_raw.SumOfSquares(BIGINT) RETURNS BIGINT
LOCATION '/user/hive/warehouse/external/udfs/libmyudf.so'
INIT_FN='SumOfSquaresInit'
UPDATE_FN='SumOfSquaresUpdate'
MERGE_FN='SumOfSquaresMerge'
FINALIZE_FN='SumOfSquaresFinalize';
