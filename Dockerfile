FROM golang:alpine3.7 as builder
RUN apk add --no-cache \
	git \
	upx
RUN go get github.com/poppen/hugo-amazon-api
WORKDIR $GOPATH/src/github.com/poppen/hugo-amazon-api
RUN go build -ldflags "-s -w"
RUN go get github.com/pwaller/goupx
RUN goupx hugo-amazon-api
RUN cp hugo-amazon-api /app

FROM alpine as runner
ENV DOMAIN JP
ENV PORT 8080
COPY --from=builder ./app /
CMD /app -access "$ACCESS_KEY" -secret "$SECRET_KEY" -tag "$ASSOCIATE_TAG" -domain "$DOMAIN" -port "$PORT" -redis-url "$REDIS_URL"
