Object subclass: Room [

    | gameObjects description connections |

    Room >> initialize [
        gameObjects := OrderedCollection new.
        description := ''.
        connections := OrderedCollection new: 4.
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

    Room >> addConnection: aRoom withDescription: aConnectionDescription [
        connections add: (aRoom -> aConnectionDescription).
    ]

    Room >> printDetails [
        Transcript show: 'Description: ', description; nl.
        Transcript show: 'GameObjects: ', gameObjects asString; nl.
        Transcript show: 'Connections: ', connections asString; nl.
    ]

]

