// Toggle password visibility
function togglePassword() {
    const passwordInput = document.getElementById('password');
    const toggleIcon = document.getElementById('toggleIcon');
    
    if (passwordInput.type === 'password') {
        passwordInput.type = 'text';
        toggleIcon.className = 'fas fa-eye-slash';
    } else {
        passwordInput.type = 'password';
        toggleIcon.className = 'fas fa-eye';
    }
}

// Show notification
function showNotification(message, isError = false) {
    const notification = document.getElementById('notification');
    const notificationText = document.getElementById('notificationText');
    
    notificationText.textContent = message;
    notification.className = `notification ${isError ? 'error' : ''} show`;
    
    setTimeout(() => {
        notification.classList.remove('show');
    }, 3000);
}

// Simulate login API call
async function loginUser(email, password) {
    // Simulate API delay
    await new Promise(resolve => setTimeout(resolve, 1500));
    
    // Demo credentials (replace with actual API call)
    if (email === 'admin@example.com' && password === 'Admin123') {
        return { success: true, user: { email, name: 'Admin User' } };
    } else {
        throw new Error('Invalid email or password');
    }
}

// Handle form submission
document.addEventListener('DOMContentLoaded', function() {
    const loginForm = document.getElementById('loginForm');
    const loginBtn = document.querySelector('.login-btn');
    const btnText = document.querySelector('.btn-text');
    
    loginForm.addEventListener('submit', async function(e) {
        e.preventDefault();
        
        if (!validateForm()) {
            return;
        }
        
        const email = document.getElementById('email').value;
        const password = document.getElementById('password').value;
        
        // Show loading state
        loginBtn.classList.add('loading');
        loginBtn.disabled = true;
        
        try {
            const result = await loginUser(email, password);
            
            if (result.success) {
                showNotification('Login successful! Redirecting...');
                
                // Simulate redirect after 2 seconds
                setTimeout(() => {
                    // Replace with actual redirect
                    window.location.href = '/dashboard';
                }, 2000);
            }
        } catch (error) {
            showNotification(error.message, true);
        } finally {
            // Remove loading state
            loginBtn.classList.remove('loading');
            loginBtn.disabled = false;
        }
    });
    
    // Handle social login buttons
    document.querySelector('.google-btn').addEventListener('click', function() {
        showNotification('Google login feature coming soon!', true);
    });
    
    document.querySelector('.github-btn').addEventListener('click', function() {
        showNotification('GitHub login feature coming soon!', true);
    });
    
    // Add input animations
    const inputs = document.querySelectorAll('input');
    inputs.forEach(input => {
        input.addEventListener('focus', function() {
            this.parentElement.classList.add('focused');
        });
        
        input.addEventListener('blur', function() {
            if (!this.value) {
                this.parentElement.classList.remove('focused');
            }
        });
    });
});
