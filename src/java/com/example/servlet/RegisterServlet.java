package com.example.servlet;

import com.example.dao.UserDAO;
import com.example.model.User;
import com.example.util.DatabaseUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String role = request.getParameter("role");

        // Validate input
        if (name == null || name.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            confirmPassword == null || confirmPassword.trim().isEmpty() ||
            role == null || role.trim().isEmpty()) {

            request.setAttribute("error", "All fields are required");
            preserveFormData(request, name, email, role);
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Validate password match
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match");
            preserveFormData(request, name, email, role);
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Validate email format
        if (!isValidEmail(email)) {
            request.setAttribute("error", "Please enter a valid email address");
            preserveFormData(request, name, email, role);
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Validate password strength
        if (password.length() < 6) {
            request.setAttribute("error", "Password must be at least 6 characters long");
            preserveFormData(request, name, email, role);
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Validate role
        if (!isValidRole(role)) {
            request.setAttribute("error", "Please select a valid role");
            preserveFormData(request, name, email, role);
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        Connection conn = null;
        try {
            conn = DatabaseUtil.getConnection();
            UserDAO userDAO = new UserDAO(conn);

            // Check if email already exists
            if (userDAO.emailExists(email.trim())) {
                request.setAttribute("error", "An account with this email already exists");
                preserveFormData(request, name, email, role);
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            // Create new user
            User user = new User(name.trim(), email.trim(), password, role.trim());

            if (userDAO.createUser(user)) {
                // Registration successful
                response.sendRedirect("login?msg=Registration successful. Please login.");
            } else {
                request.setAttribute("error", "Failed to create account. Please try again.");
                preserveFormData(request, name, email, role);
                request.getRequestDispatcher("register.jsp").forward(request, response);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error occurred. Please try again.");
            preserveFormData(request, name, email, role);
            request.getRequestDispatcher("register.jsp").forward(request, response);
        } finally {
            DatabaseUtil.closeConnection(conn);
        }
    }

    private void preserveFormData(HttpServletRequest request, String name, String email, String role) {
        request.setAttribute("name", name);
        request.setAttribute("email", email);
        request.setAttribute("role", role);
    }

    private boolean isValidEmail(String email) {
        return email != null && email.contains("@") && email.contains(".");
    }

    private boolean isValidRole(String role) {
        return "student".equals(role) || "faculty".equals(role);
    }
}
