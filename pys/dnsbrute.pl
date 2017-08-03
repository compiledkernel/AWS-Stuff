#!/usr/bin/perl -w
##################################
#
# what it does: 
#  o start with common cnames from the @cnames array
#  o if you specfied a input file, they will be appended to the
#    @cnames array
#  o try and brute force dns lookups, you can feed in start and 
#    stop ranges, or use the default of 4 - 8
# 
##################################

# use strict;
use Socket;
use Getopt::Std;

$version = "0.9.0b9";
# default to adding 5 numerics
$numeric = 5;
$ok = 0;

# common cnames, these will be tried first
@cnames = qw(
			ILMI academico acceso access acid admin administracion administrador admins afiliados agenda
			agent aix alerts antivirus app apple apps appserver archie as400 auth auto
			ayuda backup banking bbdd bbs bea beta bigip bolsa buscador ca
			canal catalog certify cgi channel channels chat chats cisco clientes club
			cluster clusters code commerce community compaq compras consola console consumer contact
			contracts core corporate correo correoweb cortafuegos cso data database datos db
			db2 default demo desarrollo descargas design dev devel develop developer device
			dial digital dilbert directory disc discovery disk disney dmz dns dns-2
			dns1 dns2 dns3 docs documentacion documentos domain domains dominio domino dominoweb
			download e-commerce earth ecommerce edi education ejemplo email empresa empresas enable
			eng engine engineer enterprise estadisticas events example exchange extern external extranet
			fax field file fileserver firewall formacion foro foros forum forums foto
			fotos frodo fsp ftp ftp2 fw fw-1 fw1 galeria galerias galleries games gandalf gatekeeper
			gateway gopher guest gw hello help helpdesk helponline hidden home hp hp-ux
			hpux ibm ibmdb ids images imail imap imap4 img info intern
			internal intranet invalid ips ipsec ipsec-gw irc ircserver irix jobs juegos kerberos ldap
			link linux lista lists listserver localhost log login logs lotus louts
			mail mailhost main management manager map mapas maps marketing media members
			messenger mngt mobile monitor mrtg mssql multimedia music mx mysql
			names nameserver netdata netstats network news nms nntp noc
			nombres notes noticias ns ns1 ns2 ntp online openview oracle osx osxadmin outlook
			page pages paginas partner partners pc pda personal ph photos pictures
			pix pop pop3 portal postales postgres ppp prensa press printer private
			project projects proxy prueba pruebas public ra radio radius raptor ras
			read register registro remote reports resumenes root router rwhois sac schedules
			scotty search secret secure security sendmail seri serv serv2 server service
			services servicio servidor share shop shopping site sms smtp smtphost snmp
			snmpd snort solaris solutions soporte source sql ssl stage staging stats
			storage store streaming sun support switch sysback system tech
			terminal test tienda time tivoli training transfers uddi unix update
			upload video vpn w1 w2 w3 wais wap web webdocs weblib
			weblogic webmail webmin webserver webservices websphere whois windows wingate wireless
			work world write ws ws1 ws2 ws3 www www1
			www2 www3
	);

# gotta have at least the domain and log file
if ($#ARGV ==  -1) {
 &USAGE;
 exit;
}

# get args
getopts("o:i:d:s:e:hvbn:p", \%args);

# want help?
if ($args{h}) { &USAGE; }

# print cnames
if ($args{p}) {
 &PRINT_CNAMES;
}

# no domain?
if (!$args{d}) {
 &USAGE;
 exit;
}

# set our input vars to easy names
$domain = $args{d};
$log = $args{o};
$in = $args{i};
$brute = $args{b};
$start = $args{s};
$end = $args{e};
$v = $args{v};
if ($args{n}) { $numeric = $args{n}; }
# zero out some counting vars
$success = 0;
$b_success = 0;
$b_lookups = 0;
$prev_lookups = 0;

# check if output file was set
if (!$log) {
 $log = ">&STDOUT";
} else {
 $log = ">>"."$log";
} 

# parse cnames from input file
if ($in) {
 open(IN,"<$in") or die "** ERROR - problem opening $in: $!\n";
 while (<IN>) {
  chomp;
  push(@cnames,$_);# I love perl
 }
}

# do each of our cnames
foreach $name (@cnames) {
 $i=0;
 # also add numbers to cnames
 while($i < $numeric+1) {
  if($i == 0) {
   $host = $name . "." . $domain;
  } else {
   $host = $name . $i . "." . $domain;
  }
  # check for the name
  $ok = GET_IP();
  $i++;
  if ($ok) {$success++;}
 }
}

print "\n$success common cname lookups were successful on $domain\n";

#####################################
# take you hands off me j00 brewt!!! 
#####################################
if ($brute) {
 print "\nentering brute force mode... go get some coffee.. in another state...\n";
 
 # set our defaults if none given
 if (!$start) {$start = 4;}
 if (!$end) {$end = 8;} # XXX add check to make sure $end !> $start

 # start and end for brute force need to be int
 if ($start !~ /[0-9]/ || $end !~ /[0-9]/) {
  print "\n** ERROR - start and end points need to be integers\n";
  exit;
 }

 if ($v) {print "\tusing range: $start - $end\n\n";}

 # set our begining cname to the length specified
 for ($i = 0; $i != $start; $i++) {
  $val .= "a";
 }

 # do lookups until we have reached the stop point
 while (length($val) < $end + 1) {
  if ($b_lookups == ($prev_lookups + 20)) {print "did $b_lookups\n";$prev_lookups += 20;}
  $host = $val.".".$domain;
  if (length($val) > length($prev)) {
   print "\nstarting on $val\n";
   print "$b_success brute force lookups were successful so far\n";
  }
  $ok = GET_IP();
  # iterate all these fricken vars
  if ($ok) {$b_success++;}
  $prev = $val;
  $val++;
  $b_lookups++;
 }
 print "\ngot $b_success total lookups from brute force\n";
} 

$total = $success+$b_success;
print "\n--------------------------------------\n";
print "TOTAL SUCCESSES: $total";
print "\n--------------------------------------\n";

#####################################
# SUBROUTINES
#####################################

# subroutine to look up an IP
sub GET_IP {
 if ($v) {print "trying $host ";}
  
 $inet = inet_aton("$host");
 if (!defined $inet) {
  if ($v) {print "....failed\n\n";}
  return 0;
 } else {
  if ($v) {print "....success!!!\n\n";}
 }
 $ip = inet_ntoa($inet);

 open(LOG,"$log") or die "** ERROR - problem opening $log: $!\n";
 print LOG "$host:$ip\n";
 close(LOG);

 return 1;
}

# usage subroutine
sub USAGE {
 print "USAGE:\n";
 print "\n$0 -d <domain> -o <out-file> -i <input-file> -s <int> -e <int> -bnhv\n";
 print "\t-d <domain>\t\tdomain to use\n";
 print "\t-o <out-file>\t\tfile to log results in\n";
 print "\t-i <input-file>\t\tfile containing cnames, one per line\n";
 print "\t-b\t\t\tperform brute force dns lookups\n";
 print "\t-s <number>\t\tstart range for brute force\n";
 print "\t-e <number>\t\tend range for brute force\n";
 print "\t-n <number>\t\tappened incrementing integers up to <number> to end of each cname (0 disables)\n";
 print "\t-p\t\t\tprint out the current default cname list\n";
 print "\t-h\t\t\tprint this help message\n";
 print "\t-v\t\t\tbe verbose (print all debug messages)\n";
 print "\n";
 exit;
}

sub PRINT_CNAMES {
 foreach $name (@cnames) {
  print "$name\n";
 }
 exit;
}

# wo0p. Socket skills.. ;p
