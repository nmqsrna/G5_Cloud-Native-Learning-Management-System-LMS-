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

@WebServlet("/EditCourseServlet")
public class EditCourseServlet extends HttpServlet {
    private final String dbUrl = "jdbc:mysql://localhost:3306/lms_db"; // 🎯 FIX: lms_db
    private final String dbUser = "root";
    private final String dbPass = "admin"; 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Tangkap parameter dari borang edit di detail-course.jsp
        String courseId = request.getParameter("courseId");
        String title = request.getParameter("courseTitle");
        String desc = request.getParameter("courseDesc"); 
        String instructor = request.getParameter("instructorName");
        String category = request.getParameter("courseCategory");
        String level = request.getParameter("courseLevel");
        String tags = request.getParameter("courseTags");
        
        // 2. Query SQL UPDATE diselaraskan mengikut lajur lms_db awak
        String updateQuery = "UPDATE courses SET title=?, description=?, instructor=?, category=?, level=?, tags=? WHERE id=?";
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);
                 PreparedStatement ps = conn.prepareStatement(updateQuery)) {
                
                ps.setString(1, title);
                ps.setString(2, desc);
                ps.setString(3, instructor);
                ps.setString(4, category);
                ps.setString(5, level);
                ps.setString(6, tags);
                ps.setInt(7, Integer.parseInt(courseId));
                
                ps.executeUpdate();
                System.out.println(">>> LMS EDIT SUCCESS: Course ID " + courseId + " updated.");
            }
        } catch (Exception e) {
            System.out.println("!!! LMS EDIT COURSE ERROR !!!");
            e.printStackTrace();
        }
        
        // 3. Alirkan semula ke DetailCourseServlet untuk papar data yang baru diubah
        response.sendRedirect("DetailCourseServlet?id=" + courseId);
    }
}