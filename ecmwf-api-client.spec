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
Buildrequires: python
BuildArch: noarch
Vendor: ECMWF <software.support@ecmwf.int>
Url: https://software.ecmwf.int/stash/projects/PRDEL/repos/ecmwf-api-client/browse

%description
UNKNOWN

%prep
%setup -c %{name}-%{version}

%build
python setup.py build

%install
python setup.py install --single-version-externally-managed -O1 --root=$RPM_BUILD_ROOT --record=INSTALLED_FILES

%clean
echo rm -rf $RPM_BUILD_ROOT

%files -f INSTALLED_FILES
%defattr(-,root,root)