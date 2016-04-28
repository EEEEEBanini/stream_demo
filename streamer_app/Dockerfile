# Builds a docker image configured for the dev environment.

FROM phusion/passenger-ruby22

# Set correct environment variables.
ENV HOME /root
ENV FILE_SERVER_URL 'http://file_server:8889'

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

ADD . /home/app/streamer_app

# get rid of the version information in the path
RUN cd /home/app/streamer_app && bundle update && bundle install
RUN cd /home/app/streamer_app && RAILS_ENV=development bundle exec rake
RUN chown -R app:app /home/app/streamer_app

ADD streamer_app.conf /etc/nginx/sites-enabled/streamer_app.conf

EXPOSE 8888

RUN rm /etc/nginx/sites-enabled/default
RUN rm -f /etc/service/nginx/down


RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
