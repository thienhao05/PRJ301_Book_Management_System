-- =========================================
-- IF EXISTS → DROP DATABASE → CREATE AGAIN
-- =========================================
USE master;
GO

IF EXISTS (SELECT * FROM sys.databases WHERE name = 'BookstoreDB')
BEGIN
    ALTER DATABASE BookstoreDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE BookstoreDB;
END
GO

CREATE DATABASE BookstoreDB;
GO

USE BookstoreDB;
GO

-- =============================
-- USERS
-- =============================
CREATE TABLE Users (
    id INT PRIMARY KEY IDENTITY(1,1),
    full_name NVARCHAR(100) NOT NULL,
    email NVARCHAR(100) UNIQUE NOT NULL,
    password NVARCHAR(255) NOT NULL,
    phone NVARCHAR(20),
    address NVARCHAR(MAX),
    role NVARCHAR(20) DEFAULT 'USER',
    status NVARCHAR(20) DEFAULT 'ACTIVE',
    created_at DATETIME DEFAULT GETDATE()
);

-- =============================
-- CATEGORIES
-- =============================
CREATE TABLE Categories (
    id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(MAX),
    status NVARCHAR(20) DEFAULT 'ACTIVE'
);

-- =============================
-- PUBLISHERS
-- =============================
CREATE TABLE Publishers (
    id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(150) NOT NULL,
    description NVARCHAR(MAX)
);

-- =============================
-- BOOKS
-- =============================
CREATE TABLE Books (
    id INT PRIMARY KEY IDENTITY(1,1),
    title NVARCHAR(255) NOT NULL,
    author NVARCHAR(150),
    description NVARCHAR(MAX),
    price DECIMAL(10,2) NOT NULL,
    original_price DECIMAL(10,2),
    stock INT DEFAULT 0,
    image_url NVARCHAR(255),
    category_id INT,
    publisher_id INT,
    created_at DATETIME DEFAULT GETDATE(),
    status NVARCHAR(20) DEFAULT 'ACTIVE',

    FOREIGN KEY (category_id) REFERENCES Categories(id),
    FOREIGN KEY (publisher_id) REFERENCES Publishers(id)
);

-- =============================
-- ORDERS
-- =============================
CREATE TABLE Orders (
    id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL,
    order_date DATETIME DEFAULT GETDATE(),
    total_amount DECIMAL(12,2) NOT NULL,
    shipping_address NVARCHAR(MAX) NOT NULL,
    phone NVARCHAR(20) NOT NULL,
    payment_method NVARCHAR(20) DEFAULT 'COD',
    payment_status NVARCHAR(20) DEFAULT 'UNPAID',
    status NVARCHAR(30) DEFAULT 'PENDING',

    FOREIGN KEY (user_id) REFERENCES Users(id)
);

-- =============================
-- ORDER DETAILS
-- =============================
CREATE TABLE OrderDetails (
    id INT PRIMARY KEY IDENTITY(1,1),
    order_id INT NOT NULL,
    book_id INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,

    FOREIGN KEY (order_id) REFERENCES Orders(id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES Books(id)
);

-- =============================
-- REVIEWS
-- =============================
CREATE TABLE Reviews (
    id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT,
    book_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (book_id) REFERENCES Books(id)
);

-- =============================
-- INDEXES
-- =============================
CREATE INDEX idx_book_title ON Books(title);
CREATE INDEX idx_book_price ON Books(price);
CREATE INDEX idx_order_user ON Orders(user_id);

---SeedData

-- =============================
-- INSERT USERS
-- =============================
INSERT INTO Users (full_name, email, password, phone, address, role)
VALUES 
(N'Admin', 'admin@bookstore.com', '123456', '0909000001', N'HCM City', 'ADMIN'),
(N'Nguyễn Văn A', 'a@gmail.com', '123456', '0909000002', N'Hà Nội', 'USER'),
(N'Trần Thị B', 'b@gmail.com', '123456', '0909000003', N'Đà Nẵng', 'USER');

-- =============================
-- INSERT CATEGORIES
-- =============================
INSERT INTO Categories (name, description)
VALUES
(N'Văn học', N'Tiểu thuyết, truyện ngắn'),
(N'Kỹ năng sống', N'Phát triển bản thân'),
(N'Thiếu nhi', N'Sách dành cho trẻ em'),
(N'Manga', N'Truyện tranh Nhật Bản');

-- =============================
-- INSERT PUBLISHERS
-- =============================
INSERT INTO Publishers (name, description)
VALUES
(N'NXB Trẻ', N'Nhà xuất bản Trẻ'),
(N'NXB Kim Đồng', N'Nhà xuất bản Kim Đồng'),
(N'NXB Lao Động', N'Nhà xuất bản Lao Động');

-- =============================
-- INSERT BOOKS
-- =============================
INSERT INTO Books (title, author, description, price, original_price, stock, image_url, category_id, publisher_id)
VALUES
(N'Đắc Nhân Tâm', N'Dale Carnegie', N'Sách kỹ năng nổi tiếng', 89000, 120000, 50, 'dacnhantam.jpg', 2, 1),
(N'Nhà Giả Kim', N'Paulo Coelho', N'Tiểu thuyết truyền cảm hứng', 99000, 130000, 40, 'nhagiakim.jpg', 1, 1),
(N'Doraemon Tập 1', N'Fujiko F Fujio', N'Truyện tranh thiếu nhi', 25000, 30000, 100, 'doraemon1.jpg', 4, 2),
(N'Tôi Tài Giỏi Bạn Cũng Thế', N'Adam Khoo', N'Phát triển bản thân', 110000, 150000, 30, 'toitaigioi.jpg', 2, 3),
(N'Harry Potter 1', N'J.K. Rowling', N'Phù thủy và phép thuật', 150000, 200000, 25, 'harry1.jpg', 1, 1),
(N'Conan Tập 1', N'Gosho Aoyama', N'Thám tử lừng danh', 20000, 25000, 80, 'conan1.jpg', 4, 2),
(N'Cho Tôi Xin Một Vé Đi Tuổi Thơ', N'Nguyễn Nhật Ánh', N'Truyện thiếu nhi nổi tiếng', 85000, 100000, 60, 'tuoitho.jpg', 3, 1),
(N'7 Thói Quen Hiệu Quả', N'Stephen Covey', N'Kỹ năng lãnh đạo', 120000, 160000, 35, '7thoiquen.jpg', 2, 3);

-- =============================
-- INSERT ORDERS
-- =============================
INSERT INTO Orders (user_id, total_amount, shipping_address, phone, payment_method, payment_status, status)
VALUES
(2, 178000, N'Hà Nội', '0909000002', 'COD', 'UNPAID', 'PENDING'),
(3, 150000, N'Đà Nẵng', '0909000003', 'BANK', 'PAID', 'CONFIRMED');

-- =============================
-- INSERT ORDER DETAILS
-- =============================
INSERT INTO OrderDetails (order_id, book_id, price, quantity)
VALUES
(1, 1, 89000, 2),
(2, 5, 150000, 1);

-- =============================
-- INSERT REVIEWS
-- =============================
INSERT INTO Reviews (user_id, book_id, rating, comment)
VALUES
(2, 1, 5, N'Sách rất hay và bổ ích!'),
(3, 5, 4, N'Nội dung hấp dẫn, đáng đọc'),
(2, 3, 5, N'Truyện tuổi thơ không thể thiếu');