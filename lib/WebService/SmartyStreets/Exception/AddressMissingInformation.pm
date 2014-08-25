package WebService::SmartyStreets::Exception::AddressMissingInformation;
use Moo;
extends 'Throwable::Error';

has '+message' => ( default => 'Missing Secondary Info; The address was DPV confirmed, but it is missing secondary information (apartment, suite, etc).' );

1;
