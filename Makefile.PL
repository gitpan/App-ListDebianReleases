
# This file was automatically generated by Dist::Zilla::Plugin::MakeMaker v5.029.
use strict;
use warnings;

use 5.010001;

use ExtUtils::MakeMaker;



my %WriteMakefileArgs = (
  "ABSTRACT" => "List Debian releases",
  "AUTHOR" => "perlancar <perlancar\@cpan.org>",
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => 0,
    "Perl::osnames" => "0.09"
  },
  "DISTNAME" => "App-ListDebianReleases",
  "EXE_FILES" => [
    "bin/list-debian-releases"
  ],
  "LICENSE" => "perl",
  "MIN_PERL_VERSION" => "5.010001",
  "NAME" => "App::ListDebianReleases",
  "PREREQ_PM" => {
    "Debian::Releases" => 0,
    "Perinci::CmdLine::Any" => "0.06",
    "Rinci" => "1.1.0",
    "Version::Util" => 0
  },
  "TEST_REQUIRES" => {
    "File::Spec" => 0,
    "IO::Handle" => 0,
    "IPC::Open3" => 0,
    "Test::More" => 0
  },
  "VERSION" => "0.03",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


my %FallbackPrereqs = (
  "Debian::Releases" => 0,
  "ExtUtils::MakeMaker" => 0,
  "File::Spec" => 0,
  "IO::Handle" => 0,
  "IPC::Open3" => 0,
  "Perinci::CmdLine::Any" => "0.06",
  "Perl::osnames" => "0.09",
  "Rinci" => "1.1.0",
  "Test::More" => 0,
  "Version::Util" => 0
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  delete $WriteMakefileArgs{TEST_REQUIRES};
  delete $WriteMakefileArgs{BUILD_REQUIRES};
  $WriteMakefileArgs{PREREQ_PM} = \%FallbackPrereqs;
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);




# modify generated Makefile to generate shell completion scripts. this piece
# is generated by Dist::Zilla::Plugin::GenShellCompletion version 0.07.
GEN_SHELL_COMPLETION:
{
    use Perl::osnames 0.09 qw(is_posix);
    last unless is_posix();

    print "Modifying Makefile to generate shell completion on install\n";
    open my($fh), "<", "Makefile" or die "Can't open generated Makefile: $!";
    my $content = do { local $/; ~~<$fh> };

    $content =~ s/^(install :: pure_install doc_install)/$1 comp_install/m
        or die "Can't find pattern in Makefile (1)";

    $content =~ s/^(uninstall :: .+)/$1 comp_uninstall/m
        or die "Can't find pattern in Makefile (2)";

    $content .= qq|\ncomp_install :\n\t| .
        q|$(PERLRUN) -E'if(eval { require App::shcompgen; 1 }) { system "shcompgen", "--verbose", "generate", "--replace", @ARGV }' -- $(EXE_FILES)| .
        qq|\n\n|;

    $content .= qq|\ncomp_uninstall :\n\t| .
        q|$(PERLRUN) -E'if(eval { require App::shcompgen; 1 }) { system "shcompgen", "--verbose", "remove", @ARGV }' -- $(EXE_FILES)| .
        qq|\n\n|;

    open $fh, ">", "Makefile" or die "Can't write modified Makefile: $!";
    print $fh $content;
}
