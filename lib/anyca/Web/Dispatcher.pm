package anyca::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use Amon2::Web::Dispatcher::RouterBoom;

use Time::Piece; 
use Data::Dumper;

# get '/' => sub {
#     my ($c) = @_;
#     my $counter = $c->session->get('counter') || 0;
#     $counter++;
#     $c->session->set('counter' => $counter);
#     return $c->render('index.tx', {
#         counter => $counter,
#     });
# };

get '/' => sub {
    my($c) = @_;
    my $order = $c->req->parameters->{order} ? $c->req->parameters->{order} : 'ASC';
    my @schedules = $c->db->search('schedules',{},{order_by => "date ${order}"});

    # my $time = $schedules[4]->date->strftime('%Y/%m/%d');
    my $today = Time::Piece->localtime->strftime('%Y/%m/%d');
    my @datas = ();

    for my $schedule (@schedules) {
        
        my $color = $schedule->date->strftime('%Y/%m/%d') eq $today ? 'text-danger' : 'text-black';
        my $new_data = {
            schedule => $schedule,
            color => $color
    };
        push(@datas, $new_data);
    };
    return $c->render('index.tx',{schedules => \@datas});    
};

get '/edit/:id' => sub {
    my ($c,$args) = @_;
    my $id = $args->{id};
    my $schedule = $c->db->single('schedules',{id => $id });

    return $c->render('edit.tx', {schedule => $schedule})
};

post '/edit/:id' => sub {
    my ($c,$args) = @_;
    my $id = $args->{id};
    my $title = $c->req->parameters->{title};
    my $date = $c->req->parameters->{date};

    $c->db->update('schedules', {
        title => $title,
        date => $date
    },{
        id => $id
    });
    
    $c->redirect('/');
};

post '/post' => sub {
    my ($c) = @_;
    my $title = $c->req->parameters->{title};
    my $date = $c->req->parameters->{date};

    $c->db->insert(schedules => {
        title => $title,
        date => $date,
    });

    $c->redirect('/');
};

post 'schedules/:id/delete' => sub {
    my ($c,$args) = @_;
    my $id = $args->{id};

    $c->db->delete('schedules' => {id => $id});
    return $c->redirect('/');
};


# post '/reset_counter' => sub {
#     my $c = shift;
#     $c->session->remove('counter');
#     return $c->redirect('/');
# };

# post '/account/logout' => sub {
#     my ($c) = @_;
#     $c->session->expire();
#     return $c->redirect('/');
# };

1;
