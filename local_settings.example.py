# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = 'CHANGEME'

# Database
# https://docs.djangoproject.com/en/1.10/ref/settings/#databases

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': 'CHANGEME',
        'USER': 'CHANGEME',
        'PASSWORD': 'CHANGEME',
        'HOST': 'localhost',
        'PORT': '5432',
    }
}
