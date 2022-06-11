package anyca::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use Amon2::Web::Dispatcher::RouterBoom;

use Time::Piece; 
use Data::Dumper;

use anyca::Web::Function::ScheduleFunc;


get '/' => sub {
    my($c) = @_;
    my @schedules = anyca::Web::Function::ScheduleFunc::getAll($c);

    return $c->render('index.tx',{schedules => @schedules});    
};

get '/edit/:id' => sub {
    my ($c,$args) = @_;
    my $schedule = anyca::Web::Function::ScheduleFunc::getOne($c,$args);

    return $c->render('edit.tx', {schedule => $schedule})
};

post '/edit/:id' => sub {
    my ($c,$args) = @_;
    anyca::Web::Function::ScheduleFunc::update($c,$args);
    
    $c->redirect('/');
};

post '/post' => sub {
    my ($c) = @_;
    anyca::Web::Function::ScheduleFunc::create($c);

    $c->redirect('/');
};

post '/delete/:id' => sub {
    my ($c,$args) = @_;
    anyca::Web::Function::ScheduleFunc::delete($c,$args);

    $c->redirect('/');
};


1;
