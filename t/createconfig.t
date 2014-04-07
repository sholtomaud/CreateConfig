#!/usr/bin/perl -w
use Test::More;
use Data::Dumper;
use CreateConfig;
use CreateConfig::CreateJSON;
use FindBin qw($Bin);
use constant DNRM_DIR => $Bin.'/dnrmdata/'; 
use constant TABLE_CONFIG_DIR => $Bin.'/config/'; 


my $table_config = TABLE_CONFIG_DIR;
print "table_config [$table_config]\n";

mkdir $table_config if (! -d $table_config);
ok(-d $table_config, 'made $table_config directory ok' );

#my $t_config = TABLE_CONFIG_DIR;
#opendir(DR, $t_config);


my $dnrm_dir = DNRM_DIR;
opendir(DIR, $dnrm_dir);
ok(DIR, 'odendir DIR directory ok' );

my @files = grep { $_ ne '.' && $_ ne '..' } readdir DIR;
closedir DIR;

my $tests_per_file = 4;
my $number_of_tests_run = 2;
foreach my $table_file (@files){
  print "testing file [$table_file]\n";
  my ($table_name,$file_ext) = split(/\./,$table_file);
  my $config = CreateConfig->new(
    db_file               => $dnrm_dir.'/'.$table_file,       #req 
    table_name            => $table_name,       #req      
    file_delimiter        => '|'               #req  
  );

  ok(defined $config, 'CreateConfig->new returned something' );
  ok($config->check_open, 'check_open() ok');
 
  my $col_names = $config->get_column_names;
  #print "hashreturn zero [$hashreturn[0] ]\n";
  #print "return col_names [".Dumper($col_names)."]\n";
  ok($config->get_column_names, 'get_column_names() ok');
  
  my $data_types = $config->get_column_types;
  #print "data_types [".Dumper($data_types)."]\n";
  ok($config->get_column_types, 'get_column_types() ok');
    
  #print "Col name [$_]\n" for @$hashreturn;
  #my @returns = @$hashreturn;
  #foreach my $col ( 0..$#returns ){
  #  print "col [$col] returns [$returns[$col]]\n";
  #}
  
  my $json = CreateConfig::CreateJSON->new(
    table_name   => $table_name,
    headers      => $col_names,  
    data_types   => $data_types,
    config_dir   => TABLE_CONFIG_DIR
  );
  
  my $array = $json->create_config_json;
  #print "headers [".Dumper($array)."]\n";
  #$json->close();
  
  #$config->create_config_json($col_names,$data_types);
  #$config->close();
  
  $number_of_tests_run += $tests_per_file;
}

#close DR;

#ok(unlink $file,'unlinking file [$file]');
#ok(rmdir $logpath,'rmdir temp [$logpath]');

done_testing( $number_of_tests_run );
