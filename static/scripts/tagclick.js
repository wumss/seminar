document.querySelector('#tagclick').onclick = function() {
    location.href = '/tag/' + document.querySelector('#selectedtag').value;
}
