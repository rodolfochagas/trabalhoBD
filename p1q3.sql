SELECT conname as nome_chave_estrangeira,  pg_get_constraintdef(r.oid, true), conrelid::regclass, conindid::regclass     
FROM pg_constraint r
WHERE r.contype = 'f' ORDER BY 1;

-- SELECT conname,
-- pg_catalog.pg_get_constraintdef(r.oid, true) as condef
-- FROM pg_catalog.pg_constraint r
-- WHERE r.contype = 'f' ORDER BY 1
