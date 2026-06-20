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
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import model.User;

@WebServlet("/UpdateProfileServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10,      // 10MB
        maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class UpdateProfileServlet extends HttpServlet {

    private final String dbUrl = "jdbc:mysql://localhost:3306/lms_db";
    private final String dbUser = "root";
    private final String dbPass = "admin";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");
        String fileName = user.getProfilePicture(); // Simpan nama fail asal

        // 1. Proses Muat Naik Gambar
        try {
            Part filePart = request.getPart("profilePic");
            if (filePart != null && filePart.getSize() > 0) {
                String originalName = filePart.getSubmittedFileName();
                fileName = "user_" + user.getId() + "_" + System.currentTimeMillis() + "_" + originalName;

                // Pastikan folder 'uploads' ada di dalam root projek anda
                String appPath = request.getServletContext().getRealPath("");
                String savePath = appPath + File.separator + "uploads";
                File fileSaveDir = new File(savePath);
                if (!fileSaveDir.exists()) fileSaveDir.mkdir();

                filePart.write(savePath + File.separator + fileName);
                System.out.println(">>> DEBUG: Gambar disimpan di: " + savePath + File.separator + fileName);
            }
        } catch (Exception e) {
            System.err.println(">>> DEBUG ERROR: Gagal muat naik gambar: " + e.getMessage());
        }

        // 2. Kemaskini Database
        String sql = "UPDATE users SET fullname = ?, email = ?, profile_picture = ? WHERE id = ?";
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPass); 
                 PreparedStatement ps = conn.prepareStatement(sql)) {

                ps.setString(1, (fullname != null && !fullname.isEmpty()) ? fullname : user.getFullname());
                ps.setString(2, (email != null && !email.isEmpty()) ? email : user.getEmail());
                ps.setString(3, fileName);
                ps.setString(4, user.getId());

                int rows = ps.executeUpdate();
                if (rows > 0) {
                    // Update Session
                    user.setFullname(fullname);
                    user.setEmail(email);
                    user.setProfilePicture(fileName);
                    session.setAttribute("user", user);
                    System.out.println(">>> DEBUG: Sesi telah dikemaskini untuk ID: " + user.getId());
                    response.sendRedirect("profile.jsp?msg=update_success");
                } else {
                    response.sendRedirect("profile.jsp?error=update_failed");
                }
            }
        } catch (Exception e) {
            System.err.println(">>> DEBUG ERROR: Gagal update DB: " + e.getMessage());
            e.printStackTrace(); 
            response.sendRedirect("profile.jsp?error=db_error");
        }
    }
}