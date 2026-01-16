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

// ============ SPEED TEST FUNCTIONS ============

function loadSpeedTestData() {
    speedTestLevels = [
        {
            id: "test-1", level: 1, title: "The Coffee Bean", wpm: 200,
            text: "Coffee is one of the most popular beverages in the world. It originated in Ethiopia, where legend says a goat herder named Kaldi discovered it after noticing his goats became energetic after eating certain berries. The beans are actually seeds from the coffee cherry fruit. Today, Brazil is the world's largest coffee producer, followed by Vietnam and Colombia. Coffee contains caffeine, which stimulates the central nervous system and can improve focus and alertness. Most people drink coffee in the morning to help wake up, though some prefer it throughout the day. The two main types of coffee beans are Arabica and Robusta. Arabica beans are considered higher quality and have a smoother taste, while Robusta beans are stronger and contain more caffeine.",
            questions: [
                { question: "Where did coffee originate?", options: ["Brazil", "Ethiopia", "Vietnam", "Colombia"], correctIndex: 1 },
                { question: "Who discovered coffee according to legend?", options: ["A farmer", "A scientist", "A goat herder named Kaldi", "A merchant"], correctIndex: 2 },
                { question: "What is the world's largest coffee producer?", options: ["Colombia", "Vietnam", "Ethiopia", "Brazil"], correctIndex: 3 },
                { question: "What does caffeine stimulate?", options: ["The digestive system", "The central nervous system", "The immune system", "The respiratory system"], correctIndex: 1 },
                { question: "Which coffee bean type is considered higher quality?", options: ["Robusta", "Liberica", "Arabica", "Excelsa"], correctIndex: 2 }
            ]
        },
        {
            id: "test-2", level: 2, title: "The Human Brain", wpm: 300,
            text: "The human brain is the most complex organ in the body, weighing about three pounds and containing approximately 86 billion neurons. These neurons communicate through electrical and chemical signals, forming trillions of connections called synapses. The brain is divided into different regions, each responsible for specific functions. The frontal lobe handles decision-making, problem-solving, and personality. The temporal lobe processes hearing and language comprehension. The parietal lobe manages sensory information and spatial awareness. The occipital lobe is dedicated to visual processing. The brain consumes about 20 percent of the body's energy, despite being only 2 percent of body weight.",
            questions: [
                { question: "How many neurons does the human brain contain?", options: ["10 million", "1 billion", "86 billion", "100 trillion"], correctIndex: 2 },
                { question: "Which lobe handles decision-making?", options: ["Temporal lobe", "Frontal lobe", "Parietal lobe", "Occipital lobe"], correctIndex: 1 },
                { question: "What percentage of body energy does the brain consume?", options: ["5 percent", "10 percent", "15 percent", "20 percent"], correctIndex: 3 },
                { question: "Which lobe processes visual information?", options: ["Frontal lobe", "Temporal lobe", "Parietal lobe", "Occipital lobe"], correctIndex: 3 },
                { question: "What are connections between neurons called?", options: ["Axons", "Dendrites", "Synapses", "Myelin"], correctIndex: 2 }
            ]
        },
        {
            id: "test-3", level: 3, title: "The Solar System", wpm: 400,
            text: "Our solar system formed approximately 4.6 billion years ago from a giant cloud of gas and dust called a nebula. At its center sits the Sun, a medium-sized star that contains 99.86 percent of the solar system's total mass. Eight planets orbit the Sun, divided into two categories: the inner rocky planets and the outer gas giants. Mercury, Venus, Earth, and Mars are the terrestrial planets, composed primarily of rock and metal. Jupiter, Saturn, Uranus, and Neptune are the gas giants, with Jupiter being the largest planet in our solar system. Beyond Neptune lies the Kuiper Belt, home to dwarf planets like Pluto.",
            questions: [
                { question: "How old is our solar system?", options: ["1 billion years", "2.5 billion years", "4.6 billion years", "10 billion years"], correctIndex: 2 },
                { question: "What percentage of the solar system's mass is in the Sun?", options: ["75 percent", "85 percent", "95 percent", "99.86 percent"], correctIndex: 3 },
                { question: "Which is the largest planet?", options: ["Saturn", "Neptune", "Jupiter", "Uranus"], correctIndex: 2 },
                { question: "Where is the Kuiper Belt located?", options: ["Between Earth and Mars", "Between Mars and Jupiter", "Beyond Neptune", "Near Mercury"], correctIndex: 2 },
                { question: "How many planets orbit the Sun?", options: ["7", "8", "9", "10"], correctIndex: 1 }
            ]
        },
        {
            id: "test-4", level: 4, title: "The Renaissance", wpm: 500,
            text: "The Renaissance, meaning 'rebirth' in French, was a transformative cultural movement that began in Italy during the 14th century and spread across Europe over the next three centuries. This period marked a transition from medieval times to modernity, characterized by renewed interest in classical Greek and Roman culture, art, philosophy, and science. Florence, Italy, served as the movement's birthplace, largely due to the patronage of wealthy families like the Medici. Artists such as Leonardo da Vinci, Michelangelo, and Raphael created masterpieces that revolutionized visual arts. The printing press, invented by Johannes Gutenberg around 1440, democratized knowledge by making books accessible.",
            questions: [
                { question: "What does 'Renaissance' mean?", options: ["Revolution", "Rebirth", "Reform", "Recovery"], correctIndex: 1 },
                { question: "Which city was the birthplace of the Renaissance?", options: ["Rome", "Venice", "Florence", "Milan"], correctIndex: 2 },
                { question: "Which family was a major patron of Renaissance arts?", options: ["Borgia", "Medici", "Sforza", "Este"], correctIndex: 1 },
                { question: "Who invented the printing press?", options: ["Leonardo da Vinci", "Galileo", "Johannes Gutenberg", "Copernicus"], correctIndex: 2 },
                { question: "When did the Renaissance begin?", options: ["12th century", "14th century", "16th century", "18th century"], correctIndex: 1 }
            ]
        },
        {
            id: "test-5", level: 5, title: "Quantum Physics", wpm: 600,
            text: "Quantum physics describes the behavior of matter and energy at the smallest scales, where classical physics breaks down. Max Planck initiated the quantum revolution in 1900 when he proposed that energy is emitted in discrete packets called quanta. Albert Einstein extended this idea, explaining the photoelectric effect by proposing that light consists of particles called photons. Werner Heisenberg formulated the uncertainty principle, which states that we cannot simultaneously know both the exact position and momentum of a particle. Erwin Schrödinger's famous thought experiment involving a cat illustrated the concept of superposition.",
            questions: [
                { question: "Who proposed that energy is emitted in discrete packets?", options: ["Einstein", "Max Planck", "Heisenberg", "Schrödinger"], correctIndex: 1 },
                { question: "What are discrete packets of energy called?", options: ["Photons", "Electrons", "Quanta", "Atoms"], correctIndex: 2 },
                { question: "What does the uncertainty principle relate to?", options: ["Energy and time", "Position and momentum", "Mass and velocity", "Charge and spin"], correctIndex: 1 },
                { question: "What concept does Schrödinger's cat illustrate?", options: ["Entanglement", "Uncertainty", "Superposition", "Wave-particle duality"], correctIndex: 2 },
                { question: "When did Planck propose his quantum theory?", options: ["1850", "1900", "1925", "1950"], correctIndex: 1 }
            ]
        }
    ];
}

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
