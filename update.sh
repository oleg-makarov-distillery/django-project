#!/bin/bash
git pull
pip install -r requirements
python manage.py migrate
python manage.py collectstatic --noinput
