FROM scratch
ADD root.tar.xz /
RUN make-ca -C /etc/ssl/certdata.txt
CMD ["/usr/bin/bash"]
