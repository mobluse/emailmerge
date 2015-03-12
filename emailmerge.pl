#!/usr/bin/perl

# emailmerge.pl v0.4.0 -- A bulk email merge script/program for keeping contact, sending
# invitations, applying for jobs, CRM etc. by sending personalized emails.
# For examples of usage, see <http://en.wikipedia.org/wiki/Mail_merge>.
# Author: Mikael O. Bonnier, mikael.bonnier@gmail.com, http://www.df.lth.se.orbin.se/~mikaelb/
# Copyright (C) 2008 Mikael O. Bonnier, Lund, Sweden.
# License  GPLv3+:  GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>.
# This  is  free  software:  you  are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.
# Do not use this for sending spam, please.

use strict;
use warnings;
use Email::Send
    ; # Needs bug fixed sub datasend and "%S" in Net::SMTP::TLS,
      # see bug ID 33031 and 35606 on CPAN.
use Email::MIME::Creator;
use MIME::Words qw/encode_mimewords/;
use IO::All;
use DBI;

my %settings = (
    SMTP        => 'smtp.gmail.com',
    PORT        => 587,
    FROM_DOMAIN => '',
    FROM        => 'Firstname Lastname <firstname.lastname@gmail.com>',
    REPLY_TO    => 'firstname.lastname@gmail.com',
    USER_AGENT  => 'Thunderbird 2.0.0.14 (X11/20080505)',
    TEMPLATE    => 5,
    UPLDDIR => '../Documents/CV',
    DELAY   => 30, # seconds
    DB      => 'riksdagen',
    DB_HOST => 'localhost',
);
@ARGV == 4
    or die
'Provide username and password for the SMTP and the MySQL server, respectively,'
    . " on the command line.\n";
@settings{qw( USER PASS DB_USER DB_PASS)} = @ARGV;

my $dbh = DBI->connect( "DBI:mysql:$settings{DB}:$settings{DB_HOST}",
    $settings{DB_USER}, $settings{DB_PASS} );
$dbh->do('set names utf8');

my $q = qq|SELECT tSubject, tBody, tFile
           FROM Templates
           WHERE tId = $settings{TEMPLATE}|;
my $sth = $dbh->prepare($q);
$sth->execute;
my $as = [];
while ( my $hr = $sth->fetchrow_hashref ) {
    push @$as, $hr;
}
for my $row (@$as) {
    $settings{SUBJECT} = $row->{tSubject};
    $settings{BODY}    = $row->{tBody};
    $settings{FILE}    = $row->{tFile};
}

$q = q|SELECT *
       FROM Contacts
       WHERE cSend = 1
       ORDER BY cId ASC|;
$sth = $dbh->prepare($q);
$sth->execute;
$as = [];
while ( my $hr = $sth->fetchrow_hashref ) {
    push @$as, $hr;
}

my $mailer = Email::Send->new(
    {
        mailer      => 'SMTP::TLS',
        mailer_args => [
            Host     => $settings{SMTP},
            Port     => $settings{PORT},
            User     => $settings{USER},
            Password => $settings{PASS},
            Hello    => $settings{FROM_DOMAIN},
        ]
    }
);

for my $row (@$as) {
    my $body_text = $settings{BODY};
    for my $heading (keys %$row) {
        $body_text =~ s/\$$heading/$row->{$heading}/g;
    }

    # multipart message
    my @parts = (
        Email::MIME->create(
            attributes => {
                content_type => 'text/plain',
                encoding     => '8bit',
                charset      => 'utf-8',
            },
            body => $body_text,
        ),
        Email::MIME->create(
            attributes => {
                filename     => $settings{FILE},
                content_type => 'application/pdf',
                encoding     => 'base64',
                disposition  => 'inline',
                name         => $settings{FILE},
            },
            body => io( $settings{UPLDDIR} . '/' . $settings{FILE} )->all,
        ),
    );

    my $email = Email::MIME->create(
        header => [
            From         => $settings{FROM},
            'Reply-To'   => $settings{REPLY_TO},
            To           => $row->{cEmail},
            'User-Agent' => $settings{USER_AGENT},
            Subject      => encode_mimewords( $settings{SUBJECT} ),
        ],
        attributes => { charset => '', },
        parts      => [@parts],
    );
    sleep $settings{DELAY};
    eval { $mailer->send($email) };
    die "Error sending email: $@" if $@;
    $q = qq|UPDATE Contacts
       SET cSentLast = now()
       WHERE cId = $row->{cId} LIMIT 1|;
    $dbh->do($q);
}

$dbh->disconnect;

__END__
