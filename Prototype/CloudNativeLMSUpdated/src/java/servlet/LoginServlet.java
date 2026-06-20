package servlet;

import dao.UserDAO;
import model.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Ambil input
        String matric = request.getParameter("matric");
        String password = request.getParameter("password");
        String selectedRole = request.getParameter("role");

        System.out.println(">>> DEBUG LOGIN: Matric input = " + matric);
        System.out.println(">>> DEBUG LOGIN: Role input = " + selectedRole);

        // 2. Cipta DAO dan semak login
        UserDAO dao = new UserDAO();
        User user = dao.loginUser(matric, password); // PENTING: Panggil guna matric

        // 3. Logik semakan
        if (user != null && user.getRole().equalsIgnoreCase(selectedRole)) {
            System.out.println(">>> DEBUG LOGIN: User berjaya dijumpai! Nama: " + user.getFullname());
            
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            String cp = request.getContextPath();

            if ("student".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect(cp + "/studentDashboard.jsp");
            } else if ("instructor".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect(cp + "/instructorDashboard.jsp");
            } else {
                response.sendRedirect(cp + "/adminDashboard.jsp");
            }
        } else {
            System.out.println(">>> DEBUG LOGIN: User GAGAL dijumpai atau Role tidak padan!");
            response.sendRedirect("login.jsp?error=invalid");
        }
    }
}