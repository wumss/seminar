new Clipboard('.copyclipboard');

const URL = 'https://raw.githubusercontent.com/wumss/seminar/master/data/suggested-topics.json';
const resultBox = document.querySelector('#committed');
const statusBox = document.querySelector('#status');
const topicList = document.querySelector('#suggested');

const addTopicTopic = document.querySelector('#attopic');
const addTopicTags = document.querySelector('#attags');
const addTopicReferences = document.querySelector('#atreferences');
const addTopicExcerpt = document.querySelector('#atexcerpt');

let baseData = null;
const delta = [];

const logStatus = function (err) {
    statusBox.textContent = err;
};

const computePresentData = function () {
    const result = [];
    for (let obj of baseData) {
        result.push(obj);
    }
    for (let obj of delta) {
        result.push(obj);
    }
    return result;
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

const splitOn = function (str, chr) {
    return str.split(chr).map(x => x.trim()).filter(x => x);
};

const updateTopicToBeAdded = function () {
    if (!delta.length) {
        delta.push({});
    }
    const thisdelta = delta[0];
    thisdelta.topic = addTopicTopic.value;
    thisdelta.tags = splitOn(addTopicTags.value, ',');
    thisdelta.references = splitOn(addTopicReferences.value, '\n');
    const excerpt = addTopicExcerpt.value.trim();
    if (excerpt) {
        thisdelta.excerpt = excerpt;
    }
    updateResultToCommit();
};

const defer = function (func) {
    return () => window.setTimeout(func, 0);
};

addTopicTopic.onkeypress = defer(updateTopicToBeAdded);
addTopicTags.onkeypress = defer(updateTopicToBeAdded);
addTopicReferences.onkeypress = defer(updateTopicToBeAdded);
addTopicExcerpt.onkeypress = defer(updateTopicToBeAdded);

fetch(URL).then(
    response => response.json()
).then(function (json) {
    baseData = json;
    updateResultToCommit();
    logStatus('Successfully loaded data.');
}).catch(function (ex) {
    logStatus(`Loading or parsing of JSON failed: ${ex}`);
});
