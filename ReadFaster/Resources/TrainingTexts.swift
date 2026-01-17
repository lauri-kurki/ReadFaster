import Foundation

/// Pre-loaded training texts for the speed reading practice
/// Supports English and German based on device language
enum TrainingTexts {
    
    static var allTexts: [TrainingText] {
        let isGerman = LanguageManager.shared.isGerman
        return isGerman ? germanTexts : englishTexts
    }
    
    // MARK: - English Texts
    
    static let englishTexts: [TrainingText] = [
        TrainingText(
            title: "Welcome to Speed Reading",
            author: "ReadFaster",
            content: """
            Welcome to ReadFaster. This app will help you read faster than ever before.
            
            The technique you are about to learn is called RSVP, which stands for Rapid Serial Visual Presentation. Instead of moving your eyes across lines of text, words come to you one at a time, right in the center of your screen.
            
            Notice the letter highlighted in red. This is called the Optimal Recognition Point, or ORP. Your brain processes words fastest when your eyes focus on this specific letter, usually about one third into the word.
            
            By keeping the ORP in exactly the same position for every word, your eyes never need to move. This eliminates the time wasted on eye movements, allowing you to read much faster.
            
            Most people read around 200 to 250 words per minute. With practice, you can easily double or triple that speed. Some readers reach 600 words per minute or more while maintaining excellent comprehension.
            
            Start with slower speeds to get comfortable. As you progress through the training levels, the speed will increase gradually. Do not worry if it feels fast at first. Your brain will adapt quickly.
            
            Ready to begin? Complete this text to unlock the next level. Good luck on your speed reading journey!
            """,
            level: 1
        ),
        TrainingText(
            title: "Our Solar System",
            author: "Science Library",
            content: """
            Our solar system is a vast and fascinating place. At its center sits the Sun, a massive ball of hot plasma that provides the energy necessary for life on Earth.
            
            Eight planets orbit the Sun. The four inner planets, Mercury, Venus, Earth, and Mars, are small and rocky. They are called the terrestrial planets because they have solid surfaces.
            
            Beyond Mars lies the asteroid belt, a region filled with rocky debris left over from the formation of the solar system. Past the asteroids are the four outer planets, also known as the gas giants.
            
            Jupiter is the largest planet, so massive that all other planets could fit inside it. Saturn is famous for its beautiful rings made of ice and rock. Uranus and Neptune are ice giants, cold and distant worlds with thick atmospheres.
            
            At the edge of our solar system lies the Kuiper Belt, home to dwarf planets like Pluto. Even farther out is the Oort Cloud, a theoretical shell of icy objects that marks the boundary between our solar system and interstellar space.
            
            Scientists continue to explore our cosmic neighborhood using telescopes and spacecraft. Each new discovery reveals more about the universe we call home.
            """,
            level: 2
        ),
        TrainingText(
            title: "The Art of Strategy",
            author: "Sun Tzu (adapted)",
            content: """
            The art of strategy is of vital importance. It is a matter of life and death, a road either to safety or to ruin. Hence it demands careful study.
            
            All warfare is based on deception. When able to attack, we must seem unable. When using our forces, we must seem inactive. When we are near, we must make the enemy believe we are far away.
            
            The supreme art of war is to subdue the enemy without fighting. Thus the skillful leader subdues the enemy's troops without any fighting. He captures cities without laying siege. He overthrows kingdoms without lengthy operations in the field.
            
            Know yourself and know your enemy, and in a hundred battles you will never be in peril. When you are ignorant of the enemy but know yourself, your chances of winning or losing are equal. If ignorant both of your enemy and yourself, you are certain to be in danger in every battle.
            
            Speed is the essence of strategy. Take advantage of the enemy's unpreparedness. Travel by unexpected routes. Strike where the enemy has not anticipated.
            
            These principles have guided leaders for thousands of years. They apply not only to warfare but to business, sports, and the challenges of everyday life.
            """,
            level: 3
        ),
        TrainingText(
            title: "The Green Light",
            author: "Classic Literature",
            content: """
            In my younger and more vulnerable years, my father gave me some advice that I have been turning over in my mind ever since. Whenever you feel like criticizing anyone, he told me, just remember that all the people in this world have not had the advantages that you have had.
            
            That summer I had just arrived in the East, nervous and excited. I rented a small house in the village of West Egg, on that slender island which extends itself due east of New York. My house was at the very tip of the egg, squeezed between two huge mansions.
            
            The one on my right was a colossal affair by any standard. It was a factual imitation of some castle in Normandy, with a tower on one side, spanking new under a thin beard of raw ivy. My own house was an eyesore, but it was a small eyesore, and so it had been overlooked.
            
            Across the courtesy bay, the white palaces of fashionable East Egg glittered along the water. The history of the summer really begins on the evening I drove over there to have dinner with some old friends.
            
            It was then that I first glimpsed my mysterious neighbor. He was standing alone on his lawn, gazing at a single green light across the water. What that light meant to him, I would only discover much later.
            """,
            level: 4
        ),
        TrainingText(
            title: "The Last Morning",
            author: "AI Stories",
            content: """
            Maya woke to the sound of rain on glass. The city stretched below her apartment, its towers disappearing into clouds of morning mist. Somewhere down there, among millions of lights and lives, her future waited.
            
            She had exactly twelve hours left. Twelve hours before the shuttle departed, before Earth became nothing more than a blue dot in the window of her cabin. Mars colony applications took three years to process, she remembered. Three years of waiting, hoping, wondering if she had made the right choice.
            
            The coffee machine hummed to life as she approached the kitchen. Her grandmother's photograph sat on the shelf, faded but precious. What would she think of all this? A granddaughter leaving the only planet humanity had ever known, chasing dreams across the void of space.
            
            Her phone buzzed. Messages from friends, family, colleagues. Some wished her luck. Others asked her to reconsider. One simply said goodbye. She read each one carefully, letting the words sink in.
            
            Outside, the rain had stopped. Sunlight broke through the clouds, painting the wet streets gold. The city had never looked more beautiful than in this moment of leaving it behind.
            
            Maya smiled and began to pack. Some journeys, she realized, are worth taking alone. Some dreams are worth the distance they demand. Today was not an ending. It was a beginning.
            """,
            level: 5
        )
    ]
    
    // MARK: - German Texts
    
    static let germanTexts: [TrainingText] = [
        TrainingText(
            title: "Willkommen zum Schnelllesen",
            author: "ReadFaster",
            content: """
            Willkommen bei ReadFaster. Diese App wird dir helfen, schneller zu lesen als je zuvor.
            
            Die Technik, die du gleich lernst, heißt RSVP. Das steht für Rapid Serial Visual Presentation. Anstatt deine Augen über Textzeilen zu bewegen, kommen die Wörter einzeln zu dir, genau in die Mitte deines Bildschirms.
            
            Beachte den rot markierten Buchstaben. Das ist der sogenannte Optimal Recognition Point, kurz ORP. Dein Gehirn verarbeitet Wörter am schnellsten, wenn deine Augen auf diesen bestimmten Buchstaben fokussieren.
            
            Da der ORP bei jedem Wort an derselben Stelle bleibt, müssen sich deine Augen nie bewegen. Das eliminiert die Zeit, die für Augenbewegungen verloren geht, und ermöglicht dir viel schnelleres Lesen.
            
            Die meisten Menschen lesen etwa 200 bis 250 Wörter pro Minute. Mit Übung kannst du diese Geschwindigkeit leicht verdoppeln oder verdreifachen. Manche Leser erreichen 600 Wörter pro Minute oder mehr.
            
            Beginne mit langsameren Geschwindigkeiten, um dich daran zu gewöhnen. Die Geschwindigkeit wird mit jedem Level schrittweise erhöht. Mach dir keine Sorgen, wenn es anfangs schnell erscheint. Dein Gehirn passt sich schnell an.
            
            Bereit anzufangen? Schließe diesen Text ab, um das nächste Level freizuschalten. Viel Erfolg!
            """,
            level: 1
        ),
        TrainingText(
            title: "Die Geschichte des Buchdrucks",
            author: "Wissen Bibliothek",
            content: """
            Die Erfindung des Buchdrucks mit beweglichen Lettern durch Johannes Gutenberg um 1450 war eine der bedeutendsten Entwicklungen der Menschheitsgeschichte. In Mainz entwickelte er eine Technik, die die Welt für immer verändern sollte.
            
            Vor Gutenberg wurden Bücher von Hand kopiert. Mönche in Klöstern verbrachten Jahre damit, einzelne Werke zu schreiben. Ein einziges Buch konnte so teuer sein wie ein Haus. Nur Könige, Adelige und Klöster konnten sich Bücher leisten.
            
            Gutenbergs Druckerpresse ermöglichte die schnelle Herstellung von Büchern. Was früher Monate dauerte, konnte nun in Tagen erledigt werden. Die Preise fielen, und immer mehr Menschen konnten lesen lernen.
            
            Sein berühmtestes Werk ist die Gutenberg-Bibel. Etwa 180 Exemplare wurden zwischen 1452 und 1455 gedruckt. Heute existieren noch 49 Stück, und jedes ist ein unschätzbares Kulturerbe.
            
            Der Buchdruck verbreitete sich rasant in ganz Europa. Innerhalb von 50 Jahren gab es Druckereien in jeder größeren Stadt. Wissenschaft, Religion und Politik wurden durch die neue Möglichkeit des Wissensaustauschs revolutioniert.
            
            Die Reformation wäre ohne den Buchdruck undenkbar gewesen. Martin Luthers Schriften verbreiteten sich in Wochen statt Jahren. Gutenbergs Erfindung legte den Grundstein für unsere moderne Informationsgesellschaft.
            """,
            level: 2
        ),
        TrainingText(
            title: "Wolfgang Amadeus Mozart",
            author: "Musik Geschichte",
            content: """
            Wolfgang Amadeus Mozart wurde am 27. Januar 1756 in Salzburg geboren. Schon als kleines Kind zeigte er außergewöhnliches musikalisches Talent. Mit drei Jahren spielte er Klavier, mit fünf komponierte er seine ersten Stücke.
            
            Sein Vater Leopold erkannte das Genie seines Sohnes und nahm ihn auf ausgedehnte Konzertreisen durch ganz Europa. Der kleine Wolfgang spielte vor Königen und Kaisern. In Paris, London und Wien feierte er Triumphe.
            
            Trotz seines frühen Ruhmes hatte Mozart oft finanzielle Schwierigkeiten. In Wien lebte er in bescheidenen Verhältnissen, komponierte aber unermüdlich. Opern wie Die Zauberflöte, Don Giovanni und Die Hochzeit des Figaro entstanden.
            
            Mozart schrieb über 600 Werke in nur 35 Lebensjahren. Sinfonien, Klavierkonzerte, Kammermusik und Kirchenmusik. Jedes Werk zeigt seine einzigartige Fähigkeit, Melodien zu erschaffen, die direkt ins Herz gehen.
            
            Am 5. Dezember 1791 starb Mozart in Wien unter mysteriösen Umständen. Er war erst 35 Jahre alt. Sein letztes Werk, das Requiem, blieb unvollendet. Es wurde von seinem Schüler Franz Xaver Süßmayr vervollständigt.
            
            Mozarts Musik hat die Jahrhunderte überdauert. Heute wird er als einer der größten Komponisten aller Zeiten verehrt. Seine Werke werden täglich auf der ganzen Welt aufgeführt und berühren Menschen jeder Kultur.
            """,
            level: 3
        ),
        TrainingText(
            title: "Die Berliner Mauer",
            author: "Deutsche Geschichte",
            content: """
            Am 13. August 1961 erwachte Berlin in einer geteilten Welt. Über Nacht hatten Soldaten begonnen, eine Mauer durch die Stadt zu errichten. Familien wurden getrennt, Freundschaften zerrissen, Leben für immer verändert.
            
            Die Mauer war 155 Kilometer lang und trennte West-Berlin vollständig von Ost-Berlin und dem umgebenden DDR-Territorium. Wachtürme, Stacheldraht und Todesstreifen machten eine Flucht nahezu unmöglich. Dennoch versuchten es viele.
            
            Mindestens 140 Menschen starben bei Fluchtversuchen. Einige versuchten es durch Tunnel, andere schwammen durch Kanäle oder versteckten sich in Autos. Die Verzweiflung trieb Menschen zu waghalsigen Aktionen.
            
            28 Jahre lang stand die Mauer als Symbol des Kalten Krieges. Sie teilte nicht nur eine Stadt, sondern zwei Weltanschauungen. Kapitalismus gegen Kommunismus, Freiheit gegen Kontrolle, West gegen Ost.
            
            Am 9. November 1989 geschah das Unglaubliche. Die DDR-Regierung öffnete die Grenzen. Tausende strömten zu den Übergängen. Menschen tanzten auf der Mauer, die so lange Angst und Trennung symbolisiert hatte.
            
            Der Fall der Berliner Mauer leitete das Ende des Kalten Krieges ein. Ein Jahr später wurde Deutschland wiedervereinigt. Heute erinnern Mauerreste und Gedenkstätten an diese bedeutsame Zeit deutscher Geschichte.
            """,
            level: 4
        ),
        TrainingText(
            title: "Deutsche Erfindungen",
            author: "Technik Magazin",
            content: """
            Deutschland hat der Welt viele bahnbrechende Erfindungen geschenkt. Vom Automobil bis zum Aspirin, von der Druckerpresse bis zum MP3-Format. Deutscher Erfindergeist hat unser modernes Leben geprägt.
            
            Karl Benz baute 1885 das erste praktisch nutzbare Automobil. Sein dreirädriger Motorwagen legte den Grundstein für eine Industrie, die heute Millionen Menschen beschäftigt. Fast zeitgleich arbeitete Gottlieb Daimler an einem vierrädrigen Fahrzeug.
            
            Rudolf Diesel entwickelte 1893 einen Motor, der effizienter war als alle bisherigen. Der Dieselmotor revolutionierte den Güterverkehr und die Schifffahrt. Noch heute treibt er Lastwagen, Züge und Schiffe auf der ganzen Welt an.
            
            Wilhelm Conrad Röntgen entdeckte 1895 eine neue Art von Strahlung. Die nach ihm benannten Röntgenstrahlen ermöglichten zum ersten Mal Blicke ins Innere des menschlichen Körpers ohne Operation.
            
            Felix Hoffmann synthetisierte 1897 bei Bayer die Acetylsalicylsäure in stabiler Form. Unter dem Namen Aspirin wurde es zum meistverkauften Medikament der Welt. Es lindert Schmerzen, senkt Fieber und beugt Herzinfarkten vor.
            
            Im Jahr 1987 entwickelte das Fraunhofer-Institut das MP3-Format. Diese Erfindung revolutionierte die Musikindustrie vollständig. Plötzlich passten tausende Songs auf einen kleinen Speicherchip.
            
            Diese Erfindungen zeigen, dass deutsche Ingenieure und Wissenschaftler seit Jahrhunderten die Welt verändern. Ihr Streben nach Perfektion und Innovation treibt den Fortschritt bis heute voran.
            """,
            level: 5
        )
    ]
}
