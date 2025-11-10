package com.example.model;

import java.sql.Timestamp;
import java.time.LocalDateTime;

/**
 * User model representing system users (students, faculty, admin)
 */
public class User {
    private int userId;
    private String name;
    private String email;
    private String password;
    private String role; // student, faculty, admin
    private Timestamp createdAt;

    // Default constructor
    public User() {
        this.createdAt = Timestamp.valueOf(LocalDateTime.now());
    }

    // Constructor with all fields
    public User(int userId, String name, String email, String password, String role, Timestamp createdAt) {
        this.userId = userId;
        this.name = name;
        this.email = email;
        this.password = password;
        this.role = role;
        this.createdAt = createdAt;
    }

    // Constructor for new user creation
    public User(String name, String email, String password, String role) {
        this.name = name;
        this.email = email;
        this.password = password;
        this.role = role;
        this.createdAt = Timestamp.valueOf(LocalDateTime.now());
    }

    // Getters and Setters
    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    // Utility methods
    public boolean isStudent() {
        return "student".equalsIgnoreCase(this.role);
    }

    public boolean isFaculty() {
        return "faculty".equalsIgnoreCase(this.role);
    }

    public boolean isAdmin() {
        return "admin".equalsIgnoreCase(this.role);
    }

    public String getDisplayRole() {
        if (role == null) return "Unknown";
        return role.substring(0, 1).toUpperCase() + role.substring(1).toLowerCase();
    }

    @Override
    public String toString() {
        return "User{" +
                "userId=" + userId +
                ", name='" + name + '\'' +
                ", email='" + email + '\'' +
                ", role='" + role + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        User user = (User) obj;
        return userId == user.userId;
    }

    @Override
    public int hashCode() {
        return Integer.hashCode(userId);
    }
}
