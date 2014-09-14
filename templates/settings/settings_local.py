# Local Django settings. Use this to overload global settings to your liking.

# Database
# https://docs.djangoproject.com/en/1.6/ref/settings/#databases
import os

BASE_DIR = os.path.dirname(os.path.dirname(__file__))

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': os.path.join(BASE_DIR, 'db.sqlite3'),
    }
}

