package dao;

import model.Course;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CourseDAO {

    private Connection con;

    // Konfigurasi Database Terpusat Selamat
    private final String dbUrl = "jdbc:mysql://localhost:3306/lms_db";
    private final String dbUser = "root";
    private final String dbPass = "admin";

    public CourseDAO() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            this.con = DriverManager.getConnection(dbUrl, dbUser, dbPass);
        } catch (Exception e) {
            System.out.println(">>> CourseDAO Connection Initialization FAILED!");
            e.printStackTrace();
        }
    }

    /**
     * Fungsi menambah kursus baru (Dinamik & Selaras dengan
     * CreateCourseServlet)
     */
    public int addCourse(Course c) {
        int generatedId = 0;
        String sql = "INSERT INTO courses(title, description, instructor, category, level, tags, status) VALUES(?,?,?,?,?,?,?)";

        try {
            try (PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, c.getTitle());
                ps.setString(2, c.getDescription());
                ps.setString(3, c.getInstructorName());
                ps.setString(4, c.getCategory() != null ? c.getCategory() : "Technology");
                ps.setString(5, c.getLevel() != null ? c.getLevel() : "Beginner");
                ps.setString(6, c.getTags() != null ? c.getTags() : "");
                ps.setString(7, "Draft");

                int row = ps.executeUpdate();
                if (row > 0) {
                    try (ResultSet rs = ps.getGeneratedKeys()) {
                        if (rs.next()) {
                            generatedId = rs.getInt(1);
                        }
                    }
                }
            }
        } catch (Exception e) {
            System.out.println(">>> CourseDAO.addCourse ERROR !!!");
            e.printStackTrace();
        }
        return generatedId;
    }

    /**
     * Fungsi mengambil senarai kursus mengikut nama pengajar
     */
    public List<Course> getInstructorCourses(String instructorName) {
        List<Course> list = new ArrayList<>();
        String sql = "SELECT * FROM courses WHERE instructor = ? ORDER BY id DESC";

        try {
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, instructorName);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Course c = new Course();
                        c.setId(rs.getInt("id"));
                        c.setTitle(rs.getString("title"));
                        c.setDescription(rs.getString("description"));
                        c.setCategory(rs.getString("category"));
                        c.setLevel(rs.getString("level"));
                        c.setStatus(rs.getString("status"));
                        list.add(c);
                    }
                }
            }
        } catch (Exception e) {
            System.out.println(">>> ERROR: getInstructorCourses failed!");
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Fungsi mengambil semua kursus yang berstatus 'Active' untuk paparan
     * senarai subjek Student
     */
    public List<Course> getAllActiveCourses() {
        List<Course> list = new ArrayList<>();
        String sql = "SELECT * FROM courses WHERE status = 'Active' ORDER BY id DESC";
        try {
            try (PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Course c = new Course();
                    c.setId(rs.getInt("id"));
                    c.setTitle(rs.getString("title"));
                    c.setDescription(rs.getString("description"));
                    c.setInstructorName(rs.getString("instructor"));
                    c.setCategory(rs.getString("category"));
                    c.setLevel(rs.getString("level"));
                    c.setStatus(rs.getString("status"));
                    list.add(c);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Fungsi mengambil senarai kursus yang TELAH didaftar oleh student tertentu
     */
    public List<Course> getStudentEnrolledCourses(String studentId) { // Tukar int ke String
        List<Course> list = new ArrayList<>();
        String sql = "SELECT c.* FROM courses c JOIN enrollments e ON c.id = e.course_id WHERE e.student_id = ?";
        try {
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, studentId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Course c = new Course();
                        c.setId(rs.getInt("id"));
                        c.setTitle(rs.getString("title"));
                        c.setDescription(rs.getString("description"));
                        c.setInstructorName(rs.getString("instructor"));
                        c.setCategory(rs.getString("category"));
                        c.setLevel(rs.getString("level"));
                        c.setStatus(rs.getString("status"));
                        list.add(c);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * 🎯 FIX SEBENAR: Hanya tinggal SATU (1) fungsi enrollCourse yang stabil ke
     * lms_db
     */
    /**
     * 🎯 FIX SEBENAR: Tukar studentId kepada String supaya padan dengan No.
     * Matrik
     */
    public boolean enrollCourse(String studentId, int courseId) { // Tukar ke String
        boolean status = false;
        String sql = "INSERT INTO enrollments (student_id, course_id) VALUES (?, ?)";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, studentId); // Tukar ke setString
            ps.setInt(2, courseId);

            int result = ps.executeUpdate();
            if (result > 0) {
                status = true;
            }
        } catch (Exception e) {
            System.out.println("!!! LMS ENROLL DATABASE ERROR IN DAO !!!");
            e.printStackTrace();
        }
        return status;
    }

    /**
     * Fungsi untuk mengemas kini butiran kursus
     */
    public boolean updateCourse(Course c) {
        boolean status = false;
        String sql = "UPDATE courses SET title=?, description=?, instructor=?, category=?, level=?, tags=? WHERE id=?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, c.getTitle());
            ps.setString(2, c.getDescription());
            ps.setString(3, c.getInstructorName());
            ps.setString(4, c.getCategory());
            ps.setString(5, c.getLevel());
            ps.setString(6, c.getTags());
            ps.setInt(7, c.getId());
            status = ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }

    /**
     * Fungsi untuk memadam kursus berdasarkan ID
     */
    public boolean deleteCourse(int id) {
        boolean status = false;
        String sql = "DELETE FROM courses WHERE id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            status = ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }
}
