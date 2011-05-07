use inc::Module::Install;

# perldoc_make_pod;
all_from 'lib/Perldoc.pm';
# readme_from 'lib/Perldoc.pod';
manifest_skip;
version_check;
ack_xxx;

requires 'Mouse';
requires 'YAML::XS';
requires 'IO::All';

use_test_base;

install_script 'bin/perl-doc';

WriteAll;
