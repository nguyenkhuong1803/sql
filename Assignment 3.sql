select * from `account`;

-- q2: lấy ra tất cả các phòng ban
select departmentname from department;

-- q3: lấy ra id của phòng ban sale
select departmentid from department where departmentname = 'sale';

-- q4: lấy ra account có fullname dài nhất
select * from account where length(fullname) = (select max(length(fullname))from account);

-- q5: lấy ra account có fullname dài nhất và thuộc phòng ban có id=3
WITH q5 AS
(
SELECT * FROM `Account` WHERE DepartmentID =3
)
SELECT * FROM q5
WHERE LENGTH(Fullname) = (SELECT MAX(LENGTH(Fullname)) FROM q5);

-- q6 lấy tên group tạo trước ngày 20/12/2019
select groupname from `group`dua
	where createdate < '2019-12-20';
    
-- q7 lấy ra id của question có >=4 câu trả lời
select a.questionid, count(a.questionid) as sl from answer as a
	group by a.questionid having sl >=4;
    
-- q8 lấy ra các mã đề thi cói thời gian thi >= 60 phút và tạo trước ngày 20/12/2019
select `code` from exam
	where duration >= 60 and createdate<'2019-12-20';
    
-- q9 lấy ra 5 group được tạo gần đây nhất
select * from `group` 
	order by createdate desc limit 5;
    
-- q10 đếm số nhân viên thuộc departmentid = 2
select departmentid,(departmentid) as sl from `account`
	where departmentid = 2
		group by departmentid;
        
-- q11 lấy ra nhân viên có tên bắt đầu bằng chữ "D" và kết thúc bằng chữ "o"
select * from `account`
	where (fullname like "D%") and (fullname like "%o");
    
-- q12 xóa tất cả các exam tạo trước ngày 20/12/2019
delete from exam 
	where createdate < '2019-12-20';
    
-- q13 xóa tất cả các question có nội dung bắt đầu từ "câu hỏi"
delete from question
	where (content like "câu hỏi%");

-- q14 update thông tin của account có id = 5 thành tên "Nguyễn Bá Lộc" và email thành loc.nguyenba@vti.com.vn
update `account` set fullname = n'Nguyễn Bá Lộc',
					 email = 'loc.nguyenba@vti.com.vn'
		where accountid = 5;
        
-- q15 update account có id = 5 sẽ thuộc group có id = 4
update groupaccount set groupid = 4
	where accountid = 5;

