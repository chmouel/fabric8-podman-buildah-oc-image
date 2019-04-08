FROM centos:7

LABEL maintainer "Devtools <devtools@redhat.com>"
LABEL author "Devtools <devtools@redhat.com>"

ENV GIT_VERSION 2.21.0

# Update GIT cause I don't know any other ways to get offical centos git package that works in container
# the infamous error: fatal: unable to look up current user in the passwd file: no such user
RUN yum update -y && \
  yum install -y make curl-devel expat-devel gettext-devel openssl-devel zlib-devel gcc perl-ExtUtils-MakeMaker && \
  curl -L https://www.kernel.org/pub/software/scm/git/git-${GIT_VERSION}.tar.gz | tar xzv && \
  pushd git-${GIT_VERSION} && \
  make prefix=/usr/ install && \
  popd && \
  rm -rf git-${GIT_VERSION}* && \
  yum remove -y curl-devel expat-devel gettext-devel openssl-devel zlib-devel gcc perl-ExtUtils-MakeMaker make && \
  yum clean all

RUN yum -y install epel-release centos-release-openshift-origin311.noarch && \
  yum -y install --enablerepo=epel podman buildah origin-clients && \
  yum --disablerepo=base,updates --enablerepo=epel install git && \
  yum clean all && \
  mkdir -p /usr/local/bin && \
  curl -L $(curl -L -s "https://api.github.com/repos/openshift/source-to-image/releases/latest"| python -c "import sys, json;x=json.load(sys.stdin);print([ r['browser_download_url'] for r in x['assets'] if 'linux-amd64' in r['name']][0])") -o /tmp/s2i.tgz && \
  tar xz -f/tmp/s2i.tgz -C /usr/local/bin/ && \
  chmod -R 755  /usr/local/bin && \
  rm -f /tmp/s2i.tgz

RUN useradd -ms /bin/bash buildah
RUN echo buildah:500000:65536 > /etc/subuid && echo buildah:500000:65536 > /etc/subgid
USER buildah
WORKDIR /home/buildah
