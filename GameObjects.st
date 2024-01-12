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
    GameObject >> pickable [
        ^pickable
    ]

    GameObject >> pickable: aBoolean [
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
    GameObject >> open [
        Transcript show: 'You don''t know how to open this.'; cr.
    ]

    GameObject >> use: aString [
        Transcript show: 'You don''t know how to use this.'; cr.
    ]

    GameObject >> describe [
        Transcript show: description; cr.
    ]
]


GameObject subclass: UsableObject [
    |triggerItemName triggerAddedObjects|



    "Initialize method"
    UsableObject class >> new [
        ^super new initialize
    ]

    "Initialization method"
    UsableObject >> initialize [
        super initialize.
        triggerItemName := 'notValidItemName'.
        triggerAddedObjects := OrderedCollection new.
        ^self
    ]

    UsableObject >> addTriggerObject: aGameObject [
        triggerAddedObjects add: aGameObject.
    ]

    UsableObject >> removeTriggerObject: aGameObject [
        triggerAddedObjects remove: aGameObject ifAbsent: [].
    ]

    "Adds items to current room after a correct thing is used on it"
    UsableObject >> use: aString inRoom: room [
        triggerItemName = asString ifTrue: [
            triggerAddedObjects do: [ :object |
                room addGameObject: object.
            ].
            Transcript show: 'You DO know how to use this.'; cr.
        ] ifFalse: [
            Transcript show: 'You do not know how to use this in this manner.'; cr.
        ]
    ]


]


"TODO: Make Locker class and Door class
Locker : has things inside it, if opened will add things to room
Door: has a direction and another room. If opened, will add connection to current room"