<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>

        <title>Login</title>

        <link rel="stylesheet" href="css/style.css">

        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap"
              rel="stylesheet">

    </head>

    <body>

        <div class="auth-container">

            <div class="auth-split">

                <div class="auth-left">

                    <div class="auth-logo">
                        <h1>LMS</h1>
                    </div>

                    <div class="auth-title">
                        <h2>Welcome Back!</h2>
                        <p>Please login to your account</p>
                    </div>

                    <form action="LoginServlet" method="post">

                        <div class="form-group">
                            <label>No. Matrik</label>
                            <input type="text" 
                                   name="matric" 
                                   class="form-control" 
                                   placeholder="Contoh: S76276" 
                                   required>
                        </div>

                        <div class="form-group">
                            <label>Password</label>
                            <input type="password" 
                                   name="password" 
                                   class="form-control" 
                                   required>
                        </div>

                        <form action="${pageContext.request.contextPath}/LoginServlet" method="POST" autocomplete="off">
                            <div class="form-group">
                                <label for="role">Log in As:</label>
                                <select name="role" class="form-control" required>
                                    <option value="student">Student</option>
                                    <option value="instructor">Instructor</option>
                                    <option value="admin">Admin</option>
                                </select>
                            </div>

                            <button type="submit"
                                    class="btn btn-primary btn-block">
                                Login
                            </button>
                        </form>



                    </form>

                    <br>

                    <center>
                        Don't have an account?
                        <a href="register.jsp">Register here</a>
                    </center>

                </div>

                <div class="auth-right">

                    <img src="images/login.png">

                </div>

            </div>

        </div>
    </body>
</html>