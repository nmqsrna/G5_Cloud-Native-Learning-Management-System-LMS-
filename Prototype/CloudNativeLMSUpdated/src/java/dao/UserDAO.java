package dao;

import java.sql.*;
import model.User;

public class UserDAO {

    private Connection con;

    public UserDAO() {
        con = DBConnection.getConnection();
    }

    public boolean registerUser(User user) {
        boolean status = false;
        System.out.println("DEBUG DAO: Menerima data ID=" + user.getId() + ", Email=" + user.getEmail());

        try {
            String sql = "INSERT INTO users(id, fullname, email, password, role, username, phone) VALUES(?,?,?,?,?,?,?)";

            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, user.getId());
                ps.setString(2, user.getFullname());
                ps.setString(3, user.getEmail());
                ps.setString(4, user.getPassword());
                ps.setString(5, user.getRole());
                ps.setString(6, user.getUsername());
                ps.setString(7, user.getPhone());

                int row = ps.executeUpdate();
                status = (row > 0);
                System.out.println("DEBUG DAO: Row updated = " + row);
            }
        } catch (Exception e) {
            System.err.println("DEBUG DAO ERROR: " + e.getMessage());
            e.printStackTrace();
        }
        return status;
    }

    public User loginUser(String id, String password) { // Tukar parameter 'email' kepada 'id'
        User user = null;
        try {
            // SQL MESTI MENCARI BERDASARKAN ID
            String sql = "SELECT * FROM users WHERE id=? AND password=?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, id);
                ps.setString(2, password);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        user = new User();
                        user.setId(rs.getString("id"));
                        user.setFullname(rs.getString("fullname"));
                        user.setEmail(rs.getString("email"));
                        user.setRole(rs.getString("role"));
                        user.setUsername(rs.getString("username"));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

    // Buka UserDAO.java dan pastikan method ini wujud:
    public boolean enrollCourse(String studentId, int courseId) {
        String sql = "INSERT INTO enrollments (student_id, course_id) VALUES (?, ?)";
        try (PreparedStatement ps = con.prepareStatement(sql)) { // Guna 'con' sedia ada
            ps.setString(1, studentId);
            ps.setInt(2, courseId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println(">>> DEBUG ERROR ENROLL: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
