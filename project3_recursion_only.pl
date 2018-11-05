:- import basics.
:- import append/3 from basics.
:- import member/2 from basics.
:- import between/3 from basics.

%=======================================================
%%Q1_This_predicate_returns_the_authorized_roles_of_a_user
%=======================================================

authorized_roles(User,List_Role) :-
  findall(Y,ur(User,Y),List_1),
  role_hierarchy(List_1,[],List_Role).

role_hierarchy([F|L],F1,List_Role):-
  findall(Y,rh(F,Y),List_2),
  append(L,List_2,N),
  append(F1,[F],F2),
  remove_common_from2(F2,N,N2),
  role_hierarchy(N2,F2,List_Role).

role_hierarchy([],New,List_Role):-
  List_Prev = New,
  remove_duplicates(List_Prev,List_Role).

%=======================================================
%%Q2_This_predicate_computes_the_authorized_roles_of_a_user
%Then_takes_that_data_to_find_the_respective_authorized
%Permissions_for_those_roles
%=======================================================

authorized_permissions(User,List_Permissions):-
  authorized_roles(User,List_Role),
  permission_hierarchy(List_Role,[],List_Permissions).

permission_hierarchy([F|L],F1,List_Permissions):-
  findall(Y,rp(F,Y),List_2),
  append(F1,List_2,N),
  permission_hierarchy(L,N,List_Permissions).

permission_hierarchy([],New,List_Permissions):-
  List_Prev = New,
  remove_duplicates(List_Prev,List_Permissions).

%=======================================================
%%Q3_This_predicate_counts_minimum_roles_required
%=======================================================
minRoles(S):-
  users(X),
  list_maker(X,User_list),
  authorized_rp_recur(User_list,[],All_roles),
  list_sort(All_roles,[],All_sort_roles),
  remove_duplicates(All_sort_roles,All_unique_roles),
  length_list(All_unique_roles,S).

%____________________________________________________________
%These_are_all_helper_predicates_that_help_compute_the_results
%____________________________________________________________

%This_predicate_is_used_to_sort_a_given_list_of_lists

list_sort([],Temp,All_sort_roles):-
  All_sort_roles = Temp.

list_sort([F|L],Temp,All_sort_roles):-
  insertionSort(F,A),
  append([A],Temp,New),
  list_sort(L,New,All_sort_roles).

insert(X, [], [X]):- !.
insert(X, [X1|L1], [X, X1|L1]):- X=<X1, !.
insert(X, [X1|L1], [X1|L]):- insert(X, L1, L).

insertionSort([], []):- !.
insertionSort([X|L], S):- insertionSort(L, S1), insert(X, S1, S).

%This_predicate_computes_the_length_of_list
length_list([_|Xs], M):-
  length_list(Xs, N),
  M is N+1.

length_list([], 0).

%This_predicate_returns_all_permissions_for_a_user_as_a_list

authorized_rp_recur([F|L],Temp,One_rp):-
  authorized_permissions(F,List_Permissions),
  append([List_Permissions],Temp,New),
  authorized_rp_recur(L,New,One_rp).

authorized_rp_recur([],Temp,One_rp):-
  One_rp = Temp.

%This_predicate_computes_roles_for_all_users_and_returns
%As_a_list

authorized_roles_recur([F|L],Temp,All_roles):-
  authorized_roles(F,List_Role),
  append([List_Role],Temp,New),
  authorized_roles_recur(L,New,All_roles).

authorized_roles_recur([],Temp,All_roles):-
  All_roles = Temp.

%This_predicate_creates_a_list_of_n_integers

list_maker(N, L):-
  findall(Num, between(1, N, Num), L).

%This_predicate_is_used_to_remove_the
%common_elements_from_the_tail_of_a_list
%It_is_a_lookahead_to_remove_cycles_if_any

remove_common_from2(F2,[F|N],N2):-
  member(F, F2), !,
  remove_common_from2(F2,N,N2).

remove_common_from2(F2,[F|N],[F|N2]):-
  remove_common_from2(F2,N,N2).

remove_common_from2(_,[],[]).

%This_predicate_is_used_to_remove_the
%duplicates_from_a_list

remove_duplicates([X|Rest], Result) :-
	member(X, Rest), !,
	remove_duplicates(Rest, Result).

remove_duplicates([X|Rest], [X|Result]) :-
	% X is not a member of Rest as
	% the above clause has a cut in it.
	remove_duplicates(Rest, Result).

remove_duplicates([], []).
