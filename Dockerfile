#===============================================================================
#
#                    ##        .
#              ## ## ##       ==
#           ## ## ## ##      ===
#       /""""""""""""""""\___/ ===
#  ~~~ {~~ ~~~~ ~~~ ~~~~ ~~ ~ /  ===- ~~~
#       \______ o          __/
#         \    \        __/
#          \____\______/
#
#  Subversion v1.8.x (latest) container for test purposes with Quay.io
#
#===============================================================================

# Pull base OS image, needs to be be CentOS v6.x as there are currently (Oct 2014) no SVN packages from WANDisco for CentOS v7
FROM centos:centos6
MAINTAINER Patrick M. Slattery <pslattery@mywebgrocer.org>

# WANdisco yum repo for SVN v1.8 for CentOS v6.x
ADD /etc/yum.repos.d /etc/yum.repos.d

# Install Apache and SVN server and client
RUN yum install -y httpd mod_dav_svn serf subversion subversion-python subversion-tools

# Optimized httpd.conf and subversion.conf
ADD /etc/httpd /etc/httpd
# SVN web access template files
ADD /var/www /var/www
# Startup script
ADD /usr/local/bin/run-httpd.sh /usr/local/bin/run-httpd.sh
RUN chmod -v +x /usr/local/bin/run-httpd.sh

# Create a test SVN repo
RUN mkdir -p /srv/svn
# This is critical, SVN will show nothing to clients if apache:apache does not own all the files.
RUN chown -cR apache:apache /srv/svn && chown -cR apache:apache /var/www
USER apache
RUN svnadmin create /srv/svn/test_repo
# Lines 35,38,39 can be removed from a production version of this container as a test repo would not be needed in such a case. Line 37 MUST be kept!

EXPOSE 80 443

USER root
CMD ["/usr/local/bin/run-httpd.sh"]
