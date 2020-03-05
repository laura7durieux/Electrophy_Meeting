%%% Exemple de traitement �lectrophy avec 2 canaux

% Charger dans matlab les donn�es (ici on prend un exemple d'un seul
% fichier)
% load('path/fihier');            Th�orie
load('E:\Data_Electrophy\Electrophy2\190508_rat7_Hab1\F190508-0001.mat') % exemple 


% Suprimer toutes les varaiables except�es celles que tu veux 
clearvars -except CLFP_001 CLFP_001_BitResolution CLFP_001_Gain CLFP_001_KHz CLFP_002 CLFP_003 CLFP_004 CLFP_005 CLFP_006 CLFP_007 CLFP_008 CLFP_009 CLFP_010 CLFP_011 CLFP_012 CLFP_013 CLFP_014 CLFP_015 CLFP_016

% Attribuer des variables avec un nom plus clair (renomme comme tu veux)
srate = CLFP_001_KHz*1000; %% mets la frequence d'�chantillonage dans une autre variable 
ch_bitResolution = CLFP_001_BitResolution; %% put the bitResolution from the software raw data into a new variable
ch_gain = CLFP_001_Gain; %% put the gain from the software raw data into a new variable

% Nous allons garder que la ch 1 et 2 pour le moment 
LFPTemp = [CLFP_001 ; CLFP_002]; % cr�ation d'une matrix o� les lignes sont les deux canaux et les colonnes repr�sentent les �chantillons (temps).

% Exemple de plot sur deux canaux
figure;
subplot(211)
plot(LFP(1,:))
title('Ch 1')
ylabel('en bit')
xlabel('en point')
subplot(212)
plot(LFP(2,:))
title('Ch 2')
ylabel('en bit')
xlabel('en point')

% Maintenant nous allons ajouter le temps et les mv

% Conversion en mv 
LFP=double(LFP)*ch_bitResolution/ch_gain/1000; % Convert bit into mV!

% Calculer le temps 
% Calcul du temps entre chaque point
dt = 1/srate;
% Calcul du temps total des donn�es 
tottime = length(LFP)/srate;
% Calcul du vecteur au chaque point repr�sente le temps en sec (il est de la
% m�me longueur que LFP)
Time = 0:dt:tottime-dt; % (On fait moins "dt" car on parle en position, et donc il y a un point en plus puisque l'on commence � z�ro).

% Exemple de plot sur deux canaux apr�s ajout du temps et conversion en mv
figure;
subplot(211)
plot(Time,LFP(1,:))
title('Ch 1')
ylabel('en mV')
xlabel('en second')
subplot(212)
plot(Time,LFP(2,:))
title('Ch 2')
ylabel('en mV')
xlabel('en second')

% Application du filtre de Nelson
LFPFil = ck_filt(LFP,srate,[0.1 500],'band'); % filtre les fr�quences en dessous de 0.1Hz et au dessus de 500Hz _ Filtre de Nelson
% attention il faut avoir le dossier "From Nelson" d'ajouter dans les chemins d'acc�s Matlab

% Nous pouvons faire le plot du filtre pour comparer 
figure 
plot(Time,LFP(1,:),'b')
hold on
plot(Time,LFPFil(1,:),'r')
legend('Sans filtre','Avec filtre')
title('Comparaison des signaux avec o� sans le filtre')
ylabel('en mV')
xlabel('en second')


% Maintenant nous allons faire la r�f�rence local
LFPnet = [LFPFil(2,:)] - [LFPFil(1,:)];
% Ou une mani�re plus simple de l'�crire 
LFP1 = LFPFil(2,:);
LFP2 = LFPFil(1,:);
LFPnet = LFP1 - LFP2;
% Comme tu peux voir LFPnet est de la bonne taille (m�me longeure)

% Nous allons faire le plot pour savoir comment cela � modifier notre
% signal
figure 
plot(Time,LFP1,'b')
hold on
plot(Time,LFPnet,'r')
legend('Avant Reference locale','Apres reference locale')
title('Comparaison avant et arpes la premiere derivation')
ylabel('en mV')
xlabel('en second')

%%%%%%%%%% Je pense que c'est pas mal pour le moment %%%%%%%%%%%%%%%%%%%%%

