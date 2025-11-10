package com.example.model;

import java.sql.Date;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * Paper model representing research papers in the system
 */
public class Paper {
    private int paperId;
    private String title;
    private String abstractText;
    private String filePath;
    private int submittedBy; // user_id of the author
    private String status; // submitted, under review, accepted, rejected
    private Date submissionDate;

    // Additional fields for display purposes
    private String authorName;
    private String authorEmail;

    // Status constants
    public static final String STATUS_SUBMITTED = "submitted";
    public static final String STATUS_UNDER_REVIEW = "under review";
    public static final String STATUS_ACCEPTED = "accepted";
    public static final String STATUS_REJECTED = "rejected";

    // Default constructor
    public Paper() {
        this.submissionDate = new Date(System.currentTimeMillis());
        this.status = STATUS_SUBMITTED;
    }

    // Constructor with all fields
    public Paper(int paperId, String title, String abstractText, String filePath,
                 int submittedBy, String status, Date submissionDate) {
        this.paperId = paperId;
        this.title = title;
        this.abstractText = abstractText;
        this.filePath = filePath;
        this.submittedBy = submittedBy;
        this.status = status;
        this.submissionDate = submissionDate;
    }

    // Constructor for new paper creation
    public Paper(String title, String abstractText, String filePath, int submittedBy) {
        this.title = title;
        this.abstractText = abstractText;
        this.filePath = filePath;
        this.submittedBy = submittedBy;
        this.status = STATUS_SUBMITTED;
        this.submissionDate = new Date(System.currentTimeMillis());
    }

    // Getters and Setters
    public int getPaperId() {
        return paperId;
    }

    public void setPaperId(int paperId) {
        this.paperId = paperId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getAbstractText() {
        return abstractText;
    }

    public void setAbstractText(String abstractText) {
        this.abstractText = abstractText;
    }

    public String getFilePath() {
        return filePath;
    }

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    public int getSubmittedBy() {
        return submittedBy;
    }

    public void setSubmittedBy(int submittedBy) {
        this.submittedBy = submittedBy;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getSubmissionDate() {
        return submissionDate;
    }

    public void setSubmissionDate(Date submissionDate) {
        this.submissionDate = submissionDate;
    }

    public String getAuthorName() {
        return authorName;
    }

    public void setAuthorName(String authorName) {
        this.authorName = authorName;
    }

    public String getAuthorEmail() {
        return authorEmail;
    }

    public void setAuthorEmail(String authorEmail) {
        this.authorEmail = authorEmail;
    }

    // Utility methods
    public String getStatusDisplayName() {
        if (status == null) return "Unknown";
        return status.substring(0, 1).toUpperCase() + status.substring(1);
    }

    public String getStatusBadgeClass() {
        if (status == null) return "badge";
        switch (status.toLowerCase()) {
            case STATUS_SUBMITTED:
                return "badge submitted";
            case STATUS_UNDER_REVIEW:
                return "badge under_review";
            case STATUS_ACCEPTED:
                return "badge accepted";
            case STATUS_REJECTED:
                return "badge rejected";
            default:
                return "badge";
        }
    }

    public String getFormattedSubmissionDate() {
        if (submissionDate == null) return "";
        return submissionDate.toString();
    }

    public boolean isEditable() {
        return STATUS_SUBMITTED.equals(status);
    }

    public boolean canBeReviewed() {
        return STATUS_SUBMITTED.equals(status) || STATUS_UNDER_REVIEW.equals(status);
    }

    public String getFileName() {
        if (filePath == null || filePath.isEmpty()) return "No file";
        String[] parts = filePath.split("/");
        return parts[parts.length - 1];
    }

    public String getShortAbstract(int maxLength) {
        if (abstractText == null) return "";
        if (abstractText.length() <= maxLength) return abstractText;
        return abstractText.substring(0, maxLength) + "...";
    }

    @Override
    public String toString() {
        return "Paper{" +
                "paperId=" + paperId +
                ", title='" + title + '\'' +
                ", status='" + status + '\'' +
                ", submittedBy=" + submittedBy +
                ", submissionDate=" + submissionDate +
                '}';
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        Paper paper = (Paper) obj;
        return paperId == paper.paperId;
    }

    @Override
    public int hashCode() {
        return Integer.hashCode(paperId);
    }
}
