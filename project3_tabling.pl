:- auto_table.

% List_Roles is the Set of all Roles that User has.
% It returns 'no' when there are no more roles that belong to the User.
authorized_roles(User,List_Roles):-
    % Build the setof all roles for the User
    setof(Role, all_roles(User, Role), List_Roles).

    % Setof is Sorted order, no repitition

% List_Permissions is the Set of the Permissions that a User has.
% It returns 'no' when there are no permissions that belong to the User.
authorized_permissions(User,List_Permissions):-
    setof(Perm, all_perms(User, Perm), List_Permissions).

% Get the minimum number of Roles that
% is required to satisfy question 3
% We build a set of all Permissions Lists
% that we obtains in Question 2 and return the len of this set
% Since this is a set, we have no duplicates.
% Since authorized_permissions returns a 'no' for users that dont have
% permissions, we are guaranteed the correct answer

minRoles(S):-
    setof(Perms, authorize_permissions_recur(Roles), ListListPerms),
    len(ListListPerms, S).

% Get all the descendent Roles that the 'Role' is an ascendant of.
descendent_role(Role, Desc):-
    % Role has a direct relation to Desc,
    % or has a transitive relation with a descendant
    rh(Role, Desc);
    rh(Role, X),
    descendent_role(X, Desc).

% Get all the roles that a User can have.
all_roles(User, Desc):-
    % Either the user has a "direct" relationship
    % or has a transitive Role hierarchy
    ur(User, Desc);
    ur(User,Role),
    descendent_role(Role, Desc).

% Get all the permissions of the User
% using the already defined all_roles predicate
all_perms(User, Perm):-
    all_roles(User, Role),
    rp(Role, Perm).

% Standard len definition to get the length of a list
len([],0).

len([_|Tail], N):-
    len(Tail, NOfTail),
    N is NOfTail + 1.

% A wrapper around the authorized_roles predicate
% that obtains the authorized_roles for every user that is defined.
authorize_permissions_recur(Perms):-
    ur(User,_),
    authorized_permissions(User, Perms).

% For the beginner -
% ',' is used to 'and' predicates
% ';' is used to 'or' predicates
% '.' is used to terminate predicates 
% Credits for this code: @adarshdec23