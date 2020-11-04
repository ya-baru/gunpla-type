FROM ruby:2.7.1-alpine

ENV RUNTIME_PACKAGES="git vim nodejs yarn postgresql tzdata gmp-dev ruby-dev graphviz less imagemagick curl fontconfig make" \
  CHROME_PACKAGES="chromium-chromedriver zlib-dev chromium xvfb wait4ports xorg-server dbus ttf-freefont mesa-dri-swrast udev" \
  BUILD_PACKAGES="build-base curl-dev postgresql-dev linux-headers libxml2-dev" \
  ROOT="/gunpla-type" \
  LANG=C.UTF-8 \
  TZ=Asia/Tokyo

WORKDIR ${ROOT}
COPY Gemfile ${ROOT}
COPY Gemfile.lock ${ROOT}

RUN apk update && \
  apk upgrade && \
  apk add --no-cache ${RUNTIME_PACKAGES} && \
  apk add --no-cache ${CHROME_PACKAGES} && \
  apk add --virtual build-packages --no-cache ${BUILD_PACKAGES} && \
  bundle install -j4 && \
  apk del build-packages && \
  curl -O https://noto-website.storage.googleapis.com/pkgs/NotoSansCJKjp-hinted.zip && \
  mkdir -p /usr/share/fonts/NotoSansCJKjp && \
  unzip NotoSansCJKjp-hinted.zip -d /usr/share/fonts/NotoSansCJKjp/ && \
  rm NotoSansCJKjp-hinted.zip && \
  fc-cache -fv

COPY . ${ROOT}

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
