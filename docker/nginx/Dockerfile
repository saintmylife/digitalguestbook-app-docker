FROM nginx:stable-perl
RUN apt-get update -qq && apt-get -y install apache2-utils

ENV RAILS_ROOT /app

RUN mkdir log
COPY nginx.conf /tmp/docker.nginx

RUN envsubst '$RAILS_ROOT' < /tmp/docker.nginx > /etc/nginx/conf.d/default.conf
EXPOSE 80

CMD [ "nginx", "-g", "daemon off;" ]