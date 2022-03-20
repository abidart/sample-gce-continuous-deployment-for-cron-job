FROM python:3.10-slim

ARG SAMPLE_VARIABLE_INJECTED_BY_GH_SECRETS
ENV SAMPLE_VARIABLE_INJECTED_BY_GH_SECRETS ${SAMPLE_VARIABLE_INJECTED_BY_GH_SECRETS}

RUN apt-get update
RUN apt-get -y install cron
RUN pip install poetry

WORKDIR /app
COPY cron /etc/cron.d/daily_cronjob

RUN chmod 0744 /etc/cron.d/daily_cronjob
RUN crontab /etc/cron.d/daily_cronjob
RUN touch /var/log/cron.log

COPY poetry.lock pyproject.toml ./
RUN poetry config virtualenvs.create false && poetry install --no-dev --no-interaction --no-ansi
COPY src ./src
RUN env >> /etc/environment
CMD cron && tail -f /var/log/cron.log