package WebService::SmartyStreets;
use Moo;
with 'WebService::BaseClientRole';

# VERSION

use aliased 'WebService::SmartyStreets::Exception::AddressNotFound';

use Function::Parameters ':strict';
use URI;

has auth_id    => ( is => 'ro', required => 1 );
has auth_token => ( is => 'ro', required => 1 );

has '+base_url' => (
    default => sub {
        my $self = shift;
        my $uri = URI->new('https://api.smartystreets.com/street-address');
        $uri->query_form(
            'auth-id'    => $self->auth_id,
            'auth-token' => $self->auth_token,
        );
        return $uri->as_string;
    },
);

method verify_address(
    Str :$street,
    Str :$street2 = '',
    Str :$city,
    Str :$state,
    Str :$zipcode = ''
) {
    my $result = $self->post($self->base_url, [{
        street     => $street,
        street2    => $street2,
        city       => $city,
        state      => $state,
        zipcode    => $zipcode,
    }]);

    AddressNotFound->throw unless $result;
    return $result;
}

1;
