package org.example;

import javax.swing.*;
import java.awt.*;
import java.sql.*;

public class NghiepVuKhacForm extends JFrame {
    private Color mainBlue = new Color(0, 102, 204);
    private Color bgPanel = new Color(250, 250, 250);

    public NghiepVuKhacForm() {
        setTitle("Quản Lý Nghiệp Vụ Nhà Hàng");
        setSize(900, 700);
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        setLocationRelativeTo(null);

        // Header
        JPanel headerPanel = new JPanel(null);
        headerPanel.setBackground(bgPanel);
        headerPanel.setPreferredSize(new Dimension(900, 80));

        JLabel lblHeader = new JLabel("HỆ THỐNG NGHIỆP VỤ CHI TIẾT");
        lblHeader.setFont(new Font("Tahoma", Font.BOLD, 22));
        lblHeader.setForeground(mainBlue);
        lblHeader.setBounds(40, 20, 500, 40);
        headerPanel.add(lblHeader);

        JTabbedPane tabs = new JTabbedPane();
        tabs.setFont(new Font("Tahoma", Font.BOLD, 13));

        // Các Tab nghiệp vụ còn lại
        tabs.addTab(" 1 & 2. Phục Vụ Bàn ", createTab12());
        tabs.addTab(" 3. Thanh Toán ", createTab3());
        tabs.addTab(" 7. Hủy Món Lẻ ", createTab7());
        tabs.addTab(" 8. Hủy Toàn Đơn ", createTab8());

        setLayout(new BorderLayout());
        add(headerPanel, BorderLayout.NORTH);
        add(tabs, BorderLayout.CENTER);
    }

    // --- TAB 1 & 2: PHỤC VỤ (Mở bàn & Gọi món) ---
    private JPanel createTab12() {
        JPanel p = createBasePanel();
        int labelX = 60, inputX = 180, width = 300;

        addSectionHeader(p, "1. MỞ BÀN MỚI", 30);
        JTextField tMaBan = addInput(p, "Mã Bàn:", labelX, inputX, 80, width);
        JTextField tMaNV = addInput(p, "Mã NV Phục Vụ:", labelX, inputX, 120, width);
        JTextField tMaKH = addInput(p, "Mã KH (nếu có):", labelX, inputX, 160, width);
        JButton btnMo = createBtn(p, "Xác Nhận Mở Bàn", new Color(220, 255, 220), inputX, 210, width);
        btnMo.addActionListener(e -> callSp("{CALL sp_MoBanMoi(?,?,?)}", tMaBan.getText(), tMaNV.getText(), tMaKH.getText()));

        addSectionHeader(p, "2. GỌI MÓN (THÊM VÀO ĐƠN)", 300);
        JTextField tMaDon = addInput(p, "Mã Đơn Hiện Tại:", labelX, inputX, 350, width);
        JTextField tMaMon = addInput(p, "Mã Món Ăn:", labelX, inputX, 390, width);
        JTextField tSL = addInput(p, "Số Lượng:", labelX, inputX, 430, width);
        JButton btnGoi = createBtn(p, "Thêm Món Vào Đơn", new Color(255, 255, 220), inputX, 480, width);
        btnGoi.addActionListener(e -> callSp("{CALL sp_GoiMon(?,?,?)}", tMaDon.getText(), tMaMon.getText(), tSL.getText()));

        return p;
    }

    // --- TAB 3: THANH TOÁN ---
    private JPanel createTab3() {
        JPanel p = createBasePanel();
        addSectionHeader(p, "3. XỬ LÝ THANH TOÁN", 50);
        JTextField tMaDonPay = addInput(p, "Mã Đơn:", 60, 180, 100, 300);
        JLabel lblPT = new JLabel("Phương Thức:");
        lblPT.setBounds(60, 145, 120, 30); p.add(lblPT);
        JComboBox<String> cbPT = new JComboBox<>(new String[]{"Tiền mặt", "Chuyển khoản", "Thẻ VISA"});
        cbPT.setBounds(180, 145, 300, 30); p.add(cbPT);

        JButton btnPay = createBtn(p, "HOÀN TẤT THANH TOÁN", new Color(225, 240, 255), 180, 200, 300);
        btnPay.addActionListener(e -> callSp("{CALL sp_ThanhToan(?,?)}", tMaDonPay.getText(), (String)cbPT.getSelectedItem()));
        return p;
    }

    // --- TAB 7: HỦY MÓN LẺ ---
    private JPanel createTab7() {
        JPanel p = createBasePanel();
        addSectionHeader(p, "7. XÓA MÓN ĂN KHỎI ĐƠN", 30);
        JTextField tH7Don = addInput(p, "Mã Đơn:", 60, 180, 100, 300);
        JTextField tH7Mon = addInput(p, "Mã Món Ăn:", 60, 180, 140, 300);

        JButton btn7 = createBtn(p, "Xác Nhận Xóa Món", new Color(255, 235, 220), 180, 200, 300);
        btn7.addActionListener(e -> callSp("{CALL sp_HuyMon(?,?)}", tH7Don.getText(), tH7Mon.getText()));
        return p;
    }

    // --- TAB 8: HỦY TOÀN BỘ ĐƠN ---
    private JPanel createTab8() {
        JPanel p = createBasePanel();
        addSectionHeader(p, "8. HỦY TOÀN BỘ ĐƠN HÀNG", 30);
        JLabel lblWarning = new JLabel("<html><font color='red'>⚠️ Cảnh báo: Thao tác này sẽ xóa vĩnh viễn hóa đơn và dữ liệu món đã gọi.</font></html>");
        lblWarning.setBounds(60, 70, 600, 30); p.add(lblWarning);

        JTextField tH8Don = addInput(p, "Mã Đơn Cần Hủy:", 60, 180, 120, 300);
        JButton btn8 = createBtn(p, "HỦY TOÀN ĐƠN", new Color(255, 220, 220), 180, 180, 300);
        btn8.setForeground(Color.RED);
        btn8.addActionListener(e -> {
            if(tH8Don.getText().isEmpty()) return;
            int c = JOptionPane.showConfirmDialog(this, "Bạn có chắc chắn muốn hủy toàn bộ đơn " + tH8Don.getText() + "?", "Xác nhận", JOptionPane.YES_NO_OPTION);
            if(c == JOptionPane.YES_OPTION) callSp("{CALL sp_HuyDonHang(?)}", tH8Don.getText());
        });
        return p;
    }

    // --- HÀM XỬ LÝ DATABASE TẬP TRUNG ---
    private void callSp(String sql, String... params) {
        try (Connection conn = DBConnection.getConnection()) {

            // 1. Kiểm tra Role Lễ Tân (nếu mở bàn)
            if (sql.contains("sp_MoBanMoi")) {
                if (!checkRole(conn, params[1], "Phục vụ")) return;
            }

            // 2. Kiểm tra trạng thái Thanh Toán (nếu Hủy món hoặc Hủy đơn)
            if (sql.contains("sp_HuyMon") || sql.contains("sp_HuyDonHang")) {
                if (isOrderPaid(conn, params[0])) {
                    JOptionPane.showMessageDialog(this, "Lỗi: Đơn hàng này đã thanh toán, không thể thực hiện thay đổi!", "Từ chối", JOptionPane.ERROR_MESSAGE);
                    return;
                }
            }

            // Thực thi Store Procedure
            CallableStatement cst = conn.prepareCall(sql);
            for (int i = 0; i < params.length; i++) {
                String val = (params[i] == null) ? "" : params[i].trim();
                if (val.isEmpty()) cst.setNull(i + 1, Types.NULL);
                else if (val.matches("\\d+")) cst.setInt(i + 1, Integer.parseInt(val));
                else cst.setNString(i + 1, val);
            }
            cst.execute();
            JOptionPane.showMessageDialog(this, "Thực hiện thành công!");

        } catch (Exception e) {
            JOptionPane.showMessageDialog(this, "Lỗi hệ thống: " + e.getMessage());
        }
    }

    // Helper: Kiểm tra đơn đã thanh toán chưa
    private boolean isOrderPaid(Connection conn, String orderId) throws SQLException {
        String sql = "SELECT is_paid FROM Orders WHERE order_id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, orderId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return rs.getBoolean("is_paid");
        }
        return false;
    }

    // Helper: Kiểm tra chức vụ nhân viên
    private boolean checkRole(Connection conn, String staffId, String requiredRole) throws SQLException {
        String sql = "SELECT role FROM Staff WHERE staff_id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, staffId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            String role = rs.getNString("role");
            if (role != null && role.equalsIgnoreCase(requiredRole)) return true;
            JOptionPane.showMessageDialog(this, "Lỗi: Nhân viên mã " + staffId + " là '" + role + "'. Yêu cầu: " + requiredRole);
        } else {
            JOptionPane.showMessageDialog(this, "Lỗi: Không tìm thấy nhân viên mã " + staffId);
        }
        return false;
    }

    // --- GUI HELPERS ---
    private JPanel createBasePanel() {
        JPanel p = new JPanel(null);
        p.setBackground(Color.WHITE);
        return p;
    }

    private void addSectionHeader(JPanel p, String text, int y) {
        JLabel lbl = new JLabel(text);
        lbl.setFont(new Font("Tahoma", Font.BOLD, 15));
        lbl.setForeground(mainBlue);
        lbl.setBounds(40, y, 400, 30);
        p.add(lbl);
        JSeparator sep = new JSeparator();
        sep.setBounds(40, y + 30, 440, 10);
        p.add(sep);
    }

    private JTextField addInput(JPanel p, String label, int xL, int xI, int y, int w) {
        JLabel lbl = new JLabel(label);
        lbl.setBounds(xL, y, 120, 30);
        p.add(lbl);
        JTextField txt = new JTextField();
        txt.setBounds(xI, y, w, 30);
        p.add(txt);
        return txt;
    }

    private JButton createBtn(JPanel p, String text, Color bg, int x, int y, int w) {
        JButton btn = new JButton(text);
        btn.setBounds(x, y, w, 40);
        btn.setBackground(bg);
        btn.setFont(new Font("Tahoma", Font.BOLD, 12));
        btn.setFocusPainted(false);
        p.add(btn);
        return btn;
    }

    public static void main(String[] args) {
        try { UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName()); } catch (Exception e) {}
        new NghiepVuKhacForm().setVisible(true);
    }
}