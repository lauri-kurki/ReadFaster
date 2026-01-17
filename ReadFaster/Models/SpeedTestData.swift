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
    
    func loadLevels() {
        let isGerman = LanguageManager.shared.isGerman
        levels = isGerman ? germanLevels : englishLevels
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
        let previousLevelId = "test-\(level.level - 1)"
        return completedLevels.contains(previousLevelId)
    }
    
    // MARK: - English Levels
    
    private var englishLevels: [SpeedTestLevel] {
        [
            SpeedTestLevel(
                id: "test-1", level: 1, title: "The Coffee Bean", wpm: 200,
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
                id: "test-2", level: 2, title: "The Human Brain", wpm: 300,
                text: "The human brain is the most complex organ in the body, weighing about three pounds and containing approximately 86 billion neurons. These neurons communicate through electrical and chemical signals, forming trillions of connections called synapses. The brain is divided into different regions, each responsible for specific functions. The frontal lobe handles decision-making, problem-solving, and personality. The temporal lobe processes hearing and language comprehension. The parietal lobe manages sensory information and spatial awareness. The occipital lobe is dedicated to visual processing. The brain consumes about 20 percent of the body's energy, despite being only 2 percent of body weight.",
                questions: [
                    SpeedTestQuestion(question: "How many neurons does the human brain contain?", options: ["10 million", "1 billion", "86 billion", "100 trillion"], correctIndex: 2),
                    SpeedTestQuestion(question: "Which lobe handles decision-making?", options: ["Temporal lobe", "Frontal lobe", "Parietal lobe", "Occipital lobe"], correctIndex: 1),
                    SpeedTestQuestion(question: "What percentage of body energy does the brain consume?", options: ["5 percent", "10 percent", "15 percent", "20 percent"], correctIndex: 3),
                    SpeedTestQuestion(question: "Which lobe processes visual information?", options: ["Frontal lobe", "Temporal lobe", "Parietal lobe", "Occipital lobe"], correctIndex: 3),
                    SpeedTestQuestion(question: "What are connections between neurons called?", options: ["Axons", "Dendrites", "Synapses", "Myelin"], correctIndex: 2)
                ]
            ),
            SpeedTestLevel(
                id: "test-3", level: 3, title: "The Solar System", wpm: 400,
                text: "Our solar system formed approximately 4.6 billion years ago from a giant cloud of gas and dust called a nebula. At its center sits the Sun, a medium-sized star that contains 99.86 percent of the solar system's total mass. Eight planets orbit the Sun, divided into two categories: the inner rocky planets and the outer gas giants. Mercury, Venus, Earth, and Mars are the terrestrial planets, composed primarily of rock and metal. Jupiter, Saturn, Uranus, and Neptune are the gas giants, with Jupiter being the largest planet in our solar system. Beyond Neptune lies the Kuiper Belt, home to dwarf planets like Pluto.",
                questions: [
                    SpeedTestQuestion(question: "How old is our solar system?", options: ["1 billion years", "2.5 billion years", "4.6 billion years", "10 billion years"], correctIndex: 2),
                    SpeedTestQuestion(question: "What percentage of the solar system's mass is in the Sun?", options: ["75 percent", "85 percent", "95 percent", "99.86 percent"], correctIndex: 3),
                    SpeedTestQuestion(question: "Which is the largest planet?", options: ["Saturn", "Neptune", "Jupiter", "Uranus"], correctIndex: 2),
                    SpeedTestQuestion(question: "Where is the Kuiper Belt located?", options: ["Between Earth and Mars", "Between Mars and Jupiter", "Beyond Neptune", "Near Mercury"], correctIndex: 2),
                    SpeedTestQuestion(question: "How many planets orbit the Sun?", options: ["7", "8", "9", "10"], correctIndex: 1)
                ]
            ),
            SpeedTestLevel(
                id: "test-4", level: 4, title: "The Renaissance", wpm: 500,
                text: "The Renaissance, meaning 'rebirth' in French, was a transformative cultural movement that began in Italy during the 14th century and spread across Europe over the next three centuries. This period marked a transition from medieval times to modernity, characterized by renewed interest in classical Greek and Roman culture, art, philosophy, and science. Florence, Italy, served as the movement's birthplace, largely due to the patronage of wealthy families like the Medici. Artists such as Leonardo da Vinci, Michelangelo, and Raphael created masterpieces that revolutionized visual arts. The printing press, invented by Johannes Gutenberg around 1440, democratized knowledge by making books accessible.",
                questions: [
                    SpeedTestQuestion(question: "What does 'Renaissance' mean?", options: ["Revolution", "Rebirth", "Reform", "Recovery"], correctIndex: 1),
                    SpeedTestQuestion(question: "Which city was the birthplace of the Renaissance?", options: ["Rome", "Venice", "Florence", "Milan"], correctIndex: 2),
                    SpeedTestQuestion(question: "Which family was a major patron of Renaissance arts?", options: ["Borgia", "Medici", "Sforza", "Este"], correctIndex: 1),
                    SpeedTestQuestion(question: "Who invented the printing press?", options: ["Leonardo da Vinci", "Galileo", "Johannes Gutenberg", "Copernicus"], correctIndex: 2),
                    SpeedTestQuestion(question: "When did the Renaissance begin?", options: ["12th century", "14th century", "16th century", "18th century"], correctIndex: 1)
                ]
            ),
            SpeedTestLevel(
                id: "test-5", level: 5, title: "Quantum Physics", wpm: 600,
                text: "Quantum physics describes the behavior of matter and energy at the smallest scales, where classical physics breaks down. Max Planck initiated the quantum revolution in 1900 when he proposed that energy is emitted in discrete packets called quanta. Albert Einstein extended this idea, explaining the photoelectric effect by proposing that light consists of particles called photons. Werner Heisenberg formulated the uncertainty principle, which states that we cannot simultaneously know both the exact position and momentum of a particle. Erwin Schrödinger's famous thought experiment involving a cat illustrated the concept of superposition.",
                questions: [
                    SpeedTestQuestion(question: "Who proposed that energy is emitted in discrete packets?", options: ["Einstein", "Max Planck", "Heisenberg", "Schrödinger"], correctIndex: 1),
                    SpeedTestQuestion(question: "What are discrete packets of energy called?", options: ["Photons", "Electrons", "Quanta", "Atoms"], correctIndex: 2),
                    SpeedTestQuestion(question: "What does the uncertainty principle relate to?", options: ["Energy and time", "Position and momentum", "Mass and velocity", "Charge and spin"], correctIndex: 1),
                    SpeedTestQuestion(question: "What concept does Schrödinger's cat illustrate?", options: ["Entanglement", "Uncertainty", "Superposition", "Wave-particle duality"], correctIndex: 2),
                    SpeedTestQuestion(question: "When did Planck propose his quantum theory?", options: ["1850", "1900", "1925", "1950"], correctIndex: 1)
                ]
            )
        ]
    }
    
    // MARK: - German Levels
    
    private var germanLevels: [SpeedTestLevel] {
        [
            SpeedTestLevel(
                id: "test-1", level: 1, title: "Bienen und Honig", wpm: 200,
                text: "Bienen sind faszinierende Insekten, die seit Jahrtausenden eine wichtige Rolle in der Natur spielen. Ein einzelner Bienenstock kann bis zu 60.000 Bienen beherbergen. Die Königin ist die einzige Biene, die Eier legt. Für ein Kilogramm Honig müssen Bienen etwa drei Millionen Blüten besuchen. Dabei legen sie eine Strecke zurück, die dem dreifachen Erdumfang entspricht. Honig ist das einzige Nahrungsmittel, das niemals verdirbt. Archäologen haben dreitausend Jahre alten Honig in ägyptischen Gräbern gefunden, der noch essbar war. Bienen kommunizieren durch einen besonderen Tanz, den sogenannten Schwänzeltanz. Damit zeigen sie anderen Bienen, wo Nahrungsquellen zu finden sind.",
                questions: [
                    SpeedTestQuestion(question: "Wie viele Bienen kann ein Bienenstock beherbergen?", options: ["10.000", "30.000", "60.000", "100.000"], correctIndex: 2),
                    SpeedTestQuestion(question: "Welche Biene legt alle Eier?", options: ["Arbeiterbiene", "Königin", "Drohne", "Wächterbiene"], correctIndex: 1),
                    SpeedTestQuestion(question: "Wie viele Blüten braucht man für ein Kilogramm Honig?", options: ["100.000", "1 Million", "3 Millionen", "10 Millionen"], correctIndex: 2),
                    SpeedTestQuestion(question: "Was ist besonders am Honig?", options: ["Er ist radioaktiv", "Er verdirbt nie", "Er ist giftig", "Er leuchtet"], correctIndex: 1),
                    SpeedTestQuestion(question: "Wie kommunizieren Bienen?", options: ["Durch Laute", "Durch Farben", "Durch einen Tanz", "Durch Geruch"], correctIndex: 2)
                ]
            ),
            SpeedTestLevel(
                id: "test-2", level: 2, title: "Das menschliche Herz", wpm: 300,
                text: "Das menschliche Herz ist ein faszinierendes Organ. Es schlägt etwa 100.000 Mal pro Tag und pumpt dabei rund 7.000 Liter Blut durch den Körper. Das Herz besteht aus vier Kammern: zwei Vorhöfen und zwei Herzkammern. Die rechte Seite pumpt sauerstoffarmes Blut zur Lunge, die linke Seite verteilt sauerstoffreiches Blut im Körper. Ein gesundes Herz ist etwa so groß wie eine Faust und wiegt zwischen 250 und 350 Gramm. Im Laufe eines durchschnittlichen Lebens schlägt das Herz etwa 2,5 Milliarden Mal. Regelmäßige Bewegung, eine ausgewogene Ernährung und der Verzicht auf Rauchen sind die besten Wege, das Herz gesund zu halten.",
                questions: [
                    SpeedTestQuestion(question: "Wie oft schlägt das Herz pro Tag?", options: ["50.000", "100.000", "200.000", "500.000"], correctIndex: 1),
                    SpeedTestQuestion(question: "Wie viele Kammern hat das Herz?", options: ["2", "3", "4", "6"], correctIndex: 2),
                    SpeedTestQuestion(question: "Wie viel Blut pumpt das Herz pro Tag?", options: ["1.000 Liter", "3.000 Liter", "7.000 Liter", "15.000 Liter"], correctIndex: 2),
                    SpeedTestQuestion(question: "Wie groß ist ein gesundes Herz?", options: ["Wie ein Ei", "Wie eine Faust", "Wie ein Apfel", "Wie ein Fußball"], correctIndex: 1),
                    SpeedTestQuestion(question: "Wie oft schlägt das Herz im Leben?", options: ["1 Million", "100 Millionen", "2,5 Milliarden", "10 Milliarden"], correctIndex: 2)
                ]
            ),
            SpeedTestLevel(
                id: "test-3", level: 3, title: "Die Alpen", wpm: 400,
                text: "Die Alpen sind das höchste und ausgedehnteste Gebirge Europas. Sie erstrecken sich über acht Länder: Frankreich, Monaco, Italien, die Schweiz, Liechtenstein, Deutschland, Österreich und Slowenien. Der höchste Gipfel ist der Mont Blanc mit 4.810 Metern. Die Alpen entstanden vor etwa 65 Millionen Jahren durch die Kollision der afrikanischen und europäischen Kontinentalplatten. Rund 14 Millionen Menschen leben in den Alpen. Die Gletscher der Alpen sind wichtige Wasserreserven für Europa, schrumpfen aber aufgrund des Klimawandels stetig. Der Alpentourismus begann im 19. Jahrhundert und heute besuchen jährlich über 100 Millionen Touristen die Region.",
                questions: [
                    SpeedTestQuestion(question: "Über wie viele Länder erstrecken sich die Alpen?", options: ["5", "6", "8", "10"], correctIndex: 2),
                    SpeedTestQuestion(question: "Welcher ist der höchste Gipfel?", options: ["Matterhorn", "Mont Blanc", "Zugspitze", "Großglockner"], correctIndex: 1),
                    SpeedTestQuestion(question: "Wie hoch ist der höchste Gipfel?", options: ["3.810 Meter", "4.810 Meter", "5.810 Meter", "6.810 Meter"], correctIndex: 1),
                    SpeedTestQuestion(question: "Wann begann der Alpentourismus?", options: ["17. Jahrhundert", "18. Jahrhundert", "19. Jahrhundert", "20. Jahrhundert"], correctIndex: 2),
                    SpeedTestQuestion(question: "Wie viele Touristen besuchen die Alpen jährlich?", options: ["10 Millionen", "50 Millionen", "100 Millionen", "200 Millionen"], correctIndex: 2)
                ]
            ),
            SpeedTestLevel(
                id: "test-4", level: 4, title: "Die Industrielle Revolution", wpm: 500,
                text: "Die Industrielle Revolution begann Mitte des 18. Jahrhunderts in Großbritannien und veränderte die Welt grundlegend. Handarbeit wurde zunehmend durch Maschinen ersetzt. Die Dampfmaschine, perfektioniert von James Watt 1769, war der wichtigste Motor dieser Entwicklung. Fabriken entstanden und Menschen zogen vom Land in die Städte. Die Textilindustrie war besonders bedeutend. Neue Transportmittel wie Eisenbahnen und Dampfschiffe revolutionierten den Handel. Die Arbeitsbedingungen waren oft hart: lange Arbeitszeiten, niedrige Löhne und auch Kinderarbeit waren weit verbreitet. Erst nach und nach entstanden Gewerkschaften und Arbeitsgesetze. Die Industrielle Revolution legte den Grundstein für unsere moderne Wirtschaft und Gesellschaft.",
                questions: [
                    SpeedTestQuestion(question: "Wo begann die Industrielle Revolution?", options: ["Frankreich", "Deutschland", "Großbritannien", "USA"], correctIndex: 2),
                    SpeedTestQuestion(question: "Wer perfektionierte die Dampfmaschine?", options: ["Thomas Edison", "James Watt", "Isaac Newton", "Benjamin Franklin"], correctIndex: 1),
                    SpeedTestQuestion(question: "Wann wurde die Dampfmaschine perfektioniert?", options: ["1689", "1769", "1869", "1919"], correctIndex: 1),
                    SpeedTestQuestion(question: "Welche Industrie war besonders bedeutend?", options: ["Automobil", "Chemie", "Textil", "Elektronik"], correctIndex: 2),
                    SpeedTestQuestion(question: "Was entstand, um Arbeiter zu schützen?", options: ["Banken", "Gewerkschaften", "Versicherungen", "Universitäten"], correctIndex: 1)
                ]
            ),
            SpeedTestLevel(
                id: "test-5", level: 5, title: "Albert Einstein", wpm: 600,
                text: "Albert Einstein wurde 1879 in Ulm geboren und gilt als einer der bedeutendsten Physiker aller Zeiten. Seine spezielle Relativitätstheorie von 1905 führte die berühmte Formel E=mc² ein, die zeigt, dass Masse und Energie äquivalent sind. Die allgemeine Relativitätstheorie von 1915 revolutionierte unser Verständnis von Raum, Zeit und Gravitation. Einstein erhielt 1921 den Nobelpreis für Physik, allerdings nicht für die Relativitätstheorie, sondern für seine Erklärung des photoelektrischen Effekts. Nach Hitlers Machtergreifung emigrierte er 1933 in die USA und arbeitete am Institute for Advanced Study in Princeton. Einstein starb 1955 und hinterließ ein wissenschaftliches Erbe, das bis heute die Physik prägt.",
                questions: [
                    SpeedTestQuestion(question: "Wo wurde Einstein geboren?", options: ["München", "Berlin", "Ulm", "Wien"], correctIndex: 2),
                    SpeedTestQuestion(question: "Wann veröffentlichte er die spezielle Relativitätstheorie?", options: ["1895", "1905", "1915", "1925"], correctIndex: 1),
                    SpeedTestQuestion(question: "Wofür erhielt Einstein den Nobelpreis?", options: ["Relativitätstheorie", "Photoelektrischer Effekt", "Quantenmechanik", "Kernspaltung"], correctIndex: 1),
                    SpeedTestQuestion(question: "Wann emigrierte Einstein in die USA?", options: ["1923", "1933", "1943", "1953"], correctIndex: 1),
                    SpeedTestQuestion(question: "Was zeigt die Formel E=mc²?", options: ["Lichtgeschwindigkeit", "Masse-Energie-Äquivalenz", "Schwerkraft", "Elektrizität"], correctIndex: 1)
                ]
            )
        ]
    }
}
