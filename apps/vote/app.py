# src code for a simple voting web application using Flask and Redis
# It allows users to vote between two options and stores votes in a Redis queue.
# The application also assigns a unique voter ID to each user via cookies.
# The app logs votes and handles both GET and POST requests.
# Configuration options for the two voting choices are set via environment variables.
# The application is designed to run in a containerized environment, such as Docker.
from flask import Flask, render_template, request, make_response, g
from redis import Redis
import os
import socket
import random
import json
import logging

option_a = os.getenv('OPTION_A', "Cats")
option_b = os.getenv('OPTION_B', "Dogs")
hostname = socket.gethostname()

app = Flask(__name__)
gunicorn_error_logger = logging.getLogger('gunicorn.error')
app.logger.handlers.extend(gunicorn_error_logger.handlers)
app.logger.setLevel(logging.INFO)

# Function to get a Redis connection, stored in Flask's g object for reuse
# across requests
# This avoids creating a new connection for each request
# and ensures the connection is properly closed when the request ends
# The Redis server is assumed to be running in a container named "redis"
def get_redis():
    if not hasattr(g, 'redis'):
        g.redis = Redis(
                        host=os.getenv("REDIS_HOST", "redis"),
                        port=int(os.getenv("REDIS_PORT", 6379)), 
                        db=0, 
                        socket_timeout=5,
                        decode_responses=True # Ensure responses are strings, not bytes
                        )
    return g.redis

# Route for the main page, handling both GET and POST requests
# On GET, it renders the voting page
# On POST, it processes the vote and stores it in Redis
# It also manages voter IDs via cookies
# The vote is logged for auditing purposes
@app.route("/", methods=['POST','GET'])
def hello():
    voter_id = request.cookies.get('voter_id')
    if not voter_id:
        voter_id = hex(random.getrandbits(64))[2:-1]

    vote = None

    if request.method == 'POST':
        redis = get_redis()
        vote = request.form['vote']
        app.logger.info('Received vote for %s', vote)
        data = json.dumps({'voter_id': voter_id, 'vote': vote})
        redis.rpush('votes', data)

    resp = make_response(render_template(
        'index.html',
        option_a=option_a,
        option_b=option_b,
        hostname=hostname,
        vote=vote,
    ))
    resp.set_cookie('voter_id', voter_id)
    return resp

# Run the Flask app
if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80, debug=True, threaded=True)
