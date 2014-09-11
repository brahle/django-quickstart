Django-quickstart
=================

Shell scripts that help you quickly start a Django project.

Django's setup.py is only going so far in helping you start a Django
project quickly. A lot of additional setup is needed if one wants to
follow the best engineering practices. This script should help you
kick start things "the right way" (in no means the only right way). 

If you have any suggestions/feature requests/etc., please open an issue
and I'll look into adding it. 

Requirements
============

This script requires the following software to be installed:

* `python`
* `pip`

Additionally installed
------------------------------------

For all users:

* `django`

Inside a virtual envirnoment:

* `django`
* `south`
* `fabric`
* `gunicorn`

Usage
=====

It is enough to invoke `django-quickstart.sh` from the console.

The script will then do the following:

1. Install Django for all users
2. Create a virtual envirnoment
3. Install requirements (Django, south, fabric, gunicorn) inside the 
virtual environment
4. Create a Django project
5. Copy and complete the templates
6. Initialize empty database
7. Initialize south
8. Initialize fabric
9. Create a git repisotory
10. Create a development repository
11. Initiliaze nginx
12. Set up gunicorn
13. Collect static files
14. Optionally start gunicorn

Authors
=======

Bruno Rahle
