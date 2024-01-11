Object subclass: GameObject [
    | pickable description |

    "Initialize method"
    GameObject class >> new [
        ^super new initialize
    ]

    "Initialization method"
    GameObject >> initialize [
        pickable := false.
        description := 'Default description'.
        ^self
    ]

    "Accessors"
    GameObject >> pickable [
        ^pickable
    ]

    GameObject >> pickable: aBoolean [
        pickable := aBoolean.
    ]

    GameObject >> description [
        ^description
    ]

    GameObject >> description: aString [
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



