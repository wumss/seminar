MathJax.Hub.Config({
    jax: [
        "input/TeX",
        "input/MathML",
        "input/AsciiMath",
        "output/CommonHTML"
    ],
    extensions: [
        "tex2jax.js",
        "mml2jax.js",
        "asciimath2jax.js",
        "MathMenu.js",
        "MathZoom.js",
        "AssistiveMML.js"
    ],
    TeX: {
        extensions: [
            "AMSmath.js",
            "AMSsymbols.js",
            "noErrors.js",
            "noUndefined.js"
        ]
    },
    tex2jax: {
        inlineMath: [ ['$','$'], ["\\(","\\)"] ],
        displayMath: [ ['$$','$$'], ["\\[","\\]"] ],
        processEscapes: true
    },
    "HTML-CSS": {
        availableFonts: ["TeX"]
    }
});
