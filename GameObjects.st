Object subclass: GameObject [
    |name pickable description |

    "Initialize method"
    GameObject class >> new [
        ^super new initialize
    ]

    "Initialization method"
    GameObject >> initialize [
        pickable := false.
        description := 'Default description'.
        name := 'defaultName'.
        ^self
    ]

    "Accessors"
    GameObject >> getPickable [
        ^pickable
    ]

    GameObject >> setPickable: aBoolean [
        pickable := aBoolean.
    ]

    GameObject >> setName: newName [
        name := newName.
    ]

    GameObject >> getName [
        ^name
    ]

    GameObject >> description [
        ^description
    ]

    GameObject >> setDescription: aString [
        description := aString.
    ]

    "Methods"
    GameObject >> open: room [
        Transcript show: 'You don''t know how to open this.'; cr.
    ]

    GameObject >> use: aString inRoom: room [
        Transcript show: 'You don''t know how to use this.'; cr.
    ]

    GameObject >> describe [
        Transcript show: description; cr.
    ]
]


GameObject subclass: InteractibleObject [
    |triggerItemName triggerAddedObjects triggerRemovedObjects triggerMessage|



    "Initialize method"
    InteractibleObject class >> new [
        ^super new initialize
    ]

    "Initialization method"
    InteractibleObject >> initialize [
        super initialize.
        triggerItemName := 'notValidItemName'.
        triggerAddedObjects := OrderedCollection new.
        triggerRemovedObjects := OrderedCollection new.
        triggerMessage := 'You know how to use it'.
        ^self
    ]

    InteractibleObject >> addTriggerAddedObject: aGameObject [
        triggerAddedObjects add: aGameObject.
    ]

    InteractibleObject >> removeTriggerAddedObject: aGameObject [
        triggerAddedObjects remove: aGameObject ifAbsent: [].
    ]

    InteractibleObject >> addTriggerRemovedObject: aGameObject [
        triggerRemovedObjects add: aGameObject.
    ]

    InteractibleObject >> removeTriggerRemovedObject: aGameObject [
        triggerRemovedObjects remove: aGameObject ifAbsent: [].
    ]

    InteractibleObject >> setTriggerItemName: newName [
        triggerItemName := newName.
    ]

    InteractibleObject >> setTriggerMessage: newMessage [
        triggerMessage := newMessage.
    ]

    "Adds items to current room after a correct thing is used on it"
    InteractibleObject >> use: aString inRoom: room [
        triggerItemName = aString ifTrue: [
            triggerAddedObjects do: [ :object |
                room addGameObject: object.
            ].
            triggerRemovedObjects do: [ :object |
                room removeGameObject: object
            ].
            Transcript show: triggerMessage; cr.
        ] ifFalse: [
            Transcript show: 'You do not know how to use this in this manner.'; cr.
        ].
    ]
]


InteractibleObject subclass: UnlockableObject [
    | locked openMessage|
    "Initialize method"
    UnlockableObject class >> new [
        ^super new initialize
    ]

    "Initialization method"
    UnlockableObject>> initialize [
        super initialize.
        locked := true.
        triggerMessage := 'You unlock it.'.
        openMessage := 'You open it'.
        ^self
    ]

    UnlockableObject >> setLocked: aBoolean [
        locked := aBoolean.
    ]

    UnlockableObject >> use: aString inRoom: room [
        triggerItemName = aString ifTrue: [
            locked := false.
            Transcript show: triggerMessage; cr.
        ] ifFalse: [
            Transcript show: 'You do not know how to use this in this manner.'; cr.
        ].
    ]

    UnlockableObject >> setOpenMessage: newMessage [
        openMessage := newMessage.
    ]

    UnlockableObject >> open: currentRoom [
        locked ifFalse: [
            triggerAddedObjects do: [ :object |
                currentRoom addGameObject: object.
            ].
            triggerRemovedObjects do: [ :object |
                currentRoom removeGameObject: object
            ].
            Transcript show: openMessage; nl.
        ] ifTrue: [
                Transcript show: 'You have to unlock it first!'; nl.
        ].
    ]
]


UnlockableObject subclass: DoorObject [
    |connection|


    "Initialize method"
    DoorObject class >> new [
        ^super new initialize
    ]

    "Initialization method"
    DoorObject >> initialize [
        super initialize.
        openMessage := 'You open the door'.
        ^self
    ]

    DoorObject >> setConnetion: newConnection [
        connection := newConnection. " class = Connection"
    ]

    DoorObject >> open: currentRoom [
        locked ifFalse: [
            currentRoom addConnection: (connection getDirection) to: (connection getRoom).
            Transcript show: openMessage; nl.
            "currentRoom removeGameObject: self."
        ] ifTrue: [
            Transcript show: 'You have to unlock it first!'.
        ].
    ]

]


Object subclass: Connection [
    |direction nextRoom|

    Connection >> initializeConnection: newDirection to: room [
        direction := newDirection.
        nextRoom := room.
        ^self
    ]

    Connection class >> new [
        | g |
        g := super new.
        g initialize.
        ^g
    ]

    Connection class >> newDirection: direction to: room [
        | g |
        g := super new.
        g initializeConnection: direction to: room.
        ^g
    ]

    Connection >> getDirection [
        ^direction
    ]

    Connection >> getRoom [
        ^nextRoom
    ]
]


"TODO: Make Door class
Locker : has things inside it, if opened will add things to room
Door: has a direction and another room. If opened, will add connection to current room"