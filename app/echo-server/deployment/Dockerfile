ARG base_image=non-existing
FROM $base_image

EXPOSE 1323

ENTRYPOINT ["/echo-server"]

ARG src_binary=non-existing

COPY $src_binary ./vmalert-prod