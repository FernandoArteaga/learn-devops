FROM node:20-alpine as build

ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable

WORKDIR /app

COPY . /app

RUN pnpm install --prod --frozen-lockfile && pnpm build

FROM nginx:alpine-slim
LABEL authors="fernandoarteaga"

COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
