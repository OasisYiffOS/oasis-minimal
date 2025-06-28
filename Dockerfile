FROM scratch
ADD root.tar.xz /
RUN yes | bulge s
RUN rm /var/run/run
RUN rm -R /var/run
RUN ln -s /run /var/run
RUN yes | bulge u
CMD ["/usr/bin/bash"]
