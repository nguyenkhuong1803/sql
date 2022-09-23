use testing_system_assignment;
-- q1 lấy danh sách nhân viên và phòng ban
select a.*,d.departmentname from `account` as a
	join department as d on a.departmentid = d.departmentid;

-- q2 lấy ra các account tạo sau ngày 20/12/2010
select * from `account` where createdate > 20-12-2010;

-- q3 lấy ra các developer
select a.*,p.positionname from account as a
	join position as p on a.positionid = p.positionid 
		where p.positionname = 'dev';
    
-- q4 lấy các phòng ban có >3 nhân viên
select d.departmentname from `account` as a
	join department as d on a.departmentid = d.departmentid
		group by a.departmentid having count(a.departmentid)>=3;
	
-- q5 lấy danh sách câu hỏi đc sử dụng trong đề thi nhiều nhất
with q5 as (
	select eq.questionid,count(eq.questionid) as sl from exam as e
		join examquestion as eq on e.examid = eq.examid
			group by questionid
    )
select * from q5 where sl = (select max(sl)from q5);
        
-- q6 thống kê mỗi category question được sử dụng trong bao nhiêu question
select cq.categoryname,count(q.categoryid) as sl from question as q
	join categoryquestion as cq on q.categoryid = cq.categoryid
		group by categoryname;
        
-- q7 thống kê mỗi question được sử dụng trong bao nhiêu exam
select q.content,count(eq.questionid) as sl  from question as q
	join examquestion as eq on q.questionid = eq.questionid
		group by q.questionid;
        
-- q8 question có nhiều câu trả lời nhất
with q8 as(
	select q.questionid,count(a.questionid) as sl from question as q
		right join answer as a on q.questionid = a.questionid
			group by q.questionid
	)
    select * from q8 where sl = (select max(sl)from q8);
    
-- q9 thống kê số lượng account trong mỗi group
select g.groupname,count(ga.accountid) as sl from `group` as g
	join groupaccount as ga on g.groupid = ga.groupid
		group by g.groupname;
        
-- q10 chức vụ ít người nhất
with q10 as(
	select p.positionname,count(a.positionid) as sl from `account` as a
		join position as p on a.positionid = p.positionid
			group by p.positionname
	)
    select * from q10 where sl = (select min(sl)from q10);
    
-- q11 thống kê mỗi phòng ban có bao nhiêu dev, test, scrum master,pm
select d.departmentid,d.departmentname,p.positionname,count(a.positionid) as sl from `account` as a
	inner join department as d on a.departmentid = d.departmentid
    inner join position as p on a.positionid = p.positionid
		group by d.departmentid,p.positionid;
        
-- q12 lấy thông tin chi tiết của câu hỏi
select * from question as q
	join typequestion as t on q.typeid = t.typeid
    join `account` as a on q.creatorid = a.accountid
    join answer as an on q.questionid = an.questionid
    join categoryquestion as cq on q.categoryid = cq.categoryid;
    
-- q13 lấy ra số lượng câu hỏi mỗi loại
select t.typename,count(q.typeid) as sl from question as q 
	join typequestion as t on q.typeid = t.typeid
		group by t.typename;
     
-- q14 q15 lấy ra group không có account nào
select * from `group` as g 
	left join groupaccount as ga on g.groupid = ga.groupid
		where ga.accountid is null;

-- q16 lấy ra question không có answer nào
select q.questionid from question as q 
	left join answer as a on q.questionid = a.questionid
		where a.answerid is null;
        
-- q17 lấy account thuộc nhóm 1 và nhóm 2
select a.fullname from `account` as a
	join groupaccount as ga on a.accountid = ga.accountid
		where ga.groupid = 1
union
select a.fullname from `account` as a
	join groupaccount as ga on a.accountid = ga.accountid
		where ga.groupid = 2; 
        
-- q18 lấy các group có >5 và <7 thành viên
select g.groupname,count(ga.groupid) as sl from groupaccount as ga
	join `group`  as g on ga.groupid = g.groupid
		group by g.groupid having count(ga.groupid)>=5
union
select g.groupname,count(ga.groupid) as sl from groupaccount as ga
	join `group`  as g on ga.groupid = g.groupid
		group by g.groupid having count(ga.groupid)<=7;

