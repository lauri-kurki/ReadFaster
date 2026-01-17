// ReadFaster Web App

let trainingTexts = [];
let speedTestLevels = [];
let currentWords = [];
let currentIndex = 0;
let currentWPM = 300;
let isPlaying = false;
let playbackInterval = null;
let currentTitle = '';
let completedLevels = new Set(JSON.parse(localStorage.getItem('completedLevels') || '[]'));
let completedSpeedTests = new Set(JSON.parse(localStorage.getItem('completedSpeedTests') || '[]'));

// Speed Test state
let currentSpeedTestLevel = null;
let quizAnswers = [];
let currentQuestionIndex = 0;

// Language state
let currentLanguage = localStorage.getItem('appLanguage') || (navigator.language.startsWith('de') ? 'de' : 'en');
let lang = currentLanguage === 'de' ? lang_de : lang_en;

// ORP Calculation - matches iOS app
function calculateORP(word) {
    const len = word.length;
    if (len <= 1) return 0;
    if (len <= 5) return 1;
    if (len <= 9) return 2;
    if (len <= 13) return 3;
    return 4;
}

// Clean text - remove special characters except period
function cleanWord(text) {
    return text.replace(/[^\w.]/g, '');
}

function parseWord(text) {
    const cleanText = cleanWord(text);
    const orpIndex = calculateORP(cleanText);
    return {
        text: text,
        cleanText: cleanText,
        beforeORP: cleanText.substring(0, orpIndex),
        orpCharacter: cleanText.charAt(orpIndex),
        afterORP: cleanText.substring(orpIndex + 1),
        endsWithPeriod: cleanText.endsWith('.')
    };
}

function parseText(text) {
    return text.split(/\s+/)
        .filter(w => w.length > 0)
        .map(parseWord)
        .filter(w => w.cleanText.length > 0); // Remove empty words after cleaning
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

// File upload handling
async function handleFileUpload(event) {
    const file = event.target.files[0];
    if (!file) return;

    const freeText = document.getElementById('free-text');
    const ext = file.name.split('.').pop().toLowerCase();

    freeText.value = (lang.ui.loading || 'Loading...') + '\n\nFile: ' + file.name;
    freeText.disabled = true;

    try {
        let text = '';

        if (ext === 'pdf') {
            text = await extractTextFromPDF(file, (progress) => {
                freeText.value = (lang.ui.loading || 'Loading...') + '\n\n' + progress;
            });
        } else if (ext === 'docx') {
            text = await extractTextFromDOCX(file);
        } else {
            // Try reading as plain text
            text = await file.text();
        }

        if (text && text.trim().length > 0) {
            freeText.value = text;
            updateWordCount();
            updateStartButton();
        } else {
            freeText.value = 'Could not extract text from this file. The PDF may be image-based or protected.';
        }
    } catch (error) {
        console.error('Error reading file:', error);
        freeText.value = 'Error loading file: ' + error.message;
    } finally {
        freeText.disabled = false;
        event.target.value = ''; // Reset file input
    }
}

async function extractTextFromPDF(file, onProgress) {
    // Check if PDF.js is loaded
    if (typeof pdfjsLib === 'undefined') {
        throw new Error('PDF.js library not loaded');
    }

    // Disable worker to avoid cross-origin issues (works more reliably)
    pdfjsLib.GlobalWorkerOptions.workerSrc = '';

    const arrayBuffer = await file.arrayBuffer();

    const loadingTask = pdfjsLib.getDocument({
        data: arrayBuffer,
        useWorkerFetch: false,
        isEvalSupported: false,
        disableWorker: true
    });
    const pdf = await loadingTask.promise;

    let text = '';
    const totalPages = pdf.numPages;

    for (let i = 1; i <= totalPages; i++) {
        if (onProgress) {
            onProgress(`Page ${i} of ${totalPages}...`);
        }

        const page = await pdf.getPage(i);
        const content = await page.getTextContent();
        const pageText = content.items.map(item => item.str).join(' ');
        text += pageText + '\n\n';
    }

    return text.trim();
}

async function extractTextFromDOCX(file) {
    if (typeof mammoth === 'undefined') {
        throw new Error('Mammoth.js library not loaded');
    }
    const arrayBuffer = await file.arrayBuffer();
    const result = await mammoth.extractRawText({ arrayBuffer });
    return result.value;
}

// Training List is loaded via loadTrainingTexts() at end of file

function renderTrainingList() {
    const list = document.getElementById('training-list');
    if (!list) return;
    list.innerHTML = trainingTexts.map(t => {
        const isCompleted = completedLevels.has(t.id);
        const wordCount = t.content.split(/\s+/).length;
        const minutes = Math.ceil(wordCount / t.wpm);

        return `
            <button class="training-card" onclick="startTraining('${t.id}')">
                <div class="level-badge ${isCompleted ? 'completed' : ''}">${isCompleted ? '✓' : t.level}</div>
                <div class="training-info">
                    <h4>${t.title}</h4>
                    <div class="author">${t.author}</div>
                    <div class="training-meta">
                        <span>⚡ ${t.wpm} wpm</span>
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
    currentWPM = text.wpm;
    currentIndex = 0;
    currentTitle = text.title;
    window.currentTrainingId = id;

    startReader(text.id);
}

// Free Reading
const freeText = document.getElementById('free-text');
const wpmSlider = document.getElementById('wpm-slider');
const wpmDisplay = document.getElementById('wpm-display');
const wordCountEl = document.getElementById('word-count');
const startFreeBtn = document.getElementById('start-free-btn');

function updateWordCount() {
    if (!freeText || !wordCountEl) return;
    const words = freeText.value.trim().split(/\s+/).filter(w => w.length > 0);
    const count = words.length;
    wordCountEl.textContent = count > 0 ? `${count} words` : '';
}

function updateStartButton() {
    if (!freeText || !startFreeBtn) return;
    const words = freeText.value.trim().split(/\s+/).filter(w => w.length > 0);
    if (words.length > 0) {
        startFreeBtn.classList.remove('disabled');
    } else {
        startFreeBtn.classList.add('disabled');
    }
}

if (freeText) {
    freeText.addEventListener('input', () => {
        updateWordCount();
        updateStartButton();
    });
}

if (wpmSlider && wpmDisplay) {
    wpmSlider.addEventListener('input', () => {
        wpmDisplay.textContent = wpmSlider.value;
    });
}

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
        // Fallback for mobile - focus textarea and let user paste manually
        freeText.focus();
        freeText.select();
        // Show a subtle hint
        freeText.placeholder = 'Long-press to paste your text...';
        setTimeout(() => {
            freeText.placeholder = 'Paste your text here...';
        }, 3000);
    }
}

// Reader
function startReader(trainingId) {
    document.getElementById('reader-title').textContent = currentTitle;

    // Set the WPM selector value - find closest available value
    const wpmSelector = document.getElementById('wpm-selector');
    const availableValues = Array.from(wpmSelector.options).map(o => parseInt(o.value));
    const closest = availableValues.reduce((prev, curr) =>
        Math.abs(curr - currentWPM) < Math.abs(prev - currentWPM) ? curr : prev
    );
    wpmSelector.value = closest;
    currentWPM = closest; // Update to use the actual value

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
    updatePlayButton();

    scheduleNextWord();
}

function scheduleNextWord() {
    if (!isPlaying) return;

    // Calculate interval - add extra pause for period-ending words
    let interval = 60000 / currentWPM;
    const word = currentWords[currentIndex];
    if (word && word.endsWithPeriod) {
        interval *= 1.5; // 50% longer pause for sentences
    }

    playbackInterval = setTimeout(() => {
        currentIndex++;
        if (currentIndex >= currentWords.length) {
            stopPlayback();
            showComplete();
        } else {
            updateWordDisplay();
            updateProgress();
            scheduleNextWord();
        }
    }, interval);
}

function updatePlayButton() {
    const btn = document.getElementById('play-btn');
    if (isPlaying) {
        btn.innerHTML = '<span class="pause-bar"></span><span class="pause-bar"></span>';
        btn.classList.add('playing');
    } else {
        btn.innerHTML = '▶';
        btn.classList.remove('playing');
    }
}

function stopPlayback() {
    isPlaying = false;
    updatePlayButton();
    if (playbackInterval) {
        clearTimeout(playbackInterval);
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

    // Speed Test mode - go to quiz instead of complete screen
    if (window.isSpeedTestMode) {
        window.isSpeedTestMode = false;
        document.getElementById('wpm-selector').disabled = false;
        showQuiz();
        return;
    }

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
loadSpeedTestData();
applyTranslations();
updateLanguageButtons();

// ============ SPEED TEST FUNCTIONS ============

function showSpeedTest() {
    renderSpeedTestLevels();
    showScreen('speedtest-screen');
}

function renderSpeedTestLevels() {
    const list = document.getElementById('speedtest-list');
    list.innerHTML = speedTestLevels.map(level => {
        const isCompleted = completedSpeedTests.has(level.id);
        const isUnlocked = level.level === 1 || completedSpeedTests.has(`test-${level.level - 1}`);

        return `
            <button class="training-card ${!isUnlocked ? 'locked' : ''}" 
                    onclick="${isUnlocked ? `startSpeedTest('${level.id}')` : ''}"
                    ${!isUnlocked ? 'disabled' : ''}>
                <div class="level-badge ${isCompleted ? 'completed' : ''}">
                    ${isCompleted ? '✓' : (isUnlocked ? level.level : '🔒')}
                </div>
                <div class="training-info">
                    <h4>${level.title}</h4>
                    <div class="training-meta">
                        <span>⚡ ${level.wpm} WPM</span>
                        <span>5 questions</span>
                    </div>
                </div>
                ${isUnlocked ? '<span class="chevron">›</span>' : ''}
            </button>
        `;
    }).join('');
}

function startSpeedTest(levelId) {
    const level = speedTestLevels.find(l => l.id === levelId);
    if (!level) return;

    currentSpeedTestLevel = level;
    currentWPM = level.wpm;
    currentWords = parseText(level.text);
    currentIndex = 0;
    currentTitle = level.title;
    quizAnswers = [];
    currentQuestionIndex = 0;

    document.getElementById('reader-title').textContent = level.title;

    // Set WPM selector to level's WPM
    const wpmSelector = document.getElementById('wpm-selector');
    wpmSelector.value = level.wpm;
    wpmSelector.disabled = true; // Lock speed for test

    updateWordDisplay();
    updateProgress();
    showScreen('reader-screen');

    // Auto-transition to quiz when complete
    window.isSpeedTestMode = true;
}

function showQuiz() {
    currentQuestionIndex = 0;
    quizAnswers = [];
    renderQuiz();
    showScreen('quiz-screen');
}

function renderQuiz() {
    const question = currentSpeedTestLevel.questions[currentQuestionIndex];

    document.getElementById('quiz-progress').textContent = `Question ${currentQuestionIndex + 1} of 5`;

    // Render dots
    const dotsHtml = [0, 1, 2, 3, 4].map(i =>
        `<div class="dot ${i < quizAnswers.length ? 'answered' : ''}"></div>`
    ).join('');
    document.getElementById('quiz-dots').innerHTML = dotsHtml;

    document.getElementById('quiz-question').textContent = question.question;

    const letters = ['A', 'B', 'C', 'D'];
    const optionsHtml = question.options.map((opt, i) => `
        <button class="quiz-option" onclick="selectAnswer(${i})">
            <span class="letter">${letters[i]}</span>
            <span class="text">${opt}</span>
        </button>
    `).join('');
    document.getElementById('quiz-options').innerHTML = optionsHtml;
}

function selectAnswer(index) {
    quizAnswers.push(index);

    if (currentQuestionIndex < 4) {
        currentQuestionIndex++;
        renderQuiz();
    } else {
        showSpeedTestResult();
    }
}

function showSpeedTestResult() {
    const score = calculateScore();
    const passed = currentSpeedTestLevel.level <= 2 ? score >= 3 : score >= 4;

    if (passed) {
        completedSpeedTests.add(currentSpeedTestLevel.id);
        localStorage.setItem('completedSpeedTests', JSON.stringify([...completedSpeedTests]));
    }

    const result = getResultMessage(score);

    document.getElementById('result-trophy').textContent = result.emoji;
    document.getElementById('result-title').textContent = result.title;
    document.getElementById('result-subtitle').textContent = result.subtitle;
    document.getElementById('result-score').textContent = `${score}/5 correct`;
    document.getElementById('result-score').style.color = passed ? 'var(--success)' : 'var(--accent)';

    let buttonsHtml = '';
    if (passed && currentSpeedTestLevel.level < 5) {
        buttonsHtml += `<button class="result-btn primary" onclick="nextSpeedTestLevel()">Next Level →</button>`;
    }
    if (!passed) {
        buttonsHtml += `<button class="result-btn primary" onclick="retrySpeedTest()">Try Again</button>`;
    }
    buttonsHtml += `<button class="result-btn secondary" onclick="showSpeedTest()">Back to Menu</button>`;

    document.getElementById('result-buttons').innerHTML = buttonsHtml;

    showScreen('result-screen');
}

function calculateScore() {
    let correct = 0;
    quizAnswers.forEach((answer, i) => {
        if (answer === currentSpeedTestLevel.questions[i].correctIndex) {
            correct++;
        }
    });
    return correct;
}

function getResultMessage(score) {
    switch (score) {
        case 5: return { emoji: '🏆', title: 'Perfect!', subtitle: "You're a Speed Reading Champion!" };
        case 4: return { emoji: '⭐', title: 'Excellent!', subtitle: "You're a Speedy Reader!" };
        case 3: return { emoji: '✓', title: 'Good Job!', subtitle: 'You passed the test!' };
        case 2: return { emoji: '📚', title: 'Almost There!', subtitle: 'Keep practicing to improve!' };
        default: return { emoji: '💪', title: 'Keep Trying!', subtitle: 'Practice makes perfect!' };
    }
}

function nextSpeedTestLevel() {
    const nextLevel = speedTestLevels.find(l => l.level === currentSpeedTestLevel.level + 1);
    if (nextLevel) {
        startSpeedTest(nextLevel.id);
    } else {
        showSpeedTest();
    }
}

function retrySpeedTest() {
    startSpeedTest(currentSpeedTestLevel.id);
}

// ============ LANGUAGE FUNCTIONS ============

function showSettings() {
    showScreen('settings-screen');
}

function setLanguage(langCode) {
    if (langCode === currentLanguage) return;

    currentLanguage = langCode;
    localStorage.setItem('appLanguage', langCode);
    lang = langCode === 'de' ? lang_de : lang_en;

    // Reload data with new language
    loadTrainingTexts();
    loadSpeedTestData();
    applyTranslations();
    updateLanguageButtons();
}

function updateLanguageButtons() {
    const enBtn = document.getElementById('lang-en');
    const deBtn = document.getElementById('lang-de');

    if (enBtn && deBtn) {
        enBtn.classList.toggle('active', currentLanguage === 'en');
        deBtn.classList.toggle('active', currentLanguage === 'de');
    }
}

function applyTranslations() {
    const ui = lang.ui;

    // Home screen
    const homeTitle = document.getElementById('home-title');
    const homeTagline = document.getElementById('home-tagline');
    if (homeTitle) homeTitle.textContent = ui.appName;
    if (homeTagline) homeTagline.textContent = ui.tagline;

    // Mode cards - update text content
    const modeCards = document.querySelectorAll('.mode-card');
    if (modeCards.length >= 3) {
        modeCards[0].querySelector('h3').textContent = ui.speedTest;
        modeCards[0].querySelector('p').textContent = ui.speedTestDesc;
        modeCards[1].querySelector('h3').textContent = ui.training;
        modeCards[1].querySelector('p').textContent = ui.trainingDesc;
        modeCards[2].querySelector('h3').textContent = ui.freeReading;
        modeCards[2].querySelector('p').textContent = ui.freeReadingDesc;
    }

    // Training screen
    const trainingSubtitle = document.getElementById('training-subtitle');
    if (trainingSubtitle) trainingSubtitle.textContent = ui.trainingSubtitle;

    // Free Reading screen
    const freeTitle = document.getElementById('free-title');
    const pasteBtn = document.getElementById('paste-btn');
    const uploadBtn = document.getElementById('upload-btn');
    const speedLabel = document.getElementById('speed-label');
    const startReadingText = document.getElementById('start-reading-text');
    const freeText = document.getElementById('free-text');

    if (freeTitle) freeTitle.textContent = ui.freeReading;
    if (pasteBtn) pasteBtn.textContent = ui.paste;
    if (uploadBtn) uploadBtn.textContent = ui.upload;
    if (speedLabel) speedLabel.textContent = ui.speed || 'Speed';
    if (startReadingText) startReadingText.textContent = ui.startReading;
    if (freeText) freeText.placeholder = ui.placeholder;

    // Settings screen
    const settingsTitle = document.getElementById('settings-title');
    const settingsLangLabel = document.getElementById('settings-lang-label');
    if (settingsTitle) settingsTitle.textContent = ui.settings;
    if (settingsLangLabel) settingsLangLabel.textContent = ui.language;
}

// Update loadTrainingTexts to use language data
function loadTrainingTexts() {
    trainingTexts = lang.training.map(t => ({
        id: t.id,
        title: t.title,
        author: t.author,
        level: t.level,
        wpm: t.wpm,
        content: t.content
    }));
    renderTrainingList();
}

// Update loadSpeedTestData to use language data
function loadSpeedTestData() {
    speedTestLevels = lang.speedTest;
}

// Keyboard shortcuts for desktop
document.addEventListener('keydown', (e) => {
    // Only work when reader is active
    const readerScreen = document.getElementById('reader-screen');
    if (!readerScreen || !readerScreen.classList.contains('active')) return;

    // Ignore if typing in an input
    if (e.target.tagName === 'INPUT' || e.target.tagName === 'TEXTAREA') return;

    switch (e.code) {
        case 'Space':
            e.preventDefault();
            togglePlayback();
            break;
        case 'ArrowLeft':
            e.preventDefault();
            adjustSpeed(-50);
            break;
        case 'ArrowRight':
            e.preventDefault();
            adjustSpeed(50);
            break;
        case 'Escape':
            e.preventDefault();
            showHome();
            break;
        case 'KeyR':
            e.preventDefault();
            restartReading();
            break;
    }
});

function adjustSpeed(delta) {
    currentWPM = Math.max(100, Math.min(800, currentWPM + delta));
    document.getElementById('current-wpm').textContent = currentWPM;

    // Restart playback with new speed if playing
    if (isPlaying) {
        stopPlayback();
        startPlayback();
    }
}

function restartReading() {
    currentIndex = 0;
    updateWordDisplay();
}
