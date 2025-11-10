package com.example.dao;

import com.example.model.Paper;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Data Access Object for Paper operations
 */
public class PaperDAO {
    private Connection connection;

    public PaperDAO(Connection connection) {
        this.connection = connection;
    }

    /**
     * Submit a new paper
     */
    public boolean submitPaper(Paper paper) throws SQLException {
        String sql = "INSERT INTO papers (title, abstract, file_path, submitted_by, status, submission_date) VALUES (?, ?, ?, ?, ?, ?)";

        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, paper.getTitle());
            stmt.setString(2, paper.getAbstractText());
            stmt.setString(3, paper.getFilePath());
            stmt.setInt(4, paper.getSubmittedBy());
            stmt.setString(5, paper.getStatus());
            stmt.setDate(6, paper.getSubmissionDate());

            int rowsAffected = stmt.executeUpdate();

            if (rowsAffected > 0) {
                // Get the generated paper ID
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        paper.setPaperId(generatedKeys.getInt(1));
                    }
                }
                return true;
            }
            return false;
        }
    }

    /**
     * Get paper by ID
     */
    public Paper findById(int paperId) throws SQLException {
        String sql = "SELECT p.*, u.name as author_name, u.email as author_email " +
                     "FROM papers p JOIN users u ON p.submitted_by = u.user_id " +
                     "WHERE p.paper_id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, paperId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToPaper(rs);
                }
            }
        }
        return null;
    }

    /**
     * Get papers by author (user ID)
     */
    public List<Paper> findByAuthor(int userId) throws SQLException {
        String sql = "SELECT p.*, u.name as author_name, u.email as author_email " +
                     "FROM papers p JOIN users u ON p.submitted_by = u.user_id " +
                     "WHERE p.submitted_by = ? ORDER BY p.submission_date DESC";

        return getPapersFromQuery(sql, userId);
    }

    /**
     * Get papers by status
     */
    public List<Paper> findByStatus(String status) throws SQLException {
        String sql = "SELECT p.*, u.name as author_name, u.email as author_email " +
                     "FROM papers p JOIN users u ON p.submitted_by = u.user_id " +
                     "WHERE p.status = ? ORDER BY p.submission_date DESC";

        return getPapersFromQuery(sql, status);
    }

    /**
     * Get all papers
     */
    public List<Paper> findAll() throws SQLException {
        String sql = "SELECT p.*, u.name as author_name, u.email as author_email " +
                     "FROM papers p JOIN users u ON p.submitted_by = u.user_id " +
                     "ORDER BY p.submission_date DESC";

        List<Paper> papers = new ArrayList<>();

        try (PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                papers.add(mapResultSetToPaper(rs));
            }
        }
        return papers;
    }

    /**
     * Update paper status
     */
    public boolean updateStatus(int paperId, String newStatus) throws SQLException {
        String sql = "UPDATE papers SET status = ? WHERE paper_id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, newStatus);
            stmt.setInt(2, paperId);

            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Update paper details (title, abstract, file path)
     */
    public boolean updatePaper(Paper paper) throws SQLException {
        String sql = "UPDATE papers SET title = ?, abstract = ?, file_path = ? WHERE paper_id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, paper.getTitle());
            stmt.setString(2, paper.getAbstractText());
            stmt.setString(3, paper.getFilePath());
            stmt.setInt(4, paper.getPaperId());

            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Delete paper by ID
     */
    public boolean deletePaper(int paperId) throws SQLException {
        String sql = "DELETE FROM papers WHERE paper_id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, paperId);

            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Get paper count by status for a specific author
     */
    public Map<String, Integer> getStatusCountsByAuthor(int userId) throws SQLException {
        String sql = "SELECT status, COUNT(*) as count FROM papers WHERE submitted_by = ? GROUP BY status";
        Map<String, Integer> statusCounts = new HashMap<>();

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    statusCounts.put(rs.getString("status"), rs.getInt("count"));
                }
            }
        }
        return statusCounts;
    }

    /**
     * Get overall paper count by status (for faculty/admin dashboard)
     */
    public Map<String, Integer> getOverallStatusCounts() throws SQLException {
        String sql = "SELECT status, COUNT(*) as count FROM papers GROUP BY status";
        Map<String, Integer> statusCounts = new HashMap<>();

        try (PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                statusCounts.put(rs.getString("status"), rs.getInt("count"));
            }
        }
        return statusCounts;
    }

    /**
     * Get total paper count
     */
    public int getTotalPaperCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM papers";

        try (PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    /**
     * Search papers by title or abstract
     */
    public List<Paper> searchPapers(String searchTerm) throws SQLException {
        String sql = "SELECT p.*, u.name as author_name, u.email as author_email " +
                     "FROM papers p JOIN users u ON p.submitted_by = u.user_id " +
                     "WHERE p.title LIKE ? OR p.abstract LIKE ? " +
                     "ORDER BY p.submission_date DESC";

        List<Paper> papers = new ArrayList<>();
        String searchPattern = "%" + searchTerm + "%";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    papers.add(mapResultSetToPaper(rs));
                }
            }
        }
        return papers;
    }

    /**
     * Get recent papers (last N papers)
     */
    public List<Paper> getRecentPapers(int limit) throws SQLException {
        String sql = "SELECT p.*, u.name as author_name, u.email as author_email " +
                     "FROM papers p JOIN users u ON p.submitted_by = u.user_id " +
                     "ORDER BY p.submission_date DESC LIMIT ?";

        List<Paper> papers = new ArrayList<>();

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, limit);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    papers.add(mapResultSetToPaper(rs));
                }
            }
        }
        return papers;
    }

    /**
     * Helper method to execute queries with a single parameter
     */
    private List<Paper> getPapersFromQuery(String sql, Object parameter) throws SQLException {
        List<Paper> papers = new ArrayList<>();

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            if (parameter instanceof Integer) {
                stmt.setInt(1, (Integer) parameter);
            } else if (parameter instanceof String) {
                stmt.setString(1, (String) parameter);
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    papers.add(mapResultSetToPaper(rs));
                }
            }
        }
        return papers;
    }

    /**
     * Map ResultSet to Paper object
     */
    private Paper mapResultSetToPaper(ResultSet rs) throws SQLException {
        Paper paper = new Paper(
            rs.getInt("paper_id"),
            rs.getString("title"),
            rs.getString("abstract"),
            rs.getString("file_path"),
            rs.getInt("submitted_by"),
            rs.getString("status"),
            rs.getDate("submission_date")
        );

        // Set additional author information if available
        try {
            paper.setAuthorName(rs.getString("author_name"));
            paper.setAuthorEmail(rs.getString("author_email"));
        } catch (SQLException e) {
            // These columns might not be available in all queries
        }

        return paper;
    }
}
