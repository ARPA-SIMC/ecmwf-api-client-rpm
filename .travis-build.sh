#!/bin/bash
set -exo pipefail

image=$1

if [[ $image =~ ^centos:7 ]]
then
    pkgcmd="yum"
    builddep="yum-builddep"
    sed -i '/^tsflags=/d' /etc/yum.conf
    yum install -q -y epel-release
    yum install -q -y @buildsys-build
    yum install -q -y yum-utils
    yum install -q -y rpmdevtools
elif [[ $image =~ ^centos:8 ]]
then
    pkgcmd="dnf"
    builddep="dnf builddep"
    sed -i '/^tsflags=/d' /etc/dnf/dnf.conf
    dnf install -q -y epel-release
    dnf install -q -y 'dnf-command(config-manager)'
    dnf config-manager --set-enabled powertools
    dnf groupinstall -q -y "Development Tools"
    dnf install -q -y 'dnf-command(builddep)'
    dnf install -q -y rpmdevtools
elif [[ $image =~ ^fedora: ]]
then
    pkgcmd="dnf"
    builddep="dnf builddep"
    sed -i '/^tsflags=/d' /etc/dnf/dnf.conf
    dnf install -q -y @buildsys-build
    dnf install -q -y 'dnf-command(builddep)'
    dnf install -q -y rpmdevtools
fi

$builddep -y ecmwf-api-client.spec

if [[ $image =~ ^fedora: || $image =~ ^centos: ]]
then
    pkgname="$(rpmspec -q --qf="ecmwf-api-client-%{version}-%{release}\n" ecmwf-api-client.spec | head -n1)"
    mkdir -p ~/rpmbuild/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS}
    cp ecmwf-api-client.spec ~/rpmbuild/SPECS/
    spectool -g -R ~/rpmbuild/SPECS/ecmwf-api-client.spec
    rpmbuild -ba ~/rpmbuild/SPECS/ecmwf-api-client.spec
else
    echo "Unsupported image"
    exit 1
fi
