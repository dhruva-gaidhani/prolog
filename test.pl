%:- Input Format.

users(5).
roles(5).
perms(4).

ur(1,2).
ur(1,5).
ur(2,1).
ur(3,3).
ur(4,3).
ur(4,4).
ur(5,4).

rp(1,3).
rp(2,3).
rp(3,1).
rp(4,2).
rp(5,4).

%The_format_is_(Ascendant,Descendant)
rh(1,2).
rh(1,4).
rh(2,1).
rh(2,3).
rh(3,2).
rh(4,2).
rh(5,3).
rh(5,1).

%==================================================
%Output_Predicates
%==================================================

%authorized_roles(User,List_Role).

% | ?- authorized_roles(1,List_Role).
% List_Role = [2,5,1,3,4]

%authorized_permissions(User,List_Permissions).

% | ?- authorized_permissions(1,List_Permissions).
% List_Permissions = [3,4,1,2]

%minRoles(S).

% | ?- minRoles(S).
% S = 2
