FROM scratch
ADD root.tar.xz /
#RUN cat /etc/ssl/certs/*.pem > /etc/ssl/cert.pem
CMD ["/usr/bin/bash"]
