%define name ecmwf-api-client
%define version 1.5.0
%define release 1%{?dist}

Summary: Python client for ECMWF web services API.
Name: %{name}
Version: %{version}
Release: %{release}
Source0: https://confluence.ecmwf.int/download/attachments/56664858/ecmwf-api-client-python.tgz
License: UNKNOWN
Group: Development/Libraries
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-buildroot
Prefix: %{_prefix}

%if 0%{?rhel} == 7
Buildrequires: python
BuildRequires: python-setuptools
%else
Buildrequires: python2
BuildRequires: python2-setuptools
%endif

BuildArch: noarch
Vendor: ECMWF <software.support@ecmwf.int>
Url: https://software.ecmwf.int/stash/projects/PRDEL/repos/ecmwf-api-client/browse

%description
Python client for ECMWF web api for accessing public datasets.

%prep
%setup -c %{name}-%{version}

%build
python2 setup.py build

%install
python2 setup.py install --single-version-externally-managed -O1 --root=$RPM_BUILD_ROOT --record=INSTALLED_FILES

%clean
echo rm -rf $RPM_BUILD_ROOT

%files -f INSTALLED_FILES
%defattr(-,root,root)
