Python Versions
===============

compile a python version with [pyenv](https://github.com/yyuu/pyenv) to use it in your app.
I don't like the default python on heroku because I find it painful to
extend, or do anything slightly nonstandard with it.

Tested versions
--------

- Stackless 3.2.2
- CPython 3.4.0

Deployment
----------

::

    $ git clone git@github.com:Enucatl/python-versions.git
    $ heroku create --region eu
    $ git push heroku master
    $ heroku config:set BUILDPACK_URL=https://github.com/Enucatl/heroku-buildpack-pyenv-builder.git
    $ heroku config:set AWS_ACCESS_KEY_ID=xxxx AWS_SECRET_ACCESS_KEY=xxxx

Usage
-----

Once deployed, building a python version is simple::

    $ heroku run ./brew <formula> <bucket>
    # Builds specified Python to ``./python``.

Releasing a formula is simple::

    $ heroku run ./bottle <formula> <bucket>
    # Builds specified Python and uploads the resulting tarball to the given S3 bucket.

Distribution "Spec"
-------------------

``runtime-name.tar.bz2``, containing the standard .pyenv folder.

Notes
-----

Development python versions might need mercurial, which is not installed on
heroku.

Python packages are installed in the additional-packages.txt file

External libs are built by the parts/libs file into the .pyenv/lib folder

The compilation takes several tens of minutes, and the dyno might be
interrupted for some reason. If there are no errors, you just need to
restart it.
