SELECT *
FROM pg_indexes
-- WHERE tablename NOT LIKE 'pg%';
WHERE schemaname = 'public';