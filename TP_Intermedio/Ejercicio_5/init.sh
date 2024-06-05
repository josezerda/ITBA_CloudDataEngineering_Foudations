#!/bin/bash

set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER"  <<-EOSQL

    DROP DATABASE IF EXISTS ds_salaries;

    CREATE DATABASE ds_salaries;

	\c ds_salaries ;
    
    DROP TABLE IF EXISTS ds_salaries;

    CREATE TABLE IF NOT EXISTS ds_salaries(
	    id	INTEGER,
	    work_year   TEXT,
	    experience_level    TEXT,
	    employment_type TEXT,
	    job_title   TEXT,
	    salary  INTEGER,
        salary_currency TEXT,
        salaryinusd INTEGER,
        employee_residence  TEXT,
        remote_ratio    INTEGER,
        company_location    TEXT,
        company_size    TEXT);

EOSQL
