FROM centos:centos6
MAINTAINER Patrick M. Slattery <pslattery@mywebgrocer.org>
RUN yum install -y httpd
EXPOSE 80
CMD ["/bin/bash"]
