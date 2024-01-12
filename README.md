# PARP2023Z Smalltalk Projekt

## Struktura i użycie:
Room:
- obiekty w pokoju
- opis
- aktywne wyjścia
- nazwa

room1 := Room new
room1 addGameObject: object1; addGameObject: object2.
room1 setName: 'room1'.

room2 := Room new.
room2 setName: 'room2'.
room2 addGameObject: object3.
room2 addConnection: 'S' to: room1. 

Objects:
- nazwa
- czy jest podnaszalny (default = false)
- opis do inspect
object1 := GameObject new.
object1 := setName: 'object1'; pickable: true.

Podklasą obiektów są obiekty na których można czegoś użyć. 
To coś identyfikowane jest nazwą (triggerItemName). Po użyciu przedmiotu o określonej nazwie do pokoju zostają dodane przedmioty które też trzymane są w obiekcie (triggerAddedObjects).

Podklasą tych obiektów są obiekty zamkykalne. Tu triggerItemName oznacza nazwę klucza który musi być uzyty żeby odblokować coś. Przedmioty zostają dodane po wywołaniu open: currentroom na odblokowanym obiekcie.

podklasą obiektów zamykalnych są drzwi które zamiast dodawać obiekty dodają połączenie do innego pokoju.
Drzwi trzymają połączenie (connection klasy Connection).
