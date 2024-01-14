CREATE OR REPLACE FUNCTION keepcoding.clean_integer(n_entero INT64)
RETURNS INT64
AS (
  IFNULL(n_entero, -999999)
)