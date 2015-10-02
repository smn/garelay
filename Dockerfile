FROM python:2.7
MAINTAINER Praekelt Foundation <dev@praekeltfoundation.org>
COPY ./docker-entrypoint.sh /
RUN pip install garelay
RUN pip install gunicorn
RUN apt-get update
RUN apt-get install -qy supervisor
RUN apt-get install -qy redis-server
ENV GARELAY_PORT 8000
ENV GARELAY_SERVER http://www.example.com/server/
EXPOSE 8000
ENTRYPOINT ["./docker-entrypoint.sh"]
