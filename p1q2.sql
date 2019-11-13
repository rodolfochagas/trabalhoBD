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


-- VERSÃO PARA UMA TABELA (tabela Album)

-- SELECT 'DROP INDEX ' || string_agg(indexrelid::regclass::text, ', ')
-- FROM pg_index i 
-- LEFT JOIN pg_depend d
-- ON d.objid = i.indexrelid 
-- AND d.deptype = 'i'
-- WHERE i.indrelid = (SELECT oid FROM pg_class WHERE relname = 'Album') 
-- AND d.objid IS NULL;

-- VERSÃO QUE RETORNA TEXTO (NÃO DEU CERTO)

-- CREATE OR REPLACE FUNCTION criarRemoveIndices(Tabela regclass)
--        RETURNS SETOF text AS $func$ 
--       BEGIN
--       RETURN QUERY
--             SELECT 'DROP INDEX ' || string_agg(indexrelid::regclass::text, ', ')
--                   FROM pg_index i 
--             LEFT JOIN pg_depend d
--                   ON d.objid = i.indexrelid 
--             AND d.deptype = 'i'
--             WHERE i.indrelid = Tabela::regclass 
--                   AND d.objid IS NULL;
--        END
--        $func$
--       LANGUAGE plpgsql;

-- VERSÃO QUE SÓ RETORNA O NOME DO ÍNDICE (TABELA INVOICE)

-- SELECT indexrelid::regclass::text
--                   FROM pg_index i 
--             LEFT JOIN pg_depend d
--                   ON d.objid = i.indexrelid 
--             AND d.deptype = 'i'
--             WHERE i.indrelid = (SELECT oid FROM pg_class WHERE relname = 'Invoice') 
--                   AND d.objid IS NULL;