# Temel Node.js imajı
FROM node:20-alpine AS deps
WORKDIR /app
COPY package.json yarn.lock* package-lock.json* ./
RUN npm install --frozen-lockfile

# Uygulamayı build etme
FROM node:20-alpine AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN npm run build

# Üretim imajını oluşturma
FROM node:20-alpine AS runner
WORKDIR /app
ENV NODE_ENV production

# Next.js uygulaması için gerekli dosyaları kopyalama
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/public ./public
COPY --from=builder /app/package.json ./package.json

# Uygulama portu 
EXPOSE 3000
CMD ["npm", "start"]