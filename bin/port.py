#!/usr/bin/python
# -*- coding: utf8-*-

from subprocess import *
import subprocess
import socket
import re
import os
import sys

try:
    import urllib.request
    urllib.disable_warnings(urllib.exceptions.InsecureRequestWarning)
except:
    pass

is_a_tty = hasattr(sys.stdout, 'isatty') and sys.stdout.isatty()

IP=r"^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$"
TICK='✓'
CROSS='❌'
if is_a_tty:
    TICK="\033[32m%s\033[0m" % TICK
else:
    CROSS="\033[41m%s\033[0m" % ('X')
def execute(command, async=False):
    try:

        proc = subprocess.Popen(command,
                            stdout=subprocess.PIPE,
                            stderr=subprocess.STDOUT,
                            shell=True)

        out = proc.stdout.read();
    except Exception as e:
        return ""
    out = out.decode('ascii').split("\n")[0].strip(" ")
    if "command not found" not in out:
        return out
    return ""


def http_get(url, **kwargs):
    try:
        if sys.version_info.major == 2:
            from urllib import urlopen
        else:
           from urllib.request import urlopen
        result = urlopen(url)
        result.read()
        code = result.getcode()
        if code > 300 and code < 400:
            return http_get(r.headers['Location'], kwargs)
        if not (code >= 200 and code < 300) and code != 302:
            return CROSS + code, False
        return TICK, True
    except Exception as e:
        if 'code' in  e.__dict__:
            return CROSS + " " + str(e.code),False
        return CROSS,False



errors=False
hosts = []
for host in sys.argv[1].split(","):
    if re.match(IP,host) != None:
        hosts.append(host)
    else:  # expand DNS names to all hosts
        out=execute('dig +short %s | tr "\n" ","' % host)
        out= [h for h in out.split(",") if h != ""]
        if out is not None and len(out) > 0:
            hosts.extend(out)
        else:
            errors=True
            print(socket.gethostname() + " nslookup " + host + ":" + CROSS)



for host in hosts:
    sys.stdout.write(socket.gethostname() + " -> " + host)
    for port in sys.argv[2].split(","):
        try:
            sys.stdout.write('     %s:' % port)
            sys.stdout.flush()
            if "/" in port:
                scheme = "https" if "44" in port.split(':')[0] else "http"
                result, error = http_get("%s://%s:%s" % (scheme, host, port))
                sys.stdout.write(result)
                errors = errors or error
            else:
                s = socket.create_connection((host, int(port)), timeout=1)
                s.close()
                sys.stdout.write (TICK)
        except Exception as e:
            errors=True
            sys.stdout.write (CROSS)
    sys.stdout.write("\n")

sys.exit(1 if errors else 0)

