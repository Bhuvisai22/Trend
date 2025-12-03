# ---------- Stage 1: Build React app ----------
FROM node:18-alpine AS build

# Set working dir
WORKDIR /app

# Copy package files first (for better caching)
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy rest of the source
COPY . .

# Build for production
RUN npm run build

# ---------- Stage 2: Nginx to serve static files ----------
FROM nginx:alpine

# Remove default nginx static content
RUN rm -rf /usr/share/nginx/html/*

# Copy built React app from previous stage
COPY --from=build /app/build /usr/share/nginx/html

# Copy custom nginx config (optional, see below)
# If you create nginx.conf, uncomment this:
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
