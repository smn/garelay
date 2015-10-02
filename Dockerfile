FROM python:2.7
MAINTAINER Praekelt Foundation <dev@praekeltfoundation.org>
RUN pip install garelay==0.1.2
RUN pip install gunicorn
RUN pip install supervisor
RUN apt-get update
RUN apt-get install -qy redis-server multitail
RUN apt-get autoremove -qy
ENV GARELAY_PORT 8000
ENV GARELAY_SERVER http://www.example.com/server/
COPY ./docker-entrypoint.sh /
EXPOSE 8000
ENTRYPOINT ["./docker-entrypoint.sh"]
