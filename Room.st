Object subclass: Room [

    | gameObjects description connections roomName |

    Room >> initialize [
        gameObjects := OrderedCollection new.
        description := 'default description'.
        roomName := 'default room name'.
        connections := Dictionary new.
    ]

    Room class >> new [
        | g |
        g := super new.
        g initialize.
        ^g
    ]


    Room >> addGameObject: aGameObject [
        gameObjects add: aGameObject.
    ]

    Room >> removeGameObject: aGameObject [
        gameObjects remove: aGameObject ifAbsent: [].
    ]

    Room >> setDescription: aDescription [
        description := aDescription.
    ]

    Room >> getDescription [
        ^description.
    ]

    Room >> setName: newName [
        roomName := newName.
    ]

    Room >> getRoomName [
        ^roomName.
    ]

    Room >> printDetails [
        Transcript show: 'Description: ', description; nl.
        Transcript show: 'GameObjects: ', gameObjects asString; nl.
        Transcript show: 'Connections: ', connections asString; nl.
    ]

    Room >> printObjects [
        gameObjects do: [ :object |
            Transcript show: (object getName), '.'; nl.
        ].
    ]

        "Function to find a GameObject by name"
    Room >> findObjectByName: aName [
        ^gameObjects detect: [ :object | object getName = aName ] ifNone: [ nil ].
    ]

    Room >> addConnection: direction to: room [
        connections at: direction put: room.
    ]

    Room >> getRoomOnThe: direction [
        ^(connections at: direction ifAbsent: [nil]) 
        " throws KeyNotFound if none is found, handle in Game"
    ]

    Room >> listConnections [

        connections keysAndValuesDo: [ :key :value |
        Transcript
        show: 'Direction: ', key asString, ' To: ', (value getRoomName) asString;
        cr.
        ].
    ]

]
