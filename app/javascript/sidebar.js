function toggleSidebar(elementId, width) {
    document.getElementById(elementId).addEventListener('click', function() {
        document.getElementById('gameplay_sidebar').style.width = width;
    });
}

toggleSidebar('hamburger', '250px');
toggleSidebar('closebtn', '0');