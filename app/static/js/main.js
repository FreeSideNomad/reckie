document.addEventListener('DOMContentLoaded', function() {
    console.log('Reckie application loaded');
    const statusElement = document.getElementById('status');
    if (statusElement) {
        statusElement.addEventListener('click', function() {
            this.style.backgroundColor = '#cce7ff';
        });
    }
});