
package CreateConfig;
use Moose;
use DBI;
use JSON;
use DateTime;
use Env;
use FindBin qw($Bin);
use File::Copy;
use Logger;
use Try::Tiny;
use Scalar::Util qw(looks_like_number);
use CreateConfig::CreateJSON;

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

Use this module to create a template json config file from a from delimited db .txt files, for mapping to the Hydstra db
  
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

 has 'db_file'        => ( is => 'rw', isa => 'Str', required => 1); 
 has 'table_name'     => ( is => 'rw', isa => 'Str', required => 1); 
 has 'file_delimiter' => ( is => 'rw', isa => 'Str', required => 1); 
 has 'field_name'     => ( is => 'rw', isa => 'Str'); 
 has 'field_type'     => ( is => 'rw', isa => 'Str'); 
 
=head1 EXPORTS

=over

=item 1

  get_column_names()

=item 2
  
  get_column_types()
  
=back 
  

=head1 SUBROUTINES/METHODS

=head2 check_open()
  
Check to see we can open the db_file
  
=cut

sub check_open{
  my $self = shift;
  open my $file, '<', $self->db_file or die return 0; 
  my $firstLine = <$file>; 
  close $file;
  return 1;
}

=head2 get_column_names()
  
Load the table headers

=cut

sub get_column_names{
  my $self = shift;
  my $file_delimiter = $self->file_delimiter;
  
  open my $file, '<', $self->db_file; 
  my $firstLine = <$file>; 
  close $file;
  chomp $firstLine;
  
  my @column_names = split(/\Q$file_delimiter/,$firstLine);
  foreach my $col_no ( 0..$#column_names  ){
    my $name = $column_names[$col_no];
    $name =~ s{"}{}g;
    $name =~ s{ }{_}g;
    $column_names[$col_no] = $name;
  }
  
  return \@column_names;
  #return 1;
}

=head2 get_column_types()
  
Query the likely data types for the first after the table headers. 
This is only a simple check of whether the data looks like a number.
 * If not then it gets a text data type. 
 * If so then it gets a numeric data type.
You will need to manually create Int and Blob and verify each guess is correct.

=cut

sub get_column_types{
  my $self = shift;
  my $linecount = 0;
  my $data_line;
  my $file_delimiter = $self->file_delimiter;
  
  open my $file, '<', $self->db_file; 
  my $firstLine = <$file>; 
  close $file;
  chomp $firstLine;
  my @column_names = split(/\Q$file_delimiter/,$firstLine);
  
  
  open (FH, '<', $self->db_file); 
  #Get first line of data
  while (<FH>) {
    if ( $linecount < 1 ){
      $linecount++;
      next;
    }
    elsif( $linecount > 0 && $linecount < 2 ){
      $data_line = $_;
      #print "data line [$data_line]\n";
      chomp $data_line;
      last;
    }
  }
  close (FH);
  
  my @data = split(/\Q$file_delimiter/,$data_line);
  my @data_types;
  
  #Check data types
  foreach my $col_no ( 0..$#column_names  ){
    my $dat = $data[$col_no]//'null';
    $dat =~ s{^"|'}{}g;
    $dat =~ s{^ }{}g;
    my $type = looks_like_number($dat)? 'numeric':'text';
    $type = (!defined $type)? 'text' : $type;
    push(@data_types,$type);
  }
  
  return \@data_types;
}

=head2 create_config_json()
  
Create config.json file for table.

=cut

sub create_config_json{
  my $self = shift;
  #my @col_names = @$colnames;
  #foreach my $col_no ( 0 .. $#col_names){
  foreach my $selfVal ( keys %{$self}){
    print "JSON col [$selfVal]\n"
  
  }
  
  #my $file_delimiter = $self->file_delimiter;
  #open (FH, '<', $self->db_file); 
=skip  
  #Get first line of data
  while (<FH>) {
    if ( $linecount < 1 ){
      $linecount++;
      next;
    }
    elsif( $linecount > 0 && $linecount < 2 ){
      $data_line = $_;
      print "data line [$data_line]\n";
      chomp $data_line;
      last;
    }
  }
  close (FH);
  
  my @data = split(/\Q$file_delimiter/,$data_line);
  my @data_types;
  
  #Check data types
  foreach my $col_no ( 0..$#data  ){
    my $dat = $data[$col_no];
    $dat =~ s{^"|'}{}g;
    $dat =~ s{^ }{}g;
    my $type = looks_like_number($dat)? 'numeric':'text';
    push(@data_types,$type);
  }
=cut  
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
