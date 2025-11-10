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

@WebServlet("/listPapers")
public class ListPapersServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect("login");
            return;
        }

        String searchTerm = request.getParameter("search");
        String statusFilter = request.getParameter("status");

        Connection conn = null;
        try {
            conn = DatabaseUtil.getConnection();
            PaperDAO paperDAO = new PaperDAO(conn);

            List<Paper> papers;

            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                // Search functionality
                papers = paperDAO.searchPapers(searchTerm.trim());
                request.setAttribute("searchTerm", searchTerm);
            } else if (statusFilter != null && !statusFilter.trim().isEmpty() && !"all".equals(statusFilter)) {
                // Filter by status
                if (currentUser.isStudent()) {
                    // For students, filter their own papers by status
                    papers = paperDAO.findByAuthor(currentUser.getUserId());
                    papers.removeIf(paper -> !statusFilter.equals(paper.getStatus()));
                } else {
                    // For faculty/admin, show all papers with the specified status
                    papers = paperDAO.findByStatus(statusFilter);
                }
                request.setAttribute("statusFilter", statusFilter);
            } else {
                // Show all papers based on user role
                if (currentUser.isStudent()) {
                    papers = paperDAO.findByAuthor(currentUser.getUserId());
                } else {
                    papers = paperDAO.findAll();
                }
            }

            request.setAttribute("papers", papers);
            request.setAttribute("currentUser", currentUser);

            // Add statistics for the current view
            long submittedCount = papers.stream().filter(p -> Paper.STATUS_SUBMITTED.equals(p.getStatus())).count();
            long reviewCount = papers.stream().filter(p -> Paper.STATUS_UNDER_REVIEW.equals(p.getStatus())).count();
            long acceptedCount = papers.stream().filter(p -> Paper.STATUS_ACCEPTED.equals(p.getStatus())).count();
            long rejectedCount = papers.stream().filter(p -> Paper.STATUS_REJECTED.equals(p.getStatus())).count();

            request.setAttribute("submittedCount", (int) submittedCount);
            request.setAttribute("reviewCount", (int) reviewCount);
            request.setAttribute("acceptedCount", (int) acceptedCount);
            request.setAttribute("rejectedCount", (int) rejectedCount);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Unable to load papers");
        } finally {
            DatabaseUtil.closeConnection(conn);
        }

        request.getRequestDispatcher("listPapers.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
