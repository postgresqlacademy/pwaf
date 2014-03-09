#!/bin/bash

find ../src/ -type f|sort|xargs cat > build.sql
