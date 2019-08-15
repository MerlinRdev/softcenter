#!/bin/sh

MODULE=uu
VERSION=1.2.12
TITLE="网易uu"
DESCRIPTION="网易uu"
HOME_URL=Module_uu.asp

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here
do_build_result

