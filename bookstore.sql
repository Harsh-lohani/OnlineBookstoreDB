-- Create Authors table
CREATE TABLE IF NOT EXISTS Authors (
    AuthorID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Bio TEXT
);

-- Create Books table
CREATE TABLE IF NOT EXISTS Books (
    BookID INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(100) NOT NULL,
    Genre VARCHAR(50),
    Price DECIMAL(10, 2),
    PublicationDate DATE,
    AuthorID INT,
    SalesCount INT DEFAULT 0,
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID)
);

-- Create Customers table
CREATE TABLE IF NOT EXISTS Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Address TEXT
);

-- Create Orders table
CREATE TABLE IF NOT EXISTS Orders (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    OrderDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Create OrderDetails table
CREATE TABLE IF NOT EXISTS OrderDetails (
    OrderDetailID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT,
    BookID INT,
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);
-- Insert Authors
INSERT INTO Authors (Name, Bio) 
SELECT 'J.K. Rowling', 'British author, best known for the Harry Potter series.' 
WHERE NOT EXISTS (SELECT * FROM Authors WHERE Name = 'J.K. Rowling');

INSERT INTO Authors (Name, Bio) 
SELECT 'George R.R. Martin', 'American novelist and short story writer, known for A Song of Ice and Fire.' 
WHERE NOT EXISTS (SELECT * FROM Authors WHERE Name = 'George R.R. Martin');

-- Insert Books
INSERT INTO Books (Title, Genre, Price, PublicationDate, AuthorID) 
SELECT 'Harry Potter and the Philosopher''s Stone', 'Fantasy', 19.99, '1997-06-26', 1 
WHERE NOT EXISTS (SELECT * FROM Books WHERE Title = 'Harry Potter and the Philosopher''s Stone');

INSERT INTO Books (Title, Genre, Price, PublicationDate, AuthorID) 
SELECT 'A Game of Thrones', 'Fantasy', 29.99, '1996-08-06', 2 
WHERE NOT EXISTS (SELECT * FROM Books WHERE Title = 'A Game of Thrones');

-- Insert Customers
INSERT INTO Customers (Name, Email, Address) 
SELECT 'John Doe', 'john.doe@example.com', '123 Elm Street' 
WHERE NOT EXISTS (SELECT * FROM Customers WHERE Email = 'john.doe@example.com');

INSERT INTO Customers (Name, Email, Address) 
SELECT 'Jane Smith', 'jane.smith@example.com', '456 Oak Avenue' 
WHERE NOT EXISTS (SELECT * FROM Customers WHERE Email = 'jane.smith@example.com');

-- Insert Orders
INSERT INTO Orders (CustomerID, OrderDate) 
SELECT 1, '2024-07-20' 
WHERE NOT EXISTS (SELECT * FROM Orders WHERE CustomerID = 1 AND OrderDate = '2024-07-20');

INSERT INTO Orders (CustomerID, OrderDate) 
SELECT 2, '2024-07-21' 
WHERE NOT EXISTS (SELECT * FROM Orders WHERE CustomerID = 2 AND OrderDate = '2024-07-21');

-- Insert OrderDetails
INSERT INTO OrderDetails (OrderID, BookID, Quantity) 
SELECT 1, 1, 1 
WHERE NOT EXISTS (SELECT * FROM OrderDetails WHERE OrderID = 1 AND BookID = 1);

INSERT INTO OrderDetails (OrderID, BookID, Quantity) 
SELECT 2, 2, 2 
WHERE NOT EXISTS (SELECT * FROM OrderDetails WHERE OrderID = 2 AND BookID = 2);
-- Drop existing stored procedure if it exists
DROP PROCEDURE IF EXISTS AddBookWithAuthor;

-- Create stored procedure to add a new book with author details
DELIMITER //

CREATE PROCEDURE AddBookWithAuthor(
    IN authorName VARCHAR(100),
    IN authorBio TEXT,
    IN bookTitle VARCHAR(100),
    IN bookGenre VARCHAR(50),
    IN bookPrice DECIMAL(10, 2),
    IN pubDate DATE
)
BEGIN
    DECLARE authorID INT;

    -- Check if the author already exists
    SET authorID = (SELECT AuthorID FROM Authors WHERE Name = authorName);

    -- If author does not exist, insert new author
    IF authorID IS NULL THEN
        INSERT INTO Authors (Name, Bio) VALUES (authorName, authorBio);
        SET authorID = LAST_INSERT_ID();
    END IF;

    -- Insert the new book
    INSERT INTO Books (Title, Genre, Price, PublicationDate, AuthorID) VALUES (bookTitle, bookGenre, bookPrice, pubDate, authorID);
END //

DELIMITER ;
-- Drop existing trigger if it exists
DROP TRIGGER IF EXISTS UpdateBookSales;

-- Create trigger to update book sales count
DELIMITER //

CREATE TRIGGER UpdateBookSales AFTER INSERT ON OrderDetails
FOR EACH ROW
BEGIN
    UPDATE Books
    SET SalesCount = SalesCount + NEW.Quantity
    WHERE BookID = NEW.BookID;
END //

DELIMITER ;
-- Drop existing view if it exists
DROP VIEW IF EXISTS PopularBooks;

-- Create a view for the most popular books
CREATE VIEW PopularBooks AS
SELECT Books.Title, SUM(OrderDetails.Quantity) AS TotalSold
FROM OrderDetails
JOIN Books ON OrderDetails.BookID = Books.BookID
GROUP BY Books.Title
ORDER BY TotalSold DESC;

-- Retrieve the most popular books
SELECT * FROM PopularBooks;
