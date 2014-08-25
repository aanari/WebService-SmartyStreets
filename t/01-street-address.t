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

done_testing;
