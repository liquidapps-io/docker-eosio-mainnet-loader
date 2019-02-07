from ubuntu:latest
RUN apt-get update && apt-get install jq -y && rm -rf /var/lib/apt/lists/*
workdir /bootstrap
add entrypoint.sh .
entrypoint ["/bootstrap/entrypoint.sh"]