FROM node:18-alpine AS build_image

WORKDIR /usr/src/app

COPY package*.json ./

# RUN npm install --production
# RUN npm ci --omit=dev
RUN npm install

COPY . .

FROM node:18-alpine AS runner_image

WORKDIR /usr/src/app

COPY --from=BUILD_IMAGE /usr/src/app/node_modules ./node_modules
COPY src ./src
COPY package*.json server.js ./
COPY entrypoint.sh ./

RUN chmod +x entrypoint.sh

RUN ls -la ./

ENV PORT=5007
ENV ACTUAL_DATA_DIR=/data
# ENV NODE_ENV=production

EXPOSE ${PORT}

ENTRYPOINT [ "./entrypoint.sh" ]
