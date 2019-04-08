#!/usr/bin/python3
import time
import threading
import requests

from flask import Flask, jsonify

app = Flask(__name__)

request_caches = {
    'status_get_resp_time': 0,
    'status_get_resp_code': 200,
    'status_get_exception': '',
}

def time_requests():
    global request_caches

    start_time = time.time()
    try:
        resp = requests.post('http://localhost:7434/status.get')
        status_code = resp.status_code

    except requests.exceptions.ConnectionError:
        status_code = 520

    except Exception as e:
        request_caches['status_get_exception'] = str(e)
        status_code = 500

    end_time = time.time()

    request_caches['status_get_resp_time'] = '{:.4f}'.format(end_time - start_time)
    request_caches['status_get_resp_code'] = status_code

    threading.Timer(5.0, time_requests).start()


@app.route('/')
def root_endpoint():
    return jsonify(success=True)


@app.route('/metrics')
def metrics_endpoint():
    global request_caches

    ret_str = f"""
# HELP status_get Status.get request metrics
# TYPE status_get counter
# {request_caches['status_get_exception']}
status_get{{status_code="{request_caches['status_get_resp_code']}"}} {request_caches['status_get_resp_time']}
"""

    return ret_str


if __name__ == '__main__':
    time_requests()

    app.run('0.0.0.0', 8081)
