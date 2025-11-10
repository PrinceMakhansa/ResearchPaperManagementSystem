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

@WebServlet("/allPapers")
public class AllPapersServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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
                papers = paperDAO.searchPapers(searchTerm.trim());
                request.setAttribute("searchTerm", searchTerm);
            } else if (statusFilter != null && !statusFilter.trim().isEmpty() && !"all".equals(statusFilter)) {
                papers = paperDAO.findByStatus(statusFilter);
                request.setAttribute("statusFilter", statusFilter);
            } else {
                papers = paperDAO.findAll();
            }

            request.setAttribute("papers", papers);
            request.setAttribute("currentUser", currentUser);

            int submittedCount = 0, reviewCount = 0, acceptedCount = 0, rejectedCount = 0;
            for (Paper p : papers) {
                String s = p.getStatus();
                if (Paper.STATUS_SUBMITTED.equals(s)) submittedCount++;
                else if (Paper.STATUS_UNDER_REVIEW.equals(s)) reviewCount++;
                else if (Paper.STATUS_ACCEPTED.equals(s)) acceptedCount++;
                else if (Paper.STATUS_REJECTED.equals(s)) rejectedCount++;
            }
            request.setAttribute("submittedCount", submittedCount);
            request.setAttribute("reviewCount", reviewCount);
            request.setAttribute("acceptedCount", acceptedCount);
            request.setAttribute("rejectedCount", rejectedCount);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Unable to load papers");
        } finally {
            DatabaseUtil.closeConnection(conn);
        }

        request.getRequestDispatcher("allPapers.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}

