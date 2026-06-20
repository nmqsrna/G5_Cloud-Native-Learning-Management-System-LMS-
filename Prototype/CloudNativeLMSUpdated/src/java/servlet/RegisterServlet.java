package servlet;

import dao.UserDAO;
import model.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Ambil data daripada borang
        String matric = request.getParameter("id");
        String fullname = request.getParameter("fullname");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String role = request.getParameter("role");
        String password = request.getParameter("password");

        // 2. DEBUG: Semak sama ada data diterima dengan betul
        System.out.println(">>> DEBUG: Matric diterima: " + matric);
        System.out.println(">>> DEBUG: Fullname diterima: " + fullname);

        if (matric == null || matric.isEmpty()) {
            System.out.println(">>> ERROR: Matric kosong! Sila semak name='id' di register.jsp");
        }

        // 3. Set data ke objek model User
        User user = new User();
        user.setId(matric);
        user.setFullname(fullname);
        user.setUsername(username);
        user.setEmail(email);
        user.setPhone(phone);
        user.setRole(role);
        user.setPassword(password);

        // 4. Panggil DAO untuk simpan ke database
        try {
            UserDAO dao = new UserDAO();
            if (dao.registerUser(user)) {
                System.out.println(">>> DEBUG: Pendaftaran berjaya ke database!");
                response.sendRedirect("login.jsp?msg=success");
            } else {
                System.out.println(">>> DEBUG: Pendaftaran gagal (DAO return false)");
                response.sendRedirect("register.jsp?msg=failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println(">>> DEBUG: Ralat sistem: " + e.getMessage());
            response.sendRedirect("register.jsp?msg=error");
        }
    }
}