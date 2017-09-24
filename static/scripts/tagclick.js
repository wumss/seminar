document.querySelector('#tagclick').onclick = function () {
  const tagItems = document.querySelectorAll('.tag-link')
  const wantedTag = document.querySelector('#selectedtag').value
  for (let tagLink of tagItems) {
    if (tagLink.textContent === wantedTag) {
      window.location.href = tagLink.href
    }
  }
}
