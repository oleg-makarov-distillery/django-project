#!/bin/bash
pip3 install -r requirements.txt
python3 manage.py migrate
python3 manage.py collectstatic --noinput
