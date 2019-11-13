CREATE OR REPLACE FUNCTION gerarCreateTable(tablename varchar)
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

CREATE OR REPLACE FUNCTION gerarScript()
   RETURNS SETOF text AS $$
DECLARE 
    script TEXT DEFAULT '';
    rec_tabela RECORD;
    cur_tabelas CURSOR
       FOR SELECT tablename
        FROM pg_catalog.pg_tables
        WHERE schemaname != 'pg_catalog'
        AND schemaname != 'information_schema';
BEGIN
   -- Open the cursor
   OPEN cur_tabelas;
   
   LOOP
    -- fetch row into the film
      FETCH cur_tabelas INTO rec_tabela;
    -- exit when no more row to fetch
      EXIT WHEN NOT FOUND;
    -- build the output
    script := script || ' ' || gerarcreatetable(rec_tabela.tablename::varchar);
   END LOOP;

   -- Close the cursor
   CLOSE cur_tabelas;
 
   RETURN NEXT script;
END; $$
 
LANGUAGE plpgsql;

select gerarscript();




-- SAÍDA
 CREATE TABLE Artist
(
    ArtistId integer NOT NULL,
    Name character varying(120) NULL
);
 CREATE TABLE Album
(
    AlbumId integer NOT NULL,
    Title character varying(160) NOT NULL,
    ArtistId integer NOT NULL
);
 CREATE TABLE Employee
(
    EmployeeId integer NOT NULL,
    LastName character varying(20) NOT NULL,
    FirstName character varying(20) NOT NULL,
    Title character varying(30) NULL,
    ReportsTo integer NULL,
    BirthDate timestamp without time zone NULL,
    HireDate timestamp without time zone NULL,
    Address character varying(70) NULL,
    City character varying(40) NULL,
    State character varying(40) NULL,
    Country character varying(40) NULL,
    PostalCode character varying(10) NULL,
    Phone character varying(24) NULL,
    Fax character varying(24) NULL,
    Email character varying(60) NULL
);
 CREATE TABLE Customer
(
    CustomerId integer NOT NULL,
    FirstName character varying(40) NOT NULL,
    LastName character varying(20) NOT NULL,
    Company character varying(80) NULL,
    Address character varying(70) NULL,
    City character varying(40) NULL,
    State character varying(40) NULL,
    Country character varying(40) NULL,
    PostalCode character varying(10) NULL,
    Phone character varying(24) NULL,
    Fax character varying(24) NULL,
    Email character varying(60) NOT NULL,
    SupportRepId integer NULL
);
 CREATE TABLE Invoice
(
    InvoiceId integer NOT NULL,
    CustomerId integer NOT NULL,
    InvoiceDate timestamp without time zone NOT NULL,
    BillingAddress character varying(70) NULL,
    BillingCity character varying(40) NULL,
    BillingState character varying(40) NULL,
    BillingCountry character varying(40) NULL,
    BillingPostalCode character varying(10) NULL,
    Total numeric(10,2) NOT NULL
);
 CREATE TABLE InvoiceLine
(
    InvoiceLineId integer NOT NULL,
    InvoiceId integer NOT NULL,
    TrackId integer NOT NULL,
    UnitPrice numeric(10,2) NOT NULL,
    Quantity integer NOT NULL
);
 CREATE TABLE Track
(
    TrackId integer NOT NULL,
    Name character varying(200) NOT NULL,
    AlbumId integer NULL,
    MediaTypeId integer NOT NULL,
    GenreId integer NULL,
    Composer character varying(220) NULL,
    Milliseconds integer NOT NULL,
    Bytes integer NULL,
    UnitPrice numeric(10,2) NOT NULL
);
 CREATE TABLE Playlist
(
    PlaylistId integer NOT NULL,
    Name character varying(120) NULL
);
 CREATE TABLE PlaylistTrack
(
    PlaylistId integer NOT NULL,
    TrackId integer NOT NULL
);
 CREATE TABLE Genre
(
    GenreId integer NOT NULL,
    Name character varying(120) NULL
);
 CREATE TABLE MediaType
(
    MediaTypeId integer NOT NULL,
    Name character varying(120) NULL
);
 CREATE TABLE album
(
    albumid integer NOT NULL,
    title character varying(160) NOT NULL,
    artistid integer NOT NULL
);
