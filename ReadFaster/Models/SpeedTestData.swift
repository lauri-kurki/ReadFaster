import Foundation

/// Model for Speed Reading Test levels and questions
struct SpeedTestLevel: Codable, Identifiable {
    let id: String
    let level: Int
    let title: String
    let wpm: Int
    let text: String
    let questions: [SpeedTestQuestion]
}

struct SpeedTestQuestion: Codable, Identifiable {
    var id: String { question }
    let question: String
    let options: [String]
    let correctIndex: Int
}

// MARK: - Speed Test Data

class SpeedTestData: ObservableObject {
    static let shared = SpeedTestData()
    
    @Published var levels: [SpeedTestLevel] = []
    @Published var completedLevels: Set<String> = []
    
    private init() {
        loadLevels()
        loadProgress()
    }
    
    private func loadLevels() {
        // Embedded test data
        let testData: [SpeedTestLevel] = [
            SpeedTestLevel(
                id: "test-1",
                level: 1,
                title: "The Coffee Bean",
                wpm: 200,
                text: "Coffee is one of the most popular beverages in the world. It originated in Ethiopia, where legend says a goat herder named Kaldi discovered it after noticing his goats became energetic after eating certain berries. The beans are actually seeds from the coffee cherry fruit. Today, Brazil is the world's largest coffee producer, followed by Vietnam and Colombia. Coffee contains caffeine, which stimulates the central nervous system and can improve focus and alertness. Most people drink coffee in the morning to help wake up, though some prefer it throughout the day. The two main types of coffee beans are Arabica and Robusta. Arabica beans are considered higher quality and have a smoother taste, while Robusta beans are stronger and contain more caffeine.",
                questions: [
                    SpeedTestQuestion(question: "Where did coffee originate?", options: ["Brazil", "Ethiopia", "Vietnam", "Colombia"], correctIndex: 1),
                    SpeedTestQuestion(question: "Who discovered coffee according to legend?", options: ["A farmer", "A scientist", "A goat herder named Kaldi", "A merchant"], correctIndex: 2),
                    SpeedTestQuestion(question: "What is the world's largest coffee producer?", options: ["Colombia", "Vietnam", "Ethiopia", "Brazil"], correctIndex: 3),
                    SpeedTestQuestion(question: "What does caffeine stimulate?", options: ["The digestive system", "The central nervous system", "The immune system", "The respiratory system"], correctIndex: 1),
                    SpeedTestQuestion(question: "Which coffee bean type is considered higher quality?", options: ["Robusta", "Liberica", "Arabica", "Excelsa"], correctIndex: 2)
                ]
            ),
            SpeedTestLevel(
                id: "test-2",
                level: 2,
                title: "The Human Brain",
                wpm: 300,
                text: "The human brain is the most complex organ in the body, weighing about three pounds and containing approximately 86 billion neurons. These neurons communicate through electrical and chemical signals, forming trillions of connections called synapses. The brain is divided into different regions, each responsible for specific functions. The frontal lobe handles decision-making, problem-solving, and personality. The temporal lobe processes hearing and language comprehension. The parietal lobe manages sensory information and spatial awareness. The occipital lobe is dedicated to visual processing. The brain consumes about 20 percent of the body's energy, despite being only 2 percent of body weight. Sleep is crucial for brain health, as it allows the brain to consolidate memories and remove waste products. Regular exercise, a healthy diet, and mental stimulation can help maintain cognitive function throughout life.",
                questions: [
                    SpeedTestQuestion(question: "How many neurons does the human brain contain?", options: ["10 million", "1 billion", "86 billion", "100 trillion"], correctIndex: 2),
                    SpeedTestQuestion(question: "Which lobe handles decision-making?", options: ["Temporal lobe", "Frontal lobe", "Parietal lobe", "Occipital lobe"], correctIndex: 1),
                    SpeedTestQuestion(question: "What percentage of body energy does the brain consume?", options: ["5 percent", "10 percent", "15 percent", "20 percent"], correctIndex: 3),
                    SpeedTestQuestion(question: "Which lobe processes visual information?", options: ["Frontal lobe", "Temporal lobe", "Parietal lobe", "Occipital lobe"], correctIndex: 3),
                    SpeedTestQuestion(question: "What helps maintain cognitive function?", options: ["Only sleep", "Only diet", "Exercise, diet, and mental stimulation", "Medication"], correctIndex: 2)
                ]
            ),
            SpeedTestLevel(
                id: "test-3",
                level: 3,
                title: "The Solar System",
                wpm: 400,
                text: "Our solar system formed approximately 4.6 billion years ago from a giant cloud of gas and dust called a nebula. At its center sits the Sun, a medium-sized star that contains 99.86 percent of the solar system's total mass. Eight planets orbit the Sun, divided into two categories: the inner rocky planets and the outer gas giants. Mercury, Venus, Earth, and Mars are the terrestrial planets, composed primarily of rock and metal. Jupiter, Saturn, Uranus, and Neptune are the gas giants, with Jupiter being the largest planet in our solar system. Beyond Neptune lies the Kuiper Belt, home to dwarf planets like Pluto and countless icy objects. The asteroid belt between Mars and Jupiter contains millions of rocky remnants from the solar system's formation. Each planet has unique characteristics: Mars has the largest volcano, Olympus Mons, while Saturn is famous for its spectacular ring system.",
                questions: [
                    SpeedTestQuestion(question: "How old is our solar system?", options: ["1 billion years", "2.5 billion years", "4.6 billion years", "10 billion years"], correctIndex: 2),
                    SpeedTestQuestion(question: "What percentage of the solar system's mass is in the Sun?", options: ["75 percent", "85 percent", "95 percent", "99.86 percent"], correctIndex: 3),
                    SpeedTestQuestion(question: "Which planet has the largest volcano?", options: ["Earth", "Venus", "Mars", "Jupiter"], correctIndex: 2),
                    SpeedTestQuestion(question: "Where is the Kuiper Belt located?", options: ["Between Earth and Mars", "Between Mars and Jupiter", "Beyond Neptune", "Inside Mercury's orbit"], correctIndex: 2),
                    SpeedTestQuestion(question: "How many planets orbit the Sun?", options: ["7", "8", "9", "10"], correctIndex: 1)
                ]
            ),
            SpeedTestLevel(
                id: "test-4",
                level: 4,
                title: "The Renaissance",
                wpm: 500,
                text: "The Renaissance, meaning 'rebirth' in French, was a transformative cultural movement that began in Italy during the 14th century and spread across Europe over the next three centuries. This period marked a transition from medieval times to modernity, characterized by renewed interest in classical Greek and Roman culture, art, philosophy, and science. Florence, Italy, served as the movement's birthplace, largely due to the patronage of wealthy families like the Medici. Artists such as Leonardo da Vinci, Michelangelo, and Raphael created masterpieces that revolutionized visual arts through techniques like perspective, chiaroscuro, and anatomical accuracy. The printing press, invented by Johannes Gutenberg around 1440, democratized knowledge by making books accessible beyond the wealthy elite. Humanism emerged as a dominant philosophy, emphasizing human potential, individualism, and secular concerns alongside religious beliefs.",
                questions: [
                    SpeedTestQuestion(question: "What does 'Renaissance' mean?", options: ["Revolution", "Rebirth", "Reform", "Recovery"], correctIndex: 1),
                    SpeedTestQuestion(question: "Which city was the birthplace of the Renaissance?", options: ["Rome", "Venice", "Florence", "Milan"], correctIndex: 2),
                    SpeedTestQuestion(question: "Which family was a major patron of Renaissance arts?", options: ["Borgia", "Medici", "Sforza", "Este"], correctIndex: 1),
                    SpeedTestQuestion(question: "Who invented the printing press?", options: ["Leonardo da Vinci", "Galileo", "Johannes Gutenberg", "Copernicus"], correctIndex: 2),
                    SpeedTestQuestion(question: "What philosophy emphasized human potential?", options: ["Scholasticism", "Humanism", "Rationalism", "Empiricism"], correctIndex: 1)
                ]
            ),
            SpeedTestLevel(
                id: "test-5",
                level: 5,
                title: "Quantum Physics",
                wpm: 600,
                text: "Quantum physics describes the behavior of matter and energy at the smallest scales, where classical physics breaks down. Max Planck initiated the quantum revolution in 1900 when he proposed that energy is emitted in discrete packets called quanta. Albert Einstein extended this idea, explaining the photoelectric effect by proposing that light consists of particles called photons. Werner Heisenberg formulated the uncertainty principle, which states that we cannot simultaneously know both the exact position and momentum of a particle. Erwin Schrödinger's famous thought experiment involving a cat illustrated the concept of superposition, where quantum objects exist in multiple states simultaneously until observed. Quantum entanglement occurs when particles become correlated so that measuring one instantly affects the other, regardless of distance. These principles underlie modern technologies including lasers, transistors, MRI machines, and quantum computing.",
                questions: [
                    SpeedTestQuestion(question: "Who proposed that energy is emitted in discrete packets?", options: ["Einstein", "Max Planck", "Heisenberg", "Schrödinger"], correctIndex: 1),
                    SpeedTestQuestion(question: "What are discrete packets of energy called?", options: ["Photons", "Electrons", "Quanta", "Atoms"], correctIndex: 2),
                    SpeedTestQuestion(question: "What does the uncertainty principle relate to?", options: ["Energy and time", "Position and momentum", "Mass and velocity", "Charge and spin"], correctIndex: 1),
                    SpeedTestQuestion(question: "What concept does Schrödinger's cat illustrate?", options: ["Entanglement", "Uncertainty", "Superposition", "Wave-particle duality"], correctIndex: 2),
                    SpeedTestQuestion(question: "What happens when entangled particles are measured?", options: ["They disappear", "Nothing happens", "One affects the other instantly", "They repel each other"], correctIndex: 2)
                ]
            )
        ]
        levels = testData
    }
    
    private func loadProgress() {
        if let data = UserDefaults.standard.array(forKey: "speedTestCompleted") as? [String] {
            completedLevels = Set(data)
        }
    }
    
    func markCompleted(_ levelId: String) {
        completedLevels.insert(levelId)
        UserDefaults.standard.set(Array(completedLevels), forKey: "speedTestCompleted")
    }
    
    func isUnlocked(_ level: SpeedTestLevel) -> Bool {
        if level.level == 1 { return true }
        // Unlock if previous level is completed
        let previousLevelId = "test-\(level.level - 1)"
        return completedLevels.contains(previousLevelId)
    }
}
