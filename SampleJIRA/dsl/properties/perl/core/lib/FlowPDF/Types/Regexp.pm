# WARNING
# Do not edit this file manually. Your changes will be overwritten with next FlowPDF update.
# WARNING

package FlowPDF::Types::Regexp;
use strict;
use warnings;
use Carp;

use FlowPDF::Exception::MissingFunctionArgument;
use FlowPDF::Exception::WrongFunctionArgumentType;

sub new {
    my ($class, @regexps) = @_;

    if (!@regexps) {
        FlowPDF::Exception::MissingFunctionArgument->new({
            argument => 'Regexps'
        })->throw();
    }

    for my $reg (@regexps) {
        if (ref $reg ne 'Regexp') {
            FlowPDF::Exception::WrongFunctionArgumentType->new({
                argument =>'Regexps',
                got => ref $reg,
                expected => 'Regexp'
            })->throw();
        }
    }
    my $self = {
        regexps => \@regexps,
    };
    bless $self, $class;
    return $self;
}

sub match {
    my ($self, $value) = @_;

    if (ref $value) {
        return 0;
    }
    for my $reg (@{$self->{regexps}}) {
        if ($value =~ m/$reg/ms) {
            return 1;
        }
    }
    return 0;
}


sub describe {
    my ($self) = @_;

    my $regs = join ', ', @{$self->{regexps}};
    return "a scalar value that matches following regexps: ($regs).";
}


1;
