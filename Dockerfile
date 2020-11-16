FROM bash:5.0.18

COPY generate-traefik-list.sh .

RUN chmod +x generate-traefik-list.sh
RUN sed -i 's%/bin/bash%/usr/local/bin/bash%' generate-traefik-list.sh

ENTRYPOINT ["./generate-traefik-list.sh"]
