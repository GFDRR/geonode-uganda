# vim:set ft=dockerfile:

FROM python:2.7.14-stretch
MAINTAINER Ariel Núñez<ariel@terranodo.io>

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# This section is borrowed from the official Django image but adds GDAL and others
RUN apt-get update && apt-cache search gdal && apt-get install -y \
        gcc \
		gettext \
		postgresql-client libpq-dev \
		sqlite3 \
        python-psycopg2 \
        python-imaging python-lxml \
        python-dev \
        python-ldap \
        libmemcached-dev libsasl2-dev zlib1g-dev \
        python-pylibmc \
        uwsgi uwsgi-plugin-python\
        software-properties-common\
        libgdal-dev\
	--no-install-recommends && rm -rf /var/lib/apt/lists/*

# libgdal-dev 
# RUN apt-add-repository ppa:ubuntugis/ppa && apt-get update && apt-get install libgdal-dev
# Upgrade pip
RUN pip install --upgrade pip
RUN pip install pygdal==2.1.2.3

# To understand the next section (the need for requirements.txt and setup.py)
# Please read: https://packaging.python.org/requirements/

# python-gdal does not seem to work, let's install manually the version that is
# compatible with the provided libgdal-dev
#RUN pip install GDAL==2.2.1 --global-option=build_ext --global-option="-I/usr/include/gdal"

# Copy the requirements first to avoid having to re-do it when the code changes.
# Requirements in requirements.txt are pinned to specific version
# usually the output of a pip freeze
# COPY requirements.txt /usr/src/app/
# RUN pip install --no-cache-dir -r requirements.txt

# Update the requirements from the local env in case they differ from the pre-built ones.
COPY requirements.txt /usr/src/app/
#RUN git clone git://github.com/GeoNode/geonode.git --depth=1; cd geonode/; pip install -e .

RUN git clone git://github.com/cezio/geonode.git -b 3531_celery_module --depth=1; cd geonode/; pip install -e .

RUN pip install --no-cache-dir -r requirements.txt

COPY . /usr/src/app/
# ONBUILD RUN pip install --no-deps --no-cache-dir -e /usr/src/app/

RUN wget https://raw.githubusercontent.com/GeoNode/geonode-docker/master/wait-for-databases.sh
RUN chmod +x wait-for-databases.sh
RUN cp wait-for-databases.sh /usr/bin/wait-for-databases

#FROM terranodo/django:geonode
#MAINTAINER Ariel Núñez<ariel@terranodo.io>

RUN mkdir -p /usr/src/empty
RUN ln -fs /usr/lib/python2.7/plat-x86_64-linux-gnu/_sysconfigdata_nd.py /usr/lib/python2.7/
COPY scripts/misc/uwsgi.ini /usr/src/

RUN pip install --upgrade -e /usr/src/app/

CMD ["/usr/bin/uwsgi", "-c", "/usr/src/uwsgi.ini"]
