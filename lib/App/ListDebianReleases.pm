package App::ListDebianReleases;

our $DATE = '2014-12-29'; # DATE
our $VERSION = '0.03'; # VERSION

use 5.010001;
use strict;
use warnings;

use Version::Util qw(cmp_version);

our %SPEC;
$SPEC{list_debian_releases} = {
    v => 1.1,
    summary => 'List Debian releases',
    args => {
        detail => {
            schema => 'bool*',
        },
    },
};
sub list_debian_releases {
    require Debian::Releases; # rather chubby

    my %args = @_;

    my $dr = Debian::Releases->new;
    my $rel = $dr->releases;
    #use Data::Dump; dd $rel;
    my @res;
    for (sort {cmp_version($a, $b)} keys %$rel) {
        push @res, $args{detail} ? {version=>$_, code_name=>$rel->{$_}} : $_;
    }
    [200, "OK", \@res];
}

1;
# ABSTRACT: List Debian releases

__END__

=pod

=encoding UTF-8

=head1 NAME

App::ListDebianReleases - List Debian releases

=head1 VERSION

This document describes version 0.03 of App::ListDebianReleases (from Perl distribution App-ListDebianReleases), released on 2015-12-29.

=head1 FUNCTIONS


=head2 list_debian_releases(%args) -> [status, msg, result, meta]

List Debian releases.

Arguments ('*' denotes required arguments):

=over 4

=item * B<detail> => I<bool>

=back

Return value:

Returns an enveloped result (an array).

First element (status) is an integer containing HTTP status code
(200 means OK, 4xx caller error, 5xx function error). Second element
(msg) is a string containing error message, or 'OK' if status is
200. Third element (result) is optional, the actual result. Fourth
element (meta) is called result metadata and is optional, a hash
that contains extra information.

 (any)

=head1 SEE ALSO

L<Debian::Releases>

=head1 HOMEPAGE

Please visit the project's homepage at L<https://metacpan.org/release/App-ListDebianReleases>.

=head1 SOURCE

Source repository is at L<https://github.com/sharyanto/perl-App-ListDebianReleases>.

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website L<https://rt.cpan.org/Public/Dist/Display.html?Name=App-ListDebianReleases>

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

perlancar <perlancar@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by perlancar@cpan.org.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
