# -*- coding: utf-8 -*-
import pymysql

class Db:
    """Login and access control"""
    __i = 2 
    def start(self):
        Db.conn = None
        self.connect()
        if Db.conn:
            self.login()
            return self.access()       
    
    def connect(self):
        """Connects to database"""
        #Dodać pętlę - czy próbować jeszcze raz
        conn_login = input("Podaj login do połączenia z bazą danych: ")
        conn_password = input("Podaj hasło do połączenia z bazą danych: ")  
        try:
            Db.conn = pymysql.connect('localhost', 'rafal', 'rafal', 'wykaz_p')
            #Out na czas testów Db.conn = pymysql.connect('localhost', conn_login, conn_password, 'wykaz_p')      
            Db.c = self.conn.cursor()
            print('Połączono z "localhost"')
        except:
            print('Błąd połączenia')
            
    def sql_fetch(self, sql):
        try:
            Db.c.execute(sql)
            return Db.c.fetchall()
        except:
            print('Nie można pobrać danych z bazy.')
            
    def login(self):
        self.user = 'rafal'
        self.password = 'rafal'
        #out na czas testów self.user = input('Podaj login: ')
        #self.password = input('Podaj hasło: ')       
            
    def access(self):
        """Checks username, password and privileges, then grants user access to database"""
        if self.user_check() == True:
            sql = ("select username, password, uprawnienia from user where username = '%s'" % self.user)
            for res in self.sql_fetch(sql):
                self.username_db = res[0]
                self.password_db = res[1]
                uprawnienia_db = res[2]
            if self.password_check() == True:
                print('Dostęp do bazy')
                if uprawnienia_db == "001":
                    print('Witaj %s! (user)' % self.username_db)
                    u1 = User()
                    return u1
                elif uprawnienia_db == "011":
                    print('Witaj %s! (admin)' % self.username_db)
                    u1 = Admin()
                    return u1
                else:
                    self.pass_fail()
    
    def user_check(self):
        """Checks if username exist in db. If not disconnects and returns False -> program ends"""
        while self.__i > 0: 
            sql = ("select username, password, uprawnienia from user where username = '%s'" % self.user)
            if len(self.sql_fetch(sql)) == 0:
                print('Niepoprawny login lub hasło (zostało prób: %i)' % self.__i)
                self.login()
            else:
                return True
            self.__i -= 1
        self.pass_fail()
        return False
    
    def password_check(self):
        while ((self.password != self.password_db) or (self.user != self.username_db)):
            print('Niepoprawny login lub hasło (zostało prób: %i)' % self.__i)
            if self.__i == 0:
                self.pass_fail()
                return False
            self.login()
            self.__i -= 1
        return True  
    
    def pass_fail(self):
        print('Brak dostępu')
        Db.conn.close()
        print('Rozłączono z "localhost"')   
    
class Menu(Db):
    def main(self):
        while True:
            print("""
---== Menu ==---
r - operacje na rekordach
q - wyjście z programu
            """)
            wybor = input('')
            if wybor == 'r' or wybor == 'R':
                print('wybrano r')
                #rekord = Rekord()
                #rekord.menu()
            elif wybor == 'q' or wybor =='Q':
                print('wybrano q')
                break
            else:
                print('Błędny wybór. Spróbuj jeszcze raz')
                continue

class User(Menu):
    pass

class Admin(User):
    pass

class Rekord(Db):    
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
u1 = test.start()
u1.main()
#user = Rekord()
#user.odczyt()