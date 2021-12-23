DROP KEYSPACE social_network;
CREATE KEYSPACE social_network WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : 1 };
USE social_network;

-- O recomendado era usar o data type UUID para identificar de forma única tuplos de uma entidade (id).
-- Contudo, para mostrar que os selects estão corretos, uso o id como int.

CREATE TABLE users (
    username text,
    fullname text,
    description text,
    email text,
    location text,
    created_at timestamp,
    groups set<text>,
    posts set<text>,
    likes map<text,text>,
    friends set<text>,
    comments map<text,text>,
    PRIMARY KEY (username)
);

CREATE TABLE locations (
    name text,
    users set<text>,
    events list<text>,
    PRIMARY KEY (name)
);

CREATE TABLE groups (
    id int,
    name text,
    managers map<text,text>,
    description text,
    is_private Boolean,
    posts map<text,text>,
    followers list<text>,
    created_at timestamp,
    topics set<text>,
    PRIMARY KEY (id)
);

CREATE TABLE posts (
    id int,
    post text,
    files set<text>,
    belongs_to map<text,text>,
    user text,
    comments map<text,text>,
    likes list<text>,
    created_at timestamp,
    PRIMARY KEY (id)
);

CREATE TABLE comments (
    id int,
    post text,
    comment text,
    files set<text>,
    user text,
    likes list<text>,
    created_at timestamp,
    PRIMARY KEY (id)
);

CREATE TABLE events (
    id int,
    name text,
    description text,
    type text,
    tags set<text>,
    location text,
    time date,
    posts map<text,text>,
    followers list<text>,
    created_at timestamp,
    PRIMARY KEY (id)
);

CREATE TABLE likes_posts (
    pub_id int,
    user text,
    PRIMARY KEY (pub_id,user)
);

CREATE TABLE likes_comments (
    com_id int,
    user text,
    PRIMARY KEY (com_id,user)
);

CREATE INDEX ON users(location);
CREATE INDEX ON users(groups);
CREATE INDEX ON users(friends);
CREATE INDEX ON groups(followers);
CREATE INDEX ON comments(user);
CREATE INDEX ON posts(KEYS(belongs_to));
CREATE INDEX ON events(time);
CREATE INDEX ON events(tags);


INSERT INTO users (username,fullname,description,email,location,created_at,groups,posts,likes,friends,comments) VALUES ('ricfazeres','Ricardo Fazeres','Youtuber e pai de 3 filhos','rfazeres@gmail.com','Lisboa',dateof(now()),{'YT Portugal'},{'Obrigado pelos 1M de subscritores!','Olhem os meus 3 filhos lindos!'},{'Golo do Taremi':'Post','Feliz Natal':'Post','ricfazeres dá like no meu comentário':'Comment'},{'claudiayt','daizer','floribela'},{'Grande golo. Viva o FCP!':'Golo do Taremi'});
INSERT INTO users (username,fullname,description,email,location,created_at,groups,posts,likes,friends,comments) VALUES ('claudiayt','Claudia Fazeres','Pequena Youtuber e mãe de 3 belos filhos','claudiafazeres@gmail.com','Lisboa',dateof(now()),{'YT Portugal','Culinária Tuga'},{'Adoro massa à carbonara','Feliz Natal'},{'Olhem os meus 3 filhos lindos!':'Post'},{'ricfazeres','daizer','bacano1'},{'O meu marido adora o Taremi. Taremi GOD':'Golo do Taremi'});
INSERT INTO users (username,fullname,description,email,location,created_at,groups,posts,likes,friends,comments) VALUES ('daizer','João Macarrão','Estudante na UA','daizer123@gmail.com','Aveiro',dateof(now()),{'YT Portugal','Futebol'},{'Golo do Taremi!','Que vergonha por parte da FPF!!!'},{'Feliz Natal':'Post','Obrigado pelos 1M de subscritores!':'Post'},{'jreis16','floribela'},{'ricfazeres dá like no meu comentário':'Obrigado pelos 1M de subscritores!'});
INSERT INTO users (username,fullname,description,email,location,created_at,groups,posts,likes,friends,comments) VALUES ('jreis16','João Reis','Um vagabundo de Ovar. Azul e branco é o meu coração','joaoreisyeye@gmail.com','Ovar',dateof(now()),{'Futebol','Rap','Notícias PT'},{'Olá amigos, adoro-vos!','#FCP','Estou farto de estudar...'},{'Olhem os meus 3 filhos lindos!':'Post'},{'claudiayt','floribela','cr7'},{});
INSERT INTO users (username,fullname,description,email,location,created_at,groups,posts,likes,friends,comments) VALUES ('ricardorz23','Ricardo Rodriguez','Estudante de LEI e part-time a lavar a loiça de casa','ricciardo_23@gmail.com','Aveiro',dateof(now()),{'Futebol','Skydiving','Programming'},{'Assembly é a melhor linguagem de programação','O ronaldo é lindo','Sabiam que Fátima pertence a Santarém e não a Leiria?'},{},{'cr7','jreis16','arturlwl'},{'Portooooo!':'Golo do Taremi!'});
INSERT INTO users (username,fullname,description,email,location,created_at,groups,posts,likes,friends,comments) VALUES ('arturlwl','Artur Correia Romão','Degustador dos hamburgueres do McDonalds','arturitorito@gmail.com','Ovar',dateof(now()),{'YT Portugal','Futebol','McDonalds'},{'CBO > BigMac','Imagina ser do Porto ahahahah que piada','BENFICAAAAA'},{'Feliz Natal':'Post'},{'claudiayt','ricardorz23','jreis16'},{'10/10, melhor de sempre':'Assembly é a melhor linguagem de programação','O messi é melhor lol':'O ronaldo é lindo'});
INSERT INTO users (username,fullname,description,email,location,created_at,groups,posts,likes,friends,comments) VALUES ('bernas','Bernardo Farias','Sou um grande Campião com I','bernoulli@gmail.com','Campia',dateof(now()),{'BTT','Ciclismo','Futebol'},{'O Porto tem a melhor equipa do ano!','Vrum vrum no meu ferrari'},{'Golo do Taremi':'Post','10/10, melhor de sempre':'Comment'},{'ricardorz23','jreis16'},{});
INSERT INTO users (username,fullname,description,email,location,created_at,groups,posts,likes,friends,comments) VALUES ('dxogo','Diogo Cruz','Sou de anadia e gosto de leitão hehe','dxogo@ua.pt','Anadia',dateof(now()),{'Bairrada fans','Assembly'},{'while True: money++','Adoro programar','Olá malta, como é que se dá print em Python?'},{'CBO > BigMac':'Post','Assembly é a melhor linguagem de programação':'Post','ricfazeres dá like no meu comentário':'Comment'},{'jreis16','bernas','arturlwl','ricardorz23'},{'Concordo amigo!':'Assembly é a melhor linguagem de programação'});
INSERT INTO users (username,fullname,description,email,location,created_at,groups,posts,likes,friends,comments) VALUES ('marianarosa','Mariana Rosa','Youtuber açoreana!','marychannelyt@gmail.com','Ponta Delgada',dateof(now()),{'YT Portugal','Skydiving'},{'Vejam o meu novo vídeo!','#MARY10 para 10% de desconto na Prozis!'},{},{'jreis16','bernas','arturlwl','ricardorz23'},{});
INSERT INTO users (username,fullname,description,email,location,created_at,groups,posts,likes,friends,comments) VALUES ('fahla','Nuno Fahla','Toco na tuna e não gosto de futebol','fahlafalha@gmail.com','Lobao',dateof(now()),{},{'Argélia best country ever','Olhem a minha gata Cheeseburga','Aveiro é nossooo','Estou triste','Acordeão is the new Guitarra'},{'Golo do Taremi':'Post','Feliz Natal':'Post','ricfazeres dá like no meu comentário':'Comment'},{'ricfazeres','claudiayt','daizer','floribela'},{});
INSERT INTO users (username,fullname,description,email,location,created_at,groups,posts,likes,friends,comments) VALUES ('evapomposo','Eva Bartolomeu','Estudante de LEI (3 ano)','pompompomposo@gmail.com','S. João da Pesqueira',dateof(now()),{'Python','Crochet'},{'Adorei a minha turma do 9 ano!','Imprimam mais dinheiro e assim ninguém fica pobre #200IQ','Por do Sol é a melhor série portuguesa','Alguém sabe fazer ponto cruz?'},{'Feliz Natal':'Post','Vrum vrum no meu ferrari':'Post'},{'bernas','ricardorz23','arturlwl'},{'Qual deles? O azul ou o vermelho?':'Vrum vrum no meu ferrari','Ninguém quer saber de futebol':'O ronaldo é lindo'});


INSERT INTO locations(name,users,events) VALUES ('Lisboa',{'ricfazeres','claudiayt','user123','floribela','lisboeta1','lisboeta2'},['Formação python','BTT1','YT meeting']);
INSERT INTO locations(name,users,events) VALUES ('Aveiro',{'daizer','ricardorz23','user922','user725'},['Ovos moles','Tech Week','UA 5.0']);
INSERT INTO locations(name,users,events) VALUES ('Ovar',{'jreis16','arturlwl','user000','user621'},[]);
INSERT INTO locations(name,users,events) VALUES ('Campia',{'bernas','mae_do_bernas'},['Naco na pedra - Sacristão']);
INSERT INTO locations(name,users,events) VALUES ('Anadia',{'dxogo','nahemah','leitoa','user111','user112','user113','user114'},['Bairrada Week']);
INSERT INTO locations(name,users,events) VALUES ('Ponta Delgada',{'marianarosa','sandra999'},[]);
INSERT INTO locations(name,users,events) VALUES ('Lobao',{'fahla'},[]);
INSERT INTO locations(name,users,events) VALUES ('S. João da Pesqueira',{'evapomposo','pesqueira123','pedrosobral','danifigueiredo','andrefreixo'},['Red Wine Portugal']);
INSERT INTO locations(name,users,events) VALUES ('Porto',{'p1234','mariorodrigues','analils','paulop','taremi9'},['NOS Primavera Sound','Red Bull Air Racing','São João']);
INSERT INTO locations(name,users,events) VALUES ('Coimbra',{'mpaiga','cunha12','joelferreira'},['Queima das Fitas']);
INSERT INTO locations(name,users,events) VALUES ('Viseu',{'carolenhs','ruip','pedrorei'},['Feira de São Mateus']);
INSERT INTO locations(name,users,events) VALUES ('Kiribati',{'kllife','qarabata','johnny12'},['New Year']);
INSERT INTO locations(name,users,events) VALUES ('Tuvalu',{'tuvaluan12','presituvalu'},['Kililiti']);
INSERT INTO locations(name,users,events) VALUES ('Braga',{'scbraga','yoloooss'},[]);
INSERT INTO locations(name,users,events) VALUES ('Medellin',{'cartier1','pabloescobar'},[]);


INSERT INTO groups(id,name,description,is_private,posts,managers,followers,created_at,topics) VALUES (1,'Skydiving','For everyone who loves Skydiving',False,{'Shooting my skydive!!':'skydiver123'},{'ricardorz23':'Admin'},['ricardorz23','marianarosa','skydiver123'],dateof(now()),{'Skydive','Sky'});
INSERT INTO groups(id,name,description,is_private,posts,managers,followers,created_at,topics) VALUES (2,'YT Portugal','Comunidade yt portuguesa',True,{'Obrigado pelos 1M de subscritores!':'ricfazeres','Vejam o meu novo vídeo!':'marianarosa'},{'tugayt123':'Admin','ricfazeres':'Moderator','claudiayt':'Moderator'},['claudiayt','marianarosa','daizer','arturlwl',tugayt123','benjamimkid','jorge1'],dateof(now()),{'Youtube','Portugal','Digital'});
INSERT INTO groups(id,name,description,is_private,posts,managers,followers,created_at,topics) VALUES (3,'Futebol','Liga Portuguesa e muito mais!! Sigam o grupo',False,{'Golo do Taremi':'daizer','Polemica do BSAD':'random123'},{'daizer':'Admin'},['ricardorz23','bernas','jreis16','arturlwl'],dateof(now()),{'Primeira Liga','Premier League','Champions League'});
INSERT INTO groups(id,name,description,is_private,posts,managers,followers,created_at,topics) VALUES (4,'Crochet','Crochet -> Técnicas e tutoriais',True,{'Alguém sabe fazer ponto cruz?':'evapomposo'},{'upaupa12':'Admin','crochetmasterino':'Helper'},['crochetmasterino','upaupa12','evapomposo'],dateof(now()),{'Tutoriais','Crochet'});
INSERT INTO groups(id,name,description,is_private,posts,managers,followers,created_at,topics) VALUES (5,'Python','I <3 PYTHON',True,{'Olá malta, como é que se dá print em Python?':'dxogo','Python tutorial':'baljeet_indian'},{'baljeet_indian':'Admin','python4life':'Moderator'},['dxogo','baljeet_indian','python4life','programmer123','programmer124'],dateof(now()),{'Programming','Coding','Python'});
INSERT INTO groups(id,name,description,is_private,posts,managers,followers,created_at,topics) VALUES (6,'Culinária Tuga','Receitas e comidas portuguesas',True,{'Adoro massa à carbonara':'claudiayt','Receita: francesinha':'franchesina321'},{'admin123':'Admin'},['claudiayt','franchesina321','dish_lover123'],dateof(now()),{'Comida'});
INSERT INTO groups(id,name,description,is_private,posts,managers,followers,created_at,topics) VALUES (7,'Assembly','Assembly community',False,{'Assembly é a melhor linguagem de programação':'ricardorz23'},{'assemblyadmin123':'Admin','ricardorz23':'Helper'},['ricardorz23','asmgod123','asmgod123'],dateof(now()),{'Programming','Assembly'});
INSERT INTO groups(id,name,description,is_private,posts,managers,followers,created_at,topics) VALUES (8,'Bairada fans','Fãs da Bairrada: Leitão, Pão, Vinho, tudo!!!',True,{'Leitão da bairrada: Melhores sitios?':'adorador_leitao1'},{'lechono':'Admin'},['lechono','adorador_leitao1','adorador_leitao2'],dateof(now()),{'Leitão','Anadia'});
INSERT INTO groups(id,name,description,is_private,posts,managers,followers,created_at,topics) VALUES (9,'Notícias PT','Toda a informação sobre o país!',False,{'João Rendeiro detido!':'tvi_reporter1'},{'info_god':'Admin','tvi_reporter1':'Helper'},['tvi_reporter1','info_god','jreis16'],dateof(now()),{'Portugal','Notícias'});
INSERT INTO groups(id,name,description,is_private,posts,managers,followers,created_at,topics) VALUES (10,'Rap','International Rap',True,{},{'zeninguem':'Admin'},[],dateof(now()),{'Rap','Music'});
INSERT INTO groups(id,name,description,is_private,posts,managers,followers,created_at,topics) VALUES (11,'McDonalds','For all the fans of the restaurant',False,{'CBO > BigMac':'arturlwl','How to use coupons?':'idontknow1'},{'donaldmcdonald':'Admin'},['arturlwl','idontknow1','donaldmcdonald','hmmm1','hmmmmm2'],dateof(now()),{'Restaurant','Fast Food'});


INSERT INTO posts(id,post,files,belongs_to,user,comments,likes,created_at) VALUES (12,'#MARY10 para 10% de desconto na Prozis!',{'prozis1.png','prozis2.png'},{},'marianarosa',{'Adoro!':'anapalmeirim','Bom desconto de natal!':'seguidora2'},['anapalmeirim','seguidora2','seguidora123'],dateof(now()));
INSERT INTO posts(id,post,files,belongs_to,user,comments,likes,created_at) VALUES (13,'Vejam o meu novo vídeo!',{},{'YT Portugal':'Group'},'marianarosa',{'Vídeo incrivel Mariana, beijinho!':'joanasilva','OMG':'seguidora1'},['seguidora1','seguidora2','joanasilva','seguidora123'],dateof(now()));
INSERT INTO posts(id,post,files,belongs_to,user,comments,likes,created_at) VALUES (14,'Golo do Taremi!',{'goal.mp4'},{'Futebol':'Group'},'daizer',{'Portooooo!':'ricardorz23','O meu marido adora o Taremi. Taremi GOD':'claudiayt','Grande golo. Viva o FCP!':'ricfazeres'},['ricfazeres','claudiayt','ricardorz23','roberto1','artur_pereira','jjboce'],dateof(now()));
INSERT INTO posts(id,post,files,belongs_to,user,comments,likes,created_at) VALUES (15,'Que vergonha por parte da FPF!!!',{},{},'daizer',{},['seguidor_daizer1','seguidor_daizer2'],dateof(now()));
INSERT INTO posts(id,post,files,belongs_to,user,comments,likes,created_at) VALUES (16,'Adorei a minha turma do 9 ano!',{'foto9ano1.png','foto9ano2.png'},{},'evapomposo',{'Saudades!':'anapalmeirim'},['anapalmeirim','maepomposo','tiapomposo'],dateof(now()));
INSERT INTO posts(id,post,files,belongs_to,user,comments,likes,created_at) VALUES (17,'Alguém sabe fazer ponto cruz?',{},{'Crochet':'Group'},'evapomposo',{'É fácil, faz X Y e depois Z!':'crochetmasterino'},[],dateof(now()));
INSERT INTO posts(id,post,files,belongs_to,user,comments,likes,created_at) VALUES (18,'Imprimam mais dinheiro e assim ninguém fica pobre #200IQ',{},{},'evapomposo',{},['jeff_bezos','elon_musk','bill_portas','socrates'],dateof(now()));
INSERT INTO posts(id,post,files,belongs_to,user,comments,likes,created_at) VALUES (19,'Aveiro é nossooo',{'aveiro_festa.png'},{'Tech Week':'Event'},'fahla',{'Bebedeira na tech week!':'anapalmeirim'},['anapalmeirim','dude123'],dateof(now()));
INSERT INTO posts(id,post,files,belongs_to,user,comments,likes,created_at) VALUES (20,'Por do Sol é a melhor série portuguesa',{},{},'evapomposo',{'Sem duvida Eva!':'user123','Concordo plenamente contigo':'seguidora2'},['user123','seguidora2','maepomposo'],dateof(now()));
INSERT INTO posts(id,post,files,belongs_to,user,comments,likes,created_at) VALUES (21,'Adoro massa à carbonara',{'carbonara.png'},{'Culinária Tuga':'Group'},'claudiayt',{},[],dateof(now()));
INSERT INTO posts(id,post,files,belongs_to,user,comments,likes,created_at) VALUES (22,'O Porto tem a melhor equipa do ano!',{},{'Futebol':'Group'},'bernas',{'Sem dúvida, o Taremi está muito forte mesmo':'ricardorz23','Viste o golaço dele? Meu deus...':'portista83'},['portista83','portista123','ricardorz23'],dateof(now()));
INSERT INTO posts(id,post,files,belongs_to,user,comments,likes,created_at) VALUES (23,'Obrigado pelos 1M de subscritores!',{'1msubs.png'},{'YT Portugal':'Group'},'ricfazeres',{'ricfazeres dá like no meu comentário':'daizer','Parabens riccccc':'seguidorric'},['seguidorric','daizer','marianarosa','claudiayt'],dateof(now()));
INSERT INTO posts(id,post,files,belongs_to,user,comments,likes,created_at) VALUES (24,'Olá malta, como é que se dá print em Python?',{},{'Formação python':'Event'},'dxogo',{},[],dateof(now()));
INSERT INTO posts(id,post,files,belongs_to,user,comments,likes,created_at) VALUES (25,'Sabiam que Fátima pertence a Santarém e não a Leiria?',{'mapa.png'},{},'ricardorz23',{'Não acredito nisso':'daizer','Fui enganada toda a vida!!!':'mpaiga'},['mpaiga','daizer','marianarosa','jreis16'],dateof(now()));
INSERT INTO posts(id,post,files,belongs_to,user,comments,likes,created_at) VALUES (26,'#FCP',{'portooo.png'},{'Futebol'':'Group'},'jreis16',{'PORTOOOO':'daizer'},['daizer','bernas'],dateof(now()));
INSERT INTO posts(id,post,files,belongs_to,user,comments,likes,created_at) VALUES (27,'CBO > BigMac',{},{'McDonalds':'Group'},'arturlwl',{},['ricardorz23'],dateof(now()));


-- Os caracteres com acento às vezes dão erro
INSERT INTO comments(id,post,comment,files,user,likes,created_at) VALUES (28,'Obrigado pelos 1M de subscritores!','ricfazeres da like no meu comentario',{'ricfazeresthebest.png'},'daizer',['ricfazeres','fahla','dxogo'],dateof(now()));
INSERT INTO comments(id,post,comment,files,user,likes,created_at) VALUES (29,'O ronaldo e lindo','Ninguem quer saber de futebol',{},'evapomposo',[],dateof(now()));
INSERT INTO comments(id,post,comment,files,user,likes,created_at) VALUES (30,'Vrum vrum no meu ferrari','Qual deles? O azul ou o vermelho?',{'meme_engarsado.png'},'evapomposo',['ricardorz23','bernas'],dateof(now()));
INSERT INTO comments(id,post,comment,files,user,likes,created_at) VALUES (31,'Golo do Taremi','O meu marido adora o Taremi. Taremi GOD',{'foto_com_o_taremi.png'},'claudiayt',['ricfazeres'],dateof(now()));
INSERT INTO comments(id,post,comment,files,user,likes,created_at) VALUES (32,'Golo do Taremi','Grande golo. Viva o FCP!',{},'ricfazeres',['claudiayt','taremi9','seguidorric'],dateof(now()));
INSERT INTO comments(id,post,comment,files,user,likes,created_at) VALUES (33,'Assembly eh a melhor linguagem de programação','Concordo amigo!',{},'dxogo',['bernas','assemblyadmin123','assembly_god123'],dateof(now()));
INSERT INTO comments(id,post,comment,files,user,likes,created_at) VALUES (34,'Golo do Taremi','Portooooo!',{'taremi9.png'},'ricardorz23',['taremi9','portista83','portista123'],dateof(now()));
INSERT INTO comments(id,post,comment,files,user,likes,created_at) VALUES (35,'Assembly eh a melhor linguagem de programaçao',''10/10, melhor de sempre',{'assembly.png'},'arturlwl',['jreis16','dxogo'],dateof(now()));
INSERT INTO comments(id,post,comment,files,user,likes,created_at) VALUES (36,'O ronaldo e lindo','O messi eh melhor lol',{'ancaramessimessimessi.png'},'arturlwl',['pedro_bastos','messifan10'],dateof(now()));
INSERT INTO comments(id,post,comment,files,user,likes,created_at) VALUES (37,'Sabiam que Fatima pertence a Santarem e nao a Leiria?','Fui enganada toda a vida!!!',{},'mpaiga',['ricardorz23','dxogo'],dateof(now()));
INSERT INTO comments(id,post,comment,files,user,likes,created_at) VALUES (38,'Alguem sabe fazer ponto cruz?','Eh facil, faz X Y e depois Z!',{'tutorial.mp4'},'crochetmasterino',['evapomposo','crochet_fan123'],dateof(now()));


INSERT INTO events(id,name,description,type,tags,location,time,posts,followers,created_at) VALUES (39,'Red Wine Portugal','International wine event','Expo',{'Wine'},'S. João da Pesqueira','2018-04-01',{'EA Wine. Taste it!':'ea_wine','Dão. The best wine brand of Portugal!':'dao_expo123'},['evapomposo','wine_gold','wine_taster','sjoaodapesqueirapresidente'],dateof(now()));
INSERT INTO events(id,name,description,type,tags,location,time,posts,followers,created_at) VALUES (40,'Formação python','Topicos: for/while loops e prints','Workshop',{'Python','Programming'},'Lisboa','2021-04-23',{'Alguém sabe como se faz print em Python?':'dxogo'},['dxogo','p','noob_python1','noob_python2'],dateof(now()));
INSERT INTO events(id,name,description,type,tags,location,time,posts,followers,created_at) VALUES (41,'BTT1','Prova amadora de BTT (para amigos)','Race',{'Sport'},'Lisboa','2021-12-12',{},['bttlover1','bttlover2','bttlover3'],dateof(now()));
INSERT INTO events(id,name,description,type,tags,location,time,posts,followers,created_at) VALUES (42,'YT meeting','Encontra os teus youtubers favoritos na Altice Arena!','Meeting',{'Youtube','Influencers'},'Lisboa','2021-06-17',{'Meeting RicFazeres - 18h30m!':'admin_yt1','Encontrei o Ric!':'seguidorric'},['seguidorric','ricardorz23','bernas','jreis16','user142'],dateof(now()));
INSERT INTO events(id,name,description,type,tags,location,time,posts,followers,created_at) VALUES (43,'Tech Week','Aveiro tech week - Technology and more!','Expo',{'Tech','Aveiro'},'Aveiro','2021-10-11',{'Future of tech - 14h00':'admintechweek','Can I get a job as a programmer?':'needajob123'},['needajob123','ricardorz23','arturlwl','fahla'],dateof(now()));
INSERT INTO events(id,name,description,type,tags,location,time,posts,followers,created_at) VALUES (44,'NOS Primavera Sound','Best music festival','Festival',{'Festival','Porto'},'Porto','2018-04-01',{'Tyler The Creator - Super Bock Stage':'nos_admin','Queen - Main Stage':'nos_admin'},['nos_admin','ricardorz23','fan123','fan124','fan125'],dateof(now()));
INSERT INTO events(id,name,description,type,tags,location,time,posts,followers,created_at) VALUES (45,'Queima das Fitas','O evento que mais esperas','Festival',{'Coimbra','Queima'},'Coimbra','2020-04-12',{'55 Euros pelo passe? Que vergonha':'revoltada123'},['revoltada123','mpaiga','cunha12','joelferreira'],dateof(now()));
INSERT INTO events(id,name,description,type,tags,location,time,posts,followers,created_at) VALUES (46,'Feira de São Mateus','Tratores, comida, roupa e muito mais!','Expo',{'Viseu','Feira'},'Viseu','2021-08-23',{'Peixe fresquinho a 5 eulos':'nagashima','Troco trator (não tem motor) por um BMW M3 antigo':'ladrao123'},['ladrao123','nagashima','mpaiga','ricardorz23'],dateof(now()));
INSERT INTO events(id,name,description,type,tags,location,time,posts,followers,created_at) VALUES (47,'Bairrada Week','A semana do leitão!','Expo',{'Food','Leitão'},'Anadia','2018-01-23',{'Churrasqueira Rocha, o melhor leitão':'degustador_de_leitao','Bela paisagem na Bairrada':'dxogo'},['dxogo','degustador_de_leitao','wine_taster','arturlwl','nahemah'],dateof(now()));
INSERT INTO events(id,name,description,type,tags,location,time,posts,followers,created_at) VALUES (48,'New Year','First country to be in 2022!','Festival',{'New Year','2022'},'Kiribati','2018-04-01',{},['kiribatian123'],dateof(now()));

INSERT INTO likes_posts(pub_id,user) VALUES(12,'anapalmeirim');
INSERT INTO likes_posts(pub_id,user) VALUES(12,'seguidora2');
INSERT INTO likes_posts(pub_id,user) VALUES(12,'seguidora123');
INSERT INTO likes_posts(pub_id,user) VALUES(13,'seguidora1');
INSERT INTO likes_posts(pub_id,user) VALUES(13,'seguidora2');
INSERT INTO likes_posts(pub_id,user) VALUES(13,'joanasilva');
INSERT INTO likes_posts(pub_id,user) VALUES(13,'seguidora123');
INSERT INTO likes_posts(pub_id,user) VALUES(14,'ricfazeres');
INSERT INTO likes_posts(pub_id,user) VALUES(14,'claudiayt');
INSERT INTO likes_posts(pub_id,user) VALUES(14,'ricardorz23');
INSERT INTO likes_posts(pub_id,user) VALUES(14,'roberto1');
INSERT INTO likes_posts(pub_id,user) VALUES(14,'artur_pereira');
INSERT INTO likes_posts(pub_id,user) VALUES(14,'jjboce');
INSERT INTO likes_posts(pub_id,user) VALUES(15,'seguidor_daizer1');
INSERT INTO likes_posts(pub_id,user) VALUES(15,'seguidor_daizer2');
INSERT INTO likes_posts(pub_id,user) VALUES(16,'anapalmeirim');
INSERT INTO likes_posts(pub_id,user) VALUES(16,'maepomposo');
INSERT INTO likes_posts(pub_id,user) VALUES(16,'tiapomposo');
INSERT INTO likes_posts(pub_id,user) VALUES(18,'jeff_bezos');
INSERT INTO likes_posts(pub_id,user) VALUES(18,'elon_musk');
INSERT INTO likes_posts(pub_id,user) VALUES(18,'bill_portas');
INSERT INTO likes_posts(pub_id,user) VALUES(18,'socrates');
INSERT INTO likes_posts(pub_id,user) VALUES(20,'user123');
INSERT INTO likes_posts(pub_id,user) VALUES(20,'seguidora2');
INSERT INTO likes_posts(pub_id,user) VALUES(20,'maepomposo');
INSERT INTO likes_posts(pub_id,user) VALUES(22,'portista83');
INSERT INTO likes_posts(pub_id,user) VALUES(22,'portista123');
INSERT INTO likes_posts(pub_id,user) VALUES(22,'ricardorz23');
INSERT INTO likes_posts(pub_id,user) VALUES(25,'mpaiga');
INSERT INTO likes_posts(pub_id,user) VALUES(25,'daizer');
INSERT INTO likes_posts(pub_id,user) VALUES(25,'marianarosa');
INSERT INTO likes_posts(pub_id,user) VALUES(25,'jreis16');
INSERT INTO likes_posts(pub_id,user) VALUES(26,'daizer');
INSERT INTO likes_posts(pub_id,user) VALUES(26,'bernas');
INSERT INTO likes_posts(pub_id,user) VALUES(27,'ricardorz23');

INSERT INTO likes_comments(com_id,user) VALUES(33,'bernas');
INSERT INTO likes_comments(com_id,user) VALUES(33,'assemblyadmin123');
INSERT INTO likes_comments(com_id,user) VALUES(33,'assembly_god123');
INSERT INTO likes_comments(com_id,user) VALUES(28,'ricfazeres');
INSERT INTO likes_comments(com_id,user) VALUES(28,'fahla');
INSERT INTO likes_comments(com_id,user) VALUES(28,'bernas');
INSERT INTO likes_comments(com_id,user) VALUES(30,'dxogo');
INSERT INTO likes_comments(com_id,user) VALUES(30,'ricardorz23');
INSERT INTO likes_comments(com_id,user) VALUES(36,'messifan10');
INSERT INTO likes_comments(com_id,user) VALUES(36,'pedro_bastos');
INSERT INTO likes_comments(com_id,user) VALUES(38,'evapomposo');
INSERT INTO likes_comments(com_id,user) VALUES(38,'crochet_fan123');
INSERT INTO likes_comments(com_id,user) VALUES(37,'ricardorz23');
INSERT INTO likes_comments(com_id,user) VALUES(37,'dxogo');
INSERT INTO likes_comments(com_id,user) VALUES(31,'ricfazeres');
INSERT INTO likes_comments(com_id,user) VALUES(32,'claudiayt');
INSERT INTO likes_comments(com_id,user) VALUES(32,'taremi9');
INSERT INTO likes_comments(com_id,user) VALUES(32,'seguidorric');
INSERT INTO likes_comments(com_id,user) VALUES(34,'taremi9');
INSERT INTO likes_comments(com_id,user) VALUES(34,'portista123');
INSERT INTO likes_comments(com_id,user) VALUES(34,'portista83');


-- Secondary indexs não podem ser usados tanto em inserts como em updates. Só nos deletes e nos selects.

UPDATE locations SET users = {'fahla','bulastro','josefina'} WHERE name = 'Lobao';
UPDATE locations SET events = ['Cartel de Medellin - Meeting'] WHERE name = 'Medellin';
UPDATE groups SET is_private = True WHERE id = 1;
UPDATE groups SET topics = {'Youtube','Conteudo','Videos'} WHERE id = 2;
UPDATE users SET location = 'Aveiro' WHERE username = 'arturlwl';
UPDATE events SET followers = ['seguidorric','ricardorz23','user142'] WHERE id = 42;

DELETE FROM likes_posts WHERE pub_id = 26 AND user = 'daizer';
DELETE FROM likes_posts WHERE pub_id = 25 AND user = 'mpaiga';
DELETE time FROM events WHERE id = 41;
DELETE FROM likes_comments WHERE com_id = 36 AND user = 'pedro_bastos';
SELECT id,name,posts FROM groups;
DELETE belongs_to FROM posts WHERE id = 27;
SELECT post,belongs_to FROM posts;
DELETE posts FROM groups WHERE id = 11;
SELECT id,name,posts FROM groups;

SELECT * FROM users;

-- users que sejam de Ovar / Aveiro
SELECT username,fullname,description,email,location FROM users WHERE location = 'Ovar';
SELECT username,fullname,description,location FROM users WHERE location = 'Aveiro';

-- users que pertencam ao grupo 'YT Portugal' / 'Futebol'
SELECT username,fullname,email,groups,created_at FROM users WHERE groups CONTAINS 'YT Portugal';
SELECT username,fullname,description,email,groups,location FROM users WHERE groups CONTAINS 'Futebol';

-- amigos do ricfazeres
SELECT username,fullname,description,friends FROM users WHERE friends CONTAINS 'ricfazeres';

SELECT likes FROM users WHERE username = 'evapomposo';

SELECT managers FROM groups WHERE id = 5;

SELECT name,events FROM locations WHERE name = 'Aveiro';
SELECT name,users FROM locations WHERE name = 'Lisboa';

SELECT * FROM groups WHERE id = 3;
SELECT id,name,description,topics,is_private FROM groups WHERE followers CONTAINS 'ricardorz23';

SELECT * FROM posts WHERE id = 14;
SELECT * FROM posts WHERE belongs_to CONTAINS KEY 'YT Portugal';

SELECT * FROM comments WHERE id = 30;
SELECT * FROM comments WHERE user = 'ricardorz23';

SELECT * FROM events WHERE id = 40;
SELECT * FROM events WHERE time = '2018-04-01';
SELECT * FROM events WHERE tags CONTAINS 'Sport';

SELECT COUNT(*) AS Aveirenses FROM users WHERE location = 'Aveiro';

SELECT * FROM likes_posts WHERE pub_id = 18;
SELECT COUNT(*) FROM likes_posts WHERE pub_id = 18;

SELECT * FROM likes_comments WHERE com_id = 34 ORDER BY user DESC;
SELECT * FROM likes_comments WHERE com_id = 34 ORDER BY user DESC LIMIT 1;

SELECT MIN (user) AS Menor_Alfabeticamente, MAX(user) AS Maior_Alfabeticamente FROM likes_posts;

