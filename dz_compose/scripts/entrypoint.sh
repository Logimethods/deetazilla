#!/bin/bash

command="$1"
shift 1

eval "./${command}.sh $@"