package anyca::Web::Function::ScheduleFunc;
use strict;
use warnings;
use utf8;
use Amon2::Web::Dispatcher::RouterBoom;
 
use Time::Piece; 
use Data::Dumper;

use anyca::Web::ORM::Schedule;

sub getAll {
    my($c) = @_;
    my $order = $c->req->parameters->{order} ? $c->req->parameters->{order} : 'ASC';
    my @getAll = anyca::Web::ORM::Schedule::getAll($c->db, $order);

    my $today = Time::Piece->localtime->strftime('%Y/%m/%d');
    my @datas = ();

    for my $schedule (@getAll) {
        
        my $color = $schedule->date->strftime('%Y/%m/%d') eq $today ? 'text-danger' : 'text-black';
        my $new_data = {
            schedule => $schedule,
            color => $color
    };
        push(@datas, $new_data);
    };

    return \@datas;    
};

sub getOne {
    my ($c,$args) = @_;
    my $id = $args->{id};
    my $getOne = anyca::Web::ORM::Schedule::getOne($c->db, $id);

    return $getOne;
};

 sub update {
    my ($c,$args) = @_;
    my $id = $args->{id};
    my $title = $c->req->parameters->{title};
    my $date = $c->req->parameters->{date};

    anyca::Web::ORM::Schedule::update($c->db, $id,$title,$date);
};

sub create {
    my ($c) = @_;
    my $title = $c->req->parameters->{title};
    my $date = $c->req->parameters->{date};

    anyca::Web::ORM::Schedule::create($c->db,$title,$date);
};

 sub delete {
    my ($c,$args) = @_;
    my $id = $args->{id};

    anyca::Web::ORM::Schedule::delete($c->db,$id);
};


1;
