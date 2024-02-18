document.getElementById('hamburger').addEventListener('click', function() {
    document.getElementById('gameplay_sidebar').style.width = '250px';
});

document.getElementById('closebtn').addEventListener('click', function() {
    document.getElementById('gameplay_sidebar').style.width = '0';
});
