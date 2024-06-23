# Documentación:

## Dataset:
*Usamos el siguiente dataset https://www.kaggle.com/datasets/arnabchaki/data-science-salaries-2023. El mismo contiene informacion detallada acerca del salario de los profesionales vinculados a Data Science. El dataset incluye la posicion en la que trabajan, el nivel de experiencia, tipo de empleo y ubicacion geografica. Esta dataset tiene como objetivo analizar la tendencia de los salarios y como influye sobre los mismos el area a lo que se dedica, region y compañia a la cual trabajan.


 Se eligió un Dataset llamado **ds_salaries**, un dataset que describe los salarios, mas detalle se encuentra en el [Readme.md](https://github.com/josezerda/ITBA_CloudDataEngineering_Foudations/blob/main/TP_Intermedio/Ejercicio_1/Ejercicio_1.md) escrito en el **Ejercicio: 1**.

<p align="center">
   <img src="https://github.com/josezerda/ITBA_CloudDataEngineering_Foudations/blob/main/TP_Intermedio/Documentacion/Imagenes/dataset.png" />
</p>

## Tecnologías:
Las tecnologías usadas para realizar el pipeline en este TP son:

* Docker.
* Docker Compose.
* Alpine.
* PostgreSQL.
* Adminer.
* Python 3.8.
* Ubuntu 20.04.
* Jupyter Notebook.

El pipeline está compuesto por las siguientes imagenes obtenidas de dockerhub:

* postgres:16-alpine
* adminer:latest.
* jupyter/scipy-notebook:ubuntu20.04-python3.8.

Las siguientes imagenes son auxiliares para la carga de los datos y para hacer consultas SQL en forma más interactiva.
* populate-db.
* jupyter.

Se uso un scrip de bash para crear la base de datos y las tablas a utilizar.
* init.sh.

## Expliación del Pipeline:

Armar el archivo docker-compose.yml
* El objetivo de este archivo es crear el pipeline para que orqueste la correcta ejecución de todos los contenedores usados para poder realizar las consultas de negocio pedidas en este TP.

````
# Docker-compose.yml

version: "3.8"
services:
  app-postgres-db:
    image: postgres:16-alpine
    hostname: app-postgres-db
    container_name: app-postgres-db
    restart: always
    environment:
      - POSTGRES_PASSWORD=postgres
      - POSTGRES_USER=postgres
    volumes:
      - ./postgres-db:/var/lib/postgresql/data
      - ./init.sh:/docker-entrypoint-initdb.d/init.sh
    ports:
      -  5455:5432
  adminer:
    image: adminer
    hostname: adminer
    container_name: adminer
    restart: always
    ports:
      - 8080:8080
  populate-db:
    build: ./populate-db/
    hostname: populate-db
    container_name: populate-db
    volumes:
      - ./ds_salaries:/ds_salaries
    depends_on:
      - app-postgres-db
  jupyter:
    build: ./jupyter/
    hostname: jupyter
    container_name: jupyter
    restart: always
    ports:
      - 8888:8888     
    volumes:
      - ./notebook:/notebook
    depends_on:
      - populate-db

volumes:
  postgres-database:
    external: true
  populate-db:
    external: true
  notebook:
    external: true
````
## Servicios:
**app-postgres-db:**
* Se arma dentro de `services`, todo el pipeline de containers a ejecutar, nosotros creamos el servicio `app-postgres-db` cuyo objetivo es levantar un sistema operativo `linux alpine` que viene ya instalado con `postgresql`, configuramos un enviroment, pasandole un nombre de usuario y una contraseña.
con respecto a `volumes`, configuramos un lugar para guardar la información de postgresql de la imagen del contenedor a una carpeta local, o sea lo que está en el directorio `/var/lib/postgresql/data` de `postgres:16-alpine`, se va a guardar en la carpeta local `postgres-db`, además vamos a copiar el script `init.sh` local hacia el directorio de la imagen `/docker-entrypoint-initdb.d/`, este script es importante ya que va a crear la database y las tablas en la imagen de postgres.
Por último exponemos el `puerto 5432` que es el de postgres, lo 5455:5432, significa que el puerto 5432 de la imagen de postgres va a ser igual al 5455 de mi puerto local, esto lo elegí así por que yo al tener instalado postgres en mi computadora local, el puerto 5432 ya estaba ocupado, por lo que tenía que ocupar otro puerto local.

**adminer:**
* `adminer:latest` es un contenedor que tiene instalado y configurado adminer, una herramienta para administrar contenido en bases de datos, que expone el `puerto 8080`, con esta herramienta vamos a verificar si el script `init.sh` pudo crear con éxito la **base de datos** y las **tablas**.

**populate-db:**
* Es una imagen creada manualmente mediante un `dockerfile`, donde pedimos que levante una imagen de `python`, e instale mediante un `requirement.txt` ciertas librerías para ejecutar scripts de SQL.
Además vamos a copiar de nuestro file local a esta imagen el archivo `populate-db.py`, una vez copiado vamos a ejecutar abrir python y vamos a ejecutar `populate-db.py`. con este script vamos a crear la **base de datos** y vamos a crear las **tablas** para que el servicio **app-postgres-db** las pueda usar.

````
# Dockerfile populate-db

FROM python:3
WORKDIR /app
ADD requirements.txt requirements.txt
RUN pip install -r requirements.txt
COPY populate.py populate.py
CMD ["python", "populate.py"]
````
* En el archivo `docker-compose.yml`, `populate-db` se comporta haciendo build al dockerfile que ejecuta los pasos antes explicados, luego copia el dataset `ds_salaries.csv` local a la imagen del contenedor, por medio de `volumes`, por últimos vamos a especificar que esta imagen `populate-db` va a depender que `app-postgres-db` se ejecute primero.

**jupyter:**
* Esta imagen hace un build a un archivo dockerfile para instalar y ejecutar `jupyter notebook`, expone el `puerto 8888`, además guarda el archivo jupyter notebook de la carpeta `/notebook` ubicado en la imagen a la carpeta `/notebook` local. tambien se describe que el `servicio jupyter` depende del `servicio populate-db`. 

````
# Dockerfile jupyter

FROM jupyter/scipy-notebook:a374cab4fcb6
WORKDIR /notebook
VOLUME /notebook
ENV JUPYTER_TOKEN=jupyter_token
ADD requirements.txt requirements.txt
RUN pip install -r requirements.txt
````

## Guía de Ejecución:
* Ir al directorio donde se ubica el archivo `docker-comporse.yml`

````
$ cd /home/jose/ITBA_AWS/ITBA_CloudDataEngineering_Foudations/TP_Intermedio/Ejercicio_5
````
* Podemos hacer `$ tree` y ver el directorio en forma de árbol:

<p align="center">
   <img src="https://github.com/josezerda/ITBA_CloudDataEngineering_Foudations/blob/main/TP_Intermedio/Documentacion/Imagenes/Imagen_tree.png" />
</p>


* Ejecutar:

````
$ docker compose up
````
<p align="center">
   <img src="https://github.com/josezerda/ITBA_CloudDataEngineering_Foudations/blob/main/TP_Intermedio/Documentacion/Imagenes/docker_compose_up.png" />
</p>

* Esperar hasta que se termine de ejecutar, una vez que se termine de ejecutar docker, podemos revisar si las tablas fueron creada con adminer.


* Ir al browser y escribir:

````
http://localhost:8080
````
* Va a aparecer en pantalla para loguearnos en Adminer:

<p align="center">
   <img src="https://github.com/josezerda/ITBA_CloudDataEngineering_Foudations/blob/main/TP_Intermedio/Documentacion/Imagenes/adminer.png" />
</p>

* Una vez logueados, probamos haciendo alguna consulta rápida para ver si todo funciona.

<p align="center">
   <img src="https://github.com/josezerda/ITBA_CloudDataEngineering_Foudations/blob/main/TP_Intermedio/Documentacion/Imagenes/probamos_consulta.png" />
</p>

* Cuando se terminé de cargar jupyter notebook:

<p align="center">
   <img src="https://github.com/josezerda/ITBA_CloudDataEngineering_Foudations/blob/main/TP_Intermedio/Documentacion/Imagenes/jupyter-notebook.png" />
</p>

* Ir al browser y escribir:

````
http://127.0.0.1:8888/lab?token=jupyter_token
````

* Ahora cargar librerias, conectarse al host:app-postgres-db a traves del puerto:5432, y escribir clave y contraseña establecidos en nuestro docker-compose.yml.

````
%sql postgresql://postgres:postgres@app-postgres-db:5432/amir_deals
````
<p align="center">
   <img src="https://github.com/josezerda/ITBA_CloudDataEngineering_Foudations/blob/main/TP_Intermedio/Documentacion/Imagenes/probamos_jupyter_nb.png" />
</p>

Con esto ya tenemos nuestro pipeline totalmente armado, además de poder hacer todo tipo de consultas en nuestra nueva base de datos postgres.

[Ir a Sección de Consultas](https://github.com/josezerda/ITBA_CloudDataEngineering_Foudations/blob/main/TP_Intermedio/Ejercicio_5/notebook/Notebook_Consultas.ipynb)

# Muchas Gracias.


