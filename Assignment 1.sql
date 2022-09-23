drop database if exists testing_system_assignment;
create database testing_system_assignment;
use testing_system_assignment;

create table department (
	departmentid smallint auto_increment primary key,
    departmentname nvarchar(50) not null unique key
);

create table position (
	positionid smallint auto_increment primary key,
    positionname varchar(20) not null 
);

create table `account` (
	accountid smallint auto_increment primary key,
    email varchar(100) unique key,
    username varchar(20) unique key not null,
    fullname nvarchar(50) not null,
    departmentid smallint,
    foreign key (departmentid) references department(departmentid),
    positionid smallint,
    foreign key (positionid) references `position`(positionid),
    createdate datetime default now()
);

create table `group`(
	groupid smallint auto_increment primary key,
    groupname nvarchar(50) unique key,
    creatorid smallint not null,
    foreign key(creatorid) references `account`(accountid),
    createdate datetime default now()
);

create table groupaccount(
	groupid smallint,
    foreign key (groupid) references `group`(groupid),
    accountid smallint,
    foreign key (accountid) references `account`(accountid),
    primary key(groupid,accountid),
    joindate datetime default now()
);

create table typequestion(
	typeid smallint auto_increment primary key,
    typename enum('essay','multiplechoice') not null
);

create table categoryquestion(
	categoryid smallint auto_increment primary key,
    categoryname nvarchar(50) not null
);

create table question(
	questionid smallint auto_increment primary key,
    content nvarchar(500) not null,
    categoryid smallint,
    foreign key(categoryid) references categoryquestion(categoryid),
    typeid smallint,
    foreign key(typeid) references typequestion(typeid),
    creatorid smallint not null,
    foreign key(creatorid) references `account`(accountid),
    createdate datetime default now()
);

create table answer(
	answerid smallint auto_increment primary key,
    content nvarchar(1000) not null,
    questionid smallint,
    foreign key(questionid) references question(questionid),
    iscorrect enum('true','false')
);

create table exam(
	examid smallint auto_increment primary key,
    examcode varchar(20) ,
    title nvarchar(50),
    categoryid smallint,
    foreign key(categoryid) references question(categoryid),
    duration smallint,
    creatorid smallint,
    foreign key(creatorid) references `account`(accountid),
    createdate datetime default now()
);

create table examquestion(
	examid smallint,
	foreign key(examid) references exam(examid),
    questionid smallint,
	foreign key(questionid) references question(questionid),
    primary key(examid,questionid)
);

insert into department(departmentname)
values
	(n'marketing'),
	(n'sale'),
	(n'bảo vệ'),
	(n'nhân sự'),
	(n'kỹ thuật'),
	(n'tài chính'),
	(n'phó giám đốc'),
	(n'giám đốc'),
	(n'thư kí'),
	(n'no person'),
	(n'Bán hàng');

insert into `position`(positionname)
values 
	('dev'),
	('test'),
	('scrum master'),
	('pm');

insert into `account`(email,username,fullName,departmentid,positionid,createdate)
values 
('email1@gmail.com','username1','fullname1','5','1','2020-03-05'),
('email2@gmail.com','username2','fullname2','1','2','2020-03-05'),
('email3@gmail.com','username3','fullname3','2','2','2020-03-07'),
('email4@gmail.com','username4','fullname4','3','4','2020-03-08'),
('email5@gmail.com','username5','fullname5','4','4','2020-03-10'),
('email6@gmail.com','username6','fullname6','6','3','2020-04-05'),
('email7@gmail.com','username7','fullname7','2','2',default),
('email8@gmail.com','username8','fullname8','8','1','2020-04-07'),
('email9@gmail.com','username9','fullname9','2','2','2020-04-07'),
('email10@gmail.com','username10','fullname10','10','1','2020-04-09'),
('email11@gmail.com','username11','fullname11','10','1',default),
('email12@gmail.com','username12','fullname12','10','1',default);

insert into `group`(groupname,creatorid,createdate)
values 
	(n'testing system',5,'2019-03-05'),
	(n'development',1,'2020-03-07'),
	(n'vti sale 01',2,'2020-03-09'),
	(n'vti sale 02',3,'2020-03-10'),
	(n'vti sale 03',4,'2020-03-28'),
	(n'vti creator',6,'2020-04-06'),
	(n'vti marketing 01',7,'2020-04-07'),
	(n'management',8,'2020-04-08'),
	(n'chat with love',9,'2020-04-09'),
	(n'vi ti ai',10,'2020-04-10');
    
insert into `groupaccount`(groupid,accountid,joindate)
values 
	(1,1,'2019-03-05'),
	(1,2,'2020-03-07'),
	(3,3,'2020-03-09'),
	(3,4,'2020-03-10'),
	(5,5,'2020-03-28'),
	(1,3,'2020-04-06'),
	(1,7,'2020-04-07'),
	(8,3,'2020-04-08'),
	(1,9,'2020-04-09'),
	(10,10,'2020-04-10');

insert into typequestion(typename)
values
	('essay'),
	('multiplechoice');

insert into categoryquestion(categoryname)
values 
	('java'),
	('asp.net'),
	('ado.net'),
	('sql'),
	('postman'),
	('ruby'),
	('python'),
	('c++'),
	('c sharp'),
	('php');

insert into question(content,categoryid,typeid,creatorid,createdate)
values 
	(n'câu hỏi về java',1,'1','2','2020-04-05'),
	(n'câu Hỏi về php',10,'2','2','2020-04-05'),
	(n'câu hỏi về c#',9,'2','3','2020-04-06'),
	(n'câu hỏi về ruby',6,'1','4','2020-04-06'),
	(n'câu hỏi về postman',5,'1','5','2020-04-06'),
	(n'câu hỏi về ado.net',3,'2','6','2020-04-06'),
	(n'câu hỏi về asp.net',2,'1','7','2020-04-06'),
	(n'câu hỏi về c++',8,'1','8','2020-04-07'),
	(n'câu hỏi về sql',4,'2','9','2020-04-07'),
	(n'câu hỏi về python',7,'1','10','2020-04-07');
    
insert into answer(content,questionid,iscorrect)
values 
	(n'trả lời 01',1,'true'),
	(n'trả lời 02',1,'false'),
	(n'trả lời 03',1,'true'),
	(n'trả lời 04',1,'false'),
	(n'trả lời 05',2,'false'),
	(n'trả lời 06',3,'false'),
	(n'trả lời 07',4,'true'),
	(n'trả lời 08',8,'true'),
	(n'trả lời 09',9,'false'),
	(n'trả lời 10',10,'false');

insert into exam(examcode,title,categoryid,duration,creatorid,createdate)
values 
	('vtiq001',n'đề thi c#',1,60,'5','2019-04-05'),
	('vtiq002',n'đề thi php',10,60,'2','2019-04-05'),
	('vtiq003',n'đề thi c++',9,120,'2','2019-04-07'),
	('vtiq004',n'đề thi java',6,60,'3','2020-04-08'),
	('vtiq005',n'đề thi ruby',5,120,'4','2020-04-10'),
	('vtiq006',n'đề thi postman',3,60,'6','2020-04-05'),
	('vtiq007',n'đề thi sql',2,60,'7','2020-04-05'),
	('vtiq008',n'đề thi python',8,60,'8','2020-04-07'),
	('vtiq009',n'đề thi ado.net',4,90,'9','2020-04-07'),
	('vtiq010',n'đề thi asp.net',7,90,'10','2020-04-08');

insert into examquestion(examid,questionid)
values 
	(1,5),
	(2,10),
	(3,4),
	(4,3),
	(5,7),
	(6,10),
	(7,2),
	(8,10),
	(9,9),
	(10,8);
    