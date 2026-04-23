FROM node:20-bookworm-slim

WORKDIR /usr/src/app

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile --production=false

COPY . .

ENV PORT=8080

EXPOSE 8080

CMD ["node", "app.js"]
