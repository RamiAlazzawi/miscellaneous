   /* Aggregate: A function that operates on multiple rows of input, returning a single value
        max()
        min()
        count()
        avg()
*/

select length(title), title from book order by length(title) asc;
select length(title), title from book order by length(title) desc;
select length(title), title from book order by title asc;
select substr(title, 1, 5) from book;
select concat(title, length(title)) from book;
select concat(title, concat(' ', length(title))) from book;
select concat(concat(concat(title, concat(' ', length(title))),' '),price) from book;
select title||' '||length(title)||' '||price from book;
select systimestamp from dual;
select systimestamp from book;
select * from dual;
-- dual is a dummy table to query things you already have.
-- aggregate
select count(*) from book;
select count(*) from book where title like '%Potter%';
select avg(price) from book;
select max(price) from book;

select b.id, b.title, ba.author_id from book b join book_author ba on b.id = ba.book_id;
create or replace view booktitleandauthor as
select b.title, a.firstname||' '||a.lastname as author from
    (select b.id, b.title, ba.author_id from book b join book_author ba on b.id = ba.book_id) b
    join author a on b.author_id = a.id;
    
select * from booktitleandauthor;
select author, count(title) as "# of Books" from booktitleandauthor group by author;


-- cross join
select count(*) from author; -- 12
select count(*) from book; -- 12
select count(*) from book cross join author; -- 144
select count(*) from genre; -- 8
select count(*) from book, genre; -- 96

-- group by and having
select count(state), rate from taxrate group by rate;
select count(state), rate from taxrate group by rate where count(state) > 1;
select count(state), rate from taxrate where count(state) > 1 group by rate;

select * from taxrate where state like '%V';
select count(state), rate from taxrate where state like '%V' group by rate having count(state) > 1;
select * from author where firstname not like '%.%';
select author, count(title) as "# of Books" from booktitleandauthor
    where author not like '%.%'
    group by author
    having count(title) > 1
    order by author asc;
    
/*
Set operations
    Combines result sets with like columns
    Union - returns all unique rows in both sets
        (a, b, c) U (b, c) = (a, b, c)
    Union All - returns all rows in both sets
        (a, b, c) U All (b, c) = (a, b, b, c, c)
    Intersect - returns only rows that exist in both sets
        (a, b, c) intersect (b, c) = (b, c)
    Minus - retuns only rows that exist only in the first set
        (a, b, c) minus (b, c) = (a)
*/

select * from taxrate where state like '%V';
select * from taxrate where rate > .05;

select * from taxrate where rate > .05 minus select * from taxrate where state like '%V';
select * from taxrate where rate > .05 union all select * from taxrate where state like '%V';

select * from taxrate where rate > .069;
select * from taxrate where rate > .069 intersect select * from taxrate where state like '%V';
select * from taxrate where rate > .069 union select * from taxrate where state like '%V';


select id, genre from genre;
select id, genre from genre join book_genre on genre.id = book_genre.genre_id where book_genre.book_id = 2;
commit;



select calculateTax(
    (select id from book where title like '%Chamber%'),
    (select id from login where username = 'paulm')) as "Taxed Price"
from dual;
select calculateTax(id, 
    (select id from login where username = 'paulm'))
        as "Taxed Price",
title from book;

select calculateTax2(50, 2) from dual;


-- make empty purchases to work with
insert into purchase (customer_id, status) values
    ((select id from login where username='paulm'), 'OPEN');
insert into purchase (customer_id, status) values
    ((select id from login where username='rorr'), 'OPEN');
commit;

set serveroutput on;
declare
    total number;
    purch_id number;
    book_id number;
begin
    -- to call a stored proc in a plsql block, you just call it
    select id into purch_id from purchase where customer_id = (select id from login where username = 'paulm');
    select id into book_id from book where title like '%Sorcerer%';
    add_book_to_cart(purch_id, book_id, total);
    dbms_output.put_line('The new total is $'||total);
end;
/

set serveroutput on;
declare
    total number;
    purch_id number;
    book_id number;
begin
    -- to call a stored proc in a plsql block, you just call it
    select id into purch_id from purchase where customer_id = (select id from login where username = 'paulm');
    select id into book_id from book where title like '%Chamber%';
    remove_book_from_cart(purch_id, book_id, total);
    dbms_output.put_line('The new total is $'||total);
end;
/