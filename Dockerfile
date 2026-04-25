FROM python:3.13.13-alpine3.22
LABEL maintainer="Amr Elkfrawy"

ENV PYTHONUNBUFFERED=1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirments.dev.txt

WORKDIR /app
EXPOSE 8000

# We are overriding this argument in the docker-compose file, so it will be set to true when we are in development mode
ARG DEV=false

RUN python -m venv /py && \
/py/bin/pip install --upgrade pip && \
    apk add --no-cache postgresql-client && \
    apk add --no-cache --virtual .tmp-build-deps \
        build-base postgresql-dev musl-dev && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ "$DEV" = "true" ]; then /py/bin/pip install -r /tmp/requirments.dev.txt; fi && \
    rm -rf /tmp/requirements.txt && \
    apk del .tmp-build-deps && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user
        
COPY ./app /app


ENV PATH="/py/bin:$PATH"
USER django-user
