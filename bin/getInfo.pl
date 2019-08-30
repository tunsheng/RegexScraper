#!/usr/bin/perl
use lib "lib/HTML";
use strict;
use warnings;
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

# Main information
my $business_name;
my $category;
my $hours;
my $email;
my $phone;
my $unsecured_link;
my $secured_link;
my $street_address;
my $postal_code;
my $address_region;
my $address_locality;
my $main_description;
my $detail_description;

# Local variables
my $fh;
my $flag;
my $print_flag;
my $description;
my $aboutTag;
my $counter;


#=== Search for email, category, links, name, phone
open($fh, '<', $clean_input) or die "Cannot open $clean_input: $!\n";
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
  if ($line =~ /"category_type":"/) {
    ($category = $1) if ( $line =~ /("category_type":"[^"]+)/ );
    if (defined $category) {
      $category =~ s/"category_type":"//g;
      $category =~ s/_/ /g;
    }
  }
  if ($line =~ /<meta property="og:title" content/) {
    ($business_name = $1) if ( $line =~ /(<meta property="og:title" content="[^"]+)/ );
    $business_name =~ s/<meta property="og:title" content="//g;
  }
}




#=== Search for address
open($fh, '<', $clean_input) or die "Cannot open $clean_input: $!\n";
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


#=== Search for business hours
$flag=0;
$print_flag=0;
$counter=0;
open($fh, '<', $clean_input) or die "Cannot open $clean_input: $!\n";
while (my $line=<$fh>) {
  if ($line =~ /alt="clock"/) {
    $flag=1;
    next;
  }
  if ($flag<=3 && $flag > 0) {
    $flag+=1;
    next;
  }
  if ($flag>3) {
    $print_flag=1;
  }
  if ($print_flag==1) {
    if ($line =~ /<\/div>/ or $counter > 20) {
      $print_flag=0;
      if ($counter > 20) {
        print "ERROR: Search for hours hit max iter.\n"
      }
      last;
    } else {
      my $temp=$line;
      $temp =~ s/^\s+//g;
      $temp =~ s/\s+$//g;
      $hours.=$temp;
      $counter+=1;
    }
  }
}

if (defined $hours) {
  ($hours = $1) if $hours =~ /(>.+<)/;
  $hours =~ s/>//g;
  $hours =~ s/<//g;
}


#=== Search for business description
open($fh, '<', $clean_input) or die "Cannot open $clean_input: $!\n";
$flag=0;
$print_flag=0;
while (my $line=<$fh>) {
  if ($line =~ /MORE INFO/) {
    $flag=1;
    next;
  }
  my $search;
  if ($flag==1) {
    if ($line =~/About/) {
      $flag=2;
      next;
    }
  }
  if ($flag==2) { # Skip twice
    $flag+=1;
    next;
  }
  if ($flag==3) { # Get tag
    $flag+=1;
    $aboutTag=$line;
    $aboutTag  =~ s/^\s+//g;
    $aboutTag  =~ s/\s+$//g;
  }
  if (defined $aboutTag) {
    if (not $print_flag) {
      if ($line =~ /$aboutTag/) {
        $print_flag=1;
      }
    }
    if ($print_flag==1) {
      if ($line =~ /<\/div>/) {
        $print_flag=0;
      } else {
        my $temp=$line;
        $temp =~ s/^\s+//g;
        $temp =~ s/\s+$//g;
        $description.=$temp;
      }
    }
  }
}

if (defined $description) {
  $main_description='';
  ($main_description = $1) if ($description =~ /($aboutTag.+$aboutTag)/);
  ($detail_description = $description) =~ s/$main_description//g;
}
if (defined $detail_description) {
  $detail_description =~ s/^\s+//g;
  $detail_description =~ s/<span class="text_exposed_hide">.+<span class="text_exposed_show">//g;
  $detail_description =~ s/<div[\s\w\d="_]+>//g;
  $detail_description =~ s/<br>//g;
  $detail_description =~ s/<\/br>//g;
  $detail_description =~ s/<a class=.+a>//g;
  $detail_description =~ s/<\/a>//g;
  $detail_description =~ s/<span class="text_exposed_hide"><span class="text_exposed_link">//g;
  $detail_description =~ s/<\/span>//g;
}
if (defined $main_description) {
  $main_description =~ s/$aboutTag//g;
  $main_description =~ s/^\s+//g;
  $main_description =~ s/\s+$//g;
}
close $fh;


#=== Saving to output
if ($debug) {
  print "=== Company Information ===\n";
  (defined $business_name)  ? print "Business Name: $business_name\n" : print "No business name.\n";
  (defined $hours)          ? print "Business Hours: $hours\n" : print "No business hours.\n";
  (defined $category)       ? print "Category: $category\n" : print "No Category.\n";
  (defined $phone)          ? print "Phone: $phone \n" : print "No phone number.\n";
  (defined $email)          ? print "Email: $email \n" : print "No email.\n";
  (defined $secured_link)   ? print "HTTPS: $secured_link \n" : print "No secured link.\n";
  (defined $unsecured_link) ? print "HTTP: $unsecured_link \n" : print "No unsecured link.\n";
  (defined $street_address)   ? print "Stree address: $street_address\n": print "No street address.\n";
  (defined $postal_code)      ? print "Postal code: $postal_code\n" : print "No postal code.\n";
  (defined $address_region)   ? print "Address region: $address_region\n": print "No address region.\n";
  (defined $address_locality) ? print "Address locality: $address_locality\n": print "No address locality\n";
  print "\n=== Business Description ===\n";
  (defined $main_description) ? print "Main Description: \n $main_description\n": print "No business description.\n";
  (defined $detail_description) ? print "Detail Description:\n $detail_description\n": print "No detail business description.\n";
}

open($fh, '>', $output) or die "Could not open file '$output' $!";
if (defined $output) {
  print $fh "=== Company Information ===\n";
  (defined $business_name)  ? print $fh "Business Name: $business_name\n" : print "No business name.\n";
  (defined $hours)          ? print $fh "Business Hours: $hours\n" : print "No business hours.\n";
  (defined $category)       ? print $fh "Category: $category\n" : print "No Category.\n";
  (defined $phone)          ? print $fh "Phone: $phone\n" : print "No phone number.\n";
  (defined $email)          ? print $fh "Email: $email\n" : print "No email.\n";
  (defined $secured_link)   ? print $fh "HTTPS: $secured_link\n" : print "No secured link.\n";
  (defined $unsecured_link) ? print $fh "HTTP: $unsecured_link\n" : print "No unsecured link.\n";
  (defined $street_address)   ? print $fh "Stree address: $street_address\n": print "No street address.\n";
  (defined $postal_code)      ? print $fh "Postal code: $postal_code\n" : print "No postal code.\n";
  (defined $address_region)   ? print $fh "State: $address_region\n": print "No address region.\n";
  (defined $address_locality) ? print $fh "City: $address_locality\n": print "No address locality\n";
  print $fh "\n=== Business Description ===\n";
  (defined $main_description) ? print $fh "Main Description: \n $main_description\n": print "No business description.\n";
  (defined $detail_description) ? print $fh "Detail Description:\n $detail_description\n": print "No detail business description.\n";
}
close $fh;
