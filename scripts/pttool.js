const URL = 'https://raw.githubusercontent.com/wumss/seminar/master/data/suggested-topics.json';
const resultBox = document.querySelector('#committed');
const statusBox = document.querySelector('#status');
const topicList = document.querySelector('#suggested');

let baseData = null;
const delta = [];

const logStatus = function (err) {
    statusBox.textContent = err;
};

const computePresentData = function () {
    return baseData;
};

const canonicalize = function (json) {
    return json.sort((f, g) => f.topic.localeCompare(g.topic));
};

const updateResultToCommit = function () {
    let json = canonicalize(computePresentData());
    resultBox.value = JSON.stringify(json, null, 4);
    while (topicList.firstChild) {
        topicList.removeChild(topicList.firstChild);
    }
    for (let object of json) {
        const ele = document.createElement('li');
        ele.textContent = object.topic;
        topicList.appendChild(ele);
    }
};

fetch(URL).then(
    response => response.json()
).then(function (json) {
    baseData = json;
    updateResultToCommit();
    logStatus('Successfully loaded data.');
}).catch(function (ex) {
    logStatus(`Loading or parsing of JSON failed: ${ex}`);
});
