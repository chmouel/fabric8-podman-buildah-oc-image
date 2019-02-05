FROM centos:7

LABEL maintainer "Devtools <devtools@redhat.com>"
LABEL author "Devtools <devtools@redhat.com>"

RUN yum -y install epel-release centos-release-openshift-origin311.noarch && \
    yum -y install --enablerepo=epel podman make golang git buildah origin-clients && \
    yum clean all

CMD /usr/bin/buildah
