# ==============================
# BUILD STAGE
# ==============================
FROM node:18-alpine AS builder

WORKDIR /app

COPY package*.json ./

RUN npm ci

COPY . .

RUN NODE_OPTIONS=--openssl-legacy-provider npm run build


# ==============================
# PRODUCTION STAGE
# ==============================
FROM nginx:alpine

# Copy React production build
COPY --from=builder /app/build /usr/share/nginx/html

# Nginx listens on 80 by default
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
