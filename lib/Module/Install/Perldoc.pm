##
# name:     Module::Install::Perldoc
# abstract: Support for Perldoc POD Generation
# author:   Ingy döt Net <ingy@ingy.net>
# year:     2006, 2007, 2011 
#
# = SYNOPSIS
#
#   use inc::Module::Install;
#
#   perldoc_make_pod;
#
# = DESCRIPTION
#
# This module provides a `perldoc_make_pod` Module::Install command for
# authors. This means that when a module author runs the `Makefile.PL`, a
# `.pod` file will be created from every `.pm` file with *Perldoc* style
# documentation.

package Module::Install::Perldoc;

use strict;
use Module::Install::Base;

use vars qw{$VERSION @ISA};
BEGIN {
    $VERSION = '0.10';
    @ISA     = qw{Module::Install::Base};
}

sub perldoc_make_pod {
    my $self = shift;
    return unless $self->is_admin;

    require File::Find;
    require Perldoc::Module;

    my @pms = glob('*.pm');
    File::Find::find( sub {
        push @pms, $File::Find::name if /\.pm$/i;
    }, 'lib');

    for my $pm (@pms) {
        my $module = Perldoc::Module->new(file => $pm);
        if ($module->needs_pod) {
            (my $pod = $pm) =~ s/\.pm$/.pod/;
            $module->write_pod($pod);
        }
    }
}

1;
