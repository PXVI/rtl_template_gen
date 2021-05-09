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

use File::Copy qw(move);

# Golobal variables
$debug_enable = 0;
$default_template_dir = "$dirname/template_dir";

# Debug subroutines
sub debug
{
    if ( $debug_enable == 1 )
    {
        print "$_[0]\n";
    }
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
        printn( "S - The directory exists. Moving to next step." );
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
                printn( "S - The directory exists. Moving to next step." );
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
    
    # Copying the template_dir structure into a new path

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
