package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.User;

@WebServlet("/EnrollCourseServlet")
public class EnrollCourseServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String courseId = request.getParameter("courseId");
        String studentId = user.getId();

        System.out.println(">>> DEBUG: Student ID = " + studentId);
        System.out.println(">>> DEBUG: Course ID = " + courseId);

        // Pastikan details database sama dengan CourseDAO awak
        String dbUrl = "jdbc:mysql://localhost:3306/lms_db";
        String dbUser = "root";
        String dbPass = "admin";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);
            
            String sql = "INSERT INTO enrollments (student_id, course_id) VALUES (?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            
            ps.setString(1, studentId);
            ps.setString(2, courseId);
            
            int row = ps.executeUpdate();
            System.out.println(">>> DEBUG: Berjaya insert " + row + " baris.");
            
            conn.close();
            response.sendRedirect("studentDashboard.jsp?msg=success");
            
            
            
        } catch (Exception e) {
            e.printStackTrace(); 
            response.sendRedirect("courses.jsp?msg=error");
        }
    }
}