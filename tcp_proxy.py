#! /usr/bin/python

import sys
import time

import monocle
from monocle import _o
monocle.init("twisted")

from monocle.stack import eventloop
from monocle.stack.network import add_service, Service, Client, ConnectionLost

def make_pumper(direction):
    @_o
    def pump(input, output):
        while True:
            try:
                message = yield input.read_some()
                print "==== %s says: =======================================" % direction
                print message
                yield output.write(message)
            except ConnectionLost:
                output.close()
                break
    return pump

def make_proxy(backend_host, backend_port):
    @_o
    def proxy(conn):
        client = Client()
        yield client.connect(backend_host, backend_port)
        monocle.launch(make_pumper("client"), conn, client)
        pumper = make_pumper("server")
        yield pumper(client, conn)
    return proxy

def parse_host_port_str(host_port_str):
    host = "127.0.0.1"
    if ":" in host_port_str:
        host, port_str = host_port_str.split(":")
    else:
        port_str = host_port_str
    return host, int(port_str)

def usage():
    print "usage: python tcp_proxy.py <front_port> <backend_port>"

if len(sys.argv) < 3:
    usage()
    sys.exit(1)

frontend_port = int(sys.argv[1])
backend_host, backend_port = parse_host_port_str(sys.argv[2])
print "proxying localhost:{} -> {}:{}".format(frontend_port, backend_host, backend_port)
add_service(Service(make_proxy(backend_host, backend_port),
                    port=frontend_port))
eventloop.run()
