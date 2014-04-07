
package CreateConfig::CreateJSON;
use Moose;

use JSON;
use DateTime;
use Env;
use FindBin qw($Bin);
use Try::Tiny;

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

Use this module to create a template json config file
  
Notes:

=over 

=item 1 

This config generater required manual mapping to Hydstra database tables and fields. You only get the template and best guess of data types.

=back 

Code snippet.

  use CreateConfig;
  
  my $config = CreateConfig->new( 
    file=>'db.txt'
  );

  $config->create;
     
=cut

 has 'headers'       => ( is => 'rw', isa => 'ArrayRef', required => 1); 
 has 'data_types'     => ( is => 'rw', isa => 'ArrayRef', required => 1); 
 has 'config_dir'     => ( is => 'rw', isa => 'Str', required => 1); 
 has 'table_name'     => ( is => 'rw', isa => 'Str', required => 1); 
 
=head1 EXPORTS

=over

=item 1

  create_config_json()

=back 
  

=head1 SUBROUTINES/METHODS

=head2 create_config_json()
  
Create config.json file for table.

=cut

sub create_config_json{
  my $self = shift;
  my @headers = @{$self->headers};
  my @data_types = @{$self->data_types};
  my $data;
  my $table_name = $self->table_name;
  my $JSONfile = $self->config_dir.$self->table_name.'.json';
  print "JSONfile [$JSONfile]\n";
  open my $fh, ">", lc($JSONfile);
  
  foreach my $header_count ( 0..$#headers){
    print "Header [$headers[$header_count]], Data type [$data_types[$header_count]]\n";
    $data->{'elements'}[$header_count]{'hydstra_mappings'}[0]{'table'} = 'TODO: setup 1..n Hydstra table mappings';
    $data->{'elements'}[$header_count]{'hydstra_mappings'}[0]{'field'} = 'TODO: setup 1..n Hydstra field mappings';

    $data->{'elements'}[$header_count]{'dnrm_field'} = lc($headers[$header_count]);
    $data->{'elements'}[$header_count]{'dnrm_table'} = lc($table_name);
    $data->{'elements'}[$header_count]{'dnrm_key_field'} = '';
    $data->{'elements'}[$header_count]{'sqlite_type'} = lc($data_types[$header_count]);
  }
  print $fh encode_json($data);
  #close ($fh);
  return 1;
}
 

=head1 AUTHOR

Sholto Maud, C<< <sholto.maud at gmail.com> >>

=head1 BUGS

Please report any bugs in the issues wiki.


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2014 Sholto Maud.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


=cut

1; # End of Import
