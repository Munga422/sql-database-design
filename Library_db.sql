CREATE DATABASE library_db;
USE library_db;
CREATE TABLE books (
book_id INT PRIMARY KEY AUTO_INCREMENT,
title VARCHAR(100) NOT NULL,
author VARCHAR(50),
 genre VARCHAR(50),
 publication_year INT,
 available_copies INT DEFAULT 1
 );
 
 CREATE TABLE borrowers (
 borrower_id INT PRIMARY KEY AUTO_INCREMENT,
 name  VARCHAR(100) NOT NULL,
 email  varchar(100) UNIQUE,
 phone VARCHAR(15)
 );
 
 CREATE TABLE loans(
 loan_id INT PRIMARY KEY AUTO_INCREMENT,
 book_id INT,
 borrower_id INT,
 loan_date DATE,
 return_date DATE,
 FOREIGN KEY(book_id) REFERENCES books(book_id),
 FOREIGN KEY (borrower_id) REFERENCES borrowers(borrower_id)
 );

-- insert into books 
 INSERT INTO books(title,author,genre,publication_year, available_copies)
 VALUES
 ('The Great Gatsby','F.Scott Fitzgerald','FICTION',1925,3),
 ('1984','Gorge ORELL','Dystopian',1949,2),
 ('Pride and Prejudice','Jane Austen','Romance', 1813,4),
 ('To Kill a Morckingbird','Haper Lee','Fiction', 1960,1),
 ('The Catcher in the Rye','J.D.Saliger','Fiction',1951,2),
 ('Brave New World','Aldous Huxley','Dystopian',1932,3),
 ('Moby Dick','Herman Melville','Adventure',1851,2),
 ('War and Peace', 'Leo Tolstoy','Historical',1865,1),
 ('The Hobbit','J.R.R.Tolkein','Fantasy',1937,5),
 ('Crime and Punishment','Fyodor Dostoevsky','Philosophical',1866,2);
 
 -- Insert into borrowers
 INSERT INTO borrowers(name,email,phone)
 VALUES
 ('John Doe','johndoe1@gmail.com','555-0101'),
 ('Jane Smith','janesmith2@gmail.com','555-0102'),
 ('Alice Johnson','alice j3@gmail.com','555-0103'),
 ('Bob Brown','bobbrown4@gmail.com','555-0104'),
 ('Carol White','carolw5@gmail.com','555-0105'),
 ('David Lee','davidlee1@gmail.com','555-0106'),
 ('Emma Davis','emmadavis2@gmail.com','555-0107'),
 ('Frank Wilson','frankw3@gmail.com','555-0108'),
 ('Grace Taylor','gracetay7@gmail.com','555-0109'),
 ('Henry Clark','henryclark81@gmail.com','555-0110');
 
 -- insert into loans
 INSERT INTO loans(book_id,borrower_id,loan_date,return_date)
 VALUES
 (1,1,'2025-06-01',NULL),
 (2,2,'2025-06-02','2025-06-15'),
 (3,3,'2025-06-05',NULL),
 (4,4,'2025-06-4','2025-06-20'),
 (5,5,'2025-06-05',NULL),
 (6,6,'2025-06-06','2025-06-18'),
 (7,7,'2025-06-07', NULL),
 (8,8,'2025-06-08','2025-06-22'),
 (9,9,'2025-06-09',NULL),
 (10,10,'2025-06-10','2025-06-25');
 
 -- QUERY 1 :Find all books currently on loan(we will use JOIN)
 SELECT b.title,br.name,l.loan_date
 FROM books b
 join loans l on b.book_id=l.book_id
 join borrowers br on l.borrower_id=br.borrower_id
 where l.return_date is null;
 
 -- EXPLANATION : THIS QUERY uses INNER JOIN to connect the books ,loans and borrowers table
 
 -- QUERY 2: List books with more than 2 available copies.(we will use subqueries)
 
 SELECT title ,available copies 
 FROM books 
 WHERE available_copies>(
							select  avg(available_copies)
                            from books
);


-- QUERY 3: Find borrowers who have borrowered more than one book (we will use CTE'S)

WITH BorrowerLoanCount AS(
		SELECT borrower_id, COUNT(*) as loan_count
		FROM loans
		GROUP BY borrower_id
		HAVING loan_count>1 
)
SELECT b.name, blc.loan_count 
FROM borrowers b
JOIN BorrowerLoanCount blc ON b.borrower_id=blc.borrower_id;

-- The CTE (BorrowerLoanCount)calculate the number of loans per borrower, and the HAVING filters orrowers with more than 1 loan and the join is used to get borrower name.

-- QUERY 4: TRIGGER

DELIMITER //
CREATE TRIGGER after_loan_insert
AFTER INSERT ON loans 
FOR EACH ROW 
BEGIN
UPDATE books
SET available_copies=available_copies-1
where book_id =NEW.book_id
AND available_copies>0;
END//
DELIMITER;

