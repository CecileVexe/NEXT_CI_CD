FROM node:24.2-alpine3.21 as builder

LABEL org.opencontainers.image.source https://github.com/cecilevexe/next_ci_cd

#Install de node
# RUN apt-get update -yq \
# && apt-get install curl gnupg -yq \
# && curl -sL https://deb.nodesource.com/setup_24.x | bash \
# && apt-get install nodejs -yq \
# && apt-get clean -y

ADD . /app/

WORKDIR /app

#ignore les dependencies de dev comme cypress
RUN npm install --omit=dev 
RUN npm run build

FROM node:24.2-alpine3.21 as next-ci-cd

#Pour le watch en dev
#COPY next.config.mjs ./next.config.mjs

COPY --from=builder /app/public ./public
COPY --from=builder /app/.next/standalone /app/
COPY --from=builder /app/.next/static /app/.next/static

WORKDIR /app
EXPOSE 3000

COPY docker/next/entrypoint.sh /usr/local/bin/entrypoint
RUN chmod +x /usr/local/bin/entrypoint

ENTRYPOINT [ "entrypoint" ]
CMD ["node", "server.js"]

EXPOSE 3000

COPY docker/next/entrypoint.sh /usr/local/bin/entrypoint
RUN chmod +x /usr/local/bin/entrypoint

ENTRYPOINT ["entrypoint"]

CMD ["npm", "run", "start"]