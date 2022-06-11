package anyca::Web::ORM::Schedule;
use strict;
use warnings;
use utf8;
use Amon2::Web::Dispatcher::RouterBoom;
 
use Time::Piece; 
use Data::Dumper;


sub getAll {
    my ($db,$order) = @_;
    my @schedules = $db->search('schedules',{},{order_by => "date ${order}"});
    return @schedules;    
};

sub getOne {
    my ($db,$id) = @_;
    my $schedule = $db->single('schedules',{id => $id });
   return $schedule;
};

 sub update {
    my ($db,$id,$title,$date) = @_;
    $db->update('schedules', {
        title => $title,
        date => $date
    },{
        id => $id
    });
};

sub create {
    my ($db,$title,$date) = @_;
    $db->insert(schedules => {
        title => $title,
        date => $date,
    });
};

 sub delete {
    my ($db,$id) = @_;
    $db->delete('schedules' => {id => $id});
};


1;
