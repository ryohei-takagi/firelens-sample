FROM amazon/aws-for-fluent-bit:2.1.1

COPY ./docker/fluentbit/fluent-bit_custom.conf /fluent-bit/etc/fluent-bit_custom.conf
COPY ./docker/fluentbit/stream_processor.conf /fluent-bit/etc/stream_processor.conf
COPY ./docker/fluentbit/parser.conf /fluent-bit/etc/parser.conf