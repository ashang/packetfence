package pf::util::networking;
=head1 NAME

pf::util::networking

=cut

=head1 DESCRIPTION

pf::util::networking

=cut

use strict;
use warnings;
use Errno qw(EINTR EAGAIN);

use base qw(Exporter);

our @EXPORT_OK = qw(syswrite_all sysread_all);

=head2 syswrite_all

A wrapper around syswrite to ensure all bytes are written to a socket

=cut

sub syswrite_all {
    my ($socket,$buffer) = @_;
    my $bytes_to_send = length $buffer;
    my $offset = 0;
    my $total_written = 0;
    while ($bytes_to_send) {
        my $bytes_sent = syswrite($socket, $buffer, $bytes_to_send, $offset);
        unless (defined $bytes_sent) {
            next if $! == EINTR;
            last;
        }
        return $offset unless $bytes_sent;
        $offset += $bytes_sent;
        $bytes_to_send -= $bytes_sent;
    }
    return $offset;
}

=head2 sysread_all

A wrapper around sysread to ensure all bytes are read from a socket

=cut


sub sysread_all {
    my $socket = $_[0];
    our $buf;
    local *buf = \$_[1];    # alias
    my $bytes_to_read = $_[2];
    my $offset = 0;
    $buf = '';
    while($bytes_to_read) {
        my $bytes_read = sysread($socket,$buf,$bytes_to_read,$offset);
        unless (defined $bytes_read) {
            next if $! == EINTR;
            last;
        }
        return $offset unless $bytes_read;
        $bytes_to_read -= $bytes_read;
        $offset += $bytes_read;
    }
    return $offset;
}

=head1 AUTHOR

Inverse inc. <info@inverse.ca>

=head1 COPYRIGHT

Copyright (C) 2005-2015 Inverse inc.

=head1 LICENSE

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
USA.

=cut

1;

