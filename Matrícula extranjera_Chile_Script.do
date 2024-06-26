*****************************************************
**Estudio de educación y migración a nivel desagreado
*en Chile 2017 - 2023
*David Limpe Cruz
********************************************************
*La base de datos del estudio está en relación a lo proporcionado por el centro de estudios de MINEDUC, el cual comprende de 2017 a 2023.

import delimited using "20220908_Matrícula_unica_2022_20220430_PUBL_MRUN.csv", delimiter(";") clear

save matricula2023.dta

clear all
*****************    Base de datos de MINEDUC  *************
cd "C:\Users\Home\Documents\@Idea_Pais_2024\ESTUDIOS IP\Migración y educación en Chile\Fuente_datos\CE_Matrícula_2017_2023"

********cchange
use matricula2023.dta
*limpieza de datos 
*matricula por género
**********codebook gen_alu
tab gen_alu
g sexo=.
replace sexo=1 if gen_alu==2 //mujer
replace sexo=0 if gen_alu==1 // hombre
label var sexo "Género del estudiante"
label defin sexo 1"Mujer" 0"Hombre"
label val sexo sexo
tab sexo
*matricula por nacionalidad
tab  cod_nac_alu 
g nacreci=.
replace nacreci=1 if cod_nac_alu=="C" | cod_nac_alu=="N" //chileno
replace nacreci=2 if cod_nac_alu=="E" // extranjero
label var nacreci "Nacionalidad segun R.C"
label defin nacreci 1"Chileno" 2"Extranjero"
label val nacreci nacreci
tab nacreci
keep if cod_pro_rbd==131
tab nom_com_alu nacreci

****
bys nacreci: tab sexo
destring edad_alu, generate(edad)

gen etario=.
replace etario=1 if edad >=0 & edad <6
replace etario=2 if edad >=6 & edad <12
replace etario=3 if edad >=12 & edad < 17
replace etario=4 if edad >=17 & edad <23
replace etario=5 if edad >=23 & edad <28
replace etario=6 if edad >=28 & edad <45
replace etario=7 if edad >=45
label var etario "Grupo Etario"
label define etario 1 "0 a 6" ///
					2 "6 a 11" ///
					3 "12 a 16" ///
					4 "17 a 22"  ///
					5 "23 a 27"	 ///
					6 "28 a 44" ///
					7 "45 a más"
label values etario etario
codebook etario
tab etario

*matricula por nivel educativo
codebook cod_ense3
tab cod_ense3

gen nivel=.
replace nivel=1 if cod_ense3==1
replace nivel=2 if cod_ense3==2
replace nivel=3 if cod_ense3==3
replace nivel=4 if cod_ense3==4
replace nivel=5 if cod_ense3==5
replace nivel=6 if cod_ense3==6
replace nivel=7 if cod_ense3==7
label var nivel "Nivel educativo"
label define nivel 1 "Educ Parvularia" ///
					2 "E. Básica Niños" ///
					3 "E. Básica Adultos" ///
					4 "E. Media H-C Jóvenes"  ///
					5 "E. Media H-C Adultos"	 ///
					6 "E. Media TPA Jóvenes"         ///
					7 "E. Media TPA Adultos"
label values nivel nivel
tab nivel

tab nivel etario if nacreci==2
*Matricula por nivel de dependencia
codebook cod_depe2
tab cod_depe2
gen dependencia=.
replace dependencia=1 if cod_depe2==1
replace dependencia=2 if cod_depe2==2
replace dependencia=3 if cod_depe2==3
replace dependencia=4 if cod_depe2==4
replace dependencia=5 if cod_depe2==5
label var dependencia "Dependencia del establecimiento"
label def dependencia 1 "Municipal" ///
					2 "Particular Subvencionado" ///
					3 "Particular Pagado" ///
					4 "Corp. de Administ. Delegada"  ///
					5 "Servicio Local de Educación" 		
label val dependencia dependencia
tab dependencia

*matricula por región
codebook cod_reg_rbd
tab cod_reg_rbd
rename cod_reg_rbd region 
label var region "Región"
label define region 1 "Tarapacá" ///
					2 "Antofagasta" ///
					3 "Atacama" ///
					4 "Coquimbo"  ///
					5 "Valparaíso"	 ///
					6 "O'Higgins"         ///
					7 "Maule"  ///
					8 "Biobío" ///
					9 "La Araucanía"  ///
					10 "Los Lagos"  ///
					11 "Aysén"  ///
					12 "Magallanes"  ///
					13 "Metropolitana"  ///
					14 "Los Ríos"  ///
					15 "Arica"   ///
					16 "Ñuble"  			
label values region region
tab region

*matricula de extranjero por nacionalidad
codebook pais_origen_alu
tab pais_origen_alu 
gen nacionalidad=.
replace nacionalidad=1 if pais_origen_alu==4
replace nacionalidad=2 if pais_origen_alu==8
replace nacionalidad=3 if pais_origen_alu==12
replace nacionalidad=4 if pais_origen_alu==16
replace nacionalidad=5 if pais_origen_alu==22
replace nacionalidad=6 if pais_origen_alu==27
replace nacionalidad=7 if (pais_origen_alu==0 | pais_origen_alu==1 | pais_origen_alu==2|pais_origen_alu==3|pais_origen_alu==5|pais_origen_alu==7|pais_origen_alu==9|pais_origen_alu==10|pais_origen_alu==11|pais_origen_alu==13|pais_origen_alu==14|pais_origen_alu==15|pais_origen_alu==17|pais_origen_alu==18|pais_origen_alu==19|pais_origen_alu==20|pais_origen_alu==21|pais_origen_alu==23|pais_origen_alu==24|pais_origen_alu==25|pais_origen_alu==26|pais_origen_alu==28|pais_origen_alu==29) 

label var nacionalidad "Nacionalidad del estudiante extranjero"
label define nacionalidad 1 "Bolivia" ///
					2 "Colombia" ///
					3 "Ecuador" ///
					4 "Haití"  ///
					5 "Perú" ///
					6 "Venezuela" ///
					7 "Otros" 
label values nacionalidad nacionalidad
tab nacionalidad
codebook nacionalidad

*agrupamos las categorías de Nivel
gen grado=.
replace grado=1 if nivel==1
replace grado=2 if (nivel==2 | nivel==3)
replace grado=3 if (nivel==4 | nivel==5 | nivel==6 | nivel==7)
label var grado "Nivel de estudios"
label def grado 1 "Parvularia" ///
					2 "Básica" ///
					3 "Media" 		
label val grado grado
tab grado

*tranformar la variable cod_com_alu
codebook cod_com_rbd
tostring cod_com_rbd, generate(cod_com_rbd1)
sort cod_com_rbd1
*save matricula2023mod.dta
clear 
use matricula2023mod.dta
*drop cod_reg_alu cod_deprov_rbd cod_pro_rbd
*drop nom_reg_rbd_a nom_com_rbd nom_deprov_rbd nom_com_alu
*drop cod_com_rbd
*save matricula2023mod1.dta
*use matricula2023mod1.dta
*keep cod_com_rbd1 cod_ense3 cod_grado2 cod_etnia_alu sexo nacreci nivel dependencia nacionalidad grado
keep nacreci cod_com_alu cod_reg_alu nom_com_alu 
*egen nmigran = group(cod_com_alu)
keep if nacreci==2
collapse (count) nacreci, by(cod_com_alu)
sort cod_com_alu
drop if nacreci==.
export excel using "bd_matrextr2017.xlsx", sheet("Hoja1") firstrow(variables)
pwd
*save matricula2023mod1, replace

*tab pais_origen_alu if cod_nac_alu=="C"

********* Tablas Cruzadas *****************
*nivel educativo con género
tab nivel 

bys nacreci: tab nivel sexo, colum
*outsheet using nivel_sexo.xlsx, replace
tab nivel sexo if nacreci==2
tab grado if region==13
tab grado if (region==13 & nacreci==2)
*dependencia
tab dependencia
bys nacreci: tab  nivel  dependencia

*nivel educativo con dependencia 
tab nivel dependencia
tab nivel dependencia, colum

* nivel educativo por regiones
bys nacreci: tab region sexo
bys nacreci: tab region dependencia, colum
bys nacreci: tab region grado
tab region nivel
bys nacreci: tab region grado, row
tab region grado
*regiones y dependencia establecimiento
tab region dependencia
tab region dependencia if nacreci==2
* nivel por  nacionalidad  - no muy relevante
bys nacreci: tab nacionalidad sexo
tab nacionalidad nivel
*si la región es Metropolitana, ver por nacionalidad
bys nacreci: tab nacionalidad sexo if region==13, colum
tab nivel if region==13
**********por Región segun sexo del extranjero
bys  nacreci: tab region sexo
tab region if nacreci==2
tab region
bys nacreci: tab sexo
tab nacreci dependencia


*********  concentración por comuna ***************
codebook nacreci
tab nom_com_rbd if nacreci==2
tab nom_com_alu if nacreci==2
tab nom_com_alu nacreci, colum

******comuna más concentradas por dependencia ******
tab nom_com_alu dependencia if (nom_com_alu=="SANTIAGO" | nom_com_alu=="INDEPENDENCIA" | nom_com_alu=="ESTACIÓN CENTRAL" | nom_com_alu=="IQUIQUE" | nom_com_alu=="CALAMA" | nom_com_alu=="ANTOFAGASTA" | nom_com_alu=="ARICA" &   nacreci==1)

tab nom_com_alu dependencia if (nom_com_alu=="SANTIAGO" | nom_com_alu=="INDEPENDENCIA" | nom_com_alu=="ESTACIÓN CENTRAL" | nom_com_alu=="IQUIQUE" | nom_com_alu=="CALAMA" | nom_com_alu=="ANTOFAGASTA" | nom_com_alu=="ARICA")
******comuna más concentradas por nivel ******
tab nom_com_alu nivel if (nacreci==2 & nom_com_alu=="SANTIAGO" | nom_com_alu=="INDEPENDENCIA" | nom_com_alu=="ESTACIÓN CENTRAL" | nom_com_alu=="IQUIQUE" | nom_com_alu=="CALAMA" | nom_com_alu=="ANTOFAGASTA" | nom_com_alu=="ARICA"), row
******comuna más concentradas por ruralidad ******
*ruralidad
codebook rural_rbd
tab nom_com_alu rural_rbd if (nacreci==2 & nom_com_alu=="SANTIAGO" | nom_com_alu=="INDEPENDENCIA" | nom_com_alu=="ESTACIÓN CENTRAL" | nom_com_alu=="IQUIQUE" | nom_com_alu=="CALAMA" | nom_com_alu=="ANTOFAGASTA" | nom_com_alu=="ARICA"), row
codebook cod_jor
gen jornada=.
replace jornada=1 if cod_jor==
tab nom_com_alu cod_jor if (nacreci==2 & nom_com_alu=="SANTIAGO" | nom_com_alu=="INDEPENDENCIA" | nom_com_alu=="ESTACIÓN CENTRAL" | nom_com_alu=="IQUIQUE" | nom_com_alu=="CALAMA" | nom_com_alu=="ANTOFAGASTA" | nom_com_alu=="ARICA"), row
*indicadores de nivel socieconómico

tab nom_rbd if (nacreci==2 & nom_com_alu=="SANTIAGO"), row


***Para región metropolitana 

bys nacreci: tab nivel sexo if region==13

bys nacreci: tab dependencia sexo if region==13

tab cod_com_alu if cod_reg_rbd==13
codebook nom_com_rbd
bys nacreci: tab nom_com_rbd  if cod_reg_rbd==
gen comuna=.
replace comuna=1 if nom_com_rbd=="ESTACIÓN CENTRAL"
replace comuna=2 if nom_com_rbd=="INDEPENDENCIA"
replace comuna=3 if nom_com_rbd=="LA FLORIDA"
replace comuna=4 if nom_com_rbd=="MAIPÚ"
replace comuna=5 if nom_com_rbd=="QUILICURA"
replace comuna=6 if nom_com_rbd=="QUINTA NORMAL"
replace comuna=7 if nom_com_rbd=="RECOLETA"
replace comuna=8 if nom_com_rbd=="SAN MIGUEL"
replace comuna=9 if nom_com_rbd=="SANTIAGO"
replace comuna=10 if nom_com_rbd=="ÑUÑOA"
replace comuna=11 if (nom_com_rbd=="ALHUÉ" | nom_com_rbd=="BUIN" | nom_com_rbd=="CALERA DE TANGO" | nom_com_rbd=="CERRILLOS" | nom_com_rbd=="QUILICURA" | nom_com_rbd=="CERRO NAVIA" | nom_com_rbd=="COLINA" | nom_com_rbd=="CONCHALÍ" | nom_com_rbd=="CURACAVÍ" | nom_com_rbd=="EL BOSQUE" | nom_com_rbd=="EL MONTE"| nom_com_rbd=="HUECHURABA"| nom_com_rbd=="ISLA DE MAIPO"| nom_com_rbd=="LA CISTERNA"| nom_com_rbd=="LA GRANJA"| nom_com_rbd=="LA PINTANA"| nom_com_rbd=="LA REINA"| nom_com_rbd=="LAMPA"| nom_com_rbd=="LAS CONDES"| nom_com_rbd=="LO BARNECHEA"| nom_com_rbd=="LO PRADO"| nom_com_rbd=="MACUL") 

label var comuna "Comuna"
label define comuna 1 "Estación central" ///
					2 "Independencia" ///
					3 "La Florida" ///
					4 "Maipú"  ///
					5 "Qilicura" ///
					6 "Quinta Normal" ///
					7 "Recoleta" ///
					8 "San Miguel" ///
					9 "Sanitago" ///
					10 "Ñuñoa" ///
					11 "Otros" 
label values comuna comuna
tab comuna
codebook comuna



bys nacreci: tab comuna if cod_reg_rbd==13

bys nacreci: tab comuna dependencia if cod_reg_rbd==13
bys nacreci: tab nom_com_rbd dependencia if cod_reg_rbd==13
bys nacreci: tab nom_com_rbd nivel if cod_reg_rbd==13

tab nom_com_alu nacreci if cod_pro_rbd==131
