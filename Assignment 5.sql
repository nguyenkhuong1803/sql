use  testing_system_assignment;

-- q1 tạo view có chứa danh sách nhân viên thuộc phòng ban sale
create or replace view q1 as
with q1a as(
SELECT 
    a.*, D.departmentname
FROM
    `account` AS a
INNER JOIN
    department AS d ON a.departmentid = d.departmentid
WHERE
    d.departmentname = 'sale'
)
select * from q1a;

-- q2 tạo view chứa thông tin account tham gia nhiều group nhất
create or replace view q2 as
with q2a as(
SELECT 
    a.accountid, a.username, a.fullname, COUNT(ga.groupid) AS c
FROM
    `account` AS a
LEFT JOIN
    groupaccount AS ga ON a.accountid = ga.accountid
GROUP BY a.accountid
    )
	select * from q2a where c = (select max(c)from q2a);
    
-- q3 tạo view chứa câu hỏi có những content quá dài và xóa nó đi
create or replace view q3 as
	select * from question 
		where length(content) > 300;
delete from q3;

-- q4 tạo view chưa danh sách các phòng ban có nhiều nhân viên nhất
create or replace view q4 as
with q4a as(
SELECT 
    d.departmentid,
    d.departmentname,
    COUNT(a.departmentid) AS sl
FROM
    `account` AS a
        JOIN
    department AS d ON a.departmentid = d.departmentid
GROUP BY d.departmentid
)
select * from q4a where sl = (select max(sl)from q4a);

-- q5 tạo view có chứa tất cả các câu hỏi do user họ Nguyễn tạo
create or replace view q5 as
select q.questionid,q.content,q.categoryid,q.typeid,q.createdate,a.fullname as creator
from question as q left join `account` as a on q.creatorid = a.accountid
where a.fullname like 'Nguyễn%';


