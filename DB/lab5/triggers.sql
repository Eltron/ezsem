create sequence tr_gen;
alter sequence tr_gen restart with 0;

create or alter trigger tr_id_autonic for transportation
active before insert position 0 as
begin
	if(new.id is null or new.id = 0) then new.id = next value for tr_gen;
end

create or alter trigger load_ctl for load
active before delete position 0 as
begin
	delete from ord where id_load = old.id;
	delete from insurance where id_load = old.id;
end

create of alter exception iscopy 'This entry is already exists!';

create or alter trigger tr_not_copy for transportation
active before insert position 0 as
begin
    if((select id from transportation where id_ord = new.id_ord and
    id_transport = new.id_transport) in (select id from transportation))
    then exception iscopy;
end

create or alter trigger load_stowage for ord
active before insert position 0 as
begin
	execute procedure stowage;
end