# ITBA - Cloud Data Engineering

Bienvenido al TP Intermedio de la sección Foundations del Módulo 1 de la Diplomatura en Cloud Data Engineering del ITBA.


## Ejercicio 1: Elección de dataset.

Crear un Pull Request con un archivo en formato **markdown** expliando el **dataset elegido** y una breve descripción de **al menos 4 preguntas de negocio** que se podrían responder teniendo esos datos en una base de datos relacional de manera que sean consultables con **lenguaje SQL**.

### _Respuesta Ejercicio 1:_
* El Dataset elegido es un dataset llamado **Data Science Job Salaries**, es un dataset obtenido de Kaggle. Este dataset tiene las columnas:

1. work_year:	The year the salary was paid.
2. experience_level:	The experience level in the job during the year with the following possible values: EN Entry-level / Junior MI Mid-level / Intermediate SE Senior-level / Expert EX Executive-level / Director
3. employment_type:	The type of employement for the role: PT Part-time FT Full-time CT Contract FL Freelance
4. job_title:	The role worked in during the year.
5. salary:	The total gross salary amount paid.
6. salary_currency:	The currency of the salary paid as an ISO 4217 currency code.
7. salary_in_usd:	The salary in USD (FX rate divided by avg. USD rate for the respective year via fxdata.foorilla.com).
8. employee_residence:	Employee's primary country of residence in during the work year as an ISO 3166 country code.
9. remote_ratio:	The overall amount of work done remotely, possible values are as follows: 0 No remote work (less than 20%) 50 Partially remote 100 Fully remote (more than 80%)
10. company_location:	The country of the employer's main office or contracting branch as an ISO 3166 country code.
11. company_size:	The average number of people that worked for the company during the year: S less than 50 employees (small) M 50 to 250 employees (medium) L more than 250 employees (large)

    
### Consultas:

* Las preguntas de negocio que se podrían responder con lenguaje SQL son:

Estan en la Jupyter Notebook "Notebook_Consultas.ipynb"