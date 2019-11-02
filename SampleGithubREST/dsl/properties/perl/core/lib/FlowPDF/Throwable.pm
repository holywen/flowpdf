# WARNING
# Do not edit this file manually. Your changes will be overwritten with next FlowPDF update.
# WARNING

package FlowPDF::Throwable;

=head1 NAME

FlowPDF::Throwable

=head1 AUTHOR

CloudBees

=head1 DESCRIPTION

This class provides a low-level base class for exceptions that is being used in FlowPDF development.

If you're a framework developer and know what are you doing, use this class.
If you're looking for a base class for custom Exceptions, visit L<FlowPDF::Exception>.

B<Important note>

This class and inherited classes have automatic toString call in the scalar context.
It has been done to allow exceptions be used with regular croak or die function in the scalar context.

=head3 METHODS

This class provides following getters and setters:

=over

=item new($hashref)

Constructor. Accepts hash reference that may have fields: callInfo, message and code.

=item getMessage()

=item setMessage($str)

=item getCode()

=item setCode($str)

=item getCallInfo()

=item setCallInfo($str)

=item throw()

This function throws an exception.

=item toString()

Converts a throwable object into string. Automatically being applied in the scalar context.

=item is($reference)

Returns a true if $reference has the same reference as current throwable object. It is done for simplification of exception handling.
For example:

%%%LANG=perl%%%

try {
    $exception->throw();
} catch {
    my ($e) = @_;
    if ($e->is('CustomException1')) {
        ...;
    }
    elsif ($e->is('CustomException2')) {
        ...;
    }
}

%%%LANG%%%

=back

=cut




use overload '""' => 'toString';

use strict;
use warnings;
use Data::Dumper;
use Carp;
use FlowPDF::Types;
use FlowPDF::Devel::Stacktrace;


# This class has been created without inheriting of BaseClass or BaseClass2 for a reason.
# Since this is a very generic class and it is being used everywhere, including BaseClass and BaseClass2, it could not be extending that classes
# to avoid any circular depenencies. That is also a reason, why it is not annotated too much and annotations are not very user-friendly.

sub getMessage {
    my ($self) = @_;

    return $self->{message};
}

sub setMessage {
    my ($self, $message) = @_;

    $self->{message} = $message;
    return 1;
}

sub getCode {
    my ($self) = @_;

    return $self->{code};
}

sub setCode {
    my ($self, $code) = @_;

    $self->{code} = $code;
    return 1;
}

sub getCallInfo {
    my ($self) = @_;

    return $self->{callInfo};
}

sub setCallInfo {
    my ($self, $callInfo) = @_;

    $self->{callInfo} = $callInfo;
    return 1;
}

sub new {
    my ($class, $params) = @_;

    my $self = {};
    bless $self, $class;

    if (defined $params->{message}) {
        $self->setMessage($params->{message});
    }

    if (defined $params->{code}) {
        $self->setCode($params->{code});
    }

    if (defined $params->{callInfo}) {
        $self->setCallInfo($params->{callInfo});
    }
    return $self;
}


sub toString {
    my ($self) = @_;

    my $finalMessage = '';

    my $code = $self->getCode();
    if ($code) {
        my $code = $self->getCode();
        $finalMessage .= sprintf '[%s]: ', $code;
    }

    $finalMessage .= $self->getMessage();

    my $callInfo = $self->getCallInfo();
    my $tail = '';
    if ($callInfo) {
        $tail = "\n" . $callInfo->toString();
    }

    $finalMessage .= $tail;
    return $finalMessage;
}

sub throw {
    my ($self) = @_;

    $self->setCallInfo(FlowPDF::Devel::Stacktrace->new());

    croak $self;
}

sub is {
    my ($self, $what) = @_;

    # TODO: Validate here.
    unless (defined $what) {
        return undef;
    }
    my $class = ref $what ? ref $what : $what;
    if (ref $self eq $class) {
        return 1;
    }
    return 0;
}


1;


# throw new FlowPDF::Throwable ('');
