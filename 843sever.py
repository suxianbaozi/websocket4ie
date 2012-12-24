import socket
import time
from threading import Thread

class returnCrossDomain(Thread):
    def __init__(self,connection):
        Thread.__init__(self)
        self.con = connection
    def run(self):
        clientData  = self.con.recv(1024)
        xmlData  = '''<?xml version="1.0" encoding="utf-8"?>'''
        xmlData += '''<!DOCTYPE cross-domain-policy SYSTEM "http://www.adobe.com/xml/dtds/cross-domain-policy.dtd">'''
        xmlData += '''<cross-domain-policy><site-control permitted-cross-domain-policies="all"/>'''
        xmlData += '''<allow-access-from domain="*.aifang.com" to-ports="*" />'''
        xmlData += '''<allow-access-from domain="*.anjuke.com" to-ports="*" />'''
        xmlData += '''<allow-access-from domain="*.haozu.com" to-ports="*" />'''
        xmlData += '''<allow-access-from domain="*.jinpu.com" to-ports="*" />'''
        xmlData += '''<allow-access-from domain="*.ajkcdn.com" to-ports="*" />'''
        xmlData += '''<allow-access-from domain="*.aifcdn.com" to-ports="*" />'''
        xmlData += '''<allow-access-from domain="*.anjukestatic.com" to-ports="*" />'''
	xmlData += '''</cross-domain-policy>\0'''
        try:
            self.con.send(xmlData)
        except Excepiton,e:
            pass
        self.con.close()
def main():
    sock = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
    sock.bind(('',843))
    sock.listen(100)
    while True:
        try:
            connection,address = sock.accept()
            returnCrossDomain(connection).start()
        except:
            time.sleep(1)

if __name__=="__main__":
    main()
            


 
