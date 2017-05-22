# -*- coding: utf-8 -*-
import pymysql

class Db:
    'Login and access control'
    __i = 2 
    def __init__(self):
        self.login()
        self.connect()
        self.access()
    
    def login(self):
        self.login = input('Podaj login: ')
        self.password = input('Podaj hasło: ')  
    
    def connect(self):
        try:
            Db.conn = pymysql.connect('localhost', self.login, self.password, 'wykaz_p')      
            Db.c = self.conn.cursor()
            print('Połączono z "localhost"')
            print(Db.c)
        except:
            print('Błąd połączenia')
            #Tutaj dodać pętlę - czy próbować jeszcze raz
    
    def access(self):
        uprawnienia = ("select username, password, uprawnienia from user where username = '%s'" % self.login)
        print(uprawnienia)
        Db.c.execute(uprawnienia)
        result = Db.c.fetchall()
        for kol in result:
            username_db = kol[0]
            password_db = kol[1]
            uprawnienia_db = kol[2]
        #Do oddzielnej metody?   
        while self.__i <= 3 and self.password != password_db:
            print('Niepoprawny login lub hasło')
            self.password = input('Podaj hasło (%i próba): ' % self.__i)
            print(self.password, password_db)
            if self.__i == 3:
                print('Brak dostępu')
                Db.conn.close()
                print('Rozłączono z "localhost"')
            self.__i += 1
        print('Dostęp do bazy')
    
    #To do innej klasy
    def menu(self):
        while True:
            print('--== Menu ==--')
            wybor = input('"r" - operacje na rekordach\n"q" - wyjście z programu')
            if wybor == 'r' or wybor == 'R':
                rekord = Rekord()
                rekord.menu()
            elif wybor == 'q' or wybor =='Q':
                break
            else:
                print('Błędny wybór. Spróbuj jeszcze raz')
                continue


class Rekord(Db):
    def __init__(self):
        pass
        '''To chyba niepotrzebne
        self.c = self.conn.cursor()'''
    #polacz() jest w klasie DB
    '''
    def polacz(self):
        try:
            self.conn = pymysql.connect('localhost', 'rafal', 'rafal', 'testowa')       
            self.c = self.conn.cursor()
        except:
            print('Błąd połączenia')  
    '''
    #menu będzie w innej klasie
    def menu(self):
        print('--== Menu ==--')
        print('"d" - dodaj wpis\n("m" - modyfikuj wspis)\n"o" - odczyt bazy danych\n"q" - wyjście poziom wyżej')
        while True:
            pass
    
    def odczyt(self):
        #self.polacz()
        #try:
        sql = 'select * from user'
        Db.c.execute(sql)
        print('zapytanie sql')
        result = Db.c.fetchall()
        print('%-5s%-15s%10s' % ('ID', 'User', 'uprawnienia'))
        for kol in result:
            lp = kol[0]
            user = kol[1]
            uprawnienia = kol[5]
            print('%-5s%-15s%10s' % (lp, user, uprawnienia))                
        #except:
        #    print('Błąd. Nie można odczytać') 
        Db.conn.close()
        print('Rozłączono z "localhost"')
    
    def wpis(self):
        self.polacz()
        insert = ("insert into uzytkownicy (imie, nazwisko, pesel) values ('c', 'd', '155560')")
        try:
            self.c.execute(insert)
            self.conn.commit()
        except:
            print('Błąd. Nie można dodać rekordu')
        self.conn.close()

test = Db()
#user = Rekord()
#user.odczyt()