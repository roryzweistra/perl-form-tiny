package Form::Tiny::Filter;

use Modern::Perl "2010";
use Moo;
use Types::Standard qw(HasMethods CodeRef);
use Carp qw(croak);

has "type" => (
	is => "ro",
	isa => HasMethods["check"],
	required => 1,
);

has "code" => (
	is => "rw",
	isa => CodeRef,
	required => 1,
);


around "BUILDARGS" => sub {
	my ($orig, $class, @args) = @_;

	croak "Argument to Form::Tiny->new must be a single arrayref with two elements"
		unless @args == 1 && ref $args[0] eq ref [] && @{$args[0]} == 2;
	return {type => $args[0][0], code => $args[0][1]};
};

sub filter
{
	my ($self, $value) = @_;

	if ($self->type->check($value)) {
		return $self->code->($value);
	}

	return $value;
}

no Moo;
1;
