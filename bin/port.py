#!/usr/bin/python

import sys
from socket import *

s = socket(AF_INET, SOCK_STREAM)
try:
  host = sys.argv[1]
  port = int(sys.argv[2])
  print "Connecting to: " + host + ":" + str(port)
  s.connect((host, port))
  s.close()
  print '\033[92m' + "OK" + '\033[0m'
except Exception, e:
  s.close()
  print str(e)
  print '\033[91m' + "FAIL" +'\033[0m'