#!/usr/bin/python
# -*- coding: utf-8 -*-

#
# @package PWAF-HTTP-CONNECTOR
# @author Karolis Strumskis (karolis@strumskis.com)
# @copyright (C) 2011 postgresqlacademy.com and other contributors
# @license Licensed under the MIT License
# 
# @version 0.1
#

import cherrypy
import psycopg2
import base64

# Sukuriam connection kiekvienam thread
def connect(thread_index):
	cherrypy.thread_data.db = psycopg2.connect("host='127.0.0.1' dbname='pwaf_testing' user='pwaf_web' password='pwaf_web_pass'")
	cherrypy.thread_data.db.set_isolation_level(0)

# Cherrypy startuoja connect su kiekvienu thread
cherrypy.engine.subscribe('start_thread', connect)

class App(object):

	@cherrypy.expose
	def default(self, *vpath, **params):
		method = getattr(self, "handle_" + cherrypy.request.method, None)
		if not method:
			methods = [x.replace("handle_", "")
			for x in dir(self) if x.startswith("handle_")]
			cherrypy.response.headers["Allow"] = ",".join(methods)
			raise cherrypy.HTTPError(405, "Method not implemented.")
		return method(*vpath,**params)

	def handle_GET(self, *vpath, **params):

		cherrypy.session['lock'] = 1

		vpath_new = []
		for i in range(len(vpath)):
			vpath_new.append(vpath[i].replace("'",""))

		path = "'"+("','".join(vpath_new))+"'"
		
		##################################
		#
		#		GET/POST PARAMS
		#
		##################################

		param_names = []
		param_values = []
		
		if cherrypy.request.process_request_body:

		    if 'Content-Length' in cherrypy.request.headers:
			cl = cherrypy.request.headers['Content-Length']
    			rawbody = cherrypy.request.body.read(int(cl))

			param_names.append('Request-Payload')
			param_values.append(base64.b64encode(rawbody.encode("utf-8")))

		# encode and put GET/POST variable names into param_names and coresponding values to param_values
		for i in range(len(params.items())):
			param_names.append(params.items()[i][0]);
			param_values.append(base64.b64encode(params.items()[i][1].encode("utf-8")))
		
		# prepare pgsql arrays
		param_names = "'"+("','".join(param_names))+"'"
		param_values = "'"+("','".join(param_values))+"'"

		##################################
		#
		#		SYSTEM PARAMS
		#
		##################################

		system_param_names = []
		system_param_values = []

		system_param_names.append('session_id')
		system_param_values.append(base64.b64encode(cherrypy.session.id.encode("utf-8")))

		for header in cherrypy.request.headers:
			system_param_names.append(header)
			system_param_values.append(base64.b64encode(cherrypy.request.headers[header].encode("utf-8")))
			
		# prepare pgsql arrays
		system_param_names = "'"+("','".join(system_param_names))+"'"
		system_param_values = "'"+("','".join(system_param_values))+"'"

		c = cherrypy.thread_data.db.cursor()
		c.execute( "SELECT * FROM pwaf_web.http_request_handle(('"+cherrypy.request.method+"',"+
			"array[ "+path+" ]::text[],"+
			"array[ "+param_names+" ]::text[],"+
			"array[ "+param_values+" ]::text[],"+
			"array[ "+system_param_names+" ]::text[],"+
			"array[ "+system_param_values+" ]::text[]"+
		")::pwaf_web.http_request);" )

		data = c.fetchone()
		c.connection.commit()
		c.close()

		if data[0] in ('image/jpeg','image/png'):
			retval = base64.b64decode(data[1])
		else:
			retval = data[1]

		cherrypy.response.headers['Content-Type']=data[0]

		if data[3]:
			for header in data[3]:
				header = data[3][0].split(':', 1)
				cherrypy.response.headers[header[0]]=header[1]

		cherrypy.response.status = data[2]

		return retval

	def handle_POST(self, *vpath, **params):
		return self.handle_GET(*vpath,**params)

	def handle_PUT(self, *vpath, **params):
		return self.handle_GET(*vpath,**params)

	def handle_PATCH(self, *vpath, **params):
		return self.handle_GET(*vpath,**params)

	def handle_OPTIONS(self, *vpath, **params):
		return self.handle_GET(*vpath,**params)

	def handle_DELETE(self, *vpath, **params):
		return self.handle_GET(*vpath,**params)



settings = {

		'global': {
			'server.socket_host': '0.0.0.0',
			'server.socket_port': 8081,
			'server.thread_pool': 30,
			'server.socket_queue_size': 10,
			'log.screen': True,
			'tools.sessions.on': True,
			'tools.sessions.timeout': 60,
			'tools.encode.on': True,
			'tools.encode.encoding': 'utf-8',
			'tools.gzip.on':True,
			'tools.gzip.mime_types':['text/html','text/plain','text/css','text/javascript','application/json']
		}

}

cherrypy.config.update(settings)

cherrypy.quickstart(App())