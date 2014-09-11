Django-quickstart
=================

Shell scripts that helps you quickly start a Django project.

Django's setup.py is only going so far in helping you start a Django
project quickly. A lot of additional setup is needed if one wants to
follow the best engineering practices. This script should help you
kick start things "the right way" (in no means the only right way). 

If you have any suggestions/feature requests/etc., please open an issue
and I'll look into adding it. 

TODO(brahle): This readme, like the project, is still under construction.

Motivation
==========

After reading a few blog posts on the internet that describe "the perfect
Django/Python server" environment, there seemed to be quite a lot of stuff
to do before one could actually start working on a project. To eliviete
that problem, one could use a script that does most of that work for the
engineer - which brings us to this project. 

TODO(brahle): add links to the blog posts.

The perfect environment
=======================

TODO(brahle): Order and connect this so it actually makes sense.

Directory structure
-------------------

Your project should be separated into a (at least) a few areas:

* Production - where the current stable version of your software is
served from. It is what your users see.
* Development - where you actually make changes while you are developing
the software. Your users shouldn't use this. 
* Nightly (optional) - the current master branch of your repository. You
can call this a Beta version.
 
This script creates only the first two areas.

Security
--------

You don't want to have your security (easily) breached. Django has a bad
habbit of saving the secret key inside the `settings.py` file. We, therefore,
change that, and **automatically generate the secret key and store it in a
separate file**. `.gitignore` will ensure that we won't commit it by accident. 

We also split `settings.py` into two files:

1. `settings_global.py` which holds global settings used by all developers
of the project. Almost the default `settings.py` with the improvement described
above.
2. `settings_local.py`, which hold specific settings regarding the current
server, like the database information. Although it is added to the
`.gitignore`, be careful not to commit the unwanted changes to the repisorty,
as that might leak your database username and password. It **takes precedence**
over `settings_global.py`, so you can use it to override settings on a
per-machine basis.

Virtual environment
-------------------

The production environment is inside a [virtual environment]
(http://docs.python-guide.org/en/latest/dev/virtualenvs/) and we add the activation
script of the environment to the git reposiotry. *This is the reason it doesn't work
with multiple servers/clients.*

Inside the virtual environment, we have the following (interesting) directories:

* `<PROJECT_NAME>` - which is where the git repository is at. 
* ...

TODO(brahle): **major** Allow users from other servers to simply duplicate the
virtual environment. 

Git repository
--------------

We commit the bare bones project to a git repository alongside with our 
basic .gitignore template. 

Static files
------------

...

Fabric
------

The provided `fabfile.py` offers you a few common workflows:

1. Merging your work to master
2. Quickly deploying your work to production


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
