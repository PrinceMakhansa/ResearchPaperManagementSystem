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

@WebServlet("/facultyDashboard")
public class FacultyDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect("login");
            return;
        }

        // Only faculty and admin can access this dashboard
        if (!currentUser.isFaculty() && !currentUser.isAdmin()) {
            response.sendRedirect("dashboard");
            return;
        }

        Connection conn = null;
        try {
            conn = DatabaseUtil.getConnection();
            PaperDAO paperDAO = new PaperDAO(conn);

            // Get overall statistics
            Map<String, Integer> overallCounts = paperDAO.getOverallStatusCounts();
            request.setAttribute("submittedCount", overallCounts.getOrDefault(Paper.STATUS_SUBMITTED, 0));
            request.setAttribute("reviewCount", overallCounts.getOrDefault(Paper.STATUS_UNDER_REVIEW, 0));
            request.setAttribute("acceptedCount", overallCounts.getOrDefault(Paper.STATUS_ACCEPTED, 0));
            request.setAttribute("rejectedCount", overallCounts.getOrDefault(Paper.STATUS_REJECTED, 0));

            // Get total paper count
            int totalPapers = paperDAO.getTotalPaperCount();
            request.setAttribute("totalPapers", totalPapers);

            // Get papers pending review (submitted status)
            List<Paper> papersForReview = paperDAO.findByStatus(Paper.STATUS_SUBMITTED);
            request.setAttribute("papersForReview", papersForReview);

            // Get papers currently under review
            List<Paper> papersUnderReview = paperDAO.findByStatus(Paper.STATUS_UNDER_REVIEW);
            request.setAttribute("papersUnderReview", papersUnderReview);

            // Get recently accepted papers
            List<Paper> recentlyAccepted = paperDAO.findByStatus(Paper.STATUS_ACCEPTED);
            if (recentlyAccepted.size() > 5) {
                recentlyAccepted = recentlyAccepted.subList(0, 5);
            }
            request.setAttribute("recentlyAccepted", recentlyAccepted);

            // Get all papers for complete overview
            List<Paper> allPapers = paperDAO.findAll();
            request.setAttribute("allPapers", allPapers);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Unable to load dashboard data");
        } finally {
            DatabaseUtil.closeConnection(conn);
        }

        request.getRequestDispatcher("facultyDashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
