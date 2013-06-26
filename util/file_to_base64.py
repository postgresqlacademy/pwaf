#!/usr/bin/python

import sys, base64

print base64.b64encode(open(sys.argv[1]).read())
