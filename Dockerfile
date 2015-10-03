FROM python:2.7
MAINTAINER Praekelt Foundation <dev@praekeltfoundation.org>
ENV GARELAY_VERSION 0.1.3
ENV GARELAY_ROOT=/garelay
ENV DATABASE_URL sqlite:///$GARELAY_ROOT/db.sqlite3
RUN pip install garelay==$GARELAY_VERSION
RUN pip install gunicorn
RUN pip install supervisor
RUN apt-get update
RUN apt-get install -qy redis-server multitail
RUN apt-get autoremove -qy
ENV GARELAY_PORT 8000
ENV GARELAY_SERVER http://www.example.com/server/
COPY ./docker-entrypoint.sh /
EXPOSE 8000
VOLUME $GARELAY_ROOT
ENTRYPOINT ["./docker-entrypoint.sh"]
