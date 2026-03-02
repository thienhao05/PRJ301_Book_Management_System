-- =========================================
-- DROP & CREATE DATABASE
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


-- =====================================
-- 1. ROLES
-- =====================================
CREATE TABLE Roles (
    role_id INT PRIMARY KEY IDENTITY(1,1),
    role_name VARCHAR(50) NOT NULL UNIQUE
);

-- =====================================
-- 2. USERS
-- =====================================
CREATE TABLE Users (
    user_id INT PRIMARY KEY IDENTITY(1,1),
    full_name NVARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    role_id INT NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    status VARCHAR(20) DEFAULT 'Active',

    FOREIGN KEY (role_id) REFERENCES Roles(role_id)
);

-- =====================================
-- 3. STAFF
-- =====================================
CREATE TABLE Staff (
    staff_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT UNIQUE NOT NULL,
    hire_date DATE,
    salary DECIMAL(10,2),
    status VARCHAR(20),

    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- =====================================
-- 4. SHIFTS
-- =====================================
CREATE TABLE Shifts (
    shift_id INT PRIMARY KEY IDENTITY(1,1),
    staff_id INT NOT NULL,
    shift_date DATE,
    start_time TIME,
    end_time TIME,

    FOREIGN KEY (staff_id) REFERENCES Staff(staff_id)
);

-- =====================================
-- 5. CATEGORIES
-- =====================================
CREATE TABLE Categories (
    category_id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(255)
);

-- =====================================
-- 6. PUBLISHERS
-- =====================================
CREATE TABLE Publishers (
    publisher_id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(150) NOT NULL,
    address NVARCHAR(255),
    phone VARCHAR(20)
);

-- =====================================
-- 7. BOOKS
-- =====================================
CREATE TABLE Books (
    book_id INT PRIMARY KEY IDENTITY(1,1),
    title NVARCHAR(200) NOT NULL,
    author NVARCHAR(150),
    price DECIMAL(10,2) NOT NULL,
    stock INT DEFAULT 0,
    category_id INT,
    publisher_id INT,
    created_at DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (category_id) REFERENCES Categories(category_id),
    FOREIGN KEY (publisher_id) REFERENCES Publishers(publisher_id)
);

-- =====================================
-- 8. CART
-- =====================================
CREATE TABLE Cart (
    cart_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT UNIQUE NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- =====================================
-- 9. CART ITEMS
-- =====================================
CREATE TABLE CartItems (
    cart_item_id INT PRIMARY KEY IDENTITY(1,1),
    cart_id INT NOT NULL,
    book_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),

    FOREIGN KEY (cart_id) REFERENCES Cart(cart_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id)
);

-- =====================================
-- 10. WISHLIST
-- =====================================
CREATE TABLE Wishlist (
    wishlist_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL,
    book_id INT NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id)
);

-- =====================================
-- 11. ADDRESSES
-- =====================================
CREATE TABLE Addresses (
    address_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL,
    full_address NVARCHAR(255),
    city NVARCHAR(100),
    district NVARCHAR(100),
    is_default BIT DEFAULT 0,

    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- =====================================
-- 12. SHIPPING PROVIDERS
-- =====================================
CREATE TABLE ShippingProviders (
    shipping_provider_id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(100),
    phone VARCHAR(20),
    fee DECIMAL(10,2)
);

-- =====================================
-- 13. DISCOUNTS
-- =====================================
CREATE TABLE Discounts (
    discount_id INT PRIMARY KEY IDENTITY(1,1),
    code VARCHAR(50) UNIQUE,
    discount_percent INT CHECK (discount_percent BETWEEN 0 AND 100),
    start_date DATE,
    end_date DATE,
    status VARCHAR(20)
);

-- =====================================
-- 14. ORDERS
-- =====================================
CREATE TABLE Orders (
    order_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL,
    address_id INT NOT NULL,
    discount_id INT NULL,
    shipping_provider_id INT,
    total_amount DECIMAL(12,2),
    order_date DATETIME DEFAULT GETDATE(),
    status VARCHAR(30),

    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (address_id) REFERENCES Addresses(address_id),
    FOREIGN KEY (discount_id) REFERENCES Discounts(discount_id),
    FOREIGN KEY (shipping_provider_id) REFERENCES ShippingProviders(shipping_provider_id)
);

-- =====================================
-- 15. ORDER DETAILS
-- =====================================
CREATE TABLE OrderDetails (
    order_detail_id INT PRIMARY KEY IDENTITY(1,1),
    order_id INT NOT NULL,
    book_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    price DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id)
);

-- =====================================
-- 16. PAYMENTS
-- =====================================
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY IDENTITY(1,1),
    order_id INT UNIQUE NOT NULL,
    method VARCHAR(50),
    amount DECIMAL(12,2),
    payment_date DATETIME DEFAULT GETDATE(),
    status VARCHAR(30),

    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- =====================================
-- 17. REVIEWS
-- =====================================
CREATE TABLE Reviews (
    review_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL,
    book_id INT NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment NVARCHAR(500),
    review_date DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id)
);

-- =====================================
-- 18. NEWS
-- =====================================
CREATE TABLE News (
    news_id INT PRIMARY KEY IDENTITY(1,1),
    title NVARCHAR(200),
    content NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE(),
    staff_id INT,

    FOREIGN KEY (staff_id) REFERENCES Staff(staff_id)
);

-- =====================================
-- 19. NOTIFICATIONS
-- =====================================
CREATE TABLE Notifications (
    notification_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL,
    content NVARCHAR(255),
    created_at DATETIME DEFAULT GETDATE(),
    is_read BIT DEFAULT 0,

    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);


-- ======================= SeedData ============================

-- =====================================
-- 1. ROLES (4 records)
-- =====================================
INSERT INTO Roles (role_name) VALUES 
('Admin'), ('Manager'), ('Staff'), ('Customer');
GO

-- =====================================
-- 2. USERS (20 records)
-- =====================================
INSERT INTO Users (full_name, email, password_hash, phone, role_id) VALUES 
(N'Nguyễn Văn An', 'an.nguyen@email.com', 'hashed_pw_1', '0901234561', 1),
(N'Trần Thị Bình', 'binh.tran@email.com', 'hashed_pw_2', '0901234562', 2),
(N'Lê Hoàng Cường', 'cuong.le@email.com', 'hashed_pw_3', '0901234563', 3),
(N'Phạm Quỳnh Dung', 'dung.pham@email.com', 'hashed_pw_4', '0901234564', 3),
(N'Hoàng Văn Đạt', 'dat.hoang@email.com', 'hashed_pw_5', '0901234565', 3),
(N'Vũ Minh Tuấn', 'tuan.vu@email.com', 'hashed_pw_6', '0901234566', 4),
(N'Đặng Thu Thảo', 'thao.dang@email.com', 'hashed_pw_7', '0901234567', 4),
(N'Bùi Ngọc Lan', 'lan.bui@email.com', 'hashed_pw_8', '0901234568', 4),
(N'Đỗ Đức Phát', 'phat.do@email.com', 'hashed_pw_9', '0901234569', 4),
(N'Hồ Quang Hiếu', 'hieu.ho@email.com', 'hashed_pw_10', '0901234570', 4),
(N'Ngô Thanh Vân', 'van.ngo@email.com', 'hashed_pw_11', '0901234571', 4),
(N'Dương Tấn Tài', 'tai.duong@email.com', 'hashed_pw_12', '0901234572', 4),
(N'Lý Nhã Kỳ', 'ky.ly@email.com', 'hashed_pw_13', '0901234573', 4),
(N'Phan Mai Anh', 'anh.phan@email.com', 'hashed_pw_14', '0901234574', 4),
(N'Đinh Trọng Nhật', 'nhat.dinh@email.com', 'hashed_pw_15', '0901234575', 4),
(N'Trịnh Thăng Bình', 'binh.trinh@email.com', 'hashed_pw_16', '0901234576', 4),
(N'Lâm Minh Nhật', 'nhat.lam@email.com', 'hashed_pw_17', '0901234577', 4),
(N'Châu Kim Tinh', 'tinh.chau@email.com', 'hashed_pw_18', '0901234578', 4),
(N'Thái Văn Hùng', 'hung.thai@email.com', 'hashed_pw_19', '0901234579', 4),
(N'Vương Bích Ngọc', 'ngoc.vuong@email.com', 'hashed_pw_20', '0901234580', 4);
GO

-- =====================================
-- 3. STAFF (5 records)
-- =====================================
INSERT INTO Staff (user_id, hire_date, salary, status) VALUES 
(1, '2023-01-10', 25000000, 'Active'),
(2, '2023-05-15', 20000000, 'Active'),
(3, '2024-02-20', 12000000, 'Active'),
(4, '2024-03-01', 12000000, 'Active'),
(5, '2024-04-10', 12000000, 'Active');
GO

-- =====================================
-- 4. SHIFTS (20 records)
-- =====================================
INSERT INTO Shifts (staff_id, shift_date, start_time, end_time) VALUES 
(3, '2026-03-01', '08:00', '16:00'), (4, '2026-03-01', '14:00', '22:00'),
(5, '2026-03-02', '08:00', '16:00'), (3, '2026-03-02', '14:00', '22:00'),
(4, '2026-03-03', '08:00', '16:00'), (5, '2026-03-03', '14:00', '22:00'),
(3, '2026-03-04', '08:00', '16:00'), (4, '2026-03-04', '14:00', '22:00'),
(5, '2026-03-05', '08:00', '16:00'), (3, '2026-03-05', '14:00', '22:00'),
(4, '2026-03-06', '08:00', '16:00'), (5, '2026-03-06', '14:00', '22:00'),
(3, '2026-03-07', '08:00', '16:00'), (4, '2026-03-07', '14:00', '22:00'),
(5, '2026-03-08', '08:00', '16:00'), (3, '2026-03-08', '14:00', '22:00'),
(4, '2026-03-09', '08:00', '16:00'), (5, '2026-03-09', '14:00', '22:00'),
(3, '2026-03-10', '08:00', '16:00'), (4, '2026-03-10', '14:00', '22:00');
GO

-- =====================================
-- 5. CATEGORIES (8 records)
-- =====================================
INSERT INTO Categories (name, description) VALUES 
(N'Lập trình Cơ bản', N'Sách nền tảng lập trình'),
(N'Cơ sở Dữ liệu', N'SQL, NoSQL, Database Design'),
(N'Phân tích Hệ thống', N'UML, System Analysis & Design'),
(N'Kiểm thử Phần mềm', N'Software Testing, QA/QC'),
(N'Ngoại ngữ', N'Tiếng Nhật, Tiếng Anh'),
(N'Văn học', N'Tiểu thuyết, truyện ngắn'),
(N'Kinh tế', N'Kinh doanh, đầu tư'),
(N'Khoa học', N'Kiến thức khoa học công nghệ');
GO

-- =====================================
-- 6. PUBLISHERS (5 records)
-- =====================================
INSERT INTO Publishers (name, address, phone) VALUES 
(N'NXB Thông tin Truyền thông', N'Hà Nội', '024123456'),
(N'NXB Trẻ', N'TP. Hồ Chí Minh', '028123456'),
(N'NXB Khoa học Kỹ thuật', N'Hà Nội', '024987654'),
(N'O Reilly Media', N'USA', '+1800123456'),
(N'NXB Giáo dục', N'TP. Hồ Chí Minh', '028654321');
GO

-- =====================================
-- 7. BOOKS (20 records)
-- =====================================
INSERT INTO Books (title, author, price, stock, category_id, publisher_id) VALUES 
(N'Lập trình Java Căn Bản', N'Nguyễn Văn A', 150000, 50, 1, 1),
(N'Effective Java 3rd Edition', N'Joshua Bloch', 450000, 20, 1, 4),
(N'Thiết kế CSDL SQL Server', N'Trần Thị B', 180000, 40, 2, 3),
(N'Tối ưu hóa Truy vấn SQL', N'Lê Văn C', 200000, 30, 2, 3),
(N'System Analysis and Design', N'Alan Dennis', 550000, 15, 3, 4),
(N'UML Distilled', N'Martin Fowler', 300000, 25, 3, 4),
(N'Nhập môn Kiểm thử Phần mềm', N'Phạm Thu D', 120000, 60, 4, 1),
(N'Software Testing: Principles', N'Srinivasan Desikan', 400000, 10, 4, 4),
(N'Tự học Tiếng Nhật N5', N'Nhiều tác giả', 150000, 100, 5, 2),
(N'Ngữ pháp Tiếng Nhật N4', N'Nhiều tác giả', 160000, 80, 5, 2),
(N'Clean Code', N'Robert C. Martin', 480000, 20, 1, 4),
(N'Data Structures in Java', N'Robert Lafore', 420000, 15, 1, 4),
(N'Mastering SQL', N'Martin Gruber', 350000, 25, 2, 4),
(N'UML Cơ Bản', N'Nguyễn Văn E', 100000, 50, 3, 3),
(N'Đắc Nhân Tâm', N'Dale Carnegie', 80000, 150, 6, 2),
(N'Nhà Lãnh Đạo Không Chức Danh', N'Robin Sharma', 95000, 120, 7, 2),
(N'Lược Sử Loài Người', N'Yuval Noah Harari', 250000, 60, 8, 2),
(N'Thiết kế Hướng Đối Tượng', N'Lê Minh', 140000, 45, 1, 1),
(N'Giao tiếp Tiếng Nhật Thực tế', N'Sato', 210000, 35, 5, 5),
(N'Automated Software Testing', N'Elfriede Dustin', 520000, 12, 4, 4);
GO

-- =====================================
-- 8. CART (20 records)
-- =====================================
INSERT INTO Cart (user_id) VALUES 
(1),(2),(3),(4),(5),(6),(7),(8),(9),(10),
(11),(12),(13),(14),(15),(16),(17),(18),(19),(20);
GO

-- =====================================
-- 9. CART ITEMS (20 records)
-- =====================================
INSERT INTO CartItems (cart_id, book_id, quantity) VALUES 
(1, 1, 2), (2, 3, 1), (3, 5, 1), (4, 9, 3), (5, 11, 1),
(6, 2, 1), (7, 4, 2), (8, 6, 1), (9, 10, 1), (10, 15, 2),
(11, 12, 1), (12, 14, 1), (13, 8, 2), (14, 18, 1), (15, 20, 1),
(16, 7, 1), (17, 13, 1), (18, 19, 2), (19, 17, 1), (20, 16, 1);
GO

-- =====================================
-- 10. WISHLIST (20 records)
-- =====================================
INSERT INTO Wishlist (user_id, book_id) VALUES 
(1, 11), (2, 12), (3, 13), (4, 14), (5, 15),
(6, 1), (7, 2), (8, 3), (9, 4), (10, 5),
(11, 6), (12, 7), (13, 8), (14, 9), (15, 10),
(16, 16), (17, 17), (18, 18), (19, 19), (20, 20);
GO

-- =====================================
-- 11. ADDRESSES (20 records)
-- =====================================
INSERT INTO Addresses (user_id, full_address, city, district, is_default) VALUES 
(1, N'Đường D1, Khu Công Nghệ Cao', N'TP. Hồ Chí Minh', N'TP. Thủ Đức', 1),
(2, N'123 Lê Lợi', N'TP. Hồ Chí Minh', N'Quận 1', 1),
(3, N'45 Nguyễn Huệ', N'TP. Hồ Chí Minh', N'Quận 1', 1),
(4, N'789 Nguyễn Văn Linh', N'TP. Hồ Chí Minh', N'Quận 7', 1),
(5, N'321 Võ Văn Ngân', N'TP. Hồ Chí Minh', N'TP. Thủ Đức', 1),
(6, N'11A Nam Kỳ Khởi Nghĩa', N'TP. Hồ Chí Minh', N'Quận 3', 1),
(7, N'55 Hai Bà Trưng', N'TP. Hồ Chí Minh', N'Quận 1', 1),
(8, N'90 Pasteur', N'TP. Hồ Chí Minh', N'Quận 3', 1),
(9, N'12 Lê Duẩn', N'TP. Hồ Chí Minh', N'Quận 1', 1),
(10, N'88 Phạm Văn Đồng', N'TP. Hồ Chí Minh', N'TP. Thủ Đức', 1),
(11, N'101 Nguyễn Thị Minh Khai', N'TP. Hồ Chí Minh', N'Quận 3', 1),
(12, N'202 Trần Hưng Đạo', N'TP. Hồ Chí Minh', N'Quận 5', 1),
(13, N'303 Nguyễn Trãi', N'TP. Hồ Chí Minh', N'Quận 5', 1),
(14, N'404 Hùng Vương', N'TP. Hồ Chí Minh', N'Quận 10', 1),
(15, N'505 Ba Tháng Hai', N'TP. Hồ Chí Minh', N'Quận 10', 1),
(16, N'606 Sư Vạn Hạnh', N'TP. Hồ Chí Minh', N'Quận 10', 1),
(17, N'707 Lê Văn Sỹ', N'TP. Hồ Chí Minh', N'Quận 3', 1),
(18, N'808 Hoàng Văn Thụ', N'TP. Hồ Chí Minh', N'Quận Tân Bình', 1),
(19, N'909 Cộng Hòa', N'TP. Hồ Chí Minh', N'Quận Tân Bình', 1),
(20, N'111 Trường Chinh', N'TP. Hồ Chí Minh', N'Quận Tân Bình', 1);
GO

-- =====================================
-- 12. SHIPPING PROVIDERS (3 records)
-- =====================================
INSERT INTO ShippingProviders (name, phone, fee) VALUES 
(N'Giao Hàng Nhanh', '19001234', 30000),
(N'Giao Hàng Tiết Kiệm', '19005678', 25000),
(N'Viettel Post', '19008080', 35000);
GO

-- =====================================
-- 13. DISCOUNTS (5 records)
-- =====================================
INSERT INTO Discounts (code, discount_percent, start_date, end_date, status) VALUES 
('WELCOME2026', 10, '2026-01-01', '2026-12-31', 'Active'),
('SUMMER20', 20, '2026-06-01', '2026-08-31', 'Active'),
('FLASH50', 50, '2026-11-11', '2026-11-12', 'Active'),
('STUDENT15', 15, '2026-09-01', '2026-10-31', 'Active'),
('EXPIRED10', 10, '2025-01-01', '2025-12-31', 'Expired');
GO

-- =====================================
-- 14. ORDERS (20 records)
-- =====================================
INSERT INTO Orders (user_id, address_id, discount_id, shipping_provider_id, total_amount, status) VALUES 
(6, 6, 1, 1, 330000, 'Delivered'), (7, 7, NULL, 2, 475000, 'Processing'),
(8, 8, NULL, 3, 215000, 'Shipped'), (9, 9, 2, 1, 190000, 'Delivered'),
(10, 10, NULL, 2, 575000, 'Pending'), (11, 11, 1, 3, 305000, 'Delivered'),
(12, 12, NULL, 1, 150000, 'Cancelled'), (13, 13, NULL, 2, 425000, 'Processing'),
(14, 14, 4, 3, 150000, 'Shipped'), (15, 15, NULL, 1, 185000, 'Delivered'),
(16, 16, NULL, 2, 505000, 'Pending'), (17, 17, 1, 3, 445000, 'Delivered'),
(18, 18, NULL, 1, 380000, 'Processing'), (19, 19, NULL, 2, 125000, 'Shipped'),
(20, 20, 2, 3, 115000, 'Delivered'), (6, 6, NULL, 1, 280000, 'Pending'),
(7, 7, 1, 2, 225000, 'Delivered'), (8, 8, NULL, 3, 175000, 'Processing'),
(9, 9, NULL, 1, 240000, 'Shipped'), (10, 10, 4, 2, 535000, 'Delivered');
GO

-- =====================================
-- 15. ORDER DETAILS (20 records)
-- =====================================
INSERT INTO OrderDetails (order_id, book_id, quantity, price) VALUES 
(1, 1, 1, 150000), (1, 3, 1, 180000), (2, 2, 1, 450000), (3, 4, 1, 200000),
(4, 5, 1, 550000), (5, 6, 1, 300000), (5, 9, 1, 150000), (6, 7, 1, 120000),
(7, 8, 1, 400000), (8, 10, 1, 160000), (9, 11, 1, 480000), (10, 12, 1, 420000),
(11, 13, 1, 350000), (12, 14, 2, 100000), (13, 15, 1, 80000), (14, 16, 1, 95000),
(15, 17, 1, 250000), (16, 18, 1, 140000), (17, 19, 1, 210000), (18, 20, 1, 520000);
GO

-- =====================================
-- 16. PAYMENTS (20 records)
-- =====================================
INSERT INTO Payments (order_id, method, amount, status) VALUES 
(1, 'Credit Card', 330000, 'Completed'), (2, 'COD', 475000, 'Pending'),
(3, 'Momo', 215000, 'Completed'), (4, 'VNPay', 190000, 'Completed'),
(5, 'Bank Transfer', 575000, 'Pending'), (6, 'COD', 305000, 'Completed'),
(7, 'Momo', 150000, 'Refunded'), (8, 'Credit Card', 425000, 'Completed'),
(9, 'VNPay', 150000, 'Completed'), (10, 'Bank Transfer', 185000, 'Completed'),
(11, 'COD', 505000, 'Pending'), (12, 'Momo', 445000, 'Completed'),
(13, 'Credit Card', 380000, 'Completed'), (14, 'VNPay', 125000, 'Completed'),
(15, 'COD', 115000, 'Completed'), (16, 'Bank Transfer', 280000, 'Pending'),
(17, 'Momo', 225000, 'Completed'), (18, 'Credit Card', 175000, 'Completed'),
(19, 'VNPay', 240000, 'Completed'), (20, 'COD', 535000, 'Completed');
GO

-- =====================================
-- 17. REVIEWS (20 records)
-- =====================================
INSERT INTO Reviews (user_id, book_id, rating, comment) VALUES 
(6, 1, 5, N'Sách rất hay, dễ hiểu cho người mới.'), (7, 2, 4, N'Nội dung sâu sắc nhưng hơi khó.'),
(8, 3, 5, N'Cơ bản và thực tế.'), (9, 4, 4, N'Tối ưu SQL khá tốt.'),
(10, 5, 5, N'Kiến thức hệ thống tuyệt vời.'), (11, 6, 4, N'Sách về UML tốt nhất.'),
(12, 7, 3, N'Hơi nhiều lý thuyết.'), (13, 8, 5, N'Rất đầy đủ về testing.'),
(14, 9, 5, N'Tiếng Nhật vỡ lòng cực kỳ hữu ích.'), (15, 10, 4, N'Giải thích ngữ pháp kỹ.'),
(16, 11, 5, N'Sách gối đầu giường của Coder.'), (17, 12, 4, N'Nền tảng tốt.'),
(18, 13, 5, N'Rất đáng tiền.'), (19, 14, 4, N'Dễ tiếp cận.'),
(20, 15, 5, N'Sách kinh điển.'), (6, 16, 4, N'Đọc để có động lực.'),
(7, 17, 5, N'Góc nhìn lịch sử tuyệt vời.'), (8, 18, 4, N'Khá ổn.'),
(9, 19, 5, N'Ứng dụng tốt vào thực tế.'), (10, 20, 4, N'Chi tiết về Auto test.');
GO

-- =====================================
-- 18. NEWS (20 records)
-- =====================================
INSERT INTO News (title, content, staff_id) VALUES 
(N'Khuyến mãi tháng 3', N'Giảm giá 20% cho tất cả sách IT', 3), (N'Sách mới về', N'Effective Java đã có hàng', 3),
(N'Giảm giá mừng lễ', N'Giảm 50% trong khung giờ vàng', 4), (N'Workshop Lập trình', N'Tổ chức workshop vào cuối tuần', 4),
(N'Tác giả nổi bật', N'Giao lưu cùng tác giả...', 5), (N'Top sách bán chạy', N'Danh sách sách bán chạy nhất tháng qua', 5),
(N'Tuyển dụng Staff', N'Nhà sách đang cần tuyển thêm...', 3), (N'Mở cửa trở lại', N'Sau thời gian bảo trì...', 4),
(N'Cuộc thi Review', N'Tham gia review nhận quà', 5), (N'Cập nhật chính sách', N'Chính sách đổi trả mới', 3),
(N'Hợp tác NXB', N'Ký kết hợp tác cùng NXB...', 4), (N'Chương trình khách hàng', N'Tích điểm đổi quà', 5),
(N'Thay đổi giờ mở cửa', N'Sẽ mở cửa từ 8h sáng', 3), (N'Sách giáo khoa', N'Chuẩn bị cho năm học mới', 4),
(N'Sách ngoại văn', N'Nhập nhiều tựa sách tiếng Nhật', 5), (N'Dịch vụ gói quà', N'Miễn phí gói quà sinh nhật', 3),
(N'Sự kiện Offline', N'Offline những người yêu sách', 4), (N'Mã giảm giá App', N'Tải App nhận ngay 50k', 5),
(N'Giới thiệu sách', N'Review sách mới ra mắt', 3), (N'Bảo trì hệ thống', N'Web sẽ bảo trì vào 12h đêm nay', 4);
GO

-- =====================================
-- 19. NOTIFICATIONS (20 records)
-- =====================================
INSERT INTO Notifications (user_id, content, is_read) VALUES 
(6, N'Đơn hàng của bạn đã được giao thành công.', 1), (7, N'Đơn hàng của bạn đang được xử lý.', 0),
(8, N'Đơn hàng của bạn đã được gửi cho đơn vị vận chuyển.', 1), (9, N'Sách bạn lưu đã có hàng trở lại.', 0),
(10, N'Mã giảm giá của bạn sắp hết hạn.', 1), (11, N'Cảm ơn bạn đã đánh giá sản phẩm.', 0),
(12, N'Đơn hàng của bạn đã bị hủy.', 1), (13, N'Thanh toán thành công.', 1),
(14, N'Sản phẩm trong giỏ hàng sắp hết.', 0), (15, N'Chào mừng bạn đến với nhà sách!', 1),
(16, N'Đơn hàng của bạn đang được đóng gói.', 0), (17, N'Bạn nhận được 1 mã giảm giá mới.', 1),
(18, N'Tài khoản của bạn đã được xác thực.', 1), (19, N'Vui lòng cập nhật địa chỉ giao hàng.', 0),
(20, N'Bạn có 1 tin nhắn từ hỗ trợ viên.', 1), (6, N'Sách bạn yêu thích đang giảm giá.', 0),
(7, N'Đơn vị vận chuyển đang lấy hàng.', 1), (8, N'Giao hàng thất bại, vui lòng liên hệ shop.', 0),
(9, N'Bảo trì hệ thống lúc 12h.', 1), (10, N'Chúc mừng sinh nhật bạn!', 0);
GO

--drop table Teachers

--drop table students

--drop table Enrollments

--drop table courses