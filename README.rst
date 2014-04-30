Python Versions
===============

Pre-building hdf5, numpy and stackless python 3 for heroku.

Versions
--------

- Stackless Python 3.3.5

Deployment
----------

::

    $ git clone git@github.com:Enucatl/python-versions.git
    $ heroku create --region eu
    $ git push heroku master
    $ heroku config:set AWS_ACCESS_KEY_ID=xxxx AWS_SECRET_ACCESS_KEY=xxxx

Usage
-----

Once deployed, building a formula is simple::

    $ heroku run ./brew <formula> <bucket>
    # Builds specified Python to ``./python``.

Releasing a formula is simple::

    $ heroku run ./bottle <formula> <bucket>
    # Builds specified Python and uploads the resulting tarball to the given S3 bucket.

Distribution "Spec"
-------------------

``runtime-name.tar.bz2``, which contains ``PYTHONHOME``, including symlinks to python interpreters.
