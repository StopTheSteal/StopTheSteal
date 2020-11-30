--
-- PostgreSQL database dump
--

-- Dumped from database version 12.4 (Debian 12.4-1.pgdg100+1)
-- Dumped by pg_dump version 12.5 (Ubuntu 12.5-0ubuntu0.20.04.1)

-- Started on 2020-11-29 16:36:14 EST

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 2935 (class 1262 OID 615555)
-- Name: td_vote; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE td_vote WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8';


ALTER DATABASE td_vote OWNER TO postgres;

\connect td_vote

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 6 (class 2615 OID 615556)
-- Name: sts; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA sts;


ALTER SCHEMA sts OWNER TO postgres;

--
-- TOC entry 220 (class 1255 OID 615583)
-- Name: fn_get_precinct_aggregates(character varying); Type: FUNCTION; Schema: sts; Owner: postgres
--

CREATE FUNCTION sts.fn_get_precinct_aggregates(_state character varying) RETURNS TABLE(as_of timestamp without time zone, state character varying, file timestamp without time zone, county character varying, vote_type character varying, votes real, bidenj_votes real, trumpd_votes real, other_votes real, fips_code character varying)
    LANGUAGE plpgsql SECURITY DEFINER COST 1000 ROWS 300
    AS $$
BEGIN
RETURN QUERY
SELECT DISTINCT
	  precinct."as_of"
	, precinct."state"
	, CAST(precinct."file" as timestamp without time zone) as "file"
	, CAST(p ->> 'locality_name' as character varying) as county
	, CAST(p ->> 'vote_type' as character varying) as vote_type
	, SUM(CAST(p ->> 'votes' as real)) as votes
	, SUM(CAST(p -> 'results' ->> 'bidenj' as real)) as bidenj_votes
	, SUM(CAST(p -> 'results' ->> 'trumpd' as real)) as trumpd_votes
	, SUM(CAST(p ->> 'votes' as real) - (CAST(p -> 'results' ->> 'bidenj' as real) + CAST(p -> 'results' ->> 'trumpd' as real))) as other_votes
	, CAST(p ->> 'locality_fips' as character varying) as fips_code
FROM sts.precinct
,json_array_elements(payload) p
WHERE precinct."state" = _state
GROUP BY
	  precinct.as_of
	, precinct."state"
	, CAST(precinct."file" as timestamp without time zone)
	, CAST(p ->> 'locality_name' as character varying)
	, CAST(p ->> 'vote_type' as character varying)
	, CAST(p ->> 'locality_fips' as character varying);
END
$$;


ALTER FUNCTION sts.fn_get_precinct_aggregates(_state character varying) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 205 (class 1259 OID 615578)
-- Name: agg_mi_102020; Type: TABLE; Schema: sts; Owner: postgres
--

CREATE TABLE sts.agg_mi_102020 (
    county_name character varying(250) NOT NULL,
    fips_code character varying(5) NOT NULL,
    num_registered_voters bigint NOT NULL,
    num_perm_absentee_voters bigint NOT NULL
);


ALTER TABLE sts.agg_mi_102020 OWNER TO postgres;

--
-- TOC entry 2936 (class 0 OID 0)
-- Dependencies: 205
-- Name: TABLE agg_mi_102020; Type: COMMENT; Schema: sts; Owner: postgres
--

COMMENT ON TABLE sts.agg_mi_102020 IS 'Aggregate counts of the Wisconsin 5758 File provided by u/bear__aware
https://thedonald.win/p/11Q8O8e13w/i-purchased-the-remaining-25025-/c/';


--
-- TOC entry 204 (class 1259 OID 615575)
-- Name: census; Type: TABLE; Schema: sts; Owner: postgres
--

CREATE TABLE sts.census (
    state character varying(25),
    county character varying(50),
    "2010" integer,
    "2011" integer,
    "2012" integer,
    "2013" integer,
    "2014" integer,
    "2015" integer,
    "2016" integer,
    "2017" integer,
    "2018" integer,
    "2019" integer,
    fips_code character varying(5)
);


ALTER TABLE sts.census OWNER TO postgres;

--
-- TOC entry 2937 (class 0 OID 0)
-- Dependencies: 204
-- Name: TABLE census; Type: COMMENT; Schema: sts; Owner: postgres
--

COMMENT ON TABLE sts.census IS 'Estimated census from 7/2019
https://www2.census.gov/programs-surveys/popest/tables/2010-2019/counties/totals/co-est2019-annres.xlsx';


--
-- TOC entry 203 (class 1259 OID 615565)
-- Name: precinct; Type: TABLE; Schema: sts; Owner: postgres
--

CREATE TABLE sts.precinct (
    as_of timestamp without time zone,
    file character varying,
    payload json,
    state character varying(25)
);


ALTER TABLE sts.precinct OWNER TO postgres;

--
-- TOC entry 2938 (class 0 OID 0)
-- Dependencies: 203
-- Name: TABLE precinct; Type: COMMENT; Schema: sts; Owner: postgres
--

COMMENT ON TABLE sts.precinct IS 'NY Times precinct data crawled from links in Edison data. Only 5 states contain precinct data: Michigan, Pennsylvania, North Carolina, Florida, Georgia';


--
-- TOC entry 206 (class 1259 OID 615584)
-- Name: vw_precinct_aggregates_michigan; Type: MATERIALIZED VIEW; Schema: sts; Owner: postgres
--

CREATE MATERIALIZED VIEW sts.vw_precinct_aggregates_michigan AS
 SELECT fn_get_precinct_aggregates.as_of,
    fn_get_precinct_aggregates.state,
    fn_get_precinct_aggregates.file,
    fn_get_precinct_aggregates.county,
    fn_get_precinct_aggregates.vote_type,
    fn_get_precinct_aggregates.votes,
    fn_get_precinct_aggregates.bidenj_votes,
    fn_get_precinct_aggregates.trumpd_votes,
    fn_get_precinct_aggregates.other_votes,
    fn_get_precinct_aggregates.fips_code
   FROM sts.fn_get_precinct_aggregates('Michigan'::character varying) fn_get_precinct_aggregates(as_of, state, file, county, vote_type, votes, bidenj_votes, trumpd_votes, other_votes, fips_code)
  WITH NO DATA;


ALTER TABLE sts.vw_precinct_aggregates_michigan OWNER TO postgres;

--
-- TOC entry 207 (class 1259 OID 616367)
-- Name: vw_michigan; Type: VIEW; Schema: sts; Owner: postgres
--

CREATE VIEW sts.vw_michigan AS
 WITH cte AS (
         SELECT census.county,
                CASE census.fips_code
                    WHEN '18141'::text THEN '26149'::character varying
                    ELSE census.fips_code
                END AS fips_code,
            census."2019" AS "2019_county_census",
            voter_roll.num_perm_absentee_voters,
            voter_roll.num_registered_voters,
            census.state
           FROM (sts.census
             JOIN sts.agg_mi_102020 voter_roll ON (((census.fips_code)::text = (voter_roll.fips_code)::text)))
          WHERE ((census.state)::text = 'Michigan'::text)
        ), combine_rolls AS (
         SELECT cte_1.county,
            cte_1.fips_code,
            sum(cte_1."2019_county_census") AS "2019_county_census",
            sum(cte_1.num_perm_absentee_voters) AS num_perm_absentee_voters,
            sum(cte_1.num_registered_voters) AS num_registered_voters,
            cte_1.state
           FROM cte cte_1
          GROUP BY cte_1.county, cte_1.fips_code, cte_1.state
        )
 SELECT precinct.file,
    cte.fips_code,
    cte.county AS "2019_census.county",
    cte."2019_county_census" AS "2019_census.count",
    cte.num_perm_absentee_voters AS "voter_roll.num_perm_absentee_voters",
    cte.num_registered_voters AS "voter_roll.num_registered_voters",
    precinct.vote_type,
    precinct.bidenj_votes,
    precinct.trumpd_votes,
    precinct.other_votes,
    cte.state AS "census.state"
   FROM (combine_rolls cte
     LEFT JOIN sts.vw_precinct_aggregates_michigan precinct ON (((cte.fips_code)::text = (precinct.fips_code)::text)))
  ORDER BY cte.county, precinct.file, precinct.vote_type;


ALTER TABLE sts.vw_michigan OWNER TO postgres;

--
-- TOC entry 2800 (class 2606 OID 615582)
-- Name: agg_mi_102020 agg_mi_102020_pkey; Type: CONSTRAINT; Schema: sts; Owner: postgres
--

ALTER TABLE ONLY sts.agg_mi_102020
    ADD CONSTRAINT agg_mi_102020_pkey PRIMARY KEY (county_name, fips_code, num_registered_voters, num_perm_absentee_voters);


--
-- TOC entry 2801 (class 1259 OID 615591)
-- Name: ix_vw_precinct_aggregates_michigan_fips_code; Type: INDEX; Schema: sts; Owner: postgres
--

CREATE INDEX ix_vw_precinct_aggregates_michigan_fips_code ON sts.vw_precinct_aggregates_michigan USING btree (fips_code);


--
-- TOC entry 2795 (class 1259 OID 615571)
-- Name: precinct_expr_idx; Type: INDEX; Schema: sts; Owner: postgres
--

CREATE INDEX precinct_expr_idx ON sts.precinct USING btree ((((payload -> 0) ->> 'locality_name'::text)));


--
-- TOC entry 2796 (class 1259 OID 615572)
-- Name: precinct_expr_idx1; Type: INDEX; Schema: sts; Owner: postgres
--

CREATE INDEX precinct_expr_idx1 ON sts.precinct USING btree ((((payload -> 0) ->> 'locality_fips'::text)));


--
-- TOC entry 2797 (class 1259 OID 615573)
-- Name: precinct_expr_idx2; Type: INDEX; Schema: sts; Owner: postgres
--

CREATE INDEX precinct_expr_idx2 ON sts.precinct USING btree ((((payload -> 0) ->> 'votes'::text)));


--
-- TOC entry 2798 (class 1259 OID 615574)
-- Name: precinct_state_idx; Type: INDEX; Schema: sts; Owner: postgres
--

CREATE INDEX precinct_state_idx ON sts.precinct USING btree (state);


-- Completed on 2020-11-29 16:36:14 EST

--
-- PostgreSQL database dump complete
--

