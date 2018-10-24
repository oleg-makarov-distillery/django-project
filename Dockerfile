FROM python:3.6.0-slim

ADD . /opt/django-project
WORKDIR /opt/django-project

RUN apt-get update && apt-get install -y libpq-dev build-essential vim binutils libffi-dev \
&& pip install virtualenv \
&& pip install -r /opt/django-project/requirements.txt

RUN ["chmod", "+x", "/opt/django-project/run.sh"]

CMD ["/opt/django-project/run.sh"]
