FROM registry.access.redhat.com/ubi8/ubi:latest

EXPOSE 8080
EXPOSE 8888

#install packages 
RUN INSTALL_PKGS="python38 python38-devel python38-setuptools python38-pip nss_wrapper \
        httpd httpd-devel mod_ssl mod_auth_gssapi mod_ldap \
        mod_session atlas-devel gcc-gfortran libffi-devel libtool-ltdl enchant" && \
    yum -y module enable python38:3.8 httpd:2.4 && \
    yum -y --setopt=tsflags=nodocs install $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    rpm -e --nodeps redhat-logos-httpd && \
    yum -y clean all --enablerepo='*'

#setup venv
RUN python3.8 -m venv /py38env
RUN chown -R 1001:0 /py38env

#Activate venv and install packages
COPY requirements.txt .
RUN . /py38env/bin/activate && pip install -r requirements.txt

USER 1001
CMD . / /py38env/bin/activate