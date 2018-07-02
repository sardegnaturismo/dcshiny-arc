FROM alpine:latest

RUN \
	mkdir -p /aws && \
	apk -Uuv add groff less python py-pip && \
	pip install awscli && \
	apk --purge -v del py-pip && \
	rm /var/cache/apk/*

WORKDIR /aws
ADD ecs-worker.sh /
RUN chmod +x /ecs-worker.sh
CMD ["sh","/ecs-worker.sh"]
# ENTRYPOINT ["aws"]