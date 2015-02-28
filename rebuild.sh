#!/bin/bash

#EPEL required for fcgi-devel library (x86_64)
sudo rpm -Uhv http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
# fixing: Instance Giving "Cannot retrieve metalink for repository: epel" Error
sudo sed -i "s/mirrorlist=https/mirrorlist=http/" /etc/yum.repos.d/epel.repo

#Configure Shibboleth repository for dependencies
sudo wget http://download.opensuse.org/repositories/security://shibboleth/RHEL_6/security:shibboleth.repo -O /etc/yum.repos.d/shibboleth.repo

#Install all the things!
#Note: most of the following was manually determined. YMMV on newer versions.
sudo yum install -y \
	rpm-build \
	yum-utils \
	libxerces-c-devel \
	libxml-security-c-devel \
	libxmltooling-devel \
	xmltooling-schemas \
	libsaml-devel \
	opensaml-schemas \
	liblog4shib-devel \
	chrpath boost-devel \
	doxygen \
	unixODBC-devel \
	fcgi-devel \
	httpd-devel \
	redhat-rpm-config \
	pcre-devel \
	zlib-devel 

#Download in the home directory of the VM. Don't use the shared directory.
cd ~

#Obtain the SPRM
shib_version=shibboleth-2.5.3
yumdownloader --source $shib_version
set -x 
#Rebuild with FastCGI support
now=$(date +%Y%m%d)
rpmbuild --rebuild --quiet shibboleth*.src.rpm --with fastcgi > build.$now.log

#Remove original SRPM
rm shibboleth*.src.rpm -f