
-- q1 tạo trigger không cho phép người dùng nhập vào group có ngày tạo 1 năm trước
DROP TRIGGER IF EXISTS Trg_CheckInsertGroup;
DELIMITER $$
CREATE TRIGGER Trg_CheckInsertGroup
BEFORE INSERT ON `Group`
FOR EACH ROW
	BEGIN
		DECLARE v_CreateDate DATETIME;
		SET v_CreateDate = DATE_SUB(NOW(), interval 1 year);
		IF NEW.CreateDate <= v_CreateDate THEN
		SIGNAL SQLSTATE '10000'
		SET MESSAGE_TEXT = 'Cant create this group';
	END IF;

END$$
DELIMITER ;


-- q2 tạo trigger không cho phép thêm user vào deparment "sale" nữa
-- khi thêm hiện thông báo "Department "Sale" cannot add more user"
DROP TRIGGER IF EXISTS Trg_cantaddSale;
DELIMITER $$
CREATE TRIGGER Trg_cantaddSale
BEFORE INSERT ON `account`
FOR EACH ROW
	BEGIN
		DECLARE v_departmentid int;
		SET v_departmentid = 2;
		IF NEW.departmentid = v_departmentid THEN
		SIGNAL SQLSTATE '20000'
		SET MESSAGE_TEXT = 'Department "Sale" cannot add more user';
	END IF;

END$$
DELIMITER ;

-- q3 cấu hình 1 group có nhiều nhất là 5 user
DROP TRIGGER IF EXISTS Trg_5user;
DELIMITER $$
CREATE TRIGGER Trg_5user
BEFORE INSERT ON groupaccount
FOR EACH ROW
	BEGIN
		declare count int;
        declare masage varchar(50) default concat('không thể thêm user vào group: ',new.groupid);
		SELECT COUNT(ga.accountid)
			INTO count FROM
				`group` AS g
			JOIN
				groupaccount AS ga ON g.groupid = ga.groupid
			GROUP BY g.groupid
			HAVING g.groupid = NEW.groupid;
		IF count > 5 THEN
		SIGNAL SQLSTATE '30000'
		SET MESSAGE_TEXT = message;
	END IF;

END$$
DELIMITER ;

-- q4 cấu hình 1 bài thi có nhiều nhất là 10 question
DROP TRIGGER IF EXISTS Trg_q4;
DELIMITER $$
CREATE TRIGGER Trg_q4
BEFORE INSERT ON examquestion
FOR EACH ROW
	BEGIN
		declare count int;
        select count(eq.examid) into count from examquestion as eq
			where eq.examid = new.examid;
		if count > 10 then 
        SIGNAL SQLSTATE '40000'
		SET MESSAGE_TEXT = 'number of question in this exam is limited';
	END IF;
END$$
DELIMITER ;

-- q5 tạo trigger không cho phép người dùng xóa tài khoản có email là admin@gmail.com
DROP TRIGGER IF EXISTS Trg_q5;
DELIMITER $$
CREATE TRIGGER Trg_q5
BEFORE DELETE ON `account`
FOR EACH ROW
	BEGIN
		if old_email = 'admin@gmail.com' then
        SIGNAL SQLSTATE '50000'
		SET MESSAGE_TEXT = 'cant not delete this user';
	END IF;
END$$
DELIMITER ;

-- q6 tạo trigger cho phép người dùng khi tạo account không điền vào departmentID thì sẽ được phân vào phòng ban "waiting Department"
DROP TRIGGER IF EXISTS Trg_q6;
DELIMITER $$
CREATE TRIGGER Trg_q6
BEFORE INSERT ON `account`
FOR EACH ROW
	BEGIN
		declare waiting varchar(255);
        select d.departmentid into waiting from department as d
			where d.departmentname = 'waiting department';
		if new.deparmentid is null then 
			set new.departmentid = waiting;
	END IF;
END$$
DELIMITER ;

-- q7 cấu hình 1 bài thi chỉ cho phép user tạo tối đa 4 answers cho mỗi question, trong đó có tối đa 2 đáp án đúng
DROP TRIGGER IF EXISTS Trg_q7;
DELIMITER $$
CREATE TRIGGER Trg_q7
BEFORE INSERT ON  answer
FOR EACH ROW
	BEGIN
		declare countq int unsigned;
        declare counti int unsigned;
        select count(a.questionid) into countq from answer as a
			where a.questionid = new.questionid;
		select count(a.questionid) into counti from anser as a
			where a.questionid = new.questionid
				and a.iscorrect = new.iscorrect;
		if  countq > 4 or counti > 2 then
        SIGNAL SQLSTATE '70000'
		SET MESSAGE_TEXT = 'cant have more than 4 answer of more than 2 right answer';
	END IF;
END$$
DELIMITER ;

-- q8 nếu người dùng nhập vào gender của account là nam, nữ, chưa xác định
--    thì sẽ đổi lại thành M, F, U cho giống với cấu hình ở database
DROP TRIGGER IF EXISTS Trg_q8;
DELIMITER $$
CREATE TRIGGER Trg_q8
BEFORE INSERT ON `account`
FOR EACH ROW
	BEGIN
		if  new.gender = 'nam' then
			set new.gender = 'N';
		elseif new.gender = 'nữ' then
			set new.gender = 'F';
		elseif new.gender = 'chưa xác định' then
			set new.gender = 'U';
	END IF;
END$$
DELIMITER ;

-- q9 viết trigger không cho phép người dùng xóa bài thi mới tạo được 2 ngày
DROP TRIGGER IF EXISTS Trg_q9;
DELIMITER $$
CREATE TRIGGER Trg_q9
BEFORE DELETE ON exam
FOR EACH ROW
	BEGIN
		declare createdate1 date;
        set createdate1 = date_sub(now(), interval 2 day);
		if old.createdate = createdate1 then 
		SIGNAL SQLSTATE '90000'
		SET MESSAGE_TEXT = 'cant datele this exam';
	END IF;
END$$
DELIMITER ;

-- q10 viết trigger chỉ cho phép người dùng chỉ được update, delete các question khi question đó chưa nằm trong exam nào
DROP TRIGGER IF EXISTS Trg_q10;
DELIMITER $$
CREATE TRIGGER Trg_q10
BEFORE UPDATE ON question
FOR EACH ROW
	BEGIN
		if  then 
		SIGNAL SQLSTATE '10000'
		SET MESSAGE_TEXT = 'cant datele this question';
	END IF;
END$$
DELIMITER ;

-- q12 lấy ra thông tin exam trong đó
-- 		duration <= 30 thì sẽ đổi thành giá trị "Short time"
-- 		30 < duration <= 60 thì sẽ đổi thành giá trị "Medium time"
-- 		duration > 60 thì sẽ đổi thành giá trị "Long time" 
select *, case
		when durasion <= 30 then 'Short time'
        when duration >30 and duration <= 60 then 'Medium time'
        else 'Long time'
	end as 'type' from exam;
    
-- q13 Thống kê số account trong mỗi group và in ra thêm 1 column nữa có tên
-- 		là the_number_user_amount và mang giá trị được quy định như sau:
-- 			Nếu số lượng user trong group =< 5 thì sẽ có giá trị là few
-- 			Nếu số lượng user trong group <= 20 và > 5 thì sẽ có giá trị là normal
-- 			Nếu số lượng user trong group > 20 thì sẽ có giá trị là higher
select *, count(groupid), case
		when count(groupid) <= 5 then 'few'
        when count(groupid) <= 20 then 'normal'
        else 'higher'
	end as the_number_user_amount from groupaccount
		group by groupid;
        
-- q14 Thống kê số mỗi phòng ban có bao nhiêu user
-- 		nếu phòng ban nào không có user thì sẽ thay đổi giá trị 0 thành "Không có User"
select d.departmentid,d.departmentname,case
		when count(a.departmentid) = 0 then 'Không có User'
        else count(a.departmentid)
	end as sl from department as d
		left join `account` as a on d.departmentid = a.departmentid
			group by d.departmentid;


