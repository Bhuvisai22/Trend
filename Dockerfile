# ---------- Stage 1: build frontend ----------
FROM node:18-alpine AS build

WORKDIR /app

# copy package files and install deps
COPY package*.json ./
RUN npm install

# copy source and build
COPY . .
RUN npm run build   # this should generate the dist/ folder

# ---------- Stage 2: run with nginx ----------
FROM nginx:alpine

# copy built files from previous stage
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
