package WebService::SmartyStreets;
use Moo;
with 'WebService::BaseClientRole';

# VERSION

use aliased 'WebService::SmartyStreets::Exception::AddressNotFound';
use aliased 'WebService::SmartyStreets::Exception::AddressMissingInformation';

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

    AddressNotFound->throw unless $result and @$result;
    AddressMissingInformation->throw if @$result == 1
        and $result->[0]{analysis}{dpv_match_code} eq 'D';
    return $result;
}

=head1 SYNOPSIS

    use WebService::SmartyStreets;

    my $ss = WebService::SmartyStreets->new(
        auth_id     => 'abc123',
        auth_token  => 'zyx456',
    );

    $ss->verify_address(...);

=head1 DESCRIPTION

This module provides bindings for the
L<SmartyStreets|http://smartystreets.com/products/liveaddress-api> API.

=for markdown [![Build Status](https://travis-ci.org/aanari/WebService-SmartyStreets.svg?branch=master)](https://travis-ci.org/aanari/WebService-SmartyStreets)

=head1 METHODS

=head2 new

Instantiates a new WebService::SmartyStreets client object.

    my $ss = WebService::SmartyStreets->new(
        auth_id    => $auth_id,
        auth_token => $auth_token,
        timeout    => $retries,    # optional
        retries    => $retries,    # optional
    );

B<Parameters>

=over 4

=item - C<auth_id>

I<Required>E<10> E<8>

A valid SmartyStreets auth id for your account.

=item - C<auth_token>

I<Required>E<10> E<8>

A valid SmartyStreets auth token for your account.

=item - C<timeout>

I<Optional>E<10> E<8>

The number of seconds to wait per request until timing out.  Defaults to C<10>.

=item - C<retries>

I<Optional>E<10> E<8>

The number of times to retry requests in cases when SmartyStreets returns a 5xx response.  Defaults to C<0>.

=back

=cut

1;
