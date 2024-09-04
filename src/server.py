import sys
from http.server import BaseHTTPRequestHandler, HTTPServer
import socket

class SimpleHTTPRequestHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/helloworld':
            host = socket.gethostname().split('.')[0] # Without full domain (without ifi.uit.no)
            port = self.server.server_port
            self.send_response(200)
            self.end_headers()
            self.wfile.write(f"{host}:{port}".encode())

if __name__ == "__main__":
    port = int(sys.argv[1]) if len(sys.argv) > 1 else 5000  # default to 5000 if nothing else is spesifyed
    server_address = ('0.0.0.0', port)
    httpd = HTTPServer(server_address, SimpleHTTPRequestHandler)
    print(f"Server running on {socket.gethostname()}:{httpd.server_port}")
    httpd.serve_forever()


/mnt/users/joand4770/joand4770/src