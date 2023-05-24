FROM apache/superset:2.1.0

RUN pip install superset-iris

COPY docker-entrypoint.sh /app/

COPY superset_config.py /app/pythonpath/superset_config.py

CMD [ "/app/docker-entrypoint.sh" ]