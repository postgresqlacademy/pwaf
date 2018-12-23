#!/bin/bash

find ../src/ -type f ! -name ".DS_Store"|sort|xargs cat > build.sql
