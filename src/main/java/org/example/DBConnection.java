package org.example;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    // Sửa lại các thông số này cho đúng với máy của bạn
    private static String url = "jdbc:sqlserver://localhost\\SQLEXPRESS01:1433;databaseName=QuanLyNhaHang;encrypt=true;trustServerCertificate=true;";
    private static String user = "sa";
    private static String pass = "123";

    // Đây chính là cái "cổng" mà LoaiMonForm đang tìm
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(url, user, pass);
    }

    // Giữ lại hàm main để bạn có thể test kết nối riêng file này
    public static void main(String[] args) {
        try (Connection conn = getConnection()) {
            if (conn != null) {
                System.out.println("Chúc mừng! Kết nối thành công.");
            }
        } catch (SQLException e) {
            System.out.println("Lỗi kết nối: " + e.getMessage());
        }
    }
}