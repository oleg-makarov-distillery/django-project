#!/bin/bash
git pull
python manage.py migrate
python manage.py collectstatic --noinput
