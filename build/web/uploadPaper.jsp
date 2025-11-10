<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.model.User" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) {
        response.sendRedirect("login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Upload Paper - Research Repository</title>
    <link rel="stylesheet" href="css/styles.css" />
    <style>
        .file-upload-area {
            border: 2px dashed var(--border-strong);
            border-radius: var(--radius-lg);
            padding: 2rem;
            text-align: center;
            background: var(--bg-alt);
            transition: all 0.2s ease;
            cursor: pointer;
        }
        .file-upload-area:hover {
            border-color: var(--primary);
            background: var(--primary-light);
        }
        .file-upload-area.dragover {
            border-color: var(--primary);
            background: var(--primary-light);
            transform: scale(1.02);
        }
        .file-info {
            margin-top: 1rem;
            padding: 1rem;
            background: var(--success-light);
            border: 1px solid var(--success);
            border-radius: var(--radius);
            display: none;
        }
        .file-error {
            margin-top: 1rem;
            padding: 1rem;
            background: var(--danger-light);
            border: 1px solid var(--danger);
            border-radius: var(--radius);
            display: none;
        }
        .upload-icon {
            font-size: 3rem;
            color: var(--primary);
            margin-bottom: 1rem;
            display: block;
        }
        .form-requirements {
            background: var(--bg-alt);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            padding: 1rem;
            margin-bottom: 2rem;
        }
        .requirements-title {
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: var(--text);
        }
        .requirements-list {
            margin: 0;
            padding-left: 1.5rem;
            color: var(--text-light);
        }
        .form-preview {
            background: var(--bg-alt);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            padding: 1rem;
            margin-top: 1rem;
            display: none;
        }
        .preview-title {
            font-weight: 600;
            margin-bottom: 0.5rem;
        }
        .character-count {
            font-size: 0.875rem;
            color: var(--text-muted);
            text-align: right;
            margin-top: 0.25rem;
        }
    </style>
</head>
<body>
<nav class="site-nav">
    <div class="inner">
        <h1>Research Repository</h1>
        <ul>
            <li><a href="dashboard">Dashboard</a></li>
            <li><a href="listPapers">My Papers</a></li>
            <li><a href="allPapers">All Papers</a></li>
            <li><a href="uploadPaper">Upload Paper</a></li>
            <li><a href="logout">Logout</a></li>
        </ul>
    </div>
</nav>

<div class="container">
    <h2 class="mt-0">Upload Research Paper</h2>
    <p class="text-muted">Submit your research paper for review and publication in our repository.</p>

    <% String error = (String) request.getAttribute("error");
       String msg = request.getParameter("msg");
       if (error != null) { %>
        <div class="alert alert-error"><%= error %></div>
    <% } %>
    <% if (msg != null) { %>
        <div class="alert alert-success"><%= msg %></div>
    <% } %>

    <div class="form-requirements">
        <div class="requirements-title">Submission Requirements:</div>
        <ul class="requirements-list">
            <li>Paper must be in PDF, DOC, or DOCX format</li>
            <li>Maximum file size: 10MB</li>
            <li>Title should be descriptive and concise</li>
            <li>Abstract should summarize key findings (recommended 150-300 words)</li>
            <li>All submissions undergo peer review process</li>
        </ul>
    </div>

    <form action="uploadPaper" method="post" enctype="multipart/form-data" class="form-grid" style="max-width:800px;" id="uploadForm">
        <div class="form-row">
            <label for="title">Paper Title</label>
            <input id="title" type="text" name="title" required maxlength="200"
                   placeholder="Enter the title of your research paper" />
            <div class="character-count" id="titleCount">0/200 characters</div>
        </div>

        <div class="form-row">
            <label for="abstract">Abstract</label>
            <textarea id="abstract" name="abstract" rows="8" required maxlength="2000"
                      placeholder="Provide a comprehensive abstract that summarizes your research objectives, methodology, key findings, and conclusions."></textarea>
            <div class="character-count" id="abstractCount">0/2000 characters</div>
        </div>

        <div class="form-row">
            <label for="paperFile">Upload Paper File</label>
            <div class="file-upload-area" onclick="document.getElementById('paperFile').click()">
                <input id="paperFile" type="file" name="paperFile" accept=".pdf,.doc,.docx" style="display: none;" required />
                <div class="upload-content">
                    <div><strong>Click to select</strong> or drag and drop your paper file here</div>
                    <small class="text-muted">Supported formats: PDF, DOC, DOCX (Max: 10MB)</small>
                </div>
            </div>
            <div class="file-info" id="fileInfo">
                <strong>Selected File:</strong> <span id="fileName"></span><br>
                <small>Size: <span id="fileSize"></span></small>
            </div>
            <div class="file-error" id="fileError">
                <strong>Error:</strong> <span id="errorMessage"></span>
            </div>
        </div>

        <div class="form-preview" id="formPreview">
            <div class="preview-title">Submission Preview:</div>
            <div><strong>Title:</strong> <span id="previewTitle">-</span></div>
            <div><strong>Abstract:</strong> <span id="previewAbstract">-</span></div>
            <div><strong>File:</strong> <span id="previewFile">-</span></div>
            <div><strong>Author:</strong> <%= currentUser.getName() %> (<%= currentUser.getEmail() %>)</div>
        </div>

        <div class="form-row">
            <button type="submit" class="btn btn-large" id="submitBtn">Submit Paper for Review</button>
        </div>

        <div class="form-row">
            <a href="dashboard" class="btn btn-soft">Back to Dashboard</a>
        </div>
    </form>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const fileInput = document.getElementById('paperFile');
    const uploadArea = document.querySelector('.file-upload-area');
    const fileInfo = document.getElementById('fileInfo');
    const fileError = document.getElementById('fileError');
    const submitBtn = document.getElementById('submitBtn');
    const titleInput = document.getElementById('title');
    const abstractInput = document.getElementById('abstract');
    const formPreview = document.getElementById('formPreview');

    // File size limit (10MB)
    const maxSize = 10 * 1024 * 1024;
    const allowedTypes = ['application/pdf', 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'];
    const allowedExtensions = ['.pdf', '.doc', '.docx'];

    // Character counting
    function updateCharacterCount(input, countElement, max) {
        const count = input.value.length;
        countElement.textContent = count + '/' + max + ' characters';
        if (count > max * 0.9) {
            countElement.style.color = 'var(--warning)';
        } else {
            countElement.style.color = 'var(--text-muted)';
        }
    }

    titleInput.addEventListener('input', function() {
        updateCharacterCount(this, document.getElementById('titleCount'), 200);
        updatePreview();
    });

    abstractInput.addEventListener('input', function() {
        updateCharacterCount(this, document.getElementById('abstractCount'), 2000);
        updatePreview();
    });

    // File handling
    function showFileInfo(file) {
        document.getElementById('fileName').textContent = file.name;
        document.getElementById('fileSize').textContent = formatFileSize(file.size);
        fileInfo.style.display = 'block';
        fileError.style.display = 'none';
        submitBtn.disabled = false;
        updatePreview();
    }

    function showError(message) {
        document.getElementById('errorMessage').textContent = message;
        fileError.style.display = 'block';
        fileInfo.style.display = 'none';
        submitBtn.disabled = true;
    }

    function validateFile(file) {
        const fileName = file.name.toLowerCase();
        const hasValidExtension = allowedExtensions.some(ext => fileName.endsWith(ext));

        if (!allowedTypes.includes(file.type) && !hasValidExtension) {
            showError('Please select a PDF, DOC, or DOCX file.');
            return false;
        }

        if (file.size > maxSize) {
            showError('File size exceeds 10MB limit. Please select a smaller file.');
            return false;
        }

        if (file.size === 0) {
            showError('The selected file appears to be empty.');
            return false;
        }

        return true;
    }

    function formatFileSize(bytes) {
        if (bytes === 0) return '0 Bytes';
        const k = 1024;
        const sizes = ['Bytes', 'KB', 'MB', 'GB'];
        const i = Math.floor(Math.log(bytes) / Math.log(k));
        return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
    }

    function updatePreview() {
        const title = titleInput.value.trim();
        const abstract = abstractInput.value.trim();
        const file = fileInput.files[0];

        document.getElementById('previewTitle').textContent = title || '-';
        document.getElementById('previewAbstract').textContent = abstract || '-';
        document.getElementById('previewFile').textContent = file ? file.name : '-';

        if (title || abstract || file) {
            formPreview.style.display = 'block';
        } else {
            formPreview.style.display = 'none';
        }
    }

    // File input events
    fileInput.addEventListener('change', function() {
        const file = this.files[0];
        if (file && validateFile(file)) {
            showFileInfo(file);
        }
    });

    // Drag and drop events
    uploadArea.addEventListener('dragover', function(e) {
        e.preventDefault();
        uploadArea.classList.add('dragover');
    });

    uploadArea.addEventListener('dragleave', function(e) {
        e.preventDefault();
        uploadArea.classList.remove('dragover');
    });

    uploadArea.addEventListener('drop', function(e) {
        e.preventDefault();
        uploadArea.classList.remove('dragover');

        const files = e.dataTransfer.files;
        if (files.length > 0) {
            const file = files[0];
            if (validateFile(file)) {
                fileInput.files = e.dataTransfer.files;
                showFileInfo(file);
            }
        }
    });

    // Form validation
    document.getElementById('uploadForm').addEventListener('submit', function(e) {
        const title = titleInput.value.trim();
        const abstract = abstractInput.value.trim();
        const file = fileInput.files[0];

        if (!title) {
            e.preventDefault();
            titleInput.focus();
            showError('Please enter a paper title.');
            return false;
        }

        if (!abstract) {
            e.preventDefault();
            abstractInput.focus();
            showError('Please provide an abstract.');
            return false;
        }

        if (!file) {
            e.preventDefault();
            showError('Please select a file to upload.');
            return false;
        }

        // Show loading state
        submitBtn.innerHTML = 'Uploading...';
        submitBtn.disabled = true;
    });

    // Auto-focus title field
    titleInput.focus();
});
</script>

</body>
</html>
