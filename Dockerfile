FROM node:18-alpine

# 1. Install lightweight init system
RUN apk add --no-cache dumb-init

WORKDIR /usr/src/app

# 2. Copy dependencies with non-root ownership
COPY --chown=node:node package*.json ./
RUN npm ci --only=production

# 3. Copy application files with non-root ownership
COPY --chown=node:node . .

EXPOSE 3000

# 4. Switch to non-root user
USER node

# 5. Use dumb-init to handle signals and PID 1 duties
CMD ["dumb-init", "node", "src/app.js"]