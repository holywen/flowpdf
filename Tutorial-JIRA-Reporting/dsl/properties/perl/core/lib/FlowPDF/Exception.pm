# WARNING
# Do not edit this file manually. Your changes will be overwritten with next FlowPDF update.
# WARNING

package FlowPDF::Exception;

use base qw/FlowPDF::Throwable/;
use strict;
use warnings;
use Data::Dumper;

sub new {
    my ($class, @params) = @_;

    my $creationParams = {};
    # getting exception code for an exception definition.
    # if getCode function is available, it will be called.
    if ($class->can('exceptionCode')) {
        $creationParams->{code} = $class->exceptionCode()
    }
    # now let's try to get a template.
    # the exception class could have either template or render.
    # if it has a template, it will be used just as sprintf with parameters.

    # we can render
    if ($class->can('render')) {
        $creationParams->{message} = $class->render(@params);
    }
    # using template
    elsif ($class->can('template')) {
        my $template = $class->template();
        $creationParams->{message} = sprintf($template, @params);
    }
    # joining as message
    else {
        $creationParams->{message} = join '', @params;
    }

    my $self = $class->SUPER::new($creationParams);
    return $self;
}

=head1 NAME

FlowPDF::Exception

=head1 AUTHOR

CloudBees

=head1 DESCRIPTION

A superclass for exceptions in FlowPDF. All out-of-the box exeptions that are provided by FlowPDF are subclasses of this one.

For more details about exceptions and how to use them follow Plugin Developer's Guide.

FlowPDF provides, out of the box, following exceptions:

=head2 List of available out of the box exceptions.

=over

=item L<FlowPDF::Exception::UnexpectedEmptyValue>

An exception that could be used when something returned an unexpected undef or empty string.

=item L<FlowPDF::Exception::MissingFunctionDefinition>

An exception, that could be used when class does not have required function defined.

=item L<FlowPDF::Exception::MissingFunctionArgument>

An exception, that could be used when function expecting required parameter, and this parameter is missing.

=item L<FlowPDF::Exception::WrongFunctionArgumentType>

An exception, that could be used when function received an argument, but it has different type.

=item L<FlowPDF::Exception::WrongFunctionArgumentValue>

An exception, that could be used when function received an argument, but its value is wrong.

=item L<FlowPDF::Exception::EntityDoesNotExist>

An exception, that could be used when something does not exist, but it should. Like key in hash.

=item L<FlowPDF::Exception::EntityAlreadyExists>

An exception, that could be used when something exists, but it should not, like user with the same email.

=item L<FlowPDF::Exception::RuntimeException>

A generic runtime exception.

=back

=head2 Few words about exceptions handling in FlowPDF

We strongly recommend to use Try::Tiny for exceptions handling because eval {} approach has a lot of flaws.

Pne of them is that exception, that was raised during eval {} is automatically being assigned to global variable $@.
There are too many things that could go wrong. Try::Tiny is available in ec-perl.

For example:

%%%LANG=perl%%%

try {
    ...;
} catch {
    ...;
} finally {
    ...;
}

%%%LANG%%%

=head1 USING OUT-OF-THE-BOX EXCEPTIONS

To use any of out of the box exceptions you need to import them as regular perl module,
then create an exception object (see documentation for an exception that you want create),
then throw and then catch. For example, we will be using L<FlowPDF::Exception::UnexpectedEmptyValue> as example.

%%%LANG=perl%%%

use strict;
use warnings;
use Try::Tiny;
# 1. Import.
use FlowPDF::Exception::UnexpectedEmptyValue;
use FlowPDF::Log;

try {
    dangerous('');
} catch {
    my ($e) = @_;
    # 3. Validate.
    if ($e->is('FlowPDF::Exception::UnexpectedEmptyValue')) {
        # 4. Handle.
        logInfo("Unexpected empty value caught: $e");
    }
};

sub dangerous {
    my ($arg) = @_;

    unless ($arg) {
        # 2. Create and throw.
        FlowPDF::Exception::UnexpectedEmptyValue->new({
            where    => '1st argument',
            expected => 'non-empty value'
        })->throw();
    }
}

%%%LANG%%%

=head1 CREATING YOUR OWN EXCEPTIONS

To create your own exceptions for a plugin, you need to do the following things:

=over

=item Inherit FlowPDF::Exception

=item Define exceptionCode method

This method should return a line, that will be used as code for your exception. It could be:

%%%LANG=perl%%%

sub exceptionCode {
    return 'CUST001';
}

%%%LANG%%%

=item Define render or template methods.

You need to define only one of them.
Template method should return sprintf template, which will be used during exception object creation.
This template will be interpolated using parameters from new() method. This is simple way.

Render method accepts all parameters, that were provided to new() method, but you have to return ready-to-use message.
This method is more advanced way of exceptions creation and provides full control.

=back

Simple exception using render could be implemented like that:

%%%LANG=perl%%%

package FlowPDF::Exception::WithRender;
use base qw/FlowPDF::Exception/;
use strict;
use warnings;

sub exceptionCode {
    return 'WTHRNDR01';
}

sub render {
    my ($class, @params) = @_;
    my $message = "Following keys are wrong: " . join(', ', @params);
    return $message;
}

1;

%%%LANG%%%

=cut

1;
