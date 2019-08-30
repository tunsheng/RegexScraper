#!/usr/bin/perl
use lib "lib/HTML";
use strict;
use warnings;
# use TreeBuilder;
# use XPath;
use Getopt::Long;


# option variable with default value (false)
my $clean_input = 'tidy.html';
my $debug = '';
my $help = '';
my $input = 'index.html';
my $log = 'log.txt';
# my $link = '';
my $link = 'https://www.facebook.com/pg/sgairconservicing/about/';
my $output = 'business_info.txt';
my $skip_download = '';
my $windows = '';


GetOptions (
  'clean-input=s' => \$clean_input,
  'debug' => \$debug,
  'help' => \$help,
  'input=s' => \$input,
  'log=s' => \$log,
  'set-link=s' => \$link,
  'output=s' => \$output,
  'skip-download' => \$skip_download,
  'windows' => \$windows
) or die "ERROR: try 'perl getInfo.pl --help' for more information\n";

if ( $link eq '' ) {
  print  "ERROR: try 'perl getInfo.pl --help' for more information\n";
  exit
}

if ($help) {
  print "Usage: perl getInfo.pl [OPTION]...\n\n";
  print "\t --clean-input\n";
  print "\t\t Set tidy input html\n";
  print "\t --debug\n";
  print "\t\t Running in debug mode\n";
  print "\t --input\n";
  print "\t\t Set messy input html\n";
  print "\t --log\n";
  print "\t\t Set custom log output when downloading html\n";
  print "\t --output\n";
  print "\t\t Set messy input html\n";
  print "\t --skip-download\n";
  print "\t\t Skip downloading html\n";
  print "\t --set-link\n";
  print "\t\t Set facebook link for download\n";
  print "\t --windows\n";
  print "\t\t Output windows compatible output\n";
  print "\n";
  print "\t Report any bugs to author by including systematic documentations.\n";
  print "\t Make sure that your problem is reproducible.\n";
  print "\n";
  print "\t WARNING: USER AT YOUR OWN RISK. THE AUTHOR IS NOT RESPONSIBLE FOR ANY DAMAGES.\n";
  print "\n";
  printf "\t NO WARRANTIES: TO THE EXTENT PERMITTED BY APPLICABLE LAW, NOT ANY PERSON,\n";
  printf "\t EITHER EXPRESSLY OR IMPLICITLY, WARRANTS ANY ASPECT OF THIS SOFTWARE OR PROGRAM,\n";
  printf "\t INCLUDING ANY OUTPUT OR RESULTS OF THIS SOFTWARE OR PROGRAM. UNLESS AGREED \n";
  printf "\t TO IN WRITING. THIS SOFTWARE AND PROGRAM IS BEING PROVIDED \"AS IS\", \n";
  printf "\t WITHOUT ANY WARRANTY OF ANY TYPE OR NATURE, EITHER EXPRESS OR IMPLIED,\n";
  printf "\t INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY\n";
  printf "\t AND FITNESS FOR A PARTICULAR PURPOSE, AND ANY WARRANTY THAT THIS SOFTWARE\n";
  printf "\t OR PROGRAM IS FREE FROM DEFECTS.\n";
  exit
}

if ($debug) {
  print $clean_input; print "\n";
  print $debug; print "\n";
  print $help; print "\n";
  print $input; print "\n";
  print $log; print "\n";
  print $link; print "\n";
  print $output; print "\n";
  print $skip_download; print "\n";
  print $windows; print "\n";
}

#============
# Main Script
#============
my $fh;
open $fh, '<', $clean_input or die "Cannot open $clean_input: $!\n";
my $email;
my $phone;
my $unsecured_link;
my $secured_link;
while (my $line=<$fh>) {
  if ($line =~ /mailto:/) {
    ($email = $1) if ( $line =~ /([^:]+@[^?]+)/ );
    $email  =~ s/^\s+//g;
    $email  =~ s/\s+$//g;
  }
  if ($line =~ /Call [+]/) {
    ($phone = $line) =~ s/Call//g;
    $phone  =~ s/^\s+//g;
    $phone  =~ s/\s+$//g;
  }
  if ($line =~ /"website_url"/) {
    ($secured_link = $1) if ( $line =~ /(https:[^"]+)/ );
    ($unsecured_link = $1) if ( $line =~ /(http:[^"]+)/ );
    $secured_link =~ s/\\//g;
    $secured_link  =~ s/^\s+//g;
    $secured_link  =~ s/\s+$//g;
    $unsecured_link =~ s/\\//g;
    $unsecured_link  =~ s/^\s+//g;
    $unsecured_link  =~ s/\s+$//g;
  }
}

open $fh, '<', $clean_input or die "Cannot open $clean_input: $!\n";
my $postal_code;
my $address_region;
my $street_address;
my $address_locality;
while (my $line=<$fh>) {
  if ($line =~ /postalCode/) {
    ($postal_code = $1) if ( $line =~ /(postalCode":"[^"]+)/ );
    $postal_code  =~ s/postalCode":"//g;
    ($address_region = $1) if ( $line =~ /(addressRegion":"[^"]+)/ );
    $address_region  =~ s/addressRegion":"//g;
    ($street_address = $1) if ( $line =~ /(streetAddress":"[^"]+)/ );
    $street_address  =~ s/streetAddress":"//g;
    ($address_locality = $1) if ( $line =~ /(addressLocality":"[^"]+)/ );
    $address_locality  =~ s/addressLocality":"//g;
    last;
  }
}

if ($debug) {
  (defined $phone)          ? print "Phone: $phone \n" : print "No\n";
  (defined $email)          ? print "Email: $email \n" : print "No\n";
  (defined $secured_link)   ? print "HTTPS: $secured_link \n" : print "No\n";
  (defined $unsecured_link) ? print "HTTP: $unsecured_link \n" : print "No\n";
  (defined $street_address)   ? print "Stree address: $street_address\n": print "No\n";
  (defined $postal_code)      ? print "Postal code: $postal_code\n" : print "No \n";
  (defined $address_region)   ? print "Address region: $address_region\n": print "No\n";
  (defined $address_locality) ? print "Address locality: $address_locality\n": print "No\n";
}
