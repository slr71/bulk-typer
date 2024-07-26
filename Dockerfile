FROM clojure:temurin-22-lein-jammy

WORKDIR /usr/src/app

RUN apt-get update && \
    apt-get install -y git && \
    rm -rf /var/lib/apt/lists/*

RUN ln -s "/opt/java/openjdk/bin/java" "/bin/bulk-typer"

COPY project.clj /usr/src/app/
RUN lein deps

COPY conf/main/logback.xml /usr/src/app/
COPY . /usr/src/app

RUN lein do clean, uberjar && \
    cp target/bulk-typer-standalone.jar .

ENTRYPOINT ["bulk-typer", "-Dlogback.configurationFile=/etc/iplant/de/logging/bulk-typer-logging.xml", "-cp", ".:bulk-typer-standalone.jar", "bulk_typer.core"]
CMD ["--help"]

ARG git_commit=unknown
ARG version=unknown
ARG descriptive_version=unknown

LABEL org.cyverse.git-ref="$git_commit"
LABEL org.cyverse.version="$version"
LABEL org.cyverse.descriptive-version="$descriptive_version"
LABEL org.label-schema.vcs-ref="$git_commit"
LABEL org.label-schema.vcs-url="https://github.com/cyverse-de/bulk-typer"
LABEL org.label-schema.version="$descriptive_version"
