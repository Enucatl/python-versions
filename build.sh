#!/usr/bin/env bash
# Usage: $ build.sh -f <formula> -p <prefix> [-x <archive>]

# Syntax sugar.
indent() {
  RE="s/^/       /"
  [ $(uname) == "Darwin" ] && sed -l "$RE" || sed -u "$RE"
}

function puts-step (){
  echo "-----> $@"
}


# Argument parsing.
while getopts ":f:x:p:r:" opt; do
  case $opt in
    f)
      FORMULA=$OPTARG
      echo "Using formula: $FORMULA" >&2
      ;;
    p)
      mkdir -p $OPTARG
      PREFIX_SHORT_PATH=$OPTARG
      PREFIX_PATH=`cd "$OPTARG"; pwd`
      echo "Using prefix:  $PREFIX_PATH" >&2
      ;;
    x)
      ARCHIVE=$OPTARG
      echo "Using archive: $OPTARG" >&2
      ;;
    r)
      S3_BUCKET=$OPTARG
      echo "Using s3 bucket: $OPTARG" >&2
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

if [ ! "$FORMULA" ]; then
    echo "Please specify a valid formula with -f." >&2
    exit 1;
fi

if [ ! "$PREFIX_PATH" ]; then
    echo "Please specify a valid prefix with -p." >&2
    exit 1;
fi

set -e
set -x

$(pwd)/parts/build-python $FORMULA | indent
export PYENV_ROOT=$(pwd)/.pyenv
export PATH=$PYENV_ROOT/bin:$PATH
eval "$(pyenv init -)"
unset PYTHONPATH
unset PYTHONHOME

pyenv rehash
pyenv versions
echo $FORMULA > .python-version
pyenv versions

ls .pyenv/shims
pyenv versions

which pyenv
which python
which pip

ls .pyenv/shims
pyenv versions

set +e
set +x

if [ "$ARCHIVE" ]; then
    echo "------> Archiving $FORMULA"
    tar cjf $ARCHIVE .pyenv
fi

if [ "$S3_BUCKET" ]; then
    echo "------> Releasing $FORMULA"
    s3put -b $S3_BUCKET $ARCHIVE
fi
