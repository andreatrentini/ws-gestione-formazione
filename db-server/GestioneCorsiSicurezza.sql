drop database if exists gestionecorsisicurezza;
create database gestionecorsisicurezza;
use gestionecorsisicurezza;


### ANNI SCOLASTICI

create table anniscolastici
(annoscolastico char(7) not null,
annoinizio int not null,
annofine int not null);

alter table anniscolastici
add constraint PKAnniscolastici
primary key(annoscolastico);


### CLASSI

create table classi
(nome varchar(10) not null,
anno char(1),
sezione varchar(10),
indirizzo varchar(20),
descrizione varchar(100) not null);

alter table classi
add constraint PKClassi
primary key(nome);


### STUDENTI

create table studenti
(id int not null auto_increment primary key,
codicefiscale char(16) not null,
nome varchar(35) not null,
cognome varchar(35),
datanascita date,
sesso enum('M','F'));

alter table studenti
add constraint UniqueStudente
unique(codicefiscale);


### CLASSI STUDENTI (iscrizione di uno studente in una classe in un dato anno scolastico)

create table classistudenti
(fkannoscolastico char(7) not null,
fkclasse varchar(10) not null,
fkstudente int not null,
datainizio date not null,
datafine date);

alter table classistudenti
add constraint FKClassiStudenti_Studenti
foreign key (fkstudente)
references studenti(id);

alter table classistudenti
add constraint FKClassiStudenti_Classi
foreign key (fkclasse)
references classi(nome);

alter table classistudenti
add constraint FKClassiStudenti_Annoscolastico
foreign key (fkannoscolastico)
references anniscolastici(annoscolastico);

alter table classistudenti
add constraint PK_ClassiStudenti
primary key (fkclasse, fkstudente, fkannoscolastico, datainizio);


### MODULI

create table moduli
(id int not null auto_increment primary key,
nome varchar(200) not null,
edizione varchar(20) not null,
argomenti longtext not null,          # in alternativa longtext prevede una lunghezza massima di 4.294.967.295 caratteri
datacreazione date not null,
modificabile bool not null,
datamodifica date);


### PIANI FORMATIVI

create table pianiformativi
(id int not null auto_increment primary key,
nome varchar(200) not null,
edizione varchar(20) not null,
descrizione varchar(300) not null,
livellorischio varchar(30) not null,
datacreazione date not null,
durataprevista int not null,
percentualeobbligatorio int not null);


### PIANI FORMATIVI STUDENTI (iscrizione di uno studente ad un piano formativo)

create table pianiformativistudenti
(fkstudente int not null,
fkpianoformativo int not null,
dataiscrizione date not null,
datacertificazione date);

alter table pianiformativistudenti
add constraint PK_PianiFormativiStudenti
primary key (fkpianoformativo, fkstudente, dataiscrizione);

alter table pianiformativistudenti
add constraint FKPianiformativistudenti_Studenti
foreign key (fkstudente)
references studenti(id);

alter table pianiformativistudenti
add constraint FKPianiformativistudenti_Pianiformativi
foreign key (fkpianoformativo)
references pianiformativi(id);


### PIANI FORMATIVI MODULI (definizione della composizione di un piano formativo in relazione ai suoi moduli)

create table pianiformativimoduli
(id int not null auto_increment primary key,
fkpianoformativo int not null,
fkmodulo int not null,
durata int not null,
obbligatorio boolean not null);

alter table pianiformativimoduli
add constraint FKPianiformativimoduli_Moduli
foreign key (fkmodulo)
references moduli(id);

alter table pianiformativimoduli
add constraint FKPianiformativimoduli_Pianiformativi
foreign key (fkpianoformativo)
references pianiformativi(id);

alter table pianiformativimoduli
add constraint Unique_Pianiformativimoduli
unique (fkpianoformativo, fkmodulo);


### FORMATORI

create table formatori
(id int not null auto_increment primary key,
nome varchar(35) not null,
cognome varchar(35) not null);


### ABILITAZIONI (tiene traccia delle abilitazioni dei vari formatori ai relativi moduli)

create table abilitazioni
(fkmodulo int not null,
fkformatore int not null);

alter table abilitazioni
add constraint PKAbilitazioni
primary key(fkmodulo, fkformatore);

alter table abilitazioni
add constraint FKAbilitazioni_Moduli
foreign key(fkmodulo)
references moduli(id);

alter table abilitazioni
add constraint FKAbilitazioni_Formatori
foreign key(fkformatore)
references formatori(id);


### FORMAZIONI STUDENTI (storico della formazione degli studenti, con modulo e relativo formatore)

create table formazionistudenti
(id int not null auto_increment primary key,
fkformatore int not null,
fkstudente int not null,
fkmodulo int not null,
dataformazione date not null,
minutipresenza int not null,
superata boolean not null,
dataesame date);

alter table formazionistudenti
add constraint FKFormazionistudenti_Moduli
foreign key(fkmodulo)
references moduli(id); 

alter table formazionistudenti
add constraint FKFormazionistudenti_Studenti
foreign key(fkstudente)
references studenti(id); 

alter table formazionistudenti
add constraint FKFormazionistudenti_Formatori
foreign key(fkformatore)
references formatori(id); 

### Gestione utenti applicazione

create table utenti (
id int not null auto_increment primary key,
nome varchar(35) not null,
cognome varchar(35) not null,
username varchar(20) not null unique,
password varchar(200) not null,
lastlogin datetime,
enabled boolean not null);

### Gestione logs applicazione


create table logs (
id int not null auto_increment primary key,
datetime datetime not null,
descrizione varchar(1000) not null,
);