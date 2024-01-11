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
        name := 'default object name'.
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



"TODO: Make Locker class and Door class
Locker : has things inside it, if opened will add things to room
Door: has a direction and another room. If opened, will add connection to current room"