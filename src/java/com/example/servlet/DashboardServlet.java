package com.example.servlet;

import com.example.dao.PaperDAO;
import com.example.model.Paper;
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
import java.util.List;
import java.util.Map;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect("login");
            return;
        }

        Connection conn = null;
        try {
            conn = DatabaseUtil.getConnection();
            PaperDAO paperDAO = new PaperDAO(conn);

            if (currentUser.isStudent()) {
                loadStudentDashboard(request, currentUser, paperDAO);
            } else if (currentUser.isFaculty() || currentUser.isAdmin()) {
                loadFacultyAdminDashboard(request, currentUser, paperDAO);
            }

            request.getRequestDispatcher("dashboard.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Unable to load dashboard data");
            request.getRequestDispatcher("dashboard.jsp").forward(request, response);
        } finally {
            DatabaseUtil.closeConnection(conn);
        }
    }

    private void loadStudentDashboard(HttpServletRequest request, User user, PaperDAO paperDAO)
            throws SQLException {

        // Get student's papers
        List<Paper> userPapers = paperDAO.findByAuthor(user.getUserId());
        request.setAttribute("userPapers", userPapers);

        // Get status counts for the user
        Map<String, Integer> statusCounts = paperDAO.getStatusCountsByAuthor(user.getUserId());
        request.setAttribute("submittedCount", statusCounts.getOrDefault(Paper.STATUS_SUBMITTED, 0));
        request.setAttribute("reviewCount", statusCounts.getOrDefault(Paper.STATUS_UNDER_REVIEW, 0));
        request.setAttribute("acceptedCount", statusCounts.getOrDefault(Paper.STATUS_ACCEPTED, 0));
        request.setAttribute("rejectedCount", statusCounts.getOrDefault(Paper.STATUS_REJECTED, 0));

        // Get recent papers for overview
        List<Paper> recentPapers = paperDAO.getRecentPapers(5);
        request.setAttribute("recentPapers", recentPapers);
    }

    private void loadFacultyAdminDashboard(HttpServletRequest request, User user, PaperDAO paperDAO)
            throws SQLException {

        // Get overall statistics
        Map<String, Integer> overallCounts = paperDAO.getOverallStatusCounts();
        request.setAttribute("submittedCount", overallCounts.getOrDefault(Paper.STATUS_SUBMITTED, 0));
        request.setAttribute("reviewCount", overallCounts.getOrDefault(Paper.STATUS_UNDER_REVIEW, 0));
        request.setAttribute("acceptedCount", overallCounts.getOrDefault(Paper.STATUS_ACCEPTED, 0));
        request.setAttribute("rejectedCount", overallCounts.getOrDefault(Paper.STATUS_REJECTED, 0));

        // Get total paper count
        int totalPapers = paperDAO.getTotalPaperCount();
        request.setAttribute("totalPapers", totalPapers);

        // Get recent papers for review
        List<Paper> recentPapers = paperDAO.getRecentPapers(10);
        request.setAttribute("recentPapers", recentPapers);

        // Get papers needing review
        List<Paper> papersForReview = paperDAO.findByStatus(Paper.STATUS_SUBMITTED);
        request.setAttribute("papersForReview", papersForReview);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
