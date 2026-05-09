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
        .upload-section { max-width: 700px; }
        .upload-requirements {
            background: var(--color-bg);
            border: 1px solid var(--color-border);
            border-radius: var(--radius);
            padding: var(--space-4);
            margin-bottom: var(--space-6);
        }
        .upload-requirements h4 { margin-bottom: var(--space-2); }
        .upload-requirements ul {
            margin: 0;
            padding-left: var(--space-5);
            color: var(--color-text-muted);
            font-size: var(--text-sm);
        }
        .upload-requirements li { margin-bottom: var(--space-1); }
        .file-drop {
            border: 2px dashed var(--color-border-strong);
            border-radius: var(--radius-lg);
            padding: var(--space-8);
            text-align: center;
            cursor: pointer;
            transition: all 0.15s ease;
            background: var(--color-bg);
        }
        .file-drop:hover { border-color: var(--color-primary); }
        .file-drop.dragover { border-color: var(--color-primary); background: var(--color-primary-light); }
        .file-drop svg { width: 48px; height: 48px; color: var(--color-text-muted); margin-bottom: var(--space-4); }
        .file-drop h4 { margin-bottom: var(--space-2); }
        .file-drop small { color: var(--color-text-muted); }
        .file-info-box {
            margin-top: var(--space-4);
            padding: var(--space-4);
            border-radius: var(--radius);
            display: none;
        }
        .file-info-box.success { background: var(--color-success-light); border: 1px solid var(--color-success); }
        .file-info-box.error { background: var(--color-danger-light); border: 1px solid var(--color-danger); }
        .file-info-box small { color: var(--color-text-muted); }
        .char-count { font-size: var(--text-xs); color: var(--color-text-muted); text-align: right; margin-top: var(--space-1); }
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
            <li><a href="uploadPaper" class="active">Upload Paper</a></li>
            <li><a href="logout">Logout</a></li>
        </ul>
    </div>
</nav>

<main class="container">
    <div class="upload-section">
        <h2 style="margin-bottom: var(--space-2);">Upload Research Paper</h2>
        <p style="color: var(--color-text-muted); margin-bottom: var(--space-6);">Submit your paper for review</p>

        <% String error = (String) request.getAttribute("error");
           String msg = request.getParameter("msg");
           if (error != null) { %>
            <div class="alert alert-error"><%= error %></div>
        <% } %>
        <% if (msg != null) { %>
            <div class="alert alert-success"><%= msg %></div>
        <% } %>

        <div class="upload-requirements">
            <h4>Requirements</h4>
            <ul>
                <li>Format: PDF, DOC, or DOCX</li>
                <li>Maximum file size: 10MB</li>
                <li>Title: Max 200 characters</li>
                <li>Abstract: Max 2000 characters</li>
            </ul>
        </div>

        <form action="uploadPaper" method="post" enctype="multipart/form-data" id="uploadForm">
            <div class="form-group">
                <label class="form-label" for="title">Paper Title</label>
                <input class="form-input" id="title" type="text" name="title" required maxlength="200"
                       placeholder="Enter the title of your research paper" />
                <div class="char-count" id="titleCount">0 / 200</div>
            </div>

            <div class="form-group">
                <label class="form-label" for="abstract">Abstract</label>
                <textarea class="form-textarea" id="abstract" name="abstract" rows="6" required maxlength="2000"
                          placeholder="Summarize your research objectives, methodology, and key findings..."></textarea>
                <div class="char-count" id="abstractCount">0 / 2000</div>
            </div>

            <div class="form-group">
                <label class="form-label">Paper File</label>
                <div class="file-drop" id="fileDrop">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12" />
                    </svg>
                    <h4>Click or drag to upload</h4>
                    <small>PDF, DOC, DOCX (Max 10MB)</small>
                    <input id="paperFile" type="file" name="paperFile" accept=".pdf,.doc,.docx" style="display: none;" required />
                </div>
                <div class="file-info-box" id="fileSuccess">
                    <strong>Selected:</strong> <span id="fileName"></span>
                    <br><small>Size: <span id="fileSize"></span></small>
                </div>
                <div class="file-info-box error" id="fileError">
                    <strong>Error:</strong> <span id="errorMsg"></span>
                </div>
            </div>

            <div style="display: flex; gap: var(--space-3); margin-top: var(--space-6);">
                <button type="submit" class="btn btn-primary btn-lg" id="submitBtn">Submit for Review</button>
                <a href="dashboard" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </div>
</main>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const fileInput = document.getElementById('paperFile');
    const fileDrop = document.getElementById('fileDrop');
    const fileSuccess = document.getElementById('fileSuccess');
    const fileError = document.getElementById('fileError');
    const titleInput = document.getElementById('title');
    const abstractInput = document.getElementById('abstract');
    const submitBtn = document.getElementById('submitBtn');

    // Character count
    titleInput.addEventListener('input', function() {
        document.getElementById('titleCount').textContent = this.value.length + ' / 200';
    });
    abstractInput.addEventListener('input', function() {
        document.getElementById('abstractCount').textContent = this.value.length + ' / 2000';
    });

    // File validation
    function validateFile(file) {
        const maxSize = 10 * 1024 * 1024;
        const validExts = ['.pdf', '.doc', '.docx'];
        const ext = '.' + file.name.split('.').pop().toLowerCase();

        if (!validExts.includes(ext)) {
            return 'Invalid file type. Use PDF, DOC, or DOCX.';
        }
        if (file.size > maxSize) {
            return 'File too large. Maximum 10MB.';
        }
        return null;
    }

    function formatSize(bytes) {
        if (bytes < 1024) return bytes + ' B';
        if (bytes < 1048576) return (bytes / 1024).toFixed(1) + ' KB';
        return (bytes / 1048576).toFixed(1) + ' MB';
    }

    function showFile(file) {
        document.getElementById('fileName').textContent = file.name;
        document.getElementById('fileSize').textContent = formatSize(file.size);
        fileSuccess.style.display = 'block';
        fileError.style.display = 'none';
        submitBtn.disabled = false;
    }

    function showErr(msg) {
        document.getElementById('errorMsg').textContent = msg;
        fileError.style.display = 'block';
        fileSuccess.style.display = 'none';
        submitBtn.disabled = true;
    }

    fileInput.addEventListener('change', function() {
        if (this.files[0]) {
            const err = validateFile(this.files[0]);
            if (err) showErr(err);
            else showFile(this.files[0]);
        }
    });

    // Drag & drop
    fileDrop.addEventListener('click', () => fileInput.click());
    fileDrop.addEventListener('dragover', (e) => { e.preventDefault(); fileDrop.classList.add('dragover'); });
    fileDrop.addEventListener('dragleave', () => fileDrop.classList.remove('dragover'));
    fileDrop.addEventListener('drop', (e) => {
        e.preventDefault();
        fileDrop.classList.remove('dragover');
        if (e.dataTransfer.files[0]) {
            fileInput.files = e.dataTransfer.files;
            const err = validateFile(e.dataTransfer.files[0]);
            if (err) showErr(err);
            else showFile(e.dataTransfer.files[0]);
        }
    });

    // Submit
    document.getElementById('uploadForm').addEventListener('submit', function() {
        submitBtn.textContent = 'Uploading...';
        submitBtn.disabled = true;
    });
});
</script>

</body>
</html>