FROM jetpackio/devbox:latest

WORKDIR /code
USER root:root
RUN mkdir -p /code && chown ${DEVBOX_USER}:${DEVBOX_USER} /code
USER ${DEVBOX_USER}:${DEVBOX_USER}

COPY --chown=${DEVBOX_USER}:${DEVBOX_USER} devbox.json devbox.json
COPY --chown=${DEVBOX_USER}:${DEVBOX_USER} devbox.lock devbox.lock
COPY --chown=devbox:devbox pyproject.toml pyproject.toml
COPY --chown=devbox:devbox uv.lock uv.lock

RUN devbox run -- echo "Installed Packages." && nix-store --gc && nix-store --optimise

COPY --chown=${DEVBOX_USER}:${DEVBOX_USER} . .

RUN devbox run -- uv sync --no-dev

EXPOSE 8000

CMD ["devbox", "run", "start"]
