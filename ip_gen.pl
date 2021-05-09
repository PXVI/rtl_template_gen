# -----------------------------------------------------------------------------------
# Module Name  :
# Date Created : 10:26:57 IST, 09 May, 2021 [ Sunday ]
# 
# Author       : pxvi
# Description  :
# -----------------------------------------------------------------------------------
# 
# MIT License
# 
# Copyright (c) 2021 k-sva
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the Software), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# 
# ----------------------------------------------------------------------------------- */

use File::Basename;
my $dirname = dirname(__FILE__);

use File::Copy qw(copy move);
use File::Copy::Recursive qw(dircopy); # In case this causes an error, run [ sudo apt-get install libfile-copy-recursive-perl ]
use File::Find;

# Golobal variables
$debug_enable = 0;
$default_template_dir = "$dirname/template_dir";
$default_proj_name = "ip_example_name";
$default_top_name = $default_proj_name."_top"; # This is the name of the module tops which will be used throughout the template
$default_env_var = uc $default_proj_name."_home"; # This is the environment variable which will be used to point to this IP's install path
$author_name = "k-sva";
$copyright_name = "k-sva";

$temp_year = `date "+%Y"`;
chomp($temp_year);
$copyright_year = $temp_year;

# Debug subroutines
sub debug
{
    if ( $debug_enable == 1 )
    {
        print "$_[0]\n";
    }
}

# Print Defaults
sub print_defaults
{
    debug( "-----------------" );
    debug( "Printing Defaults" );
    debug( "-----------------" );
    debug( "debug_enable : $debug_enable" );
    debug( "default_template_dir : $default_template_dir" );
    debug( "default_proj_name : $default_proj_name" );
    debug( "default_top_name : $default_top_name" );
    debug( "default_env_var : $default_env_var" );
}

# New lilne print
sub printn
{
    print "$_[0]\n";
}

# Printing help subroutine
sub print_help
{
    print "--------------------\n";
    print "RLT Generator - Help\n";
    print "--------------------\n";
    print "-h or --help : Help section\n";
    print "-e or --example : Usage example\n";
    print "-d or --debug : Enable script debug\n";
}

# Printing example usage subroutine
sub print_example
{
    print "---------------\n";
    print "Usage Example :\n";
    print "---------------\n";
    print "perl ip_gen.pl <switch>\n";
}

# Read file subroutine
sub read_file
{
    # TODO - Not sure how this part of code works
    # https://perlmaven.com/how-to-replace-a-string-in-a-file-with-perl
    my ($filename) = @_;

    open my $in, '<:encoding(UTF-8)', $filename or die "S - Error. Could not read the file.";
    local $/ = undef;
    my $all = <$in>;
    close $in;

    return $all;
}

# Write file subroutine
sub write_file
{
    # TODO - Not sure how this part of code works
    # https://perlmaven.com/how-to-replace-a-string-in-a-file-with-perl
    my ($filename, $content) = @_;

    open my $out, '>:encoding(UTF-8)', $filename or die "S - Error. Could not open file ( $filename ) for writing.";
    print $out $content;
    close $out;

    return;
}

# Main subroutine
sub main
{
    $args = $#ARGV + 1;
    debug( "<-- Debug Mode Enabled -->" );
    debug( "Number of arguments passed    : $args" );
    debug( "The scripts relative path     : $dirname" );
    debug( "Template dir path             : $default_template_dir" );

    # Check if the template_dir exists
    if ( -e $default_template_dir and -d $default_template_dir )
    {
        debug( "The template directory exists : $default_template_dir" );
    }else
    {
        debug( "Error. The template directory does not exist : $default_template_dir" );
    }
    debug();
    print_defaults();
    debug();
    
    # Intro
    printn( "---------------------------------------------" );
    printn( "Welcome To The RTL Dev Repository Generator" );
    printn( "---------------------------------------------" );
    printn();

    # Check if destination directory exists
    print "S - Enter the destination path ( leave blank if it's the current dir ) : ";
    $destination_dir = <STDIN>;
    chomp($destination_dir);
    if ( $destination_dir eq "" )
    {
        $destination_dir = "./";
    }

    if ( -e $destination_dir and -d $destination_dir )
    {
        printn( "S - The directory exists ( $destination_dir ). Moving to next step." );
    }else
    {
        $failed = 1;
        $count = 0;
        while( $count < 4 )
        {
            $count = $count + 1;
            printn( "S - Error. Directory does not exist. Try again." );
            print "S - Enter the destination path ( leave blank if it's the current dir ) : ";
            $destination_dir = <STDIN>;
            chomp($destination_dir);
            if ( $destination_dir eq "" )
            {
                $destination_dir = "./";
            }

            if ( -e $destination_dir and -d $destination_dir )
            {
                printn( "S - The directory exists ( $destination_dir ). Moving to next step." );
                $failed = 0;
                last;
            }            
        }
        if ( $failed == 1 )
        {
            printn( "S - Failed to enter the path multiple times. Script is exiting now." );
            exit();
        }
    }
    
    # Registering the project name
    print "S - Enter the name of the project or the IP ( eg. ip_ahb3_ms, viking7 ) : ";
    $proj_name = <STDIN>;
    chomp($proj_name);
    if ( $proj_name eq "" )
    {
        printn( "S - A valid name was not provided, so the default name is being pocked : $default_proj_name" );
        $proj_name = $default_proj_name;
    }

    # Create a project directory
    $proj_path = "$destination_dir/$proj_name";
    debug( "Project path : $proj_path" );
    if ( -d $proj_path )
    {
        printn( "S - Error. Project directory already exists. Script is exiting." );
        exit;
    }
    else
    {
        if ( mkdir $proj_path )
        {
            printn( "S - New project directory created." );
        }
        else
        {
            printn( "S - Error. Project directory creation failed. Script exiting." );
            exit;
        }
    }

    # Copying the template_dir structure into a new path
    $dst = "$proj_path/";
    $src = "$default_template_dir";

    if ( dircopy( $src, $dst ) )
    {
        printn( "S - Copied all the template files into the desination project directory." );
    }
    else
    {
        printn( "S - Error. Failed to copy the template files into the destination directory. Exiting script." );
    }

    # Take the author's name, copyright year and copyright owner's name
    print( "S - Enter the author's name ( leave empty for default name ) : " );
    $user_author_name = <STDIN>;
    chomp($user_author_name);
    if ( $user_author_name eq "" )
    {
        $user_author_name = $author_name;
    }
    
    print( "S - Enter the copyright author's name ( leave empty for default name. license is MIT ) : " );
    $user_copyright_name = <STDIN>;
    chomp($user_copyright_name);
    if ( $user_copyright_name eq "" )
    {
        $user_copyright_name = $copyright_name;
    }
    
    print( "S - Enter the copyright year ( leave empty for current year ) : " );
    $user_copyright_year = <STDIN>;
    chomp($user_copyright_year);
    if ( $user_copyright_year eq "" )
    {
        $user_copyright_year = $copyright_year;
    }

    # Go through every file and first rename the files with the project name 
    # In the template files, the ip_amba_apb_slave has been used as the project/IP name
    # So text replacement will be done for files with have a substring matching this
    @files = `find $dst/*`;
    debug( "Renaming files --------\n" );
    for(@files)
    {
        chomp($_);
        debug( "File/Directory Traversed : $_" );
        if ( -e $_ and ( not ( -d $_ ) ) )
        {
            $fullfilepath = $_;
            chomp($fullfilepath);
            $basename = `basename $_`;
            chomp($basename);
            $fullpath = `realpath $_`;
            chomp($fullpath);
            debug( "Basename/Fullpath of file : $basename ( $fullpath )" );

            # Check if the filename has a substring match
            $substr = "ip_amba_apb_slave";
            $match = $basename;
            $match =~ m/ip_amba_apb_slave/;
            
            if ( not ( $& eq "" )  )
            {
                debug( "Substring ( $substr ) matched. Replacing the file with a new name now. ( $` : $& : $' )" );
                # Filename is a match. Now move the file and rename it.
                $newname = $proj_name.$';
                $newpath = `dirname $fullpath`;
                chomp($newpath);
                $newpath = $newpath."/".$newname;
                printn( "S - Creating new file ( $newname ). Full path : $newpath" );

                $temp = `mv $fullfilepath $newpath`;

                if ( -e $newpath and ( not ( -d $newpath ) ) )
                {
                    debug( "File successfully renamed." );
                }
                else
                {
                    printn( "S - Error. Failed to rename the file. Script is exiting." );
                }
            }
            debug();
        }
    }
    
    # Go through every file and 
    @files = `find $dst/*`;
    debug( "String substitutions in files --------\n" );
    for(@files)
    {
        chomp($_);
        if ( -e $_ and ( not ( -d $_ ) ) )
        {
            debug( "File Traversed : $_" );

            # Text replacement code
            debug( "User Author : $user_author_name" );
            debug( "User Copyright Author : $user_copyright_name" );
            debug( "User Copyright Year : $user_copyright_year" );
            my $data = read_file($_);
            $data =~ s/ip_amba_apb_slave/$proj_name/g;
            $data =~ s/Author       :\s*[a-zA-Z-_]*/Author       : $user_author_name/g;
            $data =~ s/Copyright [(]c[)] 2020.*/Copyright (c) $user_copyright_year $user_copyright_name/g;
            $temp = uc $proj_name;
            $data =~ s/IP_AMBA_APB_SLAVE/$temp/g;
            $temp = `date "+%H:%M:%S %Z, %d %B, %Y [ %A ]"`;
            chomp($temp);
            $data =~ s/Date Created : .*/Date Created : $temp/g;
            #debug( "$data" );
            write_file($_, $data);
        }
    }

    printn( "S - Remaining files have been moved and modified." );
    printn( "S - Repository for $proj_name has been created." );
}

# ----
# Main
# ----

# Checking switches
if ( $#ARGV + 1 == 1 )
{
    $run_main = 0;
    $a = "$ARGV[0]";
    if ( $a eq "-h" )
    {
        print_help()
    }
    elsif ( $a eq "--help" )
    {
        print_help()
    }
    elsif ( $a eq "-d" )
    {
        $debug_enable = 1;
        $run_main = 1;
    }
    elsif ( $a eq "--debug" )
    {
        $debug_enable = 1;
        $run_main = 1;
    }
    elsif ( $a eq "-e" )
    {
        print_example()
    }
    elsif ( $a eq "--example" )
    {
        print_example()
    }
    else
    {
        print "Error. Unsupported argument passed.\n";
        print_help()
    }

    if ( $run_main == 1 )
    {
        # Run the main code
        main()
    }
}elsif ( $#ARGV + 1 == 0 )
{
    # Run the main code
    main()
}
else
{
    print "Error. Unsupported number of arguments. ( Try : $ pl ip_gen.pl -h )\n";
}
