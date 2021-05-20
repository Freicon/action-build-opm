FROM golang:latest AS build

ADD . /build
WORKDIR /build
RUN go version
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o /opmbuilder .

FROM gruebel/upx:latest as upx
COPY --from=build /opmbuilder /opmbuilder
RUN upx --best --lzma /opmbuilder

FROM alpine:latest
RUN apk --no-cache add ca-certificates git
WORKDIR /root/
COPY --from=upx /opmbuilder /opmbuilder
RUN /opmbuilder help
CMD ["/opmbuilder"]
