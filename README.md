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

* [Python](https://www.python.org/) (2.7+)
* [Pip](https://pypi.python.org/pypi/pip)
* [Git](http://git-scm.com/)

You can typically install them with `sudo apt-get install python python-pip git-core`.

Additionally installed
----------------------

For all users:

* [Django](https://www.djangoproject.com/)

Inside a virtual envirnoment:

* [Django](https://www.djangoproject.com/)
* [South](http://south.aeracode.org/)
* [Fabric](https://github.com/mocco/django-fabric)
* [Gunicorn](http://gunicorn.org/)

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
