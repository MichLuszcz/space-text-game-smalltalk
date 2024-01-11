"The germ of a text adventure game
Marcin Szlenk 2022"

"Game class

Responsibilities:
* print/read outputs/inputs
* handle game loop
* handle 'instructions' and 'halt' commands

Collaborators:
* Michał Łuszczek, Jędrzej Grabski, Aleksander Drwal"



"TODOs:
Lock class
Door class
implement move directions into Room
"



Object subclass: Game [
    | isGameOver inventory currentRoom|

    introductionText := #(
        'A long time ago, in a galaxy far, far away...'
        ''
        'It is a period of civil war. Rebel'
        'spaceships, striking from a hidden'
        'base, have won their first victory'
        'against the evil Galactic Empire.'
        ''
        'During the battle, Rebel spies managed'
        'to steal secret plans to the Empire''s'
        'ultimate weapon, the Death Star, an'
        'armored space station with enough'
        'power to destroy an entire planet.'
        ''
        'Pursued by the Empire''s sinister agents,'
        'Princess Leia races home aboard her'
        'starship, custodian of the stolen plans'
        'that can save her people and restore'
        'freedom to the galaxy....'
        ''
    ).

    instructionsText := #(
        'Available commands are:'
        ''
        'instructions  -- to see these instructions.'
        'quit          -- to end the game and quit.'
        ''
    ).
 
    Game class >> new [
        | g |
        g := super new.
        g init.
        ^g
    ]

    init [
        FileStream fileIn: 'GameObjects.st'.
        FileStream fileIn: 'Room.st'.
        isGameOver := false.
        inventory := OrderedCollection new.
        currentRoom := Room new.
        currentRoom addGameObject: (GameObject new).

    ]

    "Print strings from array in separate lines."
    printLines: anArray [
        anArray do: [ :string | Transcript show: string; cr ]
    ]

    printIntroduction [
       self printLines: introductionText.
    ]

    printInstructions [
        self printLines: instructionsText.
    ]

    readCommand [
        Transcript show: '> '.
        ^ FileStream stdin nextLine
    ]

    checkInventory [

    ]

    checkExits [

    ]

    look [

    ]
    "Run the game."
    run [
        | cmd isUnknown words foundObject|

        self printIntroduction.
        self printInstructions.

        "Game loop."
        [isGameOver] whileFalse: [

            isUnknown := true.
            cmd := self readCommand.

            cmd = 'instructions' ifTrue: [
                self printInstructions.
                isUnknown := false
            ].

            cmd = 'quit' ifTrue: [
                isGameOver := true.
                isUnknown := false
            ].

            cmd isEmpty ifTrue: [
                cmd := 'EMPTYCOMMANDSKIP'.
            ].
            words := cmd substrings. "array of words"

        
            "pick"
            words first = 'pick' ifTrue: [
                foundObject := (currentRoom findObjectByName: (words last)).

                foundObject
                    ifNotNil: [
                    Transcript show: 'Picked up.'; cr.
                    currentRoom removeGameObject: foundObject.
                    inventory add: foundObject.
                    ]
                    ifNil: [
                    Transcript show: 'There is no such object in this room.'; cr.
                    ].

                isUnknown := false.
            ].

            "inspect"
            words first = 'inspect' ifTrue: [
                foundObject := (currentRoom findObjectByName: (words last)).

                foundObject
                    ifNotNil: [
                    Transcript show: (foundObject description); cr.
                    ]
                    ifNil: [
                    Transcript show: 'There is no such object in this room.'; cr.
                    ].

                isUnknown := false
            ].

            "open TODO can create paths"
            "has to add items to currentRoom"
            words first = 'open' ifTrue: [
                self printInstructions.
                Transcript show: 'sysy knyszy'; cr.
                isUnknown := false
            ].


            "use TODO, can create paths"
            words first = 'use' ifTrue: [
                self printInstructions.
                Transcript show: 'sysy knyszy'; cr.
                isUnknown := false
            ].


            "look"
            words first = 'look' ifTrue: [
                Transcript show: (currentRoom getDescription); cr.
                "List objects in room"
                currentRoom printObjects.
                isUnknown := false
            ].

            "craft spacesuit TODO"
            words first = 'craft' ifTrue: [
                self printInstructions.
                Transcript show: 'sysy knyszy'; cr.
                isUnknown := false
            ].

            "check inventory or exits TODO"
            words first = 'check' ifTrue: [
                words last = 'inventory' ifTrue: [
                    Transcript show: 'Inventory:'; cr.
                    inventory do: [ :object |
                    Transcript show: (object getName), '.'; nl.
                    ].
                    isUnknown := false
                ].
                words last = 'exits' ifTrue: [
                    Transcript show: 'check exits'; cr.
                    isUnknown := false
                ].                
            ].

        
            "move TODO"
            words first = 'move' ifTrue: [
                self printInstructions.
                Transcript show: 'sysy knyszy'; cr.
                isUnknown := false
            ].

            "connect cables? TODO"
            words first = 'connect' ifTrue: [
                self printInstructions.
                Transcript show: 'connect cables'; cr.
                isUnknown := false
            ].




                
            isUnknown ifTrue: [
                self printLines: #('Unknown command.' '')
            ]
        ]
    ]
]

Game new run.
