package org.example;

import javax.swing.*;
import javax.swing.border.EmptyBorder;
import java.awt.*;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;

public class MainMenu extends JFrame {

    // Khai báo bảng màu chuyên nghiệp (Flat UI Palette)
    private final Color CL_PRIMARY   = new Color(41, 128, 185); // Xanh dương (Thực đơn)
    private final Color CL_SUCCESS   = new Color(39, 174, 96);  // Xanh lá (Nhân viên)
    private final Color CL_PURPLE    = new Color(142, 68, 173); // Tím (Khách hàng)
    private final Color CL_WARNING   = new Color(211, 84, 0);   // Cam đậm (Nghiệp vụ)
    private final Color CL_DANGER    = new Color(192, 57, 43);  // Đỏ (Thoát)
    private final Color CL_INFO      = new Color(44, 62, 80);   // Xám đen (Báo cáo)
    private final Color CL_BG        = new Color(236, 240, 241); // Nền xám nhạt

    public MainMenu() {
        // Thiết lập cơ bản cho Frame
        setTitle("HỆ THỐNG QUẢN LÝ NHÀ HÀNG - DASHBOARD");
        setSize(1000, 600);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLocationRelativeTo(null);

        // Panel chính
        JPanel mainPanel = new JPanel(new BorderLayout());
        mainPanel.setBackground(CL_BG);
        mainPanel.setBorder(new EmptyBorder(20, 20, 20, 20));
        setContentPane(mainPanel);

        // --- Header ---
        JPanel headerPanel = new JPanel(new GridLayout(2, 1));
        headerPanel.setOpaque(false);

        JLabel lblTitle = new JLabel("RESTAURANT MANAGEMENT SYSTEM", JLabel.CENTER);
        lblTitle.setFont(new Font("Segoe UI", Font.BOLD, 28));
        lblTitle.setForeground(new Color(44, 62, 80));

        JLabel lblSubTitle = new JLabel("Vui lòng chọn chức năng để tiếp tục", JLabel.CENTER);
        lblSubTitle.setFont(new Font("Segoe UI", Font.ITALIC, 16));
        lblSubTitle.setForeground(new Color(127, 140, 141));

        headerPanel.add(lblTitle);
        headerPanel.add(lblSubTitle);
        headerPanel.setBorder(new EmptyBorder(0, 0, 30, 0));
        mainPanel.add(headerPanel, BorderLayout.NORTH);

        // --- Body: Button Grid ---
        JPanel buttonPanel = new JPanel(new GridLayout(2, 3, 25, 25));
        buttonPanel.setOpaque(false);

        // Tạo các nút chức năng
        JButton btnThucDon = createMenuButton("QUẢN LÝ THỰC ĐƠN", CL_PRIMARY);
        JButton btnNhanVien = createMenuButton("QUẢN LÝ NHÂN VIÊN", CL_SUCCESS);
        JButton btnKhachHang = createMenuButton("QUẢN LÝ KHÁCH HÀNG", CL_PURPLE);
        JButton btnNghiepVu = createMenuButton("NGHIỆP VỤ NHÀ HÀNG", CL_WARNING);
        JButton btnBaoCao   = createMenuButton("BÁO CÁO THỐNG KÊ", CL_INFO);
        JButton btnThoat    = createMenuButton("THOÁT HỆ THỐNG", CL_DANGER);

        // Sự kiện click chuột
        btnThucDon.addActionListener(e -> new ThucDonForm().setVisible(true));
        btnNhanVien.addActionListener(e -> new NhanVienForm().setVisible(true));
        btnKhachHang.addActionListener(e -> new KhachHangForm().setVisible(true));
        btnNghiepVu.addActionListener(e -> new NghiepVuKhacForm().setVisible(true));
        btnBaoCao.addActionListener(e -> new BaoCao().setVisible(true));
        btnThoat.addActionListener(e -> {
            int confirm = JOptionPane.showConfirmDialog(this, "Bạn chắc chắn muốn đóng ứng dụng?", "Xác nhận", JOptionPane.YES_NO_OPTION);
            if (confirm == JOptionPane.YES_OPTION) System.exit(0);
        });

        // Thêm nút vào Panel
        buttonPanel.add(btnThucDon);
        buttonPanel.add(btnNhanVien);
        buttonPanel.add(btnKhachHang);
        buttonPanel.add(btnNghiepVu);
        buttonPanel.add(btnBaoCao);
        buttonPanel.add(btnThoat);

        mainPanel.add(buttonPanel, BorderLayout.CENTER);

        // --- Footer ---
        JLabel lblFooter = new JLabel("Version 1.0 - © 2026 Quản Lý Nhà Hàng", JLabel.RIGHT);
        lblFooter.setFont(new Font("Segoe UI", Font.PLAIN, 12));
        lblFooter.setForeground(new Color(149, 165, 166));
        lblFooter.setBorder(new EmptyBorder(20, 0, 0, 0));
        mainPanel.add(lblFooter, BorderLayout.SOUTH);
    }

    /**
     * Hàm tạo Button tùy chỉnh với hiệu ứng Hover
     */
    private JButton createMenuButton(String text, Color baseColor) {
        JButton btn = new JButton(text);
        btn.setFont(new Font("Segoe UI", Font.BOLD, 16));
        btn.setBackground(baseColor);
        btn.setForeground(Color.WHITE); // Chữ trắng trên nền màu đậm
        btn.setFocusPainted(false);
        btn.setBorderPainted(false);
        btn.setCursor(new Cursor(Cursor.HAND_CURSOR));

        // Hiệu ứng rê chuột
        btn.addMouseListener(new MouseAdapter() {
            @Override
            public void mouseEntered(MouseEvent e) {
                btn.setBackground(baseColor.brighter()); // Sáng hơn khi di chuột vào
            }

            @Override
            public void mouseExited(MouseEvent e) {
                btn.setBackground(baseColor); // Trở về màu cũ khi di chuột ra
            }
        });

        return btn;
    }

    public static void main(String[] args) {
        // Cài đặt Look and Feel hệ thống
        try {
            UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Chạy ứng dụng
        SwingUtilities.invokeLater(() -> {
            new MainMenu().setVisible(true);
        });
    }
}