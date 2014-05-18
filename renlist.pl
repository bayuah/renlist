#!/usr/bin/perl -w
$RENLIS_VERSION="0.1.1";

use Time::Local;

=begin comment
"THE COFFEE-WARE" (Revision 1991)

Wednesday, 07 May 2014, 20:02:15 UTC+7
<b@yuah.web.id> wrote RENLIST software. As long as you
retain this notice along with the distribution of this stuff, you can do
whatever you want with this stuff. If we meet some day, and you think this
stuff is worth it, you can buy me a cup of coffee in return Bayu Aditya H.
If you ask why it's like "THE BEER-WARE LICENSE", because BEER
is haram for us.
=cut

## Default configuration.

# Comma delimiter.
$comma_delimiter="\t";

## Functions.

# Capture error status
$error=0;

# read_csv_file()
# For reading file.
# @param: $filename (string)  File path.
# @param: $delimiter (string) Coma delimiter. Default: ",".
# @return: (array) CSV Data.
sub read_csv_file{
	$error=0;
	$i=0;
	
	# Get argument list.
	my ($filename,$delimiter) = @_;
	if($delimiter eq ""){
		$delimiter=",";
		}
	
	# Open file.
	open $fh, "<", $filename or $error=$!;
	
	# If error found
	if($error){
		close($fh);
		return 1;
	}else{
		binmode $fh;
		
		# Read file.
		my @data;
		while ($line = <$fh>) {
			# Remove CR and LF.
			$line=~s/\r\n\z//;
			
			# Removes any trailing string.
			chomp $line;
			
			# Push to array.
			my @fields = split $delimiter, $line;
			push @{$data[$i++]}, @fields;
		}
		
		# Close file.
		close($fh);
		
		# Return.
		$error=0;
		return @data;
	}
	
}

# date_to_UNIX()
# Change date to unix format.
# Example: date_to_UNIX "2014-05-08 14:39:21";
sub date_to_UNIX {
	$error=0;
	my($date) = @_;
	my ($year, $month, $day, $hour, $min, $sec) = split /\W+/, $date;
	
	# If incomplete.
	unless(defined $sec){$sec=0;};
	unless(defined $min){$min=0;};
	unless(defined $min){$hour=0;};
	
	$year = $year - 1900;
	$month--;
	
	my $time = timelocal($sec,$min,$hour,$day,$month,$year) or $error=$!;
	
	if($error){
		return -1;
	};
	
	return $time;
}

# Fetch @ARGV
# my @args = grep /^-\w+/, @ARGV;
# my @args_long = grep /^--\w+/, @ARGV;
# for $i(0..$#args){
	# $argm=$args[$i];
	# if($argm eq '-h'){
		# print $args[$i] . "\r\n";
	# };
	
# };

my($filename,$arg_delimiter)=@ARGV;

# If file input is empty, exit with error.
if(!defined $filename){
	print "renlist: File input must specific.";
	exit 1;
}

# If delimiter is empty, change it to `$comma_delimiter`.
if(!defined $arg_delimiter || $arg_delimiter eq ""){
	$arg_delimiter=$comma_delimiter;
};

# Ask version.
if($filename eq "--version"|| $arg_delimiter eq "--version"){
printf "renlist: version ". $RENLIS_VERSION ."\r\n";
printf "
\"THE COFFEE-WARE\" (Revision 1991)

Wednesday, 07 May 2014, 20:02:15 UTC+7
<b\@yuah.web.id> wrote RENLIST software. As long as you retain this
notice along with the distribution of this stuff, you can do whatever
you want with this stuff. If we meet some day, and you think this
stuff is worth it, you can buy me a cup of coffee in return
Bayu Aditya H. If you ask why it's like \"THE BEER-WARE LICENSE\",
because BEER is haram for us.\r\n";
printf "\r\nWritten by Bayu Aditya H.\r\n";
	exit 0;
};

# Read file.
@data=read_csv_file $filename, $arg_delimiter;

if($error){
	printf "renlist: ". $error ."\r\n";
	exit 2;
};

# Fetching data.
$success=$err=0;
foreach $i (0..$#data){
	# Get variable.
	my $old=$data[$i][0];
	my $new=$data[$i][1];
	my $mtime=$data[$i][2];
	my $atime=$data[$i][2];
	
	# Check.
	if(defined $old
	&& defined $new ){
		
		# If old exist.
		unless (-e $old){
			printf "renlist: '$old' doesn't exist!\r\n";
			$err++;
		}else{
			$error=0;
			rename $old, $new or $error=$!;
			wait; # Wait until finish.
			if($error){
				printf "renlist: Fail to rename '$old' with reason '$error'!\r\n";
				$err++;
			}else{
				$error=0;
				# Change timestamps if defined.
				if(defined $mtime){
					
					# To UNIX Time.
					$mtime=date_to_UNIX $mtime;
					if($error){
						printf "renlist: ". $error ."\r\n";
						exit 3;
					};
					
					# If access time not defined.
					unless(defined $atime){
						$atime=undef;
					}else{
						
						# To UNIX Time.
						$atime=date_to_UNIX $atime;
						if($error){
							printf "renlist: ". $error ."\r\n";
							exit 4;
						};
					};
					
					utime $atime, $mtime, $new or $error=$!;
					wait; # Wait until finish.
					if($error){
						printf "renlist: Fail to touch '$new' with reason '$error'!\r\n";
						$err++;
					};
				};
				
				if(!$error){
					# Everything is alright...
					printf "'$old' -> '$new'\r\n";
					$success++;
				};
			};
		};
	};
};

printf "\r\nrenlist finished with $success success and $err error (total %i).", $success+$err;


# End of file.


