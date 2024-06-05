#populate.py - Punto-4

import psycopg2
import time

print("Se ejecuta el script para rellenar las columnas de la tabla ds_salaries")

time.sleep(100)
conn = psycopg2.connect("host=app-postgres-db dbname=ds_salaries user=postgres password=postgres")
cur = conn.cursor()
with open('/populate-db/ds_salaries.csv', 'r') as f:
    # Notitce that we don't need the `csv` module.
    next(f) # Skip the header row.
    cur.copy_from(f, 'ds_salaries', sep=',')

conn.commit()
time.sleep(100)

print("Ya terminó de ejecutarse el script con éxito!!!...")
