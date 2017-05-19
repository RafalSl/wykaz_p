# -*- coding: utf-8 -*-
import pymysql

class Db:
    'Logowanie i przyznawanie uprawnień'
    def __init__(self):
        self.login()
        self.polacz()        
    
    def login(self):
        login = input('Podja login: ')
        haslo = input('Podaj hasło: ')
        
    
    def polacz(self):
        try:
            self.conn = pymysql.connect('localhost', login, haslo, 'wykaz_p')      
            self.c = self.conn.cursor()
            self.dostep()
        except:
            print('Błąd połączenia')
            #Tutaj dodać pętlę - czy próbować jeszcze raz
    
    def dostep(self):
        uprawnienia = 'select username, password, uprawnienia from user where username = %s' % login
        self.c.execute(uprawnienia)
        result = self.c.fetchall()
        for kol in result:
            username_db = kol[0]
            password_db = kol[1]
            uprawnienia_db = kol[2]
        if haslo != password_db:
            print('Niepoprawny login lub hasło')
    
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
    def menu(self):
        print('--== Menu ==--')
        print('"d" - dodaj wpis\n("m" - modyfikuj wspis)\n"o" - odczyt bazy danych\n"q" - wyjście poziom wyżej')
        while True:
            pass
    
    def odczyt(self):
        self.polacz()
        try:
            sql = 'select * from uzytkownicy'
            self.c.execute(sql)
            result = self.c.fetchall()
            print('%3s%15s%15s%11s' %  ('ID', 'Imię', 'Nazwisko', 'PESEL'))
            for kol in result:
                lp = kol[0]
                imie = kol[1]
                nazwisko = kol[2]
                pesel = kol[3]
                print('%3s%15s%15s%11s' % (lp, imie, nazwisko, pesel))                
        except:
            print('Błąd. Nie można odczytać') 
        self.conn.close()
    
    def wpis(self):
        self.polacz()
        insert = ("insert into uzytkownicy (imie, nazwisko, pesel) values ('c', 'd', '155560')")
        try:
            self.c.execute(insert)
            self.conn.commit()
        except:
            print('Błąd. Nie można dodać rekordu')
        self.conn.close()

