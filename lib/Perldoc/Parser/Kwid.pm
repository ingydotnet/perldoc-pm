package Perldoc::Parser::Kwid;
use strict;
use warnings;
use base 'Document::Parser';

sub create_grammar {
    my $all_blocks = [qw(h1 h2 ul pre p)];
    my $all_phrases = [qw(b i tt)];
    return {
        top => {
            blocks => $all_blocks,
        },
        pre => {
            match => qr/^(( +.*\S.*\n)+)(?m:^ *\n)*/,
            filter => sub { while (not /^\S/m) { s/^ //gm } },
        },
        p => {
            phrases => $all_phrases,
            match => qr/^(((?!>).*\S.*\n)+)(?m:^\s*\n)*/,
            filter => sub { s/\n+\z// },
        },
        ul => {
            blocks => [qw(ul li)],
            match => qr/^((?m:^\*+ .*\n)+)\n*/,
            filter => sub { s/^\* *//mg; s/\n+\z/\n/ },
        },
        li => {
            phrases => $all_phrases,
            match => qr/(.*)\n/,
        },
        h1 => {
            phrases => $all_phrases,
            match => qr/^={1}\s+(.*?)\s*\n+/,
        },
        h2 => {
            phrases => $all_phrases,
            match => qr/^={2}\s+(.*?)\s*\n+/,
        },
        b => {
            phrases => $all_phrases,
            match => [re_huggy('\*'), qr/\{\*(.*?)\*\}/ ],
        },
        i => {
            match => [re_huggy('\/'), qr/\{\/(.*?)\/\}/ ],
        },
        tt => {
            match => [re_huggy('`'), qr/\{`(.*?)`\}/ ],
        },
    };
}

# Fancy Regexp Generators
my $ALPHANUM = '\p{Letter}\p{Number}\pM';

sub re_huggy {
    my $brace1 = shift;
    my $brace2 = shift || $brace1;

    return qr/
        (?:^|(?<=[^${ALPHANUM}${brace1}]))
        ${brace2}(\S[^${brace2}]*)${brace2}
        (?=[^{$ALPHANUM}${brace2}]|\z)
    /x;
}

1;
