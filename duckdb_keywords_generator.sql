WITH stg_keywords AS (
    ((SELECT 'duckdb_keywords' AS keyword_group, keyword_name AS keywords FROM duckdb_keywords()) UNION
    (SELECT 'duckdb_settings' AS keyword_group, name AS keywords FROM duckdb_settings()) UNION
    (SELECT 'duckdb_functions' AS keyword_group, function_name AS keywords FROM duckdb_functions()) UNION
    (SELECT 'duckdb_types' AS keyword_group, type_name AS keywords FROM duckdb_types())) ORDER BY keywords ASC
  ), str_keywords AS (
    SELECT STRING_AGG(DISTINCT keywords, ' ') AS keywords FROM stg_keywords
  ), str_builtin AS (
    SELECT STRING_AGG(DISTINCT keywords, ' ') AS builtin FROM stg_keywords WHERE keyword_group IN ('duckdb_keywords', 'duckdb_settings')
  )
SELECT 
  (SELECT keywords FROM str_keywords) AS keywords,
  (SELECT builtin FROM str_builtin) AS builtin,
  (SELECT STRING_AGG(DISTINCT type_name, ' ') FROM duckdb_types()) AS types
