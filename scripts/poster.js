var colorPick = document.getElementById('color-pick');
var miniPage = document.querySelector('.minipage');

colorPick.onchange = function(e) {
    miniPage.style.backgroundColor = colorPick.value;
}
