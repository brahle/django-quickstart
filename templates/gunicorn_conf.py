# Copyright Bruno Rahle 2014
#
# Conceptually taken from
# https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-django-with-postgres-nginx-and-gunicorn
import multiprocessing

pythonpath = '<PRODUCTION_DIR>'
bind = '127.0.0.1:<PORT>'
workers = multiprocessing.cpu_count() * 2 + 1

