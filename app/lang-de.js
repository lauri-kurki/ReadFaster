// German Language File
const lang_de = {
    // UI Strings
    ui: {
        appName: "ReadFaster",
        tagline: "Trainiere deine Lesegeschwindigkeit",

        // Mode cards
        speedTest: "Lesetest",
        speedTestDesc: "Teste dein Leseverständnis",
        training: "Trainingsmodus",
        trainingDesc: "Steigere schrittweise deine Geschwindigkeit",
        freeReading: "Freies Lesen",
        freeReadingDesc: "Lies jeden Text in deinem Tempo",

        // Speed Test
        speedTestTitle: "Lesetest",
        speedTestSubtitle: "Teste dein Leseverständnis bei verschiedenen Geschwindigkeiten",
        questions: "5 Fragen",

        // Training
        trainingTitle: "Trainingsmodus",
        trainingSubtitle: "Schließe jedes Level ab, um schneller zu werden",
        words: "Wörter",

        // Free Reading
        freeReadingTitle: "Freies Lesen",
        placeholder: "Füge deinen Text hier ein...",
        paste: "Einfügen",
        upload: "Hochladen",
        loading: "Dokument wird geladen...",
        startReading: "Lesen starten",
        speed: "Geschwindigkeit",

        // Reader
        tapToStart: "Tippe zum Starten",

        // Quiz
        questionOf: "Frage %d von 5",

        // Results
        perfectTitle: "Perfekt!",
        perfectSubtitle: "Du bist ein Schnelllese-Champion!",
        excellentTitle: "Ausgezeichnet!",
        excellentSubtitle: "Du bist ein schneller Leser!",
        goodTitle: "Gut gemacht!",
        goodSubtitle: "Du hast den Test bestanden!",
        almostTitle: "Fast geschafft!",
        almostSubtitle: "Übe weiter, um dich zu verbessern!",
        retryTitle: "Weiter üben!",
        retrySubtitle: "Übung macht den Meister!",
        score: "%d/5 richtig",
        nextLevel: "Nächstes Level →",
        tryAgain: "Nochmal versuchen",
        backToMenu: "Zurück zum Menü",

        // Complete
        complete: "Fertig!",
        stats: "%d Wörter bei %d WPM",
        done: "Fertig",

        // Settings
        settings: "Einstellungen",
        language: "Sprache",
        english: "English",
        german: "Deutsch"
    },

    // Training Texts
    training: [
        {
            id: "training-1",
            title: "Willkommen zum Schnelllesen",
            author: "ReadFaster",
            level: 1,
            wpm: 150,
            content: "Willkommen bei ReadFaster. Diese App wird dir helfen, schneller zu lesen als je zuvor.\n\nDie Technik, die du gleich lernst, heißt RSVP. Das steht für Rapid Serial Visual Presentation. Anstatt deine Augen über Textzeilen zu bewegen, kommen die Wörter einzeln zu dir, genau in die Mitte deines Bildschirms.\n\nBeachte den rot markierten Buchstaben. Das ist der sogenannte Optimal Recognition Point, kurz ORP. Dein Gehirn verarbeitet Wörter am schnellsten, wenn deine Augen auf diesen bestimmten Buchstaben fokussieren.\n\nDa der ORP bei jedem Wort an derselben Stelle bleibt, müssen sich deine Augen nie bewegen. Das eliminiert die Zeit, die für Augenbewegungen verloren geht, und ermöglicht dir viel schnelleres Lesen.\n\nDie meisten Menschen lesen etwa 200 bis 250 Wörter pro Minute. Mit Übung kannst du diese Geschwindigkeit leicht verdoppeln oder verdreifachen. Manche Leser erreichen 600 Wörter pro Minute oder mehr.\n\nBeginne mit langsameren Geschwindigkeiten, um dich daran zu gewöhnen. Die Geschwindigkeit wird mit jedem Level schrittweise erhöht. Mach dir keine Sorgen, wenn es anfangs schnell erscheint. Dein Gehirn passt sich schnell an.\n\nBereit anzufangen? Schließe diesen Text ab, um das nächste Level freizuschalten. Viel Erfolg!"
        },
        {
            id: "training-2",
            title: "Die Geschichte des Buchdrucks",
            author: "Wissen Bibliothek",
            level: 2,
            wpm: 200,
            content: "Die Erfindung des Buchdrucks mit beweglichen Lettern durch Johannes Gutenberg um 1450 war eine der bedeutendsten Entwicklungen der Menschheitsgeschichte. In Mainz entwickelte er eine Technik, die die Welt für immer verändern sollte.\n\nVor Gutenberg wurden Bücher von Hand kopiert. Mönche in Klöstern verbrachten Jahre damit, einzelne Werke zu schreiben. Ein einziges Buch konnte so teuer sein wie ein Haus. Nur Könige, Adelige und Klöster konnten sich Bücher leisten.\n\nGutenbergs Druckerpresse ermöglichte die schnelle Herstellung von Büchern. Was früher Monate dauerte, konnte nun in Tagen erledigt werden. Die Preise fielen, und immer mehr Menschen konnten lesen lernen.\n\nSein berühmtestes Werk ist die Gutenberg-Bibel. Etwa 180 Exemplare wurden zwischen 1452 und 1455 gedruckt. Heute existieren noch 49 Stück, und jedes ist ein unschätzbares Kulturerbe.\n\nDer Buchdruck verbreitete sich rasant in ganz Europa. Innerhalb von 50 Jahren gab es Druckereien in jeder größeren Stadt. Wissenschaft, Religion und Politik wurden durch die neue Möglichkeit des Wissensaustauschs revolutioniert."
        },
        {
            id: "training-3",
            title: "Wolfgang Amadeus Mozart",
            author: "Musik Geschichte",
            level: 3,
            wpm: 250,
            content: "Wolfgang Amadeus Mozart wurde am 27. Januar 1756 in Salzburg geboren. Schon als kleines Kind zeigte er außergewöhnliches musikalisches Talent. Mit drei Jahren spielte er Klavier, mit fünf komponierte er seine ersten Stücke.\n\nSein Vater Leopold erkannte das Genie seines Sohnes und nahm ihn auf ausgedehnte Konzertreisen durch ganz Europa. Der kleine Wolfgang spielte vor Königen und Kaisern. In Paris, London und Wien feierte er Triumphe.\n\nTrotz seines frühen Ruhmes hatte Mozart oft finanzielle Schwierigkeiten. In Wien lebte er in bescheidenen Verhältnissen, komponierte aber unermüdlich. Opern wie Die Zauberflöte, Don Giovanni und Die Hochzeit des Figaro entstanden.\n\nMozart schrieb über 600 Werke in nur 35 Lebensjahren. Sinfonien, Klavierkonzerte, Kammermusik und Kirchenmusik. Jedes Werk zeigt seine einzigartige Fähigkeit, Melodien zu erschaffen, die direkt ins Herz gehen.\n\nAm 5. Dezember 1791 starb Mozart in Wien unter mysteriösen Umständen. Er war erst 35 Jahre alt. Sein letztes Werk, das Requiem, blieb unvollendet."
        },
        {
            id: "training-4",
            title: "Die Berliner Mauer",
            author: "Deutsche Geschichte",
            level: 4,
            wpm: 350,
            content: "Am 13. August 1961 erwachte Berlin in einer geteilten Welt. Über Nacht hatten Soldaten begonnen, eine Mauer durch die Stadt zu errichten. Familien wurden getrennt, Freundschaften zerrissen, Leben für immer verändert.\n\nDie Mauer war 155 Kilometer lang und trennte West-Berlin vollständig von Ost-Berlin. Wachtürme, Stacheldraht und Todesstreifen machten eine Flucht nahezu unmöglich. Dennoch versuchten es viele.\n\nMindestens 140 Menschen starben bei Fluchtversuchen. Einige versuchten es durch Tunnel, andere schwammen durch Kanäle oder versteckten sich in Autos. Die Verzweiflung trieb Menschen zu waghalsigen Aktionen.\n\n28 Jahre lang stand die Mauer als Symbol des Kalten Krieges. Sie teilte nicht nur eine Stadt, sondern zwei Weltanschauungen.\n\nAm 9. November 1989 geschah das Unglaubliche. Die DDR-Regierung öffnete die Grenzen. Tausende strömten zu den Übergängen. Menschen tanzten auf der Mauer.\n\nDer Fall der Berliner Mauer leitete das Ende des Kalten Krieges ein. Ein Jahr später wurde Deutschland wiedervereinigt."
        },
        {
            id: "training-5",
            title: "Deutsche Erfindungen",
            author: "Technik Magazin",
            level: 5,
            wpm: 500,
            content: "Deutschland hat der Welt viele bahnbrechende Erfindungen geschenkt. Vom Automobil bis zum Aspirin, von der Druckerpresse bis zum MP3-Format. Deutscher Erfindergeist hat unser modernes Leben geprägt.\n\nKarl Benz baute 1885 das erste praktisch nutzbare Automobil. Sein dreirädriger Motorwagen legte den Grundstein für eine Industrie, die heute Millionen Menschen beschäftigt.\n\nRudolf Diesel entwickelte 1893 einen Motor, der effizienter war als alle bisherigen. Der Dieselmotor revolutionierte den Güterverkehr und die Schifffahrt.\n\nWilhelm Conrad Röntgen entdeckte 1895 eine neue Art von Strahlung. Die nach ihm benannten Röntgenstrahlen ermöglichten zum ersten Mal Blicke ins Innere des menschlichen Körpers.\n\nFelix Hoffmann synthetisierte 1897 bei Bayer die Acetylsalicylsäure in stabiler Form. Unter dem Namen Aspirin wurde es zum meistverkauften Medikament der Welt.\n\nIm Jahr 1987 entwickelte das Fraunhofer-Institut das MP3-Format. Diese Erfindung revolutionierte die Musikindustrie vollständig.\n\nDiese Erfindungen zeigen, dass deutsche Ingenieure und Wissenschaftler seit Jahrhunderten die Welt verändern."
        }
    ],

    // Speed Test
    speedTest: [
        {
            id: "test-1", level: 1, title: "Bienen und Honig", wpm: 200,
            text: "Bienen sind faszinierende Insekten, die seit Jahrtausenden eine wichtige Rolle in der Natur spielen. Ein einzelner Bienenstock kann bis zu 60.000 Bienen beherbergen. Die Königin ist die einzige Biene, die Eier legt. Für ein Kilogramm Honig müssen Bienen etwa drei Millionen Blüten besuchen. Dabei legen sie eine Strecke zurück, die dem dreifachen Erdumfang entspricht. Honig ist das einzige Nahrungsmittel, das niemals verdirbt. Archäologen haben dreitausend Jahre alten Honig in ägyptischen Gräbern gefunden, der noch essbar war. Bienen kommunizieren durch einen besonderen Tanz, den sogenannten Schwänzeltanz. Damit zeigen sie anderen Bienen, wo Nahrungsquellen zu finden sind.",
            questions: [
                { question: "Wie viele Bienen kann ein Bienenstock beherbergen?", options: ["10.000", "30.000", "60.000", "100.000"], correctIndex: 2 },
                { question: "Welche Biene legt alle Eier?", options: ["Arbeiterbiene", "Königin", "Drohne", "Wächterbiene"], correctIndex: 1 },
                { question: "Wie viele Blüten braucht man für ein Kilogramm Honig?", options: ["100.000", "1 Million", "3 Millionen", "10 Millionen"], correctIndex: 2 },
                { question: "Was ist besonders am Honig?", options: ["Er ist radioaktiv", "Er verdirbt nie", "Er ist giftig", "Er leuchtet"], correctIndex: 1 },
                { question: "Wie kommunizieren Bienen?", options: ["Durch Laute", "Durch Farben", "Durch einen Tanz", "Durch Geruch"], correctIndex: 2 }
            ]
        },
        {
            id: "test-2", level: 2, title: "Das menschliche Herz", wpm: 300,
            text: "Das menschliche Herz ist ein faszinierendes Organ. Es schlägt etwa 100.000 Mal pro Tag und pumpt dabei rund 7.000 Liter Blut durch den Körper. Das Herz besteht aus vier Kammern: zwei Vorhöfen und zwei Herzkammern. Die rechte Seite pumpt sauerstoffarmes Blut zur Lunge, die linke Seite verteilt sauerstoffreiches Blut im Körper. Ein gesundes Herz ist etwa so groß wie eine Faust und wiegt zwischen 250 und 350 Gramm. Im Laufe eines durchschnittlichen Lebens schlägt das Herz etwa 2,5 Milliarden Mal. Regelmäßige Bewegung und eine ausgewogene Ernährung sind die besten Wege, das Herz gesund zu halten.",
            questions: [
                { question: "Wie oft schlägt das Herz pro Tag?", options: ["50.000", "100.000", "200.000", "500.000"], correctIndex: 1 },
                { question: "Wie viele Kammern hat das Herz?", options: ["2", "3", "4", "6"], correctIndex: 2 },
                { question: "Wie viel Blut pumpt das Herz pro Tag?", options: ["1.000 Liter", "3.000 Liter", "7.000 Liter", "15.000 Liter"], correctIndex: 2 },
                { question: "Wie groß ist ein gesundes Herz?", options: ["Wie ein Ei", "Wie eine Faust", "Wie ein Apfel", "Wie ein Fußball"], correctIndex: 1 },
                { question: "Wie oft schlägt das Herz im Leben?", options: ["1 Million", "100 Millionen", "2,5 Milliarden", "10 Milliarden"], correctIndex: 2 }
            ]
        },
        {
            id: "test-3", level: 3, title: "Die Alpen", wpm: 400,
            text: "Die Alpen sind das höchste und ausgedehnteste Gebirge Europas. Sie erstrecken sich über acht Länder: Frankreich, Monaco, Italien, die Schweiz, Liechtenstein, Deutschland, Österreich und Slowenien. Der höchste Gipfel ist der Mont Blanc mit 4.810 Metern. Die Alpen entstanden vor etwa 65 Millionen Jahren durch die Kollision der afrikanischen und europäischen Kontinentalplatten. Rund 14 Millionen Menschen leben in den Alpen. Der Alpentourismus begann im 19. Jahrhundert und heute besuchen jährlich über 100 Millionen Touristen die Region.",
            questions: [
                { question: "Über wie viele Länder erstrecken sich die Alpen?", options: ["5", "6", "8", "10"], correctIndex: 2 },
                { question: "Welcher ist der höchste Gipfel?", options: ["Matterhorn", "Mont Blanc", "Zugspitze", "Großglockner"], correctIndex: 1 },
                { question: "Wie hoch ist der höchste Gipfel?", options: ["3.810 Meter", "4.810 Meter", "5.810 Meter", "6.810 Meter"], correctIndex: 1 },
                { question: "Wann begann der Alpentourismus?", options: ["17. Jahrhundert", "18. Jahrhundert", "19. Jahrhundert", "20. Jahrhundert"], correctIndex: 2 },
                { question: "Wie viele Touristen besuchen die Alpen jährlich?", options: ["10 Millionen", "50 Millionen", "100 Millionen", "200 Millionen"], correctIndex: 2 }
            ]
        },
        {
            id: "test-4", level: 4, title: "Die Industrielle Revolution", wpm: 500,
            text: "Die Industrielle Revolution begann Mitte des 18. Jahrhunderts in Großbritannien und veränderte die Welt grundlegend. Handarbeit wurde zunehmend durch Maschinen ersetzt. Die Dampfmaschine, perfektioniert von James Watt 1769, war der wichtigste Motor dieser Entwicklung. Fabriken entstanden und Menschen zogen vom Land in die Städte. Die Textilindustrie war besonders bedeutend. Die Arbeitsbedingungen waren oft hart. Erst nach und nach entstanden Gewerkschaften und Arbeitsgesetze.",
            questions: [
                { question: "Wo begann die Industrielle Revolution?", options: ["Frankreich", "Deutschland", "Großbritannien", "USA"], correctIndex: 2 },
                { question: "Wer perfektionierte die Dampfmaschine?", options: ["Thomas Edison", "James Watt", "Isaac Newton", "Benjamin Franklin"], correctIndex: 1 },
                { question: "Wann wurde die Dampfmaschine perfektioniert?", options: ["1689", "1769", "1869", "1919"], correctIndex: 1 },
                { question: "Welche Industrie war besonders bedeutend?", options: ["Automobil", "Chemie", "Textil", "Elektronik"], correctIndex: 2 },
                { question: "Was entstand, um Arbeiter zu schützen?", options: ["Banken", "Gewerkschaften", "Versicherungen", "Universitäten"], correctIndex: 1 }
            ]
        },
        {
            id: "test-5", level: 5, title: "Albert Einstein", wpm: 600,
            text: "Albert Einstein wurde 1879 in Ulm geboren und gilt als einer der bedeutendsten Physiker aller Zeiten. Seine spezielle Relativitätstheorie von 1905 führte die berühmte Formel E=mc² ein. Die allgemeine Relativitätstheorie von 1915 revolutionierte unser Verständnis von Raum, Zeit und Gravitation. Einstein erhielt 1921 den Nobelpreis für Physik für seine Erklärung des photoelektrischen Effekts. Nach Hitlers Machtergreifung emigrierte er 1933 in die USA. Einstein starb 1955 in Princeton.",
            questions: [
                { question: "Wo wurde Einstein geboren?", options: ["München", "Berlin", "Ulm", "Wien"], correctIndex: 2 },
                { question: "Wann veröffentlichte er die spezielle Relativitätstheorie?", options: ["1895", "1905", "1915", "1925"], correctIndex: 1 },
                { question: "Wofür erhielt Einstein den Nobelpreis?", options: ["Relativitätstheorie", "Photoelektrischer Effekt", "Quantenmechanik", "Kernspaltung"], correctIndex: 1 },
                { question: "Wann emigrierte Einstein in die USA?", options: ["1923", "1933", "1943", "1953"], correctIndex: 1 },
                { question: "Was zeigt die Formel E=mc²?", options: ["Lichtgeschwindigkeit", "Masse-Energie-Äquivalenz", "Schwerkraft", "Elektrizität"], correctIndex: 1 }
            ]
        }
    ]
};
