FROM python:3.6.0-slim

ADD . /opt/django-project
WORKDIR /opt/django-project

RUN apt-get update && apt-get install -y curl \
&& echo "deb http://packages.cloud.google.com/apt gcsfuse-jessie main" | tee /etc/apt/sources.list.d/gcsfuse.list \
&& curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
&& apt-get update \
&& apt-get install -y libpq-dev build-essential vim binutils libffi-dev libmysqlclient-dev gcsfuse \
&& pip install -r /opt/django-project/requirements.txt

RUN ["chmod", "+x", "/opt/django-project/run.sh"]

CMD ["/opt/django-project/run.sh"]
