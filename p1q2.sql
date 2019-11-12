CREATE OR REPLACE FUNCTION RemoveIndices(Tabela regclass)
       RETURNS void AS $func$ 
      BEGIN
            EXECUTE ( SELECT 'DROP INDEX ' || string_agg(indexrelid::regclass::text, ', ')
                        FROM pg_index i 
                        LEFT JOIN pg_depend d
                        ON d.objid = i.indexrelid 
                        AND d.deptype = 'i'
                                    WHERE i.indrelid = Tabela::regclass 
                                          AND d.objid IS NULL);
       END
       $func$
      LANGUAGE plpgsql;


-- versão para uma tabela (tabela Album)
-- SELECT 'DROP INDEX ' || string_agg(indexrelid::regclass::text, ', ')
-- FROM pg_index i 
-- LEFT JOIN pg_depend d
-- ON d.objid = i.indexrelid 
-- AND d.deptype = 'i'
-- WHERE i.indrelid = (SELECT oid FROM pg_class WHERE relname = 'Album') 
-- AND d.objid IS NULL;