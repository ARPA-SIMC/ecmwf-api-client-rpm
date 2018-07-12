#!/bin/bash
set -exo pipefail

image=$1

if [[ $image =~ ^centos: ]]
then
    pkgcmd="yum"
    builddep="yum-builddep"
    sed -i '/^tsflags=/d' /etc/yum.conf
    yum install -q -y epel-release
    yum install -q -y @buildsys-build
    yum install -q -y yum-utils
#    yum install -q -y git
    yum install -q -y rpmdevtools
    yum install -q -y yum-plugin-copr
#    yum copr enable -q -y simc/stable epel-7
elif [[ $image =~ ^fedora: ]]
then
    pkgcmd="dnf"
    builddep="dnf builddep"
    sed -i '/^tsflags=/d' /etc/dnf/dnf.conf
    dnf install -q -y @buildsys-build
    dnf install -q -y 'dnf-command(builddep)'
#    dnf install -q -y git
    dnf install -q -y rpmdevtools
#    dnf copr enable -q -y simc/stable
fi

$builddep -y ecmwf-api-client.spec

if [[ $image =~ ^fedora: || $image =~ ^centos: ]]
then
    pkgname="$(rpmspec -q --qf="ecmwf-api-client-%{version}-%{release}\n" ecmwf-api-client.spec | head -n1)"
    mkdir -p ~/rpmbuild/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS}
    cp ecmwf-api-client.spec ~/rpmbuild/SPECS/
    spectool -g -R ~/rpmbuild/SPECS/ecmwf-api-client.spec
    rpmbuild -ba ~/rpmbuild/SPECS/ecmwf-api-client.spec
    find ~/rpmbuild/{RPMS,SRPMS}/ -name "${pkgname}*rpm" -exec cp -v {} . \;
    # TODO upload ${pkgname}*.rpm to github release on deploy stage
    ls -l *rpm
else
    echo "Unsupported image"
    exit 1
fi
