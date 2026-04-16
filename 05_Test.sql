-- FILE 5: THÊM

USE QuanLyNhaHang;
GO

-- 1. THÊM NHÂN VIÊN, MÓN ĂN VÀ KHÁCH HÀNG MỚI

-- THÊM NHÂN VIÊN MỚI: EXEC sp_ThemNhanVien @TenNV, @ChucVu, @SDT
EXEC sp_ThemNhanVien N'Trần Minh Tâm', N'Phục Vụ', '0912333444'; 

-- THÊM MÓN ĂN MỚI: EXEC sp_ThemMonAn @TenMon, @Gia, @Loai
EXEC sp_ThemMonAn N'Lẩu Nấm Hải Sản', 450000, N'Lẩu';

-- THÊM KHÁCH HÀNG MỚI: EXEC sp_ThemKhachHang @TenKH, @SDT
EXEC sp_ThemKhachHang N'Phạm Gia Bình', '0966123457';


-- 2. QUY TRÌNH PHỤC VỤ (ĐƠN HÀNG SỐ 5)
-- MỞ BÀN: EXEC sp_MoBanMoi @MaBan, @MaNV, @MaKH
EXEC sp_MoBanMoi 6, 12, 5;

-- GỌI MÓN: EXEC sp_GoiMon @MaDon, @MaMon, @SoLuong
EXEC sp_GoiMon 5, 13, 1; 
EXEC sp_GoiMon 5, 6, 2;

-- THANH TOÁN: EXEC sp_ThanhToan @MaDon, @PhuongThuc
EXEC sp_ThanhToan 5, N'Tiền mặt';


-- 3. KIỂM TRA DỮ LIỆU SAU KHI CHẠY
-- Xem lại hóa đơn vừa thanh toán 
SELECT * FROM Bills WHERE order_id = 5;

-- Kiểm tra xem Bàn số 6 đã tự động trả về 'Available' chưa
SELECT * FROM Tables WHERE table_id = 6;

-- Xem danh sách đơn hàng 
SELECT * FROM Orders;

-- Xem danh sách nhân viên và món ăn để xác nhận đã thêm thành công
SELECT * FROM Staff;
SELECT * FROM MenuItems;

-----------------------------------------------------------
-- 4. DEMO CHỨC NĂNG XÓA/HỦY
-----------------------------------------------------------

-- EXEC sp_HuyMon @MaDon, @MaMon
EXEC sp_HuyMon 5, 6; 


-- Kiểm tra lại 
SELECT * FROM OrderDetails WHERE order_id = 5;
SELECT * FROM Bills WHERE order_id = 5;