FROM python:2.7

ADD . /opt/django-project
WORKDIR /opt/django-project

RUN pip install -r /opt/django-project/requirements.txt

RUN ["chmod", "+x", "/opt/django-project/run.sh"]

CMD ["/opt/django-project/run.sh"]
