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
    "michal" object1 hand_saw electrical_tools wooden_table_leg
    "olek"
    "jedrek"  
"room objects" 
    "michal" object2 alien_mass toolbox small_fire workshop_window
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
object2 setTriggerItemName: 'obj1'; addTriggerAddedObject: object3.
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


alien_mass := InteractibleObject new.
alien_mass setName: 'alien_mass'.
alien_mass setDescription: 'A strange black mass near the *workshop_window* blocks the path south. It pulsates slightly, as if breathing.
Underneath it you see one of your colleagues being slowly absorbed by what you assume to be some kind of alien intruder.
A familiar smell of fuel fumes seems to be emanating from the creature.
It might be flammable'.
"set usable thing"

toolbox := UnlockableObject new.
toolbox setName: 'toolbox'.
toolbox setDescription: 'Standard-issue toolbox. It''s unlocked'.
toolbox setPickable: false.
toolbox setLocked: false. "It's unlocked"

hand_saw := GameObject new.
hand_saw setName: 'hand_saw'.
hand_saw setDescription: 'An old hand saw'.
hand_saw setPickable: true.

electrical_tools := GameObject new.
electrical_tools setName: 'electrical_tools'.
electrical_tools setDescription: 'Various tools for electrical work such as wire cutters, soldering iron etc.'.
electrical_tools setPickable: true.

wooden_table_leg := GameObject new.
wooden_table_leg setName: 'wooden_table_leg'.
wooden_table_leg setDescription: 'Table leg, wooden'.
wooden_table_leg setPickable: true.

workshop_window := InteractibleObject new.
workshop_window setName: 'workshop_window'.
workshop_window setDescription: 'You look at the window and into space. You see pieces of debris coming from the ship as well as some strange black round objects you can''t identify.
Can be broken with enough force. Last time this happened 2 workers got sucked out into space.'.
workshop_window setPickable: false.

small_fire := InteractibleObject new.
small_fire setName: 'small_fire'.
small_fire setDescription: 'A small electrical fire seems to have broken out in the corner of the room'.
small_fire setPickable: false.

table := InteractibleObject new.
table setName: 'table'.
table setDescription: 'An old wooden table. One of its legs seems to be barely holding on.
You might be able to detach it if you had the proper tool.'.
table setPickable: false.


workshop := Room new.
workshop setDescription: 'A strange black mass near the *workshop_window* blocks the path south. It pulsates slightly, as if breathing.
Underneath it you see one of your colleagues being slowly absorbed by what you assume to be some kind of alien intruder.
A familiar smell of fuel fumes seems to be emanating from the creature.
It might be flammable'.

engineering_chief_office := Room new.
engineering_chief_office setName: 'engineering_chief_office'.
setDescription: 'The office is in heavy disarray. A closed computer sits on the desk. 
Next to one of the bookshelves lays a broken glass table. Something heavy must''ve fallen on it from one of the shelves.'.

escape_pods := Room new.
escape_pods setName: 'escape_pods'.
escape_pods setDescription: 'This room is designed to hold the emergency evacuation modules for the engineering staff.
All of them have either already been deployed, or are now covered in an alien, dark grey substance similar to the one that blocked the entrance to this room.
All except for one. You have to move fast. The pods must first be lowered using the console.
Then, once inside one of the pods, access to launch has to be granted by entering a code known to the managers of a given branch of the station.'.


"workshop addConnection: 'W' to: engine_room."








game := Game new.
game setCurrentRoom: room2.
game run.
