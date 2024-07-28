# Online Bookstore Database Management System

## Project Description

This project is an Online Bookstore Database Management System designed to handle the storage, retrieval, and management of data related to books, authors, customers, and orders.

## Database Schema

The database consists of the following tables:
- **Authors**
- **Books**
- **Customers**
- **Orders**
- **OrderDetails**

## Features

- Insert, update, and delete records of books, authors, customers, and orders.
- Retrieve lists of books by specific authors.
- Fetch orders made by specific customers.
- Generate reports of total sales for each book.
- List customers who have placed more than a certain number of orders.
- Stored procedures for adding books with author details.
- Triggers for updating book sales count.
- Views for displaying the most popular books.

## Sample Queries

- Retrieve a list of all books by a specific author:
  ```sql
  SELECT * FROM Books WHERE AuthorID = (SELECT AuthorID FROM Authors WHERE Name = 'J.K. Rowling');
"# Online Bookstore Database" 
