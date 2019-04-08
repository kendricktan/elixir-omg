#!/usr/bin/python3
import psutil

from flask import Flask, jsonify

app = Flask(__name__)


@app.route('/')
def root_endpoint():
    return jsonify(success=True)


@app.route('/metrics')
def metrics_endpoint():
    ret_str = """
# HELP node_cpu CPU Percent
# TYPE node_cpu counter
node_cpu_usage_percent {}
    """.format(psutil.cpu_percent())

    return ret_str


if __name__ == '__main__':
    app.run('0.0.0.0', 8081)
