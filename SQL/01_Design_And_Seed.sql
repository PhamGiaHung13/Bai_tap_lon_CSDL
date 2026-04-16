-- FILE 1: THIẾT KẾ CẤU TRÚC VÀ KHỞI TẠO DỮ LIỆU

USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = N'QuanLyNhaHang')
BEGIN
    ALTER DATABASE QuanLyNhaHang SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE QuanLyNhaHang;
END
GO

CREATE DATABASE QuanLyNhaHang;
GO
USE QuanLyNhaHang;
GO

-- 1. TẠO BẢNG
CREATE TABLE Tables (
    table_id INT IDENTITY(1,1) PRIMARY KEY,
    table_name NVARCHAR(50) NOT NULL,
    status NVARCHAR(20) DEFAULT 'Available' CHECK (status IN ('Available', 'Occupied', 'Reserved')));

CREATE TABLE Staff (
    staff_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    role NVARCHAR(50),
    phone VARCHAR(15));

CREATE TABLE Customers (
    customer_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    phone VARCHAR(20) UNIQUE,
    email VARCHAR(100));

CREATE TABLE MenuItems (
    menu_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    price DECIMAL(18, 2) NOT NULL CHECK (price >= 0),
    category NVARCHAR(50));

CREATE TABLE Orders (
    order_id INT IDENTITY(1,1) PRIMARY KEY,
    table_id INT FOREIGN KEY REFERENCES Tables(table_id),
    staff_id INT FOREIGN KEY REFERENCES Staff(staff_id),
    customer_id INT FOREIGN KEY REFERENCES Customers(customer_id),
    order_date DATETIME DEFAULT GETDATE(),
    is_paid BIT DEFAULT 0);

CREATE TABLE OrderDetails (
    id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT FOREIGN KEY REFERENCES Orders(order_id),
    menu_id INT FOREIGN KEY REFERENCES MenuItems(menu_id),
    quantity INT NOT NULL CHECK (quantity > 0),
    price DECIMAL(18, 2) NOT NULL);

CREATE TABLE Bills (
    bill_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT UNIQUE FOREIGN KEY REFERENCES Orders(order_id),
    total_amount DECIMAL(18, 2) DEFAULT 0,
    payment_method NVARCHAR(50),
    payment_date DATETIME DEFAULT GETDATE());

CREATE TABLE StaffShifts (
    shift_id INT IDENTITY(1,1) PRIMARY KEY,
    staff_id INT NOT NULL FOREIGN KEY REFERENCES Staff(staff_id),
    start_time DATETIME,
    end_time DATETIME);
GO

-- 2. NẠP DỮ LIỆU MẪU 

-- Bàn ăn
SET IDENTITY_INSERT [dbo].[Tables] ON 
INSERT [dbo].[Tables] ([table_id], [table_name], [status]) VALUES (1, N'Bàn số 1', N'Available')
INSERT [dbo].[Tables] ([table_id], [table_name], [status]) VALUES (2, N'Bàn số 2', N'Available')
INSERT [dbo].[Tables] ([table_id], [table_name], [status]) VALUES (3, N'Bàn VIP 01', N'Available')
INSERT [dbo].[Tables] ([table_id], [table_name], [status]) VALUES (4, N'Bàn VIP 02', N'Available')
INSERT [dbo].[Tables] ([table_id], [table_name], [status]) VALUES (5, N'Bàn sân vườn 01', N'Available')
INSERT [dbo].[Tables] ([table_id], [table_name], [status]) VALUES (6, N'Bàn sân vườn 02', N'Available')
SET IDENTITY_INSERT [dbo].[Tables] OFF
GO

-- Nhân viên
SET IDENTITY_INSERT [dbo].[Staff] ON 
INSERT [dbo].[Staff] ([staff_id], [name], [role]) VALUES (1, N'Trần Thị Bình', N'Phục vụ')
INSERT [dbo].[Staff] ([staff_id], [name], [role]) VALUES (2, N'Lê Văn Cường', N'Thu ngân')
INSERT [dbo].[Staff] ([staff_id], [name], [role]) VALUES (3, N'Nguyễn Thị Hoa', N'Phục vụ')
INSERT [dbo].[Staff] ([staff_id], [name], [role]) VALUES (4, N'Đặng Hùng Dũng', N'Bếp phó')
INSERT [dbo].[Staff] ([staff_id], [name], [role]) VALUES (5, N'Vũ Hải Yến', N'Quản lý')
INSERT [dbo].[Staff] ([staff_id], [name], [role]) VALUES (6, N'Trương Công Thành', N'Bếp phó')
INSERT [dbo].[Staff] ([staff_id], [name], [role]) VALUES (7, N'Nguyễn Bảo Ngọc', N'Phục vụ')
INSERT [dbo].[Staff] ([staff_id], [name], [role]) VALUES (8, N'Lý Hải Đăng', N'Bảo vệ')
INSERT [dbo].[Staff] ([staff_id], [name], [role]) VALUES (9, N'Nguyễn Đình Khải', N'Quản lý')
INSERT [dbo].[Staff] ([staff_id], [name], [role]) VALUES (10, N'Nguyễn Thị Linh', N'Bartender')
INSERT [dbo].[Staff] ([staff_id], [name], [role]) VALUES (11, N'Phạm Gia Hưng', N'Bếp trưởng')
SET IDENTITY_INSERT [dbo].[Staff] OFF
GO

-- Khách hàng
SET IDENTITY_INSERT [dbo].[Customers] ON 
INSERT [dbo].[Customers] ([customer_id], [name], [phone], [email]) VALUES (1, N'Nguyễn Văn An', N'0901234567', N'an@gmail.com')
INSERT [dbo].[Customers] ([customer_id], [name], [phone], [email]) VALUES (2, N'Lê Minh Tâm', N'0912345678', N'tam.le@hotail.com')
INSERT [dbo].[Customers] ([customer_id], [name], [phone], [email]) VALUES (3, N'Phạm Mỹ Linh', N'0988776655', N'linh.pham@gmail.com')
INSERT [dbo].[Customers] ([customer_id], [name], [phone], [email]) VALUES (4, N'Hoàng Gia Bảo', N'0971122334', N'bao.hoang@yahoo.com')
SET IDENTITY_INSERT [dbo].[Customers] OFF
GO

-- Thực đơn
SET IDENTITY_INSERT [dbo].[MenuItems] ON 
INSERT [dbo].[MenuItems] ([menu_id], [name], [price], [category]) VALUES (1, N'Phở Bò', CAST(55000.00 AS Decimal(18, 2)), N'Món chính')
INSERT [dbo].[MenuItems] ([menu_id], [name], [price], [category]) VALUES (2, N'Cà phê', CAST(25000.00 AS Decimal(18, 2)), N'Đồ uống')
INSERT [dbo].[MenuItems] ([menu_id], [name], [price], [category]) VALUES (3, N'Bún Chả Hà Nội', CAST(65000.00 AS Decimal(18, 2)), N'Món Chính')
INSERT [dbo].[MenuItems] ([menu_id], [name], [price], [category]) VALUES (4, N'Gỏi Cuốn', CAST(30000.00 AS Decimal(18, 2)), N'Khai vị')
INSERT [dbo].[MenuItems] ([menu_id], [name], [price], [category]) VALUES (5, N'Chả Giò', CAST(45000.00 AS Decimal(18, 2)), N'Khai vị')
INSERT [dbo].[MenuItems] ([menu_id], [name], [price], [category]) VALUES (6, N'Trà Đào Cam Sả', CAST(35000.00 AS Decimal(18, 2)), N'Đồ uống')
INSERT [dbo].[MenuItems] ([menu_id], [name], [price], [category]) VALUES (7, N'Bánh Flan', CAST(20000.00 AS Decimal(18, 2)), N'Tráng miệng')
INSERT [dbo].[MenuItems] ([menu_id], [name], [price], [category]) VALUES (8, N'Khoai Tây Chiên', CAST(35000.00 AS Decimal(18, 2)), N'Ăn vặt')
INSERT [dbo].[MenuItems] ([menu_id], [name], [price], [category]) VALUES (9, N'Ngô Chiên Bơ', CAST(30000.00 AS Decimal(18, 2)), N'Ăn vặt')
INSERT [dbo].[MenuItems] ([menu_id], [name], [price], [category]) VALUES (10, N'Mực Khô Nướng', CAST(120000.00 AS Decimal(18, 2)), N'Đồ nhắm')
INSERT [dbo].[MenuItems] ([menu_id], [name], [price], [category]) VALUES (11, N'Lẩu Thái Hải Sản', CAST(350000.00 AS Decimal(18, 2)), N'Lẩu')
INSERT [dbo].[MenuItems] ([menu_id], [name], [price], [category]) VALUES (12, N'Kem Trái Dừa', CAST(45000.00 AS Decimal(18, 2)), N'Tráng miệng')
SET IDENTITY_INSERT [dbo].[MenuItems] OFF
GO

-- Đơn hàng mẫu 
SET IDENTITY_INSERT [dbo].[Orders] ON 
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (1, 1, 1, 1, CAST(N'2026-04-02T10:38:14.077' AS DateTime), 1)
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (2, 3, 3, 2, CAST(N'2026-04-02T10:43:40.760' AS DateTime), 1)
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (3, 4, 4, 3, CAST(N'2026-04-02T11:30:00.000' AS DateTime), 1)
INSERT [dbo].[Orders] ([order_id], [table_id], [staff_id], [customer_id], [order_date], [is_paid]) VALUES (4, 2, 1, 4, CAST(N'2026-04-02T12:15:00.000' AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[Orders] OFF
GO

-- Chi tiết đơn hàng mẫu
SET IDENTITY_INSERT [dbo].[OrderDetails] ON 
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (1, 1, 1, 2, CAST(55000.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (2, 2, 3, 1, CAST(65000.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (3, 2, 6, 2, CAST(35000.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (4, 3, 11, 1, CAST(350000.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (5, 3, 1, 4, CAST(55000.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (6, 3, 4, 5, CAST(25000.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (7, 4, 5, 1, CAST(65000.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([id], [order_id], [menu_id], [quantity], [price]) VALUES (8, 4, 8, 1, CAST(35000.00 AS Decimal(18, 2)))
SET IDENTITY_INSERT [dbo].[OrderDetails] OFF
GO

-- Hóa đơn mẫu
SET IDENTITY_INSERT [dbo].[Bills] ON 
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (1, 1, CAST(110000.00 AS Decimal(18, 2)), N'Tiền mặt', CAST(N'2026-04-02T10:38:14.077' AS DateTime))
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (2, 2, CAST(135000.00 AS Decimal(18, 2)), N'Chuyển khoản', CAST(N'2026-04-02T10:43:40.760' AS DateTime))
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (3, 3, CAST(695000.00 AS Decimal(18, 2)), N'Thẻ VISA', CAST(N'2026-04-02T13:00:00.000' AS DateTime))
INSERT [dbo].[Bills] ([bill_id], [order_id], [total_amount], [payment_method], [payment_date]) VALUES (4, 4, CAST(100000.00 AS Decimal(18, 2)), N'Tiền mặt', CAST(N'2026-04-02T10:50:02.607' AS DateTime))
SET IDENTITY_INSERT [dbo].[Bills] OFF
GO

-- Ca làm việc
SET IDENTITY_INSERT [dbo].[StaffShifts] ON 
INSERT [dbo].[StaffShifts] ([shift_id], [staff_id], [start_time], [end_time]) VALUES (1, 1, CAST(N'2026-04-02T07:00:00.000' AS DateTime), CAST(N'2026-04-02T14:00:00.000' AS DateTime))
INSERT [dbo].[StaffShifts] ([shift_id], [staff_id], [start_time], [end_time]) VALUES (2, 2, CAST(N'2026-04-02T14:00:00.000' AS DateTime), CAST(N'2026-04-02T22:00:00.000' AS DateTime))
INSERT [dbo].[StaffShifts] ([shift_id], [staff_id], [start_time], [end_time]) VALUES (3, 3, CAST(N'2026-04-02T07:00:00.000' AS DateTime), CAST(N'2026-04-02T14:00:00.000' AS DateTime))
SET IDENTITY_INSERT [dbo].[StaffShifts] OFF
GO

PRINT N'>>> Đã khởi tạo cấu trúc và nạp dữ liệu mẫu thành công! <<<';
GO