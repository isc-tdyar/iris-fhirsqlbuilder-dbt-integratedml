ARG IMAGE=containers.intersystems.com/intersystems/irishealth:2023.1.0.229.0
FROM intersystemsdc/iris-community:preview as community
FROM $IMAGE

ENV PATH="$PATH:/home/irisowner/.local/bin"

RUN pip install irissqlcli

COPY --from=community /docker-entrypoint.sh /

COPY --from=community /home/irisowner/bin/iriscli /home/irisowner/bin/

ENTRYPOINT [ "/tini", "--", "/docker-entrypoint.sh" ]

CMD [ "iris" ]
