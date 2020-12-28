FROM ubuntu:latest
COPY ./bin/prom2click /prom2click

ENTRYPOINT ["/prom2click"]

