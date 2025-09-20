# base defines a base stage that uses the official python runtime base image
FROM python:3.12-slim AS base

# Add curl for healthcheck
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl && \
    rm -rf /var/lib/apt/lists/*

# Set the application directory
WORKDIR /usr/local/app

# Install our requirements.txt
COPY requirements.txt ./requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# final defines the stage that will bundle the application for production
FROM base AS final

# Copy our code from the current folder to the working directory inside the container
COPY . .

# Make port 80 available for links and/or publish
EXPOSE 80

# Define our command to be run when launching the container
# gunicorn is a production WSGI server that will serve the python app
# We set it to run 4 worker processes to handle requests
# We set the keep-alive to 0 so that connections are closed immediately after the response is sent
# This is important when running in environments like Kubernetes where idle connections can cause issues
CMD ["gunicorn", "app:app", "-b", "0.0.0.0:80", "--log-file", "-", "--access-logfile", "-", "--workers", "4", "--keep-alive", "0"]
