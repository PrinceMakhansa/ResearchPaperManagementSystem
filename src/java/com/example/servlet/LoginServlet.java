package com.example.servlet;

import com.example.dao.UserDAO;
import com.example.model.User;
import com.example.util.DatabaseUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is already logged in
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("currentUser") != null) {
            response.sendRedirect("dashboard");
            return;
        }

        // Forward to login page
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Validate input
        if (email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {

            request.setAttribute("error", "Email and password are required");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        Connection conn = null;
        try {
            conn = DatabaseUtil.getConnection();
            UserDAO userDAO = new UserDAO(conn);

            User user = userDAO.findByEmailAndPassword(email.trim(), password);

            if (user != null) {
                // Login successful
                HttpSession session = request.getSession(true);
                session.setAttribute("currentUser", user);
                session.setMaxInactiveInterval(30 * 60); // 30 minutes

                // Redirect based on role
                String redirectUrl = "dashboard";
                if (user.isFaculty()) {
                    redirectUrl = "facultyDashboard";
                }

                response.sendRedirect(redirectUrl);
            } else {
                // Login failed
                request.setAttribute("error", "Invalid email or password");
                request.setAttribute("email", email); // Preserve email for convenience
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error occurred. Please try again.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } finally {
            DatabaseUtil.closeConnection(conn);
        }
    }
}
