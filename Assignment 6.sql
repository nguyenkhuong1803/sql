use testing_system_assignment;
-- q1 nhập tên phòng ban và in ra account thuộc phòng ban đó
DROP PROCEDURE IF EXISTS proc_q1;
DELIMITER $$
CREATE PROCEDURE proc_q1 (IN in_dept_name nvarchar(255))
	BEGIN
		SELECT 
			a.accountid, a.username
		FROM
			`account` AS a
				INNER JOIN
			department AS d ON d.departmentid = a.departmentid
		WHERE
			d.departmentname = in_dept_name;
	END$$
DELIMITER ;

CALL proc_q1('sale');
CALL proc_q1('marketing');

-- q2 in ra số lượng account của mỗi group
DROP PROCEDURE IF EXISTS proc_q2;
DELIMITER $$
CREATE PROCEDURE proc_q2 (IN in_groupname nvarchar(255))
	BEGIN
		SELECT g.groupid,g.groupname,count(ga.accountid)
        from `group` as g 
        join groupaccount as ga on g.groupid = ga.groupid
        where groupname = in_groupname;
	END$$
DELIMITER ;

-- q3 thống kê mỗi type question có bao nhiêu question được tạo trong tháng hiện tại
DROP PROCEDURE IF EXISTS proc_q3;
DELIMITER $$
create procedure proc_q3()
		begin
			SELECT 
				tq.*, COUNT(q.TypeID) as sl_question
			FROM
				typequestion tq
					LEFT JOIN
				question q ON tq.TypeID = q.TypeID
			WHERE
				YEAR(q.CreateDate) = YEAR(NOW())
					AND MONTH(q.createDate) = MONTH(NOW())
			GROUP BY tq.typeId;  
		end$$
DELIMITER ;

-- cau 4: tạo store để in ra id của type question mà có nhiều câu hỏi nhất
DROP procedure IF EXISTS proc_q4;
DELIMITER $$
create procedure proc_q4()
		begin
			with max as (select count(q.typeid) as a from question as q
								group by q.typeid)
			select tq.typeid,count(q.typeid) as sl from typequestion as tq
					join question as q on tq.typeid = q.typeid
                    group by tq.typeid having sl = (select max(a) from max);
		end$$
DELIMITER ;

-- q5 sử dụng store ở q4 đẻ tìm ra tên của type question
DROP procedure IF EXISTS proc_q5;
DELIMITER $$
create procedure proc_q5() 
		begin
			with max as (select count(q.typeid) as a from question as q
								group by q.typeid)
			select tq.typename,count(q.typeid) as sl from typequestion as tq
					join question as q on tq.typeid = q.typeid
                    group by tq.typeid having sl = (select max(a) from max);
		end$$
DELIMITER ;

-- q6
-- nhập vào 1 chuỗi, trả ra tên của group, hoặc username của account mà chứa cái chuỗi đó
-- đầu vào: in_sequence varchar(255);
DROP PROCEDURE IF EXISTS proc_q6;
DELIMITER $$
create procedure proc_cau6(
	in in_sequence varchar(255))
		begin
			select a.username as result from account a where a.username like CONCAT('%', in_sequence, '%')
			union
			select g.groupName as result from `group` g where g.GroupName like CONCAT('%', in_sequence, '%');
		end$$
DELIMITER ;

-- q7 viết 1 store cho phép người dùng nhập vào thông tin fullName, email và trong store sẽ tự động gán:
-- username sẽ giống email nhưng bỏ phần @.mail đi
-- positionid sẽ có default là developer
-- departmentid sẽ được cho vào 1 phòng chờ
-- sau đó in ra kết quả tạo thành công
drop procedure if exists proc_q7
DELIMITER $$
create procedure proc_cau7(in new_fullname varchar(255),in new_email varchar(255))
	begin
		declare new_username varchar(255) default substring_index(new_email,'@',1);
        declare new_positionid int unsigned default 1;
        declare new_departmentid int unsigned default 10;
        insert into `account`(email, username, fullname, departmentid, positionid)
				values(new_email, new_username, new_fullname, new_departmentid, new_positionid);
    end$$
DELIMITER ;

-- q8 viết 1 store cho phép người dùng nhập vào Essay hoặc Multiple-Choice 
--    thống kê câu hỏi essay hoặc multiple-choice nào có content dài nhất
drop procedure if exists proc_q8
DELIMITER $$
create procedure proc_cau8()
	begin
		
    end$$
DELIMITER ;

-- q9 viết 1 store cho phép người dùng xóa exam dựa vào id
drop procedure if exists proc_q9
DELIMITER $$
create procedure proc_cau9(in examid1 int unsigned)
	begin
		delete from examquestion where examid = examid1;
        delete from exam where examid = examid1;
    end$$
DELIMITER ;

-- q10 tìm ra các exam được tạo từ 3 năm trước và xóa các exam đó đi  
--     sau đó in số lượng record đã remove từ các table liên quan trong khi removing
drop procedure if exists proc_q10
DELIMITER $$
create procedure proc_cau10()
	begin
		
    end$$
DELIMITER ;

-- q11 viết store cho phép người dùng xóa phòng ban bằng cách người dùng nhập vào tên phòng ban 
--     các account thuộc phòng ban đó sẽ được chuyển về phòng ban default là phòng ban chờ việc
drop procedure if exists proc_q11
DELIMITER $$
create procedure proc_cau11()
	begin
		
    end$$
DELIMITER ;

-- q12 viết store để in ra mỗi tháng có bao nhiêu câu hỏi được tạo trong năm nay
drop procedure if exists proc_q12
DELIMITER $$
create procedure proc_cau12()
	begin
		
    end$$
DELIMITER ;

-- q13 viết store để in ra mỗi tháng có bao nhiêu câu hỏi được tạo trong 6 tháng gần đây nhất
--     nếu tháng nào không có thì sẽ in ra là "không có câu hỏi nào trong tháng"
drop procedure if exists proc_q13
DELIMITER $$
create procedure proc_cau13()
	begin
		
    end$$
DELIMITER ;