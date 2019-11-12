-- RETORNA TEXTO
CREATE OR REPLACE FUNCTION GerarCreateTable(tablename varchar)
    RETURNS SETOF text AS $$ 
    BEGIN
			RETURN QUERY
            SELECT                                 
            'CREATE TABLE ' || relname || E'\n(\n' ||
            array_to_string(
                array_agg(
                '    ' || column_name || ' ' ||  type || ' '|| not_null
                )
                , E',\n'
            ) || E'\n);\n'
            from
            (
            SELECT 
                c.relname, a.attname AS column_name,
                pg_catalog.format_type(a.atttypid, a.atttypmod) as type,
                case 
                when a.attnotnull
                then 'NOT NULL' 
                else 'NULL' 
                END as not_null 
            FROM pg_class c,
            pg_attribute a,
            pg_type t
            WHERE c.relname = tablename
            AND a.attnum > 0
            AND a.attrelid = c.oid
            AND a.atttypid = t.oid
            ORDER BY a.attnum
            ) as tabledefinition
            group by relname;
    END
    $$
    LANGUAGE plpgsql;


-- REALIZA O SELECT

CREATE OR REPLACE FUNCTION GerarCreateTable(tablename varchar)
    RETURNS void AS $func$ 
    BEGIN
            SELECT                                 
            'CREATE TABLE ' || relname || E'\n(\n' ||
            array_to_string(
                array_agg(
                '    ' || column_name || ' ' ||  type || ' '|| not_null
                )
                , E',\n'
            ) || E'\n);\n'
            from
            (
            SELECT 
                c.relname, a.attname AS column_name,
                pg_catalog.format_type(a.atttypid, a.atttypmod) as type,
                case 
                when a.attnotnull
                then 'NOT NULL' 
                else 'NULL' 
                END as not_null 
            FROM pg_class c,
            pg_attribute a,
            pg_type t
            WHERE c.relname = tablename
            AND a.attnum > 0
            AND a.attrelid = c.oid
            AND a.atttypid = t.oid
            ORDER BY a.attnum
            ) as tabledefinition
            group by relname
        );
    END
    $func$
    LANGUAGE plpgsql;

-- NOVA FUNÇÃO COM LOOP TABELAS

CREATE OR REPLACE FUNCTION gerarScript()
   RETURNS SETOF text AS $$
DECLARE 
    titles TEXT DEFAULT '';
    rec_film   RECORD;
    cur_films CURSOR
       FOR SELECT tablename
        FROM pg_catalog.pg_tables
        WHERE schemaname != 'pg_catalog'
        AND schemaname != 'information_schema';
BEGIN
   -- Open the cursor
   OPEN cur_films;
   
   LOOP
    -- fetch row into the film
      FETCH cur_films INTO rec_film;
    -- exit when no more row to fetch
      EXIT WHEN NOT FOUND;
 
    -- build the output
    titles := titles || ' ' || rec_film.tablename;
   END LOOP;

   -- Close the cursor
   CLOSE cur_films;
 
   RETURN titles;
END; $$
 
LANGUAGE plpgsql;




-- EXEMPLO EM QUE ME BASEEI

CREATE OR REPLACE FUNCTION get_film_titles(p_year INTEGER)
   RETURNS text AS $$
DECLARE 
    titles TEXT DEFAULT '';
    rec_film   RECORD;
    cur_films CURSOR(p_year INTEGER) 
       FOR SELECT title, release_year
       FROM film
       WHERE release_year = p_year;
BEGIN
   -- Open the cursor
   OPEN cur_films(p_year);
   
   LOOP
    -- fetch row into the film
      FETCH cur_films INTO rec_film;
    -- exit when no more row to fetch
      EXIT WHEN NOT FOUND;
 
    -- build the output
      IF rec_film.title LIKE '%ful%' THEN 
         titles := titles || ',' || rec_film.title || ':' || rec_film.release_year;
      END IF;
   END LOOP;
  
   -- Close the cursor
   CLOSE cur_films;
 
   RETURN titles;
END; $$
 
LANGUAGE plpgsql;


-- FUNÇÃO COM LOOP TABELAS (não deu certo)

CREATE OR REPLACE FUNCTION gerarScript()
  RETURNS  SETOF refcursor AS $BODY$
   DECLARE
  
      --cursor
      reg refcursor;
  
BEGIN
    OPEN reg FOR SELECT tablename
            FROM pg_catalog.pg_tables
            WHERE schemaname != 'pg_catalog'
            AND schemaname != 'information_schema';
    LOOP
        SELECT GerarCreateTable(reg::text);        
        RETURN NEXT reg;
    END LOOP;
   RETURN;
END;
$BODY$
  LANGUAGE plpgsql;


-- EXEMPLO EM QUE ME BASEEI
CREATE OR REPLACE FUNCTION meuesquema.telefones()
  RETURNS SETOF meuesquema.telefone AS
$BODY$
   DECLARE
  
      --cursor
      reg meuesquema.telefone%ROWTYPE;
  
BEGIN
  
      --realiza um loop em todos os telefones da tabela
      FOR reg in
                 SELECT tel.numero, tel.ddd, tel.operadora
                 FROM meuesquema.telefone tel
  
      LOOP
  
         RETURN NEXT reg;
  
   END LOOP;
  
   RETURN;
  
END;
  
$BODY$
  LANGUAGE plpgsql VOLATILE;























-- -- LISTAR TODAS AS TABELAS

SELECT tablename
FROM pg_catalog.pg_tables
WHERE schemaname != 'pg_catalog'
AND schemaname != 'information_schema';

-- -- MOSTRAR TABELA ESPECÍFICA

-- SELECT tablename
-- FROM pg_catalog.pg_tables
-- WHERE tablename = 'Album'::text; 