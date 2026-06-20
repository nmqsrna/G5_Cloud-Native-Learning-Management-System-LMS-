package servlet;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@WebServlet("/AddModuleServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,   
    maxFileSize = 1024 * 1024 * 100,       
    maxRequestSize = 1024 * 1024 * 150     
)
public class AddModuleServlet extends HttpServlet {
    private final String dbUrl = "jdbc:mysql://localhost:3306/LMS"; 
    private final String dbUser = "root";
    private final String dbPass = "admin"; 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String courseId = request.getParameter("courseId");
        String moduleTitle = request.getParameter("moduleTitle");
        String contentType = request.getParameter("contentType");
        
        Part filePart = request.getPart("moduleFile");
        String fileName = getSubmittedFileName(filePart);
        String relativeSavePath = "";
        
        if (courseId != null && moduleTitle != null && fileName != null && !fileName.isEmpty()) {
            try {
                String uploadDir = getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "course_" + courseId;
                File dir = new File(uploadDir);
                if (!dir.exists()) dir.mkdirs();

                String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
                String fullWritePath = uploadDir + File.separator + uniqueFileName;
                filePart.write(fullWritePath);
                
                relativeSavePath = "uploads/course_" + courseId + "/" + uniqueFileName;
                String insertQuery = "INSERT INTO modules (course_id, module_title, content_type, file_path) VALUES (?, ?, ?, ?)";
                
                Class.forName("com.mysql.cj.jdbc.Driver");
                try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);
                     PreparedStatement ps = conn.prepareStatement(insertQuery)) {
                    
                    ps.setInt(1, Integer.parseInt(courseId));
                    ps.setString(2, moduleTitle.trim());
                    ps.setString(3, contentType);
                    ps.setString(4, relativeSavePath);
                    ps.executeUpdate();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect("DetailCourseServlet?id=" + courseId);
    }

    private String getSubmittedFileName(Part part) {
        for (String cd : part.getHeader("content-disposition").split(";")) {
            if (cd.trim().startsWith("filename")) {
                return cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return null;
    }
}