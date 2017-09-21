new Clipboard('.copyclipboard')

const SchemaURL = '/scripts/schema/topic.json'
const URL = 'https://raw.githubusercontent.com/wumss/seminar/master/data/suggested-topics.json'
const resultBox = document.querySelector('#committed')
const statusBox = document.querySelector('#status')
const topicList = document.querySelector('#suggested')

let editor = null
let baseData = null
const delta = []

const dependencyStatus = {
  json: false,
  schema: false
}
const phases = ['wait', 'select', 'edit', 'result']
let currentPhase = 0

const moveToNextPhase = function () {
  currentPhase += 1
  updatePhase()
}

const updatePhase = function () {
  if (phases[currentPhase] === 'edit') {
    delta.push({
      action: 'create',
      body: {}
    })
    updateTopicToBeAdded()
  } else if (phases[currentPhase] === 'result') {
    updateTopicToBeAdded()
  }
  phases.forEach(phase => {
    if (phase !== phases[currentPhase]) {
      document.getElementById(`phase-${phase}`).style.display = 'none'
    } else {
      document.getElementById(`phase-${phase}`).style.display = 'block'
    }
  })
}

const registerAsLoaded = function (type) {
  dependencyStatus[type] = true
  logLoadedStatus()
}

const logStatus = function (err) {
  statusBox.textContent = err
}

const logLoadedStatus = function () {
  if (dependencyStatus.json && dependencyStatus.schema) {
    logStatus('All data loaded; you may proceed.')
    moveToNextPhase()
  } else if (dependencyStatus.json) {
    logStatus('Please wait for schema to load.')
  } else if (dependencyStatus.schema) {
    logStatus('Please wait for JSON to load.')
  } else {
    logStatus('Please wait for data to load.')
  }
}

const computePresentData = function () {
  let result = []
  for (let obj of baseData) {
    result.push(obj)
  }
  for (let obj of delta) {
    if (obj.action === 'delete') {
      result = result.filter(o => o.topic !== obj.topic)
    } else if (obj.action === 'create') {
      result.push(obj.body)
    }
  }
  return result
}

const canonicalize = function (json) {
  return json.sort((f, g) => f.topic.localeCompare(g.topic))
}

const updateResultToCommit = function () {
  let json = canonicalize(computePresentData())
  resultBox.value = JSON.stringify(json, null, 4)
  while (topicList.firstChild) {
    topicList.removeChild(topicList.firstChild)
  }
  for (let object of json) {
    const ele = document.createElement('li')
    const anchor = document.createElement('a')
    anchor.addEventListener('click', function () {
      delta.push({
        action: 'delete',
        topic: object.topic
      })
      editor.setValue(object)
      moveToNextPhase()
    })
    ele.appendChild(anchor)
    anchor.textContent = object.topic
    topicList.appendChild(ele)
  }
}

const updateTopicToBeAdded = function () {
  let idx = delta.length - 1
  delta[idx].body = editor.getValue()
  updateResultToCommit()
}

const defer = function (func) {
  return () => window.setTimeout(func, 0)
}

document.querySelector('#new-topic').addEventListener('click', function () {
  moveToNextPhase()
})
document.querySelector('#commit-topic').addEventListener('click', function () {
  moveToNextPhase()
})

fetch(SchemaURL).then(
  response => response.json()
).then(function (json) {
  // Initialize the editor
  editor = new JSONEditor(document.getElementById('editor-container'), {
    schema: json
  })

  registerAsLoaded('schema')
})

fetch(URL).then(
  response => response.json()
).then(function (json) {
  baseData = json
  updateResultToCommit()
  registerAsLoaded('json')
}).catch(function (ex) {
  logStatus(`Loading or parsing of JSON failed: ${ex}`)
})
