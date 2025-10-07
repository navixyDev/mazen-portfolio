# Stage 1 — Build
FROM node:20-alpine AS builder
WORKDIR /app

COPY package*.json ./
RUN npm ci
COPY . .

# Build the Next.js app
RUN npm run build

# Stage 2 — Run
FROM node:20-alpine AS runner
WORKDIR /app

ENV NODE_ENV=production
# Copy only what is needed for runtime
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public

# Install only production deps
RUN npm ci --omit=dev

EXPOSE 3000

# Start Next.js server
CMD ["npm", "start"]
