# coding: utf-8

import os
from flask import Flask
import geoip2.database
import json

# initialize objects
app = Flask(__name__)
dbfile = os.getenv('GEOIP2_DB_FILE_NAME')
reader = geoip2.database.Reader(dbfile)


@app.route('/')
def index():
    return 'Hello world!'


@app.route('/<ipaddress>')
def ipaddress(ipaddress):
    try:
        response = reader.country(ipaddress)
        r = {
            'iso_code': response.country.iso_code,
            'country': response.country.names['en'],
            'error': None
        }
        return json.dumps(r)
    except Exception as e:
        r = {
            'iso_code': '',
            'country': '',
            'error': str(e)
        }
        return json.dumps(r), 400


@app.errorhandler(404)
def page_not_found(e):
    return 'Sorry, Nothing at this URL.', 404


@app.errorhandler(500)
def application_error(e):
    return 'Sorry, unexpected error: {}'.format(e), 500


if __name__ == '__main__':
    app.debug = True
    app.run(host='127.0.0.1')
