// ReadFaster Web App

let trainingTexts = [];
let currentWords = [];
let currentIndex = 0;
let currentWPM = 300;
let isPlaying = false;
let playbackInterval = null;
let currentTitle = '';
let completedLevels = new Set(JSON.parse(localStorage.getItem('completedLevels') || '[]'));

// ORP Calculation - matches iOS app
function calculateORP(word) {
    const len = word.length;
    if (len <= 1) return 0;
    if (len <= 5) return 1;
    if (len <= 9) return 2;
    if (len <= 13) return 3;
    return 4;
}

function parseWord(text) {
    const orpIndex = calculateORP(text);
    return {
        text: text,
        beforeORP: text.substring(0, orpIndex),
        orpCharacter: text.charAt(orpIndex),
        afterORP: text.substring(orpIndex + 1)
    };
}

function parseText(text) {
    return text.split(/\s+/).filter(w => w.length > 0).map(parseWord);
}

// Screen Navigation
function showScreen(screenId) {
    document.querySelectorAll('.screen').forEach(s => s.classList.remove('active'));
    document.getElementById(screenId).classList.add('active');
}

function showHome() {
    stopPlayback();
    showScreen('home-screen');
}

function showTrainingMode() {
    renderTrainingList();
    showScreen('training-screen');
}

function showFreeReading() {
    showScreen('free-screen');
}

// Training List
async function loadTrainingTexts() {
    try {
        const response = await fetch('training-texts.json');
        const data = await response.json();
        trainingTexts = data.texts;
        renderTrainingList();
    } catch (e) {
        console.error('Failed to load training texts:', e);
    }
}

function renderTrainingList() {
    const list = document.getElementById('training-list');
    list.innerHTML = trainingTexts.map(t => {
        const isCompleted = completedLevels.has(t.id);
        const wordCount = t.content.split(/\s+/).length;
        const minutes = Math.ceil(wordCount / t.targetWPM);

        return `
            <button class="training-card" onclick="startTraining(${t.id})">
                <div class="level-badge ${isCompleted ? 'completed' : ''}">${isCompleted ? '✓' : t.level}</div>
                <div class="training-info">
                    <h4>${t.title}</h4>
                    <div class="author">${t.author}</div>
                    <div class="training-meta">
                        <span>⚡ ${t.targetWPM} wpm</span>
                        <span>⏱ ${minutes} min</span>
                    </div>
                </div>
                <span class="chevron">›</span>
            </button>
        `;
    }).join('');
}

function startTraining(id) {
    const text = trainingTexts.find(t => t.id === id);
    if (!text) return;

    currentWords = parseText(text.content);
    currentWPM = text.targetWPM;
    currentIndex = 0;
    currentTitle = text.title;

    startReader(text.id);
}

// Free Reading
const freeText = document.getElementById('free-text');
const wpmSlider = document.getElementById('wpm-slider');
const wpmDisplay = document.getElementById('wpm-display');
const wordCountEl = document.getElementById('word-count');
const startFreeBtn = document.getElementById('start-free-btn');

freeText.addEventListener('input', () => {
    const words = freeText.value.trim().split(/\s+/).filter(w => w.length > 0);
    const count = words.length;
    wordCountEl.textContent = count > 0 ? `${count} words` : '';

    if (count > 0) {
        startFreeBtn.classList.remove('disabled');
    } else {
        startFreeBtn.classList.add('disabled');
    }
});

wpmSlider.addEventListener('input', () => {
    wpmDisplay.textContent = wpmSlider.value;
});

function startFreeReading() {
    const text = freeText.value.trim();
    if (!text) return;

    currentWords = parseText(text);
    currentWPM = parseInt(wpmSlider.value);
    currentIndex = 0;
    currentTitle = 'Free Reading';

    startReader(null);
}

// Paste from clipboard
async function pasteFromClipboard() {
    try {
        const text = await navigator.clipboard.readText();
        if (text) {
            freeText.value = text;
            freeText.dispatchEvent(new Event('input'));
        }
    } catch (e) {
        console.error('Failed to paste:', e);
        // Fallback - prompt user
        alert('Please use Ctrl+V / Cmd+V to paste');
    }
}

// Reader
function startReader(trainingId) {
    document.getElementById('reader-title').textContent = currentTitle;

    // Set the WPM selector value
    const wpmSelector = document.getElementById('wpm-selector');
    wpmSelector.value = currentWPM;

    updateWordDisplay();
    updateProgress();
    showScreen('reader-screen');

    // Store training ID for completion
    window.currentTrainingId = trainingId;
}

// Change speed on the fly
function changeSpeed(newWPM) {
    currentWPM = parseInt(newWPM);
    updateProgress();

    // Restart playback with new speed if playing
    if (isPlaying) {
        stopPlayback();
        startPlayback();
    }
}

function updateWordDisplay() {
    const display = document.getElementById('word-display');

    if (currentIndex >= currentWords.length) {
        showComplete();
        return;
    }

    const word = currentWords[currentIndex];

    // Dynamic font size based on word length
    const len = word.text.length;
    let fontSize = 42;
    let sideWidth = 150;

    if (len > 14) {
        fontSize = 24;
        sideWidth = 180;
    } else if (len > 10) {
        fontSize = 30;
        sideWidth = 180;
    } else if (len > 7) {
        fontSize = 36;
    }

    display.style.fontSize = `${fontSize}px`;

    display.innerHTML = `
        <span class="before-orp" style="min-width:${sideWidth}px">${word.beforeORP}</span>
        <span class="orp">${word.orpCharacter}</span>
        <span class="after-orp" style="min-width:${sideWidth}px">${word.afterORP}</span>
    `;
}

function updateProgress() {
    const progress = currentWords.length > 0 ? (currentIndex / currentWords.length) * 100 : 0;
    document.getElementById('progress-fill').style.width = `${progress}%`;
    document.getElementById('word-progress').textContent = `${currentIndex + 1}/${currentWords.length}`;

    const remaining = Math.max(0, currentWords.length - currentIndex);
    const seconds = Math.ceil(remaining * (60 / currentWPM));
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    document.getElementById('time-remaining').textContent = `${mins}:${secs.toString().padStart(2, '0')}`;
}

function togglePlayback(e) {
    if (e) e.stopPropagation();

    if (isPlaying) {
        stopPlayback();
    } else {
        startPlayback();
    }
}

function startPlayback() {
    if (currentIndex >= currentWords.length - 1) {
        currentIndex = 0;
    }

    isPlaying = true;
    document.getElementById('play-btn').textContent = '⏸';

    const interval = 60000 / currentWPM;
    playbackInterval = setInterval(() => {
        currentIndex++;
        if (currentIndex >= currentWords.length) {
            stopPlayback();
            showComplete();
        } else {
            updateWordDisplay();
            updateProgress();
        }
    }, interval);
}

function stopPlayback() {
    isPlaying = false;
    document.getElementById('play-btn').textContent = '▶';
    if (playbackInterval) {
        clearInterval(playbackInterval);
        playbackInterval = null;
    }
}

function skipForward(e, count = 3) {
    if (e) e.stopPropagation();
    currentIndex = Math.min(currentIndex + count, currentWords.length - 1);
    updateWordDisplay();
    updateProgress();
}

function skipBackward(e, count = 3) {
    if (e) e.stopPropagation();
    currentIndex = Math.max(0, currentIndex - count);
    updateWordDisplay();
    updateProgress();
}

function exitReader() {
    stopPlayback();
    showHome();
}

// Completion
function showComplete() {
    stopPlayback();

    // Mark as completed if training
    if (window.currentTrainingId) {
        completedLevels.add(window.currentTrainingId);
        localStorage.setItem('completedLevels', JSON.stringify([...completedLevels]));
    }

    document.getElementById('complete-stats').textContent =
        `${currentWords.length} words at ${currentWPM} WPM`;

    showScreen('complete-screen');
}

// Initialize
loadTrainingTexts();
