use Test::Modern;
use t::lib::Harness qw(ss);
plan skip_all => 'Invalid SmartyStreets credentials' unless defined ss();

use Storable qw(dclone);

subtest 'Testing verify_address parameter errors' => sub {
    my %address_params = (
        street => '370 Townsend St',
        city   => 'San Francisco',
        state  => 'CA',
    );

    for my $key (keys %address_params) {
        my %params = %{ dclone(\%address_params) };
        delete $params{$key};
        like exception { ss->verify_address(%params) },
            qr/Not enough arguments for method/,
            "failed correctly on missing parameter: $key";
    }
};

subtest 'Testing verify_address address errors' => sub {
    isa_ok exception { ss->verify_address(
        street  => '370 Townsend St',
        city    => 'Boulder',
        state   => 'CO',
        zipcode => '80305',
    )}, 'WebService::SmartyStreets::Exception::AddressNotFound';

    isa_ok exception { ss->verify_address(
        street  => '1529 Queen Anne Ave N',
        city    => 'Seattle',
        state   => 'WA',
        zipcode => '98109',
    )}, 'WebService::SmartyStreets::Exception::AddressMissingInformation';
};

done_testing;
