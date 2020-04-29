# BUILDER
FROM node:alpine AS aboutigor-builder
WORKDIR /app
COPY . .
RUN npm install && node_modules/.bin/coffee -b --output lib --compile src

# DEPENDENCIES
FROM node:alpine AS aboutigor-dependencies
ENV NODE_ENV=production
WORKDIR /app
COPY . .
RUN apk update && apk upgrade && npm install --production

# FINAL IMAGE
FROM node:alpine AS aboutigor-final
ENV NODE_ENV=production
WORKDIR /app
COPY . .
COPY --from=aboutigor-builder ./app/lib ./lib
COPY --from=aboutigor-dependencies ./app/node_modules ./node_modules
EXPOSE 8080
CMD ["npm", "start"]
