package servlet;

import dao.CourseDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/DeleteCourseServlet")
public class DeleteCourseServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Tangkap ID kursus yang dihantar melalui URL parameter
        String idParam = request.getParameter("id");
        
        if (idParam != null && !idParam.isEmpty()) {
            try {
                int courseId = Integer.parseInt(idParam);
                
                // 2. Panggil fungsi deleteCourse di dalam CourseDAO
                CourseDAO dao = new CourseDAO();
                boolean success = dao.deleteCourse(courseId);
                
                // 3. Alirkan semula ke dashboard bersama mesej status pemberitahuan
                if (success) {
                    System.out.println(">>> LMS SUCCESS: Course ID " + courseId + " has been deleted.");
                    response.sendRedirect("instructorDashboard.jsp?msg=delete_success");
                } else {
                    System.out.println(">>> LMS FAILED: Unable to delete Course ID " + courseId);
                    response.sendRedirect("instructorDashboard.jsp?error=delete_failed");
                }
                return;
                
            } catch (NumberFormatException e) {
                e.printStackTrace();
                response.sendRedirect("instructorDashboard.jsp?error=invalid_id");
                return;
            }
        }
        
        // Jika tiada ID dihantar, balik semula ke dashboard
        response.sendRedirect("instructorDashboard.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}