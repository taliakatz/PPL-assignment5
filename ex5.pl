:- module('ex5',
        [activity/2,
         parents/3,
         participate/2,
         parent_details/3,
         not_member/2,
         member/2,
         get_activities/2,
         get_days/2
        ]).

/*
 * **********************************************
 * Printing result depth
 *
 * You can enlarge it, if needed.
 * **********************************************
 */
maximum_printing_depth(100).

:- current_prolog_flag(toplevel_print_options, A),
   (select(max_depth(_), A, B), ! ; A = B),
   maximum_printing_depth(MPD),
   set_prolog_flag(toplevel_print_options, [max_depth(MPD)|B]).
   
% Signature: activity(Name,Day)/2
% Purpose: describe an activity at the country club and the day it takes place
%
activity(swimming,sunday).
activity(ballet,monday).
activity(judu,tuesday).
activity(soccer,wednesday).
activity(art,sunday).
activity(yoga,tuesday).

% Signature: parents(Child,Parent1,Parent2)/3
% Purpose: parents - child relation
%
parents(dany,hagit,yossi).
parents(dana,hagit,yossi).
parents(guy,meir,dikla).
parents(shai,dor,meni).

% Signature: participate(Child_name,Activity)/2
% Purpose: registration details
%
participate(dany,swimming).
participate(dany,ballet).
participate(dana,soccer).
participate(dana,judu).
participate(guy,judu).
participate(shai,soccer).

% Signature: parent_details(Name,Phone,Has_car)/3
% Purpose: parents details
%
parent_details(hagit,"0545661332",true).
parent_details(yossi,"0545661432",true).
parent_details(meir,"0545661442",false).
parent_details(dikla,"0545441332",true).
parent_details(dor,"0545881332",false).
parent_details(meni,"0545677332",true).

% Signature: not_member(Element, List)/2
% Purpose: The relation in which Element is not a member of a List.
not_member(_, []).
not_member(X, [Y|Ys]) :- X \= Y,
                         not_member(X, Ys).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% To Do

% Signature: pick_me_up(Child_name,Phone)/2
% Purpose: defines the relation between a child name and its parent phone number, when the parent has a car
pick_me_up(Child_name,Phone):-
    parents(Child_name, X, Y),
    (   parent_details(X, Phone, true);
    	parent_details(Y, Phone, true)
    ).


% Signature: active_child(Name)/1
% Purpose: returns true when a child participates in at least two activities.
active_child(Name):-
    participate(Name, X), 
    participate(Name, Y),
    X \= Y.

% Signature: activity_participants_list(Name, List)/2
% Purpose: defines the relationship between an activity and the children participating in it.
activity_participants_list(Name, List) :-
    bagof(X, participate(X, Name), List).

% Signature: can_register(Child_name,Activity)/2
% Purpose: defines the relation between a child name and an activity that the child can register to
can_register(Child_name,Activity):-
    activity(Activity, Day),
    get_days(Child_name, List2),
    not_member(Day, List2).
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% helper functions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Signature: member(Element, List)/2
% Purpose: The relation in which Element is a member of a List.
member(X, [X | _Xs]).
member(X, [_Y | Ys]) :- member(X, Ys).



% Signature: get_activities(Child_name,List)/2
% Purpose: defines the relation between a child name and and the activities the child is registered to
get_activities(Child_name,List):-
    bagof(X, participate(Child_name, X), List).


% Signature: get_days(Child_name,List)/2
% Purpose: defines the relation between a child name and and the days of the activities that the child is registerd to.
get_days(Child_name, List):-
    get_activities(Child_name, L2),
    findall(Y, (activity(X,Y), member(X,L2)),List).