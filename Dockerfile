FROM centos:7

LABEL maintainer "Devtools <devtools@redhat.com>"
LABEL author "Devtools <devtools@redhat.com>"

RUN yum -y install epel-release centos-release-openshift-origin311.noarch && \
    yum -y install --enablerepo=epel podman make golang buildah origin-clients && \
	yum --disablerepo=base,updates --enablerepo=epel install git && \
    yum clean all && \
    mkdir -p /usr/local/bin && \
    curl -L $(curl -L -s "https://api.github.com/repos/openshift/source-to-image/releases/latest"| python -c "import sys, json;x=json.load(sys.stdin);print([ r['browser_download_url'] for r in x['assets'] if 'linux-amd64' in r['name']][0])") -o /tmp/s2i.tgz && \
    tar xz -f/tmp/s2i.tgz -C /usr/local/bin/ && \
	chmod -R 755  /usr/local/bin && \
	rm -f /tmp/s2i.tgz

CMD /usr/bin/buildah
