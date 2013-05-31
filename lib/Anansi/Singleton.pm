package Anansi::Singleton;


=head1 NAME

Anansi::Singleton - A base module definition where only a single object instance
is allowed.

=head1 SYNOPSIS

    package Anansi::Example;

    use base qw(Anansi::Singleton);

    sub finalise {
        my ($self, %parameters) = @_;
    }

    sub fixate {
        my ($self, %parameters) = @_;
    }

    sub initialise {
        my ($self, %parameters) = @_;
    }

    sub reinitialise {
        my ($self, %parameters) = @_;
    }

    1;

=head1 DESCRIPTION

This is a base module definition that manages the creation and destruction of
module object instances that are not repeatable including embedded objects and
ensures that destruction can only occur when all duplicate object instances are
no longer used.  Uses L<Anansi::Class>, L<Anansi::ObjectManager> and L<base>.

=cut


our $VERSION = '0.03';

use base qw(Anansi::Class);

use Anansi::ObjectManager;


my $NAMESPACE = {};


=head1 INHERITED METHODS

=cut


=head2 finalise

Declared in L<Anansi::Class>.  Intended to be overridden by an extending module.

=cut


=head2 implicate

Declared in L<Anansi::Class>.  Intended to be overridden by an extending module.

=cut


=head2 import

Declared in L<Anansi::Class>.

=cut


=head2 initialise

Declared in L<Anansi::Class>.  Intended to be overriddeni by an extending module..

=cut


=head2 old

Declared in L<Anansi::Class>.

=cut


=head2 used

Declared in L<Anansi::Class>.

=cut


=head2 uses

Declared in L<Anansi::Class>.

=cut


=head1 METHODS

=cut


=head2 DESTROY

=over 4

=item self I<(Blessed Hash, Required)>

An object of this namespace.

=back

Performs module object instance clean-up actions.  Indirectly called by the perl
interpreter.

=cut


sub DESTROY {
    my ($self) = @_;
    my $objectManager = Anansi::ObjectManager->new();
    if(1 == $objectManager->registrations($self)) {
        $self->finalise();
        $objectManager->obsolete(
            USER => $self,
        );
        $objectManager->unregister($self);
    } elsif(1 < $objectManager->registrations($self)) {
        $self->fixate();
        $objectManager->unregister($self);
    }
}


=head2 fixate

=over 4

=item self I<(Blessed Hash, Required)>

An object of this namespace.

=item parameters I<(Hash, Optional)>

Named parameters.

=back

Called just prior to module instance object destruction where there are multiple
instances of the object remaining.  Intended to be overridden by an extending
module.  Indirectly called.

=cut


sub fixate {
    my ($self, %parameters) = @_;
}


=head2 new

    my $object = Anansi::Example->new();
    my $object = Anansi::Example->new(
        SETTING => 'example',
    );

Instantiates or reinstantiates an object instance of a module.  Indirectly
called via an extending module.

=cut


sub new {
    my ($class, %parameters) = @_;
    return if(ref($class) =~ /^(ARRAY|CODE|FORMAT|GLOB|HASH|IO|LVALUE|REF|Regexp|SCALAR|VSTRING)$/i);
    $class = ref($class) if(ref($class) !~ /^$/);
    if(!defined($NAMESPACE->{$class})) {
        my $self = {
            NAMESPACE => $class,
            PACKAGE => __PACKAGE__,
        };
        $NAMESPACE->{$class} = bless($self, $class);
        my $objectManager = Anansi::ObjectManager->new();
        $objectManager->register($NAMESPACE->{$class});
        $NAMESPACE->{$class}->initialise(%parameters);
    } else {
        my $objectManager = Anansi::ObjectManager->new();
        $objectManager->register($NAMESPACE->{$class});
        $NAMESPACE->{$class}->reinitialise(%parameters);
    }
    return $NAMESPACE->{$class};
}


=head2 reinitialise

Called just after module instance object recreation.  Intended to be overridden
by an extending module.  Indirectly called.

=cut


sub reinitialise {
    my ($self, %parameters) = @_;
}


=head1 NOTES

This module is designed to make it simple, easy and quite fast to code your
design in perl.  If for any reason you feel that it doesn't achieve these goals
then please let me know.  I am here to help.  All constructive criticisms are
also welcomed.

=cut


=head1 AUTHOR

Kevin Treleaven <kevin I<AT> treleaven I<DOT> net>

=cut


1;
