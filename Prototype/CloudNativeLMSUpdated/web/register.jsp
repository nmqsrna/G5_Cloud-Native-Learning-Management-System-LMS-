<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>

        <title>Register</title>

        <link rel="stylesheet" href="css/style.css">

        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap"
              rel="stylesheet">

    </head>

    <body>

        <div class="auth-container">

            <div class="auth-card">

                <div class="auth-logo">
                    <h1>LMS</h1>
                </div>

                <div class="auth-title">
                    <h2>Register</h2>
                    <p>Register to continue</p>
                </div>

                <form action="RegisterServlet" method="post">

                    <div class="form-group">
                        <label>No. Matrik</label>
                        <input type="text" 
                               name="id" 
                               class="form-control" 
                               placeholder="Contoh: S76276" required>
                    </div>

                    <div class="form-group">

                        <label>Full Name</label>

                        <input type="text"
                               name="fullname"
                               class="form-control"
                               required>

                    </div>

                    <div class="form-group">
                        <label>Username</label>
                        <input type="text" 
                               name="username" 
                               class="form-control" 
                               required>
                    </div>

                    <div class="form-group">

                        <label>Email</label>

                        <input type="email"
                               name="email"
                               class="form-control"
                               required>

                    </div>

                    <div class="form-group">
                        <label>No. Telefon</label>
                        <input type="tel" 
                               name="phone" 
                               class="form-control" 
                               required>
                    </div>

                    <div class="form-group">

                        <label>Password</label>

                        <input type="password"
                               name="password"
                               class="form-control"
                               required>

                    </div>

                    <div class="form-group">

                        <label>Role</label>

                        <select name="role"
                                class="form-control">

                            <option value="student">
                                Student
                            </option>

                            <option value="instructor">
                                Instructor
                            </option>

                            <option value="admin">
                                Admin
                            </option>

                        </select>

                    </div>

                    <button type="submit"
                            class="btn btn-primary btn-block">

                        Register

                    </button>

                </form>

                <br>

                <p align="center">

                    Already have an account?

                    <a href="login.jsp">
                        Login
                    </a>

                </p>

            </div>

        </div>

    </body>
</html>