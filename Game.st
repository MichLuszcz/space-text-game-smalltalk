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
                        "Transcript show: 'using ', foundObject getName, ' on ', targetItem getName; cr."
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
    "jedrek" crew_bedroom crew_bedroom_vent main_corridor cantine 
"picakble objects"
    "michal" object1 hand_saw electrical_tools wooden_table_leg metal_statue makeshift_torch code_1867
    "olek"
    "jedrek"  hammer desk_key crew_access_card thick_blanket u_s_t cyber_key
"room objects" 
    "michal" object2 alien_mass toolbox small_fire workshop_window table closed_computer opened_computer broken_console escape_pod_launch_console
    "olek"
    "jedrek" desk bed locker supply_cabinet space_latch flaming_e_box eng_chief
"doors" 
    "michal" object3 engineering_chief_office_door escape_pods_door
    "olek"
    "jedrek" security_door cantine_door south_corridor_exit_door




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
object3 setTriggerItemName: 'obj1'; setConnection: (Connection newDirection: 'N' to: room2).
object3 setName: 'door'; setLocked: false.

object1 getName.
object2 getName.
object3 getName.

room1 := Room new.
room1 addGameObject: object1; addGameObject: object3.
room1 setName: 'room1'.

room2 addGameObject: object2.
room2 addConnection: 'S' to: room1. 


" JEDREK DORRS"
security_door := DoorObject new.
security_door setTriggerItemName: 'crew_access_card';
setName: 'security_door';
setDescription: 'The door leading out of your room to the main corridor remains locked. You need your own *crew_access_card* to unlock it.'.

cantine_door := DoorObject new.
setName: 'cantine_door';
setDescription: 'This door leads to the cantine. It is not locked with any lock.'.

south_corridor_exit_door := DoorObject new.
setName: 'south_corridor_exit_door';
setDescription: 'This exit leads out of the living space to the other sections of the ship. \nIt should not be locked.'.

" JEDREK ITEMS "

" crew bedroom vent"

desk_key := GameObject new.
desk_key setName: 'desk_key'.
desk_key setDescription: 'A key to the desk in your room.'.
desk_key setPickable: true.

" crew bedroom "

hammer := GameObject new.
hammer setName: 'hammer'.
hammer setDescription: 'A hammer. It''s heavy and could be used to break things.'.
hammer setPickable: true.

crew_access_card := GameObject new.
crew_access_card setName: 'crew_access_card'.
crew_access_card setDescription: 'A card that allows you to access the crew quarters.'.
crew_access_card setPickable: true.

thick_blanket := GameObject new.
thick_blanket setName: 'thick_blanket'.
thick_blanket setDescription: 'A thick blanket.'.
thick_blanket setPickable: true.

"------------"

" main corridor "

" u_s_t := GameObject new.
u_s_t setName: 'u_s_t'.
u_s_t setDescription: 'An universal speech translator'.
u_s_t setPickable: true. "

" ------------"
" cantine"

cyber_key := GameObject new.
cyber_key setName: 'cyber_key'.
cyber_key setDescription: 'A cybernetic key'.
cyber_key setPickable: true.

"------------"

" JEDREKS ROOM ITEMS "

" crew bedroom "

desk := UnlockableObject new.
desk setName: 'desk'.
setDescription: 'The desk is locked. There should be a key on it, but maybe it flew somewhere during the crash.'.
desk setLocked: true.
desk setPickable: false.
desk setTriggerItemName: 'desk_key';
desk addTriggerAddedObject: crew_access_card; addTriggerRemovedObject: desk.
desk setTriggerMessage: 'You unlock the desk and find a *crew_access_card* inside. You take it.'.


bed := InteractibleObject new.
bed setName: 'bed'.
setDescription: 'There is nothing special on this bed, aside from a Thick_Blanket. I wonder if it could be useful later.'.
desk addTriggerAddedObject: thick_blanket; addTriggerRemovedObject: bed.


locker := UnlockableObject new.
locker setName: 'locker'.
locker setDescription: 'A locker. It''s locked. It might contain something useful.'.
locker setPickable: false.
locker setLocked: false. "It's unlocked"
locker setOpenMessage: 'Toolbox opened, you see a *hand_saw* and *electrical_tools*. The saw seems to be covered in rust, but it might be good for a single use.'.
locker addTriggerAddedObject: hammer; addTriggerRemovedObject: locker.

"-------"

" main corridor "
flaming_e_box := InteractibleObject new.
flaming_e_box setName: 'flaming_e_box'.
flaming_e_box setDescription: 'The electric box is on fire. You need to put it out somehow.'.
flaming_e_box setTriggerItemName: 'thick_blanket'.
flaming_e_box setTriggerMessage: 'You throw the blanket on the fire, putting it out. The smoke clears out and the room becomes visible again'.
flaming_e_box addTriggerAddedObject: cantine_door; addTriggerAddedObject: south_corridor_exit_door; addTriggerRemovedObject: flaming_e_box.


supply_cabinet := UnlockableObject new.
supply_cabinet setName: 'supply_cabinet'.
supply_cabinet setDescription: 'The supply cabinet is wrapped in a chain and locked with a padlock. There is now way there is a key here.'.
setTriggerItemName: 'hammer';
setTriggerMessage: 'You break the padlock with the hammer, and the items inside fall out on the floor.';
addTriggerAddedObject: engineering_chief_access_card; addTriggerRemovedObject: supply_cabinet.



" JEDREK ROOMS "

crew_bedroom := Room new.
crew_bedroom setDescription: 'You are in the crew bedroom, there is a security door on the south, and a vent entrance on the east.'
crew_bedroom addGameObject: security_door; addGameObject: desk; addGameObject: bed; addGameObject: locker.
crew_bedroom addConnection: 'E' to: crew_bedroom_vent.

security_door setConnection: (Connection newDirection: 'S' to: main_corridor).

crew_bedroom_vent := Room new.
crew_bedroom_vent setDescription: 'You crawl into a rather spatious crew bedroom vent. There it is! This is where you desk_key went! Good thing it didnt fall deeper or you would be stuck in here for ever.'
crew_bedroom_vent addGameObject: desk_key.

main_corridor := Room new.
main_corridor setDescription: 'You decide its finally time to leave your quarters. Staying here definetely wont help you find out whats going on. \nYou enter the main corridor, but you can barely see anything. You can see the reason now why the alarms are going off. \nA fire is raging only a few meters in front of you. 'Probably just an overcharged e-box' - your engineer's instinct tells you. However you still can't pass through it. You need to find a way to put it out. \nBehind your back, at the west end, there is a supply cabinet, but the east end of the corridor lays behind the fire. '
main_corridor addGameObject: locker; addGameObject : flaming_e_box.

cantine_door setConnection: (Connection newDirection: 'E' to: cantine).
" south_corridor_exit_door setConnection: (Connection newDirection: 'S' to: south_corridor). "

cantine := Room new.
cantine setDescription: 'You enter the cantine. It is a rather small room, with a few tables and chairs'.
cantine addGameObject: cyber_key.
"---------------"

engineering_chief_office_door := DoorObject new.
engineering_chief_office_door setTriggerItemName: 'engineering_chief_access_card';
setName: 'engineering_chief_office_door';
setDescription: 'The door to the chief''s office, usually locked by an access card'.


escape_pods_door := DoorObject new.
escape_pods_door setLocked: false;
setName: 'escape_pods_door';
setDescription: 'Door leading to the room with emergency escape pods for the engineering crew.'.

alien_mass := InteractibleObject new.
alien_mass setName: 'alien_mass'.
alien_mass setDescription: 'A strange black mass near the *workshop_window* blocks the path south. It pulsates slightly, as if breathing.
Underneath it you see one of your colleagues being slowly absorbed by what you assume to be some kind of alien intruder.
A familiar smell of fuel fumes seems to be emanating from the creature.
It might be flammable'.
alien_mass setTriggerItemName: 'makeshift_torch'.
alien_mass addTriggerRemovedObject: alien_mass; addTriggerAddedObject: escape_pods_door.
alien_mass setTriggerMessage: 'The alien mass burns away, revealing a door to the South leading to the escape pods!'.

hand_saw := GameObject new.
hand_saw setName: 'hand_saw'.
hand_saw setDescription: 'An old hand saw'.
hand_saw setPickable: true.

electrical_tools := GameObject new.
electrical_tools setName: 'electrical_tools'.
electrical_tools setDescription: 'Various tools for electrical work such as wire cutters, soldering iron etc.'.
electrical_tools setPickable: true.


toolbox := UnlockableObject new.
toolbox setName: 'toolbox'.
toolbox setDescription: 'Standard-issue toolbox. It''s unlocked'.
toolbox setPickable: false.
toolbox setLocked: false. "It's unlocked"
toolbox setOpenMessage: 'Toolbox opened, you see a *hand_saw* and *electrical_tools*. The saw seems to be covered in rust, but it might be good for a single use.'.
toolbox addTriggerAddedObject: hand_saw; addTriggerAddedObject: electrical_tools; addTriggerRemovedObject: toolbox.


wooden_table_leg := GameObject new.
wooden_table_leg setName: 'wooden_table_leg'.
wooden_table_leg setDescription: 'Table leg, wooden'.
wooden_table_leg setPickable: true.

workshop_window := InteractibleObject new.
workshop_window setName: 'workshop_window'.
workshop_window setDescription: 'You look at the window and into space. You see pieces of debris coming from the ship as well as some strange black round objects you can''t identify.
Can be broken with enough force. Last time this happened 2 workers got sucked out into space.'.
workshop_window setPickable: false.
workshop_window setTriggerItemName: 'metal_statue'.
workshop_window addTriggerAddedObject: escape_pods_door.
workshop_window addTriggerRemovedObject: workshop_window; addTriggerRemovedObject: alien_mass.
workshop_window setTriggerMessage: 'You hurl the statue at the window, breaking it. The air begins to get sucked out the room at an incredible speed.
You grab onto the nearest pipe. All loose objects in the room fly out of the window
and the alien mass gets sucked out with them, leaving the path south clear.
the emergency force field kicks in and seals the hole before you lose consciousness'.

makeshift_torch := GameObject new.
makeshift_torch setName: 'makeshift_torch'.
makeshift_torch setDescription: 'A torch fashioned from a wooden table leg.'.
makeshift_torch setPickable: true.


small_fire := InteractibleObject new.
small_fire setName: 'small_fire'.
small_fire setDescription: 'A small electrical fire seems to have broken out in the corner of the room'.
small_fire setPickable: false.
small_fire addTriggerAddedObject: makeshift_torch.
small_fire setTriggerItemName: 'wooden_table_leg'.
small_fire setTriggerMessage: 'You leave the table leg near the fire until it catches fire, creating a *makeshift_torch*'.

table := InteractibleObject new.
table setName: 'table'.
table setDescription: 'An old wooden table. One of its legs seems to be barely holding on.
You might be able to detach it if you had the proper tool.'.
table setPickable: false.
table setTriggerItemName: 'hand_saw'.
table addTriggerAddedObject: wooden_table_leg.
table addTriggerRemovedObject: table.
table setTriggerMessage: 'You manage to sever the loose leg with your saw.
A *wooden_table_leg* lies on the floor'. "add The second the leg comes off the saw breaks"



opened_computer := GameObject new.
opened_computer setName: 'opened_computer'.
opened_computer setDescription: 'You open the closed computer sitting on the desk. You find an open email titled ESCAPE POD CODE UPDATE:
Hi, Qaux''ods, please remember about the annual escape pod tests. We''ve changed all the codes to *1867* for this week to make the process easier.
Please have the report done by next week. Cheers.'.
opened_computer setPickable: false.

code_1867 := GameObject new.
code_1867 setName: 'code_1867'.
code_1867 setDescription: 'A code to a numerical lock'.
code_1867 setPickable: true.


closed_computer := UnlockableObject new.
closed_computer setName: 'closed_computer'.
closed_computer setDescription: 'A closed laptop'.
closed_computer setPickable: false.
closed_computer setLocked: false.
closed_computer addTriggerAddedObject: opened_computer; addTriggerAddedObject: code_1867.
closed_computer addTriggerRemovedObject: closed_computer.
closed_computer setOpenMessage: 'You open the closed computer sitting on the desk. You find an open email titled ESCAPE POD CODE UPDATE:
Hi, Qaux''ods, please remember about the annual escape pod tests. We''ve changed all the codes to *1867* for this week to make the process easier.
Please have the report done by next week. Cheers'.




metal_statue := GameObject new.
metal_statue setName: 'metal_statue'.
metal_statue setDescription: 'A heavy metal statue seems to have fallen down from one of the shelves and broken through a glass table.
It''s just small enough for you to pick up and seems to be some kind of award given to the engineering chief.'.
metal_statue setPickable: true.

escape_pod_launch_console := InteractibleObject new.
escape_pod_launch_console setName: 'escape_pod_launch_console'.
escape_pod_launch_console setDescription: 'Inside the pod is a big screen with a prompt that reads:
PLEASE ENTER LAUNCH AUTHORIZATION CODE TO INITIATE LAUNCH SEQUENCE'.
escape_pod_launch_console setTriggerItemName: 'code_1867';
setTriggerMessage: 'You punch in the code. The door to the pod closes behind you and you hear a robotic voice come from the console: 
Voice: Launch sequence initiated. Please take a seat and fasten your seatbelts. 

You sit down and hope for the best. After a 20 second countdown the pod begins to shake and propels itself out of the station.
You made it. As you''re leaving the station you see the ship is covered in a moving blanket of black material. 
You live to tell the tale. You try contacting the closest colony and explain the situation. You get permission for emergency landing.
Congratulations! You managed to escape the station!

Type "quit" to end the game.'.

broken_console := InteractibleObject new.
broken_console setName: 'broken_console'.
broken_console setDescription: 'A console used for lowering the escape pods, broken. Looks like it short-circuited.
You spot some black matter between the wires. This must be what caused the break.
Needs specialized tools to be fixed.'.
broken_console setTriggerItemName: 'electrical_tools'; 
setTriggerMessage: 'You manage to fix the console and use it to lower down the remaining escape pod. 
You can now access the *escape_pod_launch_console* inside the pod and get out of here.';
addTriggerAddedObject: escape_pod_launch_console; 
addTriggerRemovedObject: broken_console.






"MICHAL ROOMS"
workshop := Room new.
workshop setDescription: 'The workshop is where most engineering on the station happens.
A door North leads to the engineering chiefs office, a South one to the escape pods'.
workshop addGameObject: engineering_chief_office_door; addGameObject: table; addGameObject: small_fire; addGameObject: alien_mass;
addGameObject:workshop_window; addGameObject: toolbox.

engineering_chief_office := Room new.
engineering_chief_office setName: 'engineering_chief_office';
setDescription: 'The office is in heavy disarray. A closed computer sits on the desk. 
Next to one of the bookshelves lays a broken glass table. Something heavy must''ve fallen on it from one of the shelves.'.
engineering_chief_office_door setConnection: (Connection newDirection: 'N' to: engineering_chief_office).
engineering_chief_office addConnection: 'S' to: workshop.
engineering_chief_office addGameObject: metal_statue; addGameObject: closed_computer.


escape_pods := Room new.
escape_pods setName: 'escape_pods'.
escape_pods setDescription: 'This room is designed to hold the emergency evacuation modules for the engineering staff.
All of them have either already been deployed, or are now covered in an alien, dark grey substance similar to the one that blocked the entrance to this room.
All except for one. You have to move fast. The pods must first be lowered using the console.
Then, once inside one of the pods, access to launch has to be granted by entering a code known to the managers of a given branch of the station.'.
escape_pods addConnection: 'N' to: workshop.
escape_pods_door setConnection: (Connection newDirection: 'S' to: escape_pods).
escape_pods addGameObject: broken_console.


"workshop addConnection: 'W' to: engine_room."








game := Game new.
game setCurrentRoom: crew_bedroom.
game run.
