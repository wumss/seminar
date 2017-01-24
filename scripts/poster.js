var colorPick = document.getElementById('color-pick');
var miniPage = document.getElementById('minipage');

colorPick.onchange = function(e) {
    miniPage.style.backgroundColor = colorPick.value;
}
