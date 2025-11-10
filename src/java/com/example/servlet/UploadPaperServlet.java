package com.example.servlet;

import com.example.dao.PaperDAO;
import com.example.model.Paper;
import com.example.model.User;
import com.example.util.DatabaseUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.Connection;
import java.sql.SQLException;

@WebServlet("/uploadPaper")
@MultipartConfig(maxFileSize = 10 * 1024 * 1024, // 10MB
                maxRequestSize = 10 * 1024 * 1024, // 10MB
                fileSizeThreshold = 1024 * 1024) // 1MB
public class UploadPaperServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "uploads";
    private static final String[] ALLOWED_EXTENSIONS = {".pdf", ".doc", ".docx"};

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect("login");
            return;
        }

        request.getRequestDispatcher("uploadPaper.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect("login");
            return;
        }

        String title = request.getParameter("title");
        String abstractText = request.getParameter("abstract");
        Part filePart = request.getPart("paperFile");

        // Validate input
        if (title == null || title.trim().isEmpty()) {
            request.setAttribute("error", "Paper title is required");
            request.getRequestDispatcher("uploadPaper.jsp").forward(request, response);
            return;
        }

        if (abstractText == null || abstractText.trim().isEmpty()) {
            request.setAttribute("error", "Abstract is required");
            request.getRequestDispatcher("uploadPaper.jsp").forward(request, response);
            return;
        }

        if (filePart == null || filePart.getSize() == 0) {
            request.setAttribute("error", "Please select a file to upload");
            request.getRequestDispatcher("uploadPaper.jsp").forward(request, response);
            return;
        }

        // Validate file
        String fileName = getSubmittedFileName(filePart);
        if (!isValidFile(fileName)) {
            request.setAttribute("error", "Please upload a PDF, DOC, or DOCX file");
            request.getRequestDispatcher("uploadPaper.jsp").forward(request, response);
            return;
        }

        try {
            // Create upload directory if it doesn't exist
            String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            // Generate unique filename
            String fileExtension = getFileExtension(fileName);
            String uniqueFileName = System.currentTimeMillis() + "_" +
                                  currentUser.getUserId() + "_" +
                                  sanitizeFileName(fileName);

            String relativePath = UPLOAD_DIR + File.separator + uniqueFileName;
            String fullPath = uploadPath + File.separator + uniqueFileName;

            // Save file
            Files.copy(filePart.getInputStream(), Paths.get(fullPath),
                      StandardCopyOption.REPLACE_EXISTING);

            // Save paper information to database
            Connection conn = null;
            try {
                conn = DatabaseUtil.getConnection();
                PaperDAO paperDAO = new PaperDAO(conn);

                Paper paper = new Paper(title.trim(), abstractText.trim(),
                                      relativePath, currentUser.getUserId());

                if (paperDAO.submitPaper(paper)) {
                    response.sendRedirect("listPapers?msg=Paper submitted successfully");
                } else {
                    // Delete uploaded file if database insert fails
                    Files.deleteIfExists(Paths.get(fullPath));
                    request.setAttribute("error", "Failed to submit paper. Please try again.");
                    request.getRequestDispatcher("uploadPaper.jsp").forward(request, response);
                }

            } catch (SQLException e) {
                e.printStackTrace();
                // Delete uploaded file if database error occurs
                Files.deleteIfExists(Paths.get(fullPath));
                request.setAttribute("error", "Database error occurred. Please try again.");
                request.getRequestDispatcher("uploadPaper.jsp").forward(request, response);
            } finally {
                DatabaseUtil.closeConnection(conn);
            }

        } catch (IOException e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to save file. Please try again.");
            request.getRequestDispatcher("uploadPaper.jsp").forward(request, response);
        }
    }

    private String getSubmittedFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        for (String content : contentDisposition.split(";")) {
            if (content.trim().startsWith("filename")) {
                return content.substring(content.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return null;
    }

    private boolean isValidFile(String fileName) {
        if (fileName == null || fileName.trim().isEmpty()) {
            return false;
        }

        String lowerFileName = fileName.toLowerCase();
        for (String ext : ALLOWED_EXTENSIONS) {
            if (lowerFileName.endsWith(ext)) {
                return true;
            }
        }
        return false;
    }

    private String getFileExtension(String fileName) {
        int lastIndexOfDot = fileName.lastIndexOf('.');
        if (lastIndexOfDot == -1) {
            return "";
        }
        return fileName.substring(lastIndexOfDot);
    }

    private String sanitizeFileName(String fileName) {
        // Remove any potentially dangerous characters
        return fileName.replaceAll("[^a-zA-Z0-9._-]", "_");
    }
}
