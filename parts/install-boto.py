#!/usr/bin/env python

import sys
from subprocess import check_call

# check if python 2 or 3
if sys.version_info >= (3, 0):
    check_call("pip install git+https://github.com/boto/boto.git@py3kport#egg=boto", shell=True)
else:
    check_call("pip install boto", shell=True)
