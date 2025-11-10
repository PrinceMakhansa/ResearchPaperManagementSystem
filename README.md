# Research Repository System

A comprehensive web application for managing research paper submissions and peer review processes, built with Java Servlets, JSP, and MySQL.

## 🎯 Features

### For Students
- **Paper Submission**: Upload research papers with metadata
- **Submission Tracking**: Monitor paper status throughout review process
- **Personal Dashboard**: View submission statistics and recent activity
- **File Management**: Support for PDF, DOC, and DOCX formats

### For Faculty
- **Paper Review**: Comprehensive review workflow
- **Status Management**: Update paper status (submitted, under review, accepted, rejected)
- **Faculty Dashboard**: Advanced analytics and workload management
- **Batch Operations**: Efficient handling of multiple submissions

### General Features
- **User Authentication**: Secure login system with role-based access
- **Responsive Design**: Modern, mobile-friendly interface
- **Search & Filter**: Advanced paper discovery capabilities
- **Real-time Updates**: Dynamic status tracking and notifications

## 🏗️ Architecture

### Technology Stack
- **Backend**: Java Servlets, JSP, Spring
- **Database**: MySQL 8.0
- **Frontend**: HTML5, CSS3, JavaScript
- **Server**: Apache Tomcat 9.0
- **Build Tool**: Apache Ant

### Project Structure
```
project/
├── src/java/com/example/
│   ├── model/           # Data models (User, Paper)
│   ├── dao/             # Data Access Objects
│   ├── servlet/         # HTTP request handlers
│   └── util/            # Utility classes
├── web/
│   ├── css/             # Stylesheets
│   ├── WEB-INF/         # Configuration files
│   └── *.jsp            # View templates
├── database-setup.sql   # Database schema
└── build.xml           # Ant build configuration
```

## 🚀 Quick Start

### Prerequisites
- Java JDK 8 or higher
- Apache Tomcat 9.0+
- MySQL 8.0+
- Apache Ant

### Database Setup
1. Start MySQL server
2. Run the setup script:
   ```sql
   mysql -u root -p < database-setup.sql
   ```

### Application Deployment
1. Clone the repository
2. Build the application:
   ```bash
   ant clean compile dist
   ```
3. Deploy the WAR file to Tomcat:
   ```bash
   cp dist/project.war $TOMCAT_HOME/webapps/
   ```
4. Start Tomcat server
5. Access the application: `http://localhost:8080/project`

### Default Accounts
- **Student**: `student@test.com` / `password`
- **Faculty**: `faculty@test.com` / `password`
- **Admin**: `admin@test.com` / `password`

## 📋 Usage Guide

### Student Workflow
1. **Register/Login**: Create account or use demo credentials
2. **Submit Paper**: Upload research paper with title and abstract
3. **Track Progress**: Monitor review status on dashboard
4. **View Results**: Access final review decisions

### Faculty Workflow
1. **Login**: Access faculty dashboard
2. **Review Queue**: View papers pending review
3. **Review Process**: Evaluate submissions and update status
4. **Manage Workload**: Track review statistics and deadlines

### Paper Statuses
- **Submitted**: Initial submission, awaiting review
- **Under Review**: Currently being evaluated
- **Accepted**: Approved for publication
- **Rejected**: Not accepted for publication

## 🔧 Configuration

### Database Connection
Update database credentials in `DatabaseUtil.java`:
```java
private static final String URL = "jdbc:mysql://localhost:3306/research_repo";
private static final String USERNAME = "root";
private static final String PASSWORD = "your_password";
```

### File Upload Settings
Configure in `UploadPaperServlet.java`:
```java
@MultipartConfig(maxFileSize = 10 * 1024 * 1024) // 10MB limit
```

### Session Timeout
Modify in `web.xml`:
```xml
<session-config>
    <session-timeout>30</session-timeout> <!-- minutes -->
</session-config>
```

## 🎨 Styling & UI

### CSS Architecture
- **CSS Custom Properties**: Consistent theming system
- **Responsive Grid**: Mobile-first design approach
- **Component Library**: Reusable UI components
- **Modern Animations**: Smooth transitions and interactions

### Key Components
- Navigation bars with role-based menus
- Statistics cards with real-time data
- Interactive forms with validation
- Status badges and progress indicators

## 📊 Database Schema

### Users Table
```sql
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('student', 'faculty', 'admin'),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Papers Table
```sql
CREATE TABLE papers (
    paper_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
    abstract TEXT,
    file_path VARCHAR(200),
    submitted_by INT,
    status ENUM('submitted', 'under review', 'accepted', 'rejected'),
    submission_date DATE,
    FOREIGN KEY (submitted_by) REFERENCES users(user_id)
);
```

## 🔒 Security Features

- **Input Validation**: Comprehensive server-side validation
- **File Type Restrictions**: Only PDF, DOC, DOCX allowed
- **Size Limits**: Maximum 10MB per file
- **SQL Injection Prevention**: Parameterized queries
- **Session Management**: Secure session handling
- **Role-Based Access**: Different permissions for users

## 🧪 Testing

### Manual Testing
1. Test user registration and login
2. Verify paper submission workflow
3. Test faculty review process
4. Validate search and filter functionality
5. Check responsive design across devices

### Test Data
The database setup includes sample users and papers for testing:
- Multiple user roles
- Various paper statuses
- Realistic content for demo purposes

## 🚨 Troubleshooting

### Common Issues

**Database Connection Failed**
- Verify MySQL server is running
- Check database credentials
- Ensure database exists

**File Upload Errors**
- Check file size (max 10MB)
- Verify file format (PDF, DOC, DOCX)
- Ensure uploads directory exists

**Session Timeout**
- Increase session timeout in web.xml
- Check server clock synchronization

**Compilation Errors**
- Verify Java JDK version
- Check classpath configuration
- Ensure all dependencies are available

## 📝 Development Notes

### Code Standards
- Follow Java naming conventions
- Use descriptive variable names
- Include comprehensive comments
- Implement proper error handling

### Performance Considerations
- Database connection pooling recommended for production
- Implement caching for frequently accessed data
- Optimize file storage for large deployments
- Consider CDN for static assets

## 🤝 Contributing

### Development Setup
1. Fork the repository
2. Set up local development environment
3. Create feature branch
4. Implement changes with tests
5. Submit pull request

### Code Review Guidelines
- Ensure all tests pass
- Follow existing code style
- Include proper documentation
- Verify security implications

## 🆘 Support

For issues and questions:
- Check troubleshooting section
- Review database setup
- Verify server configuration
- Contact system administrator

---

*Built with ❤️ for academic research management*
