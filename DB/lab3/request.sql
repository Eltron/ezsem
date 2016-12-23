select * from client;

select * from provider;

select * from type;

select * from load;

select * from transport;

select * from insurance;

select * from ord;

select * from transportation;

select * from shedule;

select * from shedule where arr_date in ('29.11.2016' , '29.12.2016');

select * from client where name like 'D%';

select * from ord where amount_cost between 100 and 1000;

select load.name, sum( load.cost ) sum_cost from load where id_type = 2 group by load.name

select * from transport order by capacity, name;

select load.name, type.name from load, type where load.id_type = type.id;

select * from shedule as p1 inner join transportation as p2 on p1.id_transportation = p2.id and p1.arr_date ='29.11.2016';

select * from load inner join insurance as p1 on p1.id_load = load.id and load.cost > 1000; 

select load.id_type, avg(load.cost) avg_cost from load group by load.id_type having avg(load.cost) > 50000;

select name from load where id_type = (select id from type where name = 'build matherials');

create procedure ins_transport(i integer, name varchar(20), capacity int)
begin
insert into transport (id, name, capacity) values (:i, :name, :capacity);
end

create procedure ins_provider(i int, name varchar(20), surname varchar(20), oldname varchar(20), firm varchar(20), addr varchar(100), phone_num varchar(11))
begin
insert into provider (id, name, surname, oldname, firm, address, phone_number) values (:i, :name, :surname, :oldname, :firm, :addr, :phone_num);
end

create procedure ins_client(i int, name varchar(20), surname varchar(20), oldname varchar(20), addr varchar(100), phone_num varchar(11))
begin
insert into client (id, name, surname, oldname, address, phone_number) values (:i, :name, :surname, :oldname, :addr, :phone_num);
end

create procedure ins_type(i int, name varchar(20), cost float)
begin
insert into type (id, name, cost) values (:i, :name, :cost);
end

create procedure ins_load(i int, name varchar(20), id_type int, weight int, length float, width float, height float, cost float)
begin
insert into load (id, name, id_type, weight, length, width, height, cost) values (:i, :name, :id_type, :weight, :lenght, :width, :height, :cost);
end

create procedure ins_insurance(i int, id_load int, return_cost float)
begin
insert into insurance (id, id_load, return_cost) values (:i, :id_load, :return_cost);
end

create procedure ins_ord(i int, id_provider int, id_client int, id_load int, quantity int, amount_cost float, id_insurance int) 
begin
insert into ord (id, id_provider, id_client, id_load, quantity, amount_cost) values (:i, :id_provider, :id_client, :id_load, :quantity, :amount_cost);
end

create procedure ins_transportation(i int, id_transport int, id_ord int)
begin
insert into transportation (id, id_transport, id_ord) values (:i, :id_transport, :id_ord);
end

create procedure ins_shedule(i int, id_transportation int, arr_date tymestamp)
begin
insert into shedule (id, id_transportation, arr_date) values (:i, :id_transportation, :arr_date);
end

create procedure update_load(id_type int) as
begin
update load
set
	cost = cost + 100
where id_type = :id_type;
end

create procedure del_ord(i int) as
begin
delete from ord where id_client = :i and amount_cost=(select min(amount_cost) from ord where id_client = :i);
end

create procedure del_trans as
begin	
delete from transportation where id not in (select id_transportation from shedule);
end

select first 5 type.name, sum(ord.quantity) as sum_quantity from type, load, ord
where load.id = ord.id_load and type.id = load.id_type group by type.name;

select provider.name, provider.surname, provider.oldname, count(ord.id_provider) as counter from provider, ord where provider.id = ord.id_provider group by provider.name, provider.surname, provider.oldname;

create procedure del_load as
begin
delete from load where id not in (select ord.id_load from ord);
end

