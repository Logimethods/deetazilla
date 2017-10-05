#!/bin/bash

command="$1"
shift 1

exec "./${command}.sh $@"