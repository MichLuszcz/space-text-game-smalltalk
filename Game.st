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

    Game >> setCurrentRoom: room [
        currentRoom := room.
    ]

    init [
        FileStream fileIn: 'GameObjects.st'.
        FileStream fileIn: 'Room.st'.
        isGameOver := false.
        inventory := OrderedCollection new.
        currentRoom := Room new.
        currentRoom addGameObject: (GameObject new).
        currentRoom addGameObject: (InteractibleObject new).

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

    findObjectInInventory: aName [
        ^inventory detect: [ :object | object getName = aName ] ifNone: [ nil ].
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
                        foundObject getPickable ifTrue: [
                            Transcript show: 'Picked up.'; cr.
                            currentRoom removeGameObject: foundObject.
                            inventory add: foundObject.
                        ] ifFalse: [
                            Transcript show: 'You can''t pick this up'; nl.
                        ].
                    
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

            "opens"
            "has to add items to currentRoom, this happens in the Unlockable object"
            words first = 'open' ifTrue: [
                foundObject := currentRoom findObjectByName: (words last).
                foundObject 
                ifNotNil: [
                    foundObject open: currentRoom.
                ]
                ifNil: [
                    Transcript show: 'There is no such object in this room.'; cr.
                ].
                isUnknown := false
            ].


            "use"
            "use item1 on item2"
            words first = 'use' & words size = 4 ifTrue: [
                |targetItem|

                foundObject := self findObjectInInventory: (words at: 2).
                targetItem := currentRoom findObjectByName: (words last).
                foundObject 
                ifNotNil: [
                    targetItem
                    ifNotNil: [
                        Transcript show: 'using ', foundObject getName, ' on ', targetItem getName; cr.
                        targetItem use: (foundObject getName) inRoom: currentRoom.
                    ]
                    ifNil: [
                        Transcript show: 'Target item not found in this room'; nl.
                        Transcript show: 'You do have ', foundObject getName; nl; cr.
                    ].
                ]
                ifNil: [
                    Transcript show: 'You dont have that object.'; cr.
                ].
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

            "check inventory or exits"
            words first = 'check' ifTrue: [
                words last = 'inventory' ifTrue: [
                    Transcript show: 'Inventory:'; cr.
                    inventory do: [ :object |
                    Transcript show: (object getName), '.'; nl.
                    ].
                    isUnknown := false
                ].
                words last = 'exits' ifTrue: [
                    currentRoom listConnections.
                    isUnknown := false
                ].                
            ].

        
            "move"
            words first = 'move' & words size = 2 ifTrue: [
                |newRoom|

                newRoom := currentRoom getRoomOnThe: (words last).
                newRoom ifNotNil: [
                    currentRoom:= newRoom.
                    Transcript show: 'Moved to ', (currentRoom getRoomName); cr.
                    ] ifNil: [
                    Transcript show: 'You can''t go that way.'; nl.
                    ].
                
                Transcript show: 'sysy knyszy'; cr.
                isUnknown := false
            ].

            "connect cables? TODO"
            words first = 'connect' ifTrue: [
                Transcript show: 'connect cables'; cr.
                isUnknown := false
            ].
                
            isUnknown ifTrue: [
                self printLines: #('Unknown command.' '')
            ]
        ]
    ]
]


"game" |game 

"rooms"
    "michal" room1 room2 workshop engineering_chief_office escape_pods
    "olek"
    "jedrek"
"picakble objects"
    "michal" object1
    "olek"
    "jedrek"  
"room objects" 
    "michal" object2
    "olek"
    "jedrek"
"doors" 
    "michal" object3
    "olek"
    "jedrek" |




FileStream fileIn: 'GameObjects.st'.
FileStream fileIn: 'Room.st'.




room2 := Room new.
room2 setName: 'room2'.

object1 := GameObject new.
object1 setName: 'obj1'; setDescription: 'desc1'; setPickable: true.
object2 := InteractibleObject new.
object2 setName: 'obj2'; setDescription: 'desc2'.
object2 setTriggerItemName: 'obj1'; addTriggerObject: object3.
object3 := DoorObject new.
object3 setTriggerItemName: 'obj1'; setConnetion: (Connection newDirection: 'N' to: room2).
object3 setName: 'door'; setLocked: false.

object1 getName.
object2 getName.
object3 getName.

room1 := Room new.
room1 addGameObject: object1; addGameObject: object3.
room1 setName: 'room1'.

room2 addGameObject: object2.
room2 addConnection: 'S' to: room1. 



workshop := Room new.
workshop set
engineering_chief_office := Room new.
escape_pods := Room new.

"workshop addConnection: 'W' to: engine_room."








game := Game new.
game setCurrentRoom: room2.
game run.
