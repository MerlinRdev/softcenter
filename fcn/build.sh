#!/bin/sh

MODULE=fcn
VERSION=1.0
TITLE=一键接入局域网
DESCRIPTION="一款傻瓜式的接入局域网软件~"
HOME_URL=Module_fcn.asp

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here
do_build_result

# now backup
sh backup.sh $MODULE
