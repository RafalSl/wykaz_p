# wykaz_p
Database to record climbing ascents and routes database (see schema wykaz_przejsc_schema.png - github.com/RafalSl/wykaz_przejsc/blob/master/wykaz_przejsc_schema.png)

Allows climbers to record their climbing ascents on rock, mountain and indoor routes and monitor their progress. Similar to 8a.nu. I've written a simple app in Python where you can add new routes and ascents (github.com/RafalSl/Routes-and-Ascents-Python). There will be an app written in Spring with all featuers this database offers. On the bottom of the sql file you'll find some ready sql queries, i.a. personal best ascents, climbers with best ascents, most popular routes, top rated routes, routes climbed in selected period, weight monitoring, etc.

Tables and columns names are in Polish.

It has three branches:
1. Users, login and personal info (tables users and wspinacz)
2. Outdoor routes

  Tables:
  
    kraj - country
    
    rejon - area
    
    dolina - valley/sector
    
    formacja - wall/crag
    
    droga - route
 3. Indoor routes 
 
  Tables:
  
    kraj - country
    
    miasto - city
    
    sciana - gym
    
    droga_p - route
  
  There are two tables to recrod ascents, where climer's id is associated with route's id and additional info is stored: style, date, climber's weight, rating and additional comment.
  
  Table przejscia is for outdoor ascents and przejscia_p for indoor ones.
  
  There are additional tables 'schematy' for topos (routes' sketches) and 'wyceny' with different grade scales - there's an inner scale that allows to add and display routes in chosen scale (Polish, UIAA, French, USA).
    
    

-- Polish description --

Wykaz przejsc wspinaczkowych

Baza przejść wspinaczkowych zaprojektowana w Workbenchu (MySQL) na bootcampie programistycznym.
