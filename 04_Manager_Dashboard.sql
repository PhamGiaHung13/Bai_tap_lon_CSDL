-- FILE 4: HỆ THỐNG BÁO CÁO (MANAGER DASHBOARD)

USE QuanLyNhaHang;
GO

-- Tạo View để hỗ trợ truy vấn nhanh 
IF EXISTS (SELECT * FROM sys.views WHERE name = 'v_TatCaDonHang') DROP VIEW v_TatCaDonHang;
GO
CREATE VIEW v_TatCaDonHang AS
SELECT 
    O.order_id AS [Mã Đơn], T.table_name AS [Tên Bàn], S.name AS [Nhân Viên Phục Vụ],
    ISNULL(C.name, N'Khách lẻ') AS [Khách Hàng], O.order_date AS [Thời Gian],
    CASE WHEN O.is_paid = 1 THEN N'Đã thanh toán' ELSE N'Đang phục vụ' END AS [Trạng Thái]
FROM Orders O
JOIN Tables T ON O.table_id = T.table_id
JOIN Staff S ON O.staff_id = S.staff_id
LEFT JOIN Customers C ON O.customer_id = C.customer_id;
GO

-- 1. Xem tất cả đơn hàng + Bàn + Nhân viên
PRINT N'--- DANH SÁCH TỔNG QUAN ĐƠN HÀNG ---';
SELECT * FROM v_TatCaDonHang;

-- 2. Xem chi tiết từng đơn
PRINT N'--- CHI TIẾT ĐƠN HÀNG ---';
SELECT 
    OD.order_id AS [Mã Đơn], M.name AS [Tên Món], OD.quantity AS [Số Lượng], 
    FORMAT(OD.price, 'N0') + ' đ' AS [Đơn Giá], 
    FORMAT(OD.quantity * OD.price, 'N0') + ' đ' AS [Thành Tiền],
    ISNULL(B.payment_method, N'Chưa trả tiền') AS [Phương Thức Thanh Toán]
FROM OrderDetails OD
JOIN MenuItems M ON OD.menu_id = M.menu_id
LEFT JOIN Bills B ON OD.order_id = B.order_id; -- Dùng LEFT JOIN để hiện cả đơn chưa thanh toán

-- 3. Doanh thu theo ngày
SELECT 
    CAST(payment_date AS DATE) AS [Ngày], 
    COUNT(bill_id) AS [Số Hóa Đơn], 
    FORMAT(SUM(total_amount), 'N0') + ' đ' AS [Tổng Doanh Thu]
FROM Bills
GROUP BY CAST(payment_date AS DATE);

-- 4. Món bán chạy nhất
SELECT TOP 1 WITH TIES
    M.name AS [Món Bán Chạy], 
    SUM(OD.quantity) AS [Tổng Số Lượng Bán]
FROM OrderDetails OD
JOIN MenuItems M ON OD.menu_id = M.menu_id
GROUP BY M.name
ORDER BY [Tổng Số Lượng Bán] DESC;

-- 5. Tổng tiền từng đơn
SELECT 
    order_id AS [Mã Đơn], 
    FORMAT(SUM(quantity * price), 'N0') + ' đ' AS [Tổng Tiền Đơn Hàng]
FROM OrderDetails
GROUP BY order_id;

-- 6. Trạng thái các bàn
SELECT 
    table_name AS [Tên Bàn], 
    CASE 
        WHEN status = 'Occupied' THEN N'Đang có khách'
        WHEN status = 'Available' THEN N'Bàn trống'
        ELSE status 
    END AS [Trạng Thái Hiện Tại]
FROM Tables;

-- 7. Nhân viên phục vụ nhiều đơn nhất
SELECT TOP 1 WITH TIES
    S.name AS [Nhân Viên Xuất Sắc], 
    COUNT(O.order_id) AS [Số Đơn Đã Phục Vụ]
FROM Orders O
JOIN Staff S ON O.staff_id = S.staff_id
GROUP BY S.name
ORDER BY [Số Đơn Đã Phục Vụ] DESC;
GO

-- 8. Danh sách thực đơn (Menu) theo loại
PRINT N'--- 8. DANH SÁCH THỰC ĐƠN ---';
SELECT 
    category AS [Loại], 
    name AS [Tên Món], 
    FORMAT(price, 'N0') + ' đ' AS [Giá Niêm Yết]
FROM MenuItems
ORDER BY category;

-- 9. Danh sách nhân viên đang làm việc
PRINT N'--- 9. DANH SÁCH NHÂN VIÊN ---';
SELECT 
    staff_id AS [Mã NV], 
    name AS [Họ Tên], 
    role AS [Chức Vụ], 
    phone AS [Số Điện Thoại]
FROM Staff;
GO