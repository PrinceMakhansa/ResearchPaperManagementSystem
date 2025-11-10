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

@WebServlet("/updatePaperStatus")
public class UpdatePaperStatusServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect("login");
            return;
        }

        // Only faculty and admin can update paper status
        if (!currentUser.isFaculty() && !currentUser.isAdmin()) {
            response.sendRedirect("listPapers?error=Access denied");
            return;
        }

        String paperIdStr = request.getParameter("paperId");
        String newStatus = request.getParameter("status");
        String redirectUrl = request.getParameter("redirectUrl");

        // Validate input
        if (paperIdStr == null || newStatus == null) {
            response.sendRedirect("listPapers?error=Invalid parameters");
            return;
        }

        int paperId;
        try {
            paperId = Integer.parseInt(paperIdStr);
        } catch (NumberFormatException e) {
            response.sendRedirect("listPapers?error=Invalid paper ID");
            return;
        }

        // Validate status
        if (!isValidStatus(newStatus)) {
            response.sendRedirect("listPapers?error=Invalid status");
            return;
        }

        Connection conn = null;
        try {
            conn = DatabaseUtil.getConnection();
            PaperDAO paperDAO = new PaperDAO(conn);

            // Verify paper exists
            Paper paper = paperDAO.findById(paperId);
            if (paper == null) {
                response.sendRedirect("listPapers?error=Paper not found");
                return;
            }

            // Update status
            if (paperDAO.updateStatus(paperId, newStatus)) {
                String message = "Paper status updated to " + newStatus.substring(0, 1).toUpperCase() +
                               newStatus.substring(1);

                // Determine redirect URL
                String finalRedirectUrl = "listPapers?msg=" + java.net.URLEncoder.encode(message, "UTF-8");
                if (redirectUrl != null && !redirectUrl.trim().isEmpty()) {
                    if (redirectUrl.contains("?")) {
                        finalRedirectUrl = redirectUrl + "&msg=" + java.net.URLEncoder.encode(message, "UTF-8");
                    } else {
                        finalRedirectUrl = redirectUrl + "?msg=" + java.net.URLEncoder.encode(message, "UTF-8");
                    }
                }

                response.sendRedirect(finalRedirectUrl);
            } else {
                response.sendRedirect("listPapers?error=Failed to update paper status");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("listPapers?error=Database error occurred");
        } finally {
            DatabaseUtil.closeConnection(conn);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("listPapers");
    }

    private boolean isValidStatus(String status) {
        return Paper.STATUS_SUBMITTED.equals(status) ||
               Paper.STATUS_UNDER_REVIEW.equals(status) ||
               Paper.STATUS_ACCEPTED.equals(status) ||
               Paper.STATUS_REJECTED.equals(status);
    }
}
