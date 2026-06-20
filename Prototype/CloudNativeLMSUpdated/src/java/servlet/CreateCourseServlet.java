package servlet;

import dao.CourseDAO;
import model.Course;
import model.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/CreateCourseServlet")
public class CreateCourseServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Pastikan pengguna telah login
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 1. Ambil data dari form create-course.jsp
        String title = request.getParameter("courseTitle");
        String desc = request.getParameter("courseDesc");
        String category = request.getParameter("courseCategory");
        String level = request.getParameter("courseLevel");
        String tags = request.getParameter("courseTags");
        
        // 2. Bungkus ke dalam objek model Course
        Course c = new Course();
        c.setTitle(title);
        c.setDescription(desc != null && !desc.trim().isEmpty() ? desc : "No description provided.");
        c.setInstructorId(user.getId());
        
        // 🎯 KUNCI UTAMA: Ambil nama dari user.getFullname() secara terus!
        // Ini menjamin nama instructor dalam database SAMA SEBIJIK dengan akaun yang tengah login.
        c.setInstructorName(user.getFullname()); 
        
        c.setCategory(category);
        c.setLevel(level);
        c.setTags(tags);
        c.setStatus("Draft"); // Setiap kursus baru bermula sebagai Draft

        // 3. Masukkan ke database
        CourseDAO dao = new CourseDAO();
        int generatedId = dao.addCourse(c);
        
        // 4. Redirect ke halaman perincian
        if (generatedId > 0) {
            response.sendRedirect("DetailCourseServlet?id=" + generatedId);
        } else {
            response.sendRedirect("instructorDashboard.jsp?error=failed_to_create");
        }
    }
}