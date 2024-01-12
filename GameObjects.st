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
    |triggerItemName triggerAddedObjects|



    "Initialize method"
    InteractibleObject class >> new [
        ^super new initialize
    ]

    "Initialization method"
    InteractibleObject >> initialize [
        super initialize.
        triggerItemName := 'notValidItemName'.
        triggerAddedObjects := OrderedCollection new.
        ^self
    ]

    InteractibleObject >> addTriggerObject: aGameObject [
        triggerAddedObjects add: aGameObject.
    ]

    InteractibleObject >> removeTriggerObject: aGameObject [
        triggerAddedObjects remove: aGameObject ifAbsent: [].
    ]

    InteractibleObject >> setTriggerItemName: newName [
        triggerItemName := newName.
    ]


    "Adds items to current room after a correct thing is used on it"
    InteractibleObject >> use: aString inRoom: room [
        triggerItemName = asString ifTrue: [
            triggerAddedObjects do: [ :object |
                room addGameObject: object.
            ].
            Transcript show: 'You DO know how to use this.'; cr.
        ] ifFalse: [
            Transcript show: 'You do not know how to use this in this manner.'; cr.
        ].
    ]
]


InteractibleObject subclass: UnlockableObject [
    | locked |
    "Initialize method"
    UnlockableObject class >> new [
        ^super new initialize
    ]

    "Initialization method"
    UnlockableObject>> initialize [
        super initialize.
        locked := true.
        ^self
    ]

    UnlockableObject >> setLocked: aBoolean [
        locked := aBoolean.
    ]

    UnlockableObject >> use: aString inRoom: room [
        triggerItemName = aString ifTrue: [
            locked := false.
            Transcript show: 'You unlock ', name; cr.
        ] ifFalse: [
            Transcript show: 'You do not know how to use this in this manner.'; cr.
        ].
    ]

    UnlockableObject >> open: currentRoom [
        locked ifFalse: [
            triggerAddedObjects do: [ :object |
                currentRoom addGameObject: object.
            ].
        ] ifTrue [
                Transcript show: 'You have to unlock it first!'.
        ].
    ]
]


UnlockableObject subclass: DoorObject [
    |connection |


    "Initialize method"
    DoorObject class >> new [
        ^super new initialize
    ]

    "Initialization method"
    DoorObject >> initialize [
        super initialize.
        ^self
    ]

    DoorObject >> setConnetion: newConnection [
        connection := newConnection. " class = Connection"
    ]

    Door >> open: currentRoom [
        locked ifFalse: [
            currentRoom addConnection: connection.
        ] ifTrue [
            Transcript show: 'You have to unlock it first!'.
        ].
    ]

]




"TODO: Make Door class
Locker : has things inside it, if opened will add things to room
Door: has a direction and another room. If opened, will add connection to current room"