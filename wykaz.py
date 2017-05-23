# -*- coding: utf-8 -*-
import pymysql

class Db:
    """Login and access control"""
    __i = 2 
    def __init__(self):
        Db.conn = None
        self.connect()
        if Db.conn:
            self.login()
            self.access()                
    
    def login(self):
        self.user = input('Podaj login: ')
        self.password = input('Podaj hasło: ')     
    
    def connect(self):
        """Connects to database"""
        #Dodać pętlę - czy próbować jeszcze raz
        conn_login = input("Podaj login do połączenia z bazą danych: ")
        conn_password = input("Podaj hasło do połączenia z bazą danych: ")  
        try:
            Db.conn = pymysql.connect('localhost', 'rafal', 'rafal', 'wykaz_p')
            #Out na czas tetów Db.conn = pymysql.connect('localhost', conn_login, conn_password, 'wykaz_p')      
            Db.c = self.conn.cursor()
            print('Połączono z "localhost"')
        except:
            print('Błąd połączenia') 
            
    def access(self):
        """Checks username, password and privileges, then grants user access to database"""
        if self.user_check() == True:
            uprawnienia = ("select username, password, uprawnienia from user where username = '%s'" % self.user)
            Db.c.execute(uprawnienia)
            result = Db.c.fetchall()
            for res in result:
                self.username_db = res[0]
                self.password_db = res[1]
                uprawnienia_db = res[2]
            if self.password_check() == True:
                print('Dostęp do bazy') 
                #Tutaj pisz dalej!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!    
    
    def user_check(self):
        """Checks if username exist in db. If not disconnects and returns False -> program ends"""
        users = []
        Db.c.execute("select username from user")
        result = Db.c.fetchall()
        for res in result:
            users.append(res[0])
        while self.__i > 0:           
            if self.user not in users:
                print('Niepoprawny login lub hasło (zostało prób: %i)' % self.__i)
                self.login()
            else:
                return True
            self.__i -= 1
        self.pass_fail()
        return False
    
    def password_check(self):
        while (self.password != self.password_db):
            print('Niepoprawny login lub hasło (zostało prób: %i)' % self.__i)
            self.login()
            if self.__i == 0:
                self.pass_fail()
                return False
            self.__i -= 1
        return True  
    
    def pass_fail(self):
        print('Brak dostępu')
        Db.conn.close()
        print('Rozłączono z "localhost"')     
    
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