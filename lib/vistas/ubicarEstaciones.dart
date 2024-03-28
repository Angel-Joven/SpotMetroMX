import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:android_intent_plus/android_intent.dart';

class EstacionesCercanas extends StatefulWidget {
  const EstacionesCercanas({Key? key}) : super(key: key);

  @override
  _EstacionesCercanasState createState() => _EstacionesCercanasState();
}

class _EstacionesCercanasState extends State<EstacionesCercanas> {

  //Liberar recursos al controlador de distancia
  @override
  void dispose() {
    distanciaController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    distanciaController = TextEditingController();
  }

  Position? posicionActual;
  List<Map<String, dynamic>> estacionesCercanasMapa = [];
  List<GeoPoint> listaCoordenadasEstaciones = [];
  bool botonMostrarEstacionesVisible = false;
  bool infoUbicacionActualVisible = false;
  bool botonConfirmarDistanciaVisible = true;
  bool mostrarContenidoTabla = false;
  bool mostrarCeldaDistancia = true;
  bool datosCeldaConfirmados = false; //Bloquear el TextField (Celda en donde se ingresa la distancia)
  bool botonVolverCargarPagina = false;
  bool botonVerConsejos = true;
  late TextEditingController distanciaController; //Creacion del controlador de Distancia

  final Map<String, String> imagenesEstacionesMapa = {
    'pantitlan1': 'assets/metrocdmx/linea1/pantitlan1.png',
    'balbuena1': 'assets/metrocdmx/linea1/balbuena1.png',
    'balderas1': 'assets/metrocdmx/linea1/balderas1.png',
    'boulevarPtoAereo1': 'assets/metrocdmx/linea1/boulevarPtoAereo1.png',
    'candelaria1': 'assets/metrocdmx/linea1/candelaria1.png',
    'chapultepec1': 'assets/metrocdmx/linea1/chapultepec1.png',
    'cuauhtemoc1': 'assets/metrocdmx/linea1/cuauhtemoc1.png',
    'gomezFarias1': 'assets/metrocdmx/linea1/gomezFarias1.png',
    'insurgentes1': 'assets/metrocdmx/linea1/insurgentes1.png',
    'isabeLaCatolica1': 'assets/metrocdmx/linea1/isabeLaCatolica1.png',
    'juanacatlan1': 'assets/metrocdmx/linea1/juanacatlan1.png',
    'merced1': 'assets/metrocdmx/linea1/merced1.png',
    'moctezuma1': 'assets/metrocdmx/linea1/moctezuma1.png',
    'observatorio1': 'assets/metrocdmx/linea1/observatorio1.png',
    'pinoSuarez1': 'assets/metrocdmx/linea1/pinoSuarez1.png',
    'saltoDelAgua1': 'assets/metrocdmx/linea1/saltoDelAgua1.png',
    'sanLazaro1': 'assets/metrocdmx/linea1/sanLazaro1.png',
    'sevilla1': 'assets/metrocdmx/linea1/sevilla1.png',
    'tacubaya1': 'assets/metrocdmx/linea1/tacubaya1.png',
    'zaragoza1': 'assets/metrocdmx/linea1/zaragoza1.png',
    'cuatroCaminos2': 'assets/metrocdmx/linea2/cuatroCaminos2.png',
    'allende2': 'assets/metrocdmx/linea2/allende2.png',
    'bellasArtes2': 'assets/metrocdmx/linea2/bellasArtes2.png',
    'chabacano2': 'assets/metrocdmx/linea2/chabacano2.png',
    'colegioMilitar2': 'assets/metrocdmx/linea2/colegioMilitar2.png',
    'cuitlahuac2': 'assets/metrocdmx/linea2/cuitlahuac2.png',
    'ermita2': 'assets/metrocdmx/linea2/ermita2.png',
    'generalAnaya2': 'assets/metrocdmx/linea2/generalAnaya2.png',
    'hidalgo2': 'assets/metrocdmx/linea2/hidalgo2.png',
    'nativitas2': 'assets/metrocdmx/linea2/nativitas2.png',
    'normal2': 'assets/metrocdmx/linea2/normal2.png',
    'panteones2': 'assets/metrocdmx/linea2/panteones2.png',
    'pinoSuarez2': 'assets/metrocdmx/linea2/pinoSuarez2.png',
    'popotla2': 'assets/metrocdmx/linea2/popotla2.png',
    'portales2': 'assets/metrocdmx/linea2/portales2.png',
    'revolucion2': 'assets/metrocdmx/linea2/revolucion2.png',
    'sanAntonioAbad2': 'assets/metrocdmx/linea2/sanAntonioAbad2.png',
    'sanCosme2': 'assets/metrocdmx/linea2/sanCosme2.png',
    'tacuba2': 'assets/metrocdmx/linea2/tacuba2.png',
    'tasqueña2': 'assets/metrocdmx/linea2/tasqueña2.png',
    'viaducto2': 'assets/metrocdmx/linea2/viaducto2.png',
    'villaDeCortes2': 'assets/metrocdmx/linea2/villaDeCortes2.png',
    'xola2': 'assets/metrocdmx/linea2/xola2.png',
    'zocalo2': 'assets/metrocdmx/linea2/zocalo2.png',
    'indiosVerdes3': 'assets/metrocdmx/linea3/indiosVerdes3.png',
    'balderas3': 'assets/metrocdmx/linea3/balderas3.png',
    'centroMedico3': 'assets/metrocdmx/linea3/centroMedico3.png',
    'copilco3': 'assets/metrocdmx/linea3/copilco3.png',
    'coyoacan3': 'assets/metrocdmx/linea3/coyoacan3.png',
    'deportivo18DeMarzo3': 'assets/metrocdmx/linea3/deportivo18DeMarzo3.png',
    'divisionDelNorte3': 'assets/metrocdmx/linea3/divisionDelNorte3.png',
    'etiopia3': 'assets/metrocdmx/linea3/etiopia3.png',
    'eugenia3': 'assets/metrocdmx/linea3/eugenia3.png',
    'guerrero3': 'assets/metrocdmx/linea3/guerrero3.png',
    'hidalgo3': 'assets/metrocdmx/linea3/hidalgo3.png',
    'hospitalGeneral3': 'assets/metrocdmx/linea3/hospitalGeneral3.png',
    'juarez3': 'assets/metrocdmx/linea3/juarez3.png',
    'laRaza3': 'assets/metrocdmx/linea3/laRaza3.png',
    'miguelAngelDeQuevedo3': 'assets/metrocdmx/linea3/miguelAngelDeQuevedo3.png',
    'poderjudical3': 'assets/metrocdmx/linea3/poderjudical3.png',
    'potrero3': 'assets/metrocdmx/linea3/potrero3.png',
    'tlatelolco3': 'assets/metrocdmx/linea3/tlatelolco3.png',
    'universidad3': 'assets/metrocdmx/linea3/universidad3.png',
    'viverosDerechosHumanos3': 'assets/metrocdmx/linea3/viverosDerechosHumanos3.png',
    'zapata3': 'assets/metrocdmx/linea3/zapata3.png',
    'martinCarrera4': 'assets/metrocdmx/linea4/martinCarrera4.png',
    'bondojito4': 'assets/metrocdmx/linea4/bondojito4.png',
    'canalDelNorte4': 'assets/metrocdmx/linea4/canalDelNorte4.png',
    'candelaria4': 'assets/metrocdmx/linea4/candelaria4.png',
    'consulado4': 'assets/metrocdmx/linea4/consulado4.png',
    'frayServando4': 'assets/metrocdmx/linea4/frayServando4.png',
    'jamaica4': 'assets/metrocdmx/linea4/jamaica4.png',
    'morelos4': 'assets/metrocdmx/linea4/morelos4.png',
    'santaAnita4': 'assets/metrocdmx/linea4/santaAnita4.png',
    'talisman4': 'assets/metrocdmx/linea4/talisman4.png',
    'pantitlan5': 'assets/metrocdmx/linea5/pantitlan5.png',
    'aragon5': 'assets/metrocdmx/linea5/aragon5.png',
    'autobusesDelNorte5': 'assets/metrocdmx/linea5/autobusesDelNorte5.png',
    'consulado5': 'assets/metrocdmx/linea5/consulado5.png',
    'eduardoMolina5': 'assets/metrocdmx/linea5/eduardoMolina5.png',
    'hangares5': 'assets/metrocdmx/linea5/hangares5.png',
    'institutoDelPetroleo5': 'assets/metrocdmx/linea5/institutoDelPetroleo5.png',
    'laRaza5': 'assets/metrocdmx/linea5/laRaza5.png',
    'misterios5': 'assets/metrocdmx/linea5/misterios5.png',
    'oceania5': 'assets/metrocdmx/linea5/oceania5.png',
    'politecnico5': 'assets/metrocdmx/linea5/politecnico5.png',
    'terminalAerea5': 'assets/metrocdmx/linea5/terminalAerea5.png',
    'valleGomez5': 'assets/metrocdmx/linea5/valleGomez5.png',
    'martinCarrera6': 'assets/metrocdmx/linea6/martinCarrera6.png',
    'azcapotzalco6': 'assets/metrocdmx/linea6/azcapotzalco6.png',
    'deportivo18DeMarzo6': 'assets/metrocdmx/linea6/deportivo18DeMarzo6.png',
    'elRosario6': 'assets/metrocdmx/linea6/elRosario6.png',
    'ferreria6': 'assets/metrocdmx/linea6/ferreria6.png',
    'institutoDelPetroleo6': 'assets/metrocdmx/linea6/institutoDelPetroleo6.png',
    'laVillaBasilica6': 'assets/metrocdmx/linea6/laVillaBasilica6.png',
    'lindavista6': 'assets/metrocdmx/linea6/lindavista6.png',
    'norte456': 'assets/metrocdmx/linea6/norte456.png',
    'tezozomoc6': 'assets/metrocdmx/linea6/tezozomoc6.png',
    'vallejo6': 'assets/metrocdmx/linea6/vallejo6.png',
    'elRosario7': 'assets/metrocdmx/linea7/elRosario7.png',
    'aquilesSerdan7': 'assets/metrocdmx/linea7/aquilesSerdan7.png',
    'auditorio7': 'assets/metrocdmx/linea7/auditorio7.png',
    'barrancaDelMuerto7': 'assets/metrocdmx/linea7/barrancaDelMuerto7.png',
    'camarones7': 'assets/metrocdmx/linea7/camarones7.png',
    'constituyentes7': 'assets/metrocdmx/linea7/constituyentes7.png',
    'mixcoac7': 'assets/metrocdmx/linea7/mixcoac7.png',
    'polanco7': 'assets/metrocdmx/linea7/polanco7.png',
    'refineria7': 'assets/metrocdmx/linea7/refineria7.png',
    'sanAntonio7': 'assets/metrocdmx/linea7/sanAntonio7.png',
    'sanJoaquin7': 'assets/metrocdmx/linea7/sanJoaquin7.png',
    'sanPedroDeLosPinos7': 'assets/metrocdmx/linea7/sanPedroDeLosPinos7.png',
    'tacuba7': 'assets/metrocdmx/linea7/tacuba7.png',
    'tacubaya7': 'assets/metrocdmx/linea7/tacubaya7.png',
    'garibaldi8': 'assets/metrocdmx/linea8/garibaldi8.png',
    'aculco8': 'assets/metrocdmx/linea8/aculco8.png',
    'apatlaco8': 'assets/metrocdmx/linea8/apatlaco8.png',
    'atlalilco8': 'assets/metrocdmx/linea8/atlalilco8.png',
    'bellasArtes8': 'assets/metrocdmx/linea8/bellasArtes8.png',
    'cerroDeLaEstrella8': 'assets/metrocdmx/linea8/cerroDeLaEstrella8.png',
    'chabacano8': 'assets/metrocdmx/linea8/chabacano8.png',
    'constitucionDe19178': 'assets/metrocdmx/linea8/constitucionDe19178.png',
    'coyuya8': 'assets/metrocdmx/linea8/coyuya8.png',
    'doctores8': 'assets/metrocdmx/linea8/doctores8.png',
    'escuadron2018': 'assets/metrocdmx/linea8/escuadron2018.png',
    'iztacalco8': 'assets/metrocdmx/linea8/iztacalco8.png',
    'iztapalapa8': 'assets/metrocdmx/linea8/iztapalapa8.png',
    'laViga8': 'assets/metrocdmx/linea8/laViga8.png',
    'obrera8': 'assets/metrocdmx/linea8/obrera8.png',
    'saltoDelAgua8': 'assets/metrocdmx/linea8/saltoDelAgua8.png',
    'sanJuanDeLetran8': 'assets/metrocdmx/linea8/sanJuanDeLetran8.png',
    'santaAnita8': 'assets/metrocdmx/linea8/santaAnita8.png',
    'uam8': 'assets/metrocdmx/linea8/uam8.png',
    'pantitlan9': 'assets/metrocdmx/linea9/pantitlan9.png',
    'centroMedico9': 'assets/metrocdmx/linea9/centroMedico9.png',
    'chabacano9': 'assets/metrocdmx/linea9/chabacano9.png',
    'chilpancingo9': 'assets/metrocdmx/linea9/chilpancingo9.png',
    'ciudadDeportiva9': 'assets/metrocdmx/linea9/ciudadDeportiva9.png',
    'jamaica9': 'assets/metrocdmx/linea9/jamaica9.png',
    'lazaroCardenas9': 'assets/metrocdmx/linea9/lazaroCardenas9.png',
    'mixihuca9': 'assets/metrocdmx/linea9/mixihuca9.png',
    'patriotismo9': 'assets/metrocdmx/linea9/patriotismo9.png',
    'puebla9': 'assets/metrocdmx/linea9/puebla9.png',
    'tacubaya9': 'assets/metrocdmx/linea9/tacubaya9.png',
    'velodromo9': 'assets/metrocdmx/linea9/velodromo9.png',
    'atlalilco12': 'assets/metrocdmx/linea12/atlalilco12.png',
    'calle1112': 'assets/metrocdmx/linea12/calle1112.png',
    'culhuacan12': 'assets/metrocdmx/linea12/culhuacan12.png',
    'ejeCentral12': 'assets/metrocdmx/linea12/ejeCentral12.png',
    'ermita12': 'assets/metrocdmx/linea12/ermita12.png',
    'hospital20DeNoviembre12': 'assets/metrocdmx/linea12/hospital20DeNoviembre12.png',
    'insurgentesSur12': 'assets/metrocdmx/linea12/insurgentesSur12.png',
    'lomasEstrella12': 'assets/metrocdmx/linea12/lomasEstrella12.png',
    'mexicaltzingo12': 'assets/metrocdmx/linea12/mexicaltzingo12.png',
    'mixcoac12': 'assets/metrocdmx/linea12/mixcoac12.png',
    'nopalera12': 'assets/metrocdmx/linea12/nopalera12.png',
    'olivos12': 'assets/metrocdmx/linea12/olivos12.png',
    'parqueDeLosVenados12': 'assets/metrocdmx/linea12/parqueDeLosVenados12.png',
    'perifericoOriente12': 'assets/metrocdmx/linea12/perifericoOriente12.png',
    'sanAndresTomatlan12': 'assets/metrocdmx/linea12/sanAndresTomatlan12.png',
    'tezonco12': 'assets/metrocdmx/linea12/tezonco12.png',
    'tlahuac12': 'assets/metrocdmx/linea12/tlahuac12.png',
    'tlaltenco12': 'assets/metrocdmx/linea12/tlaltenco12.png',
    'zapata12': 'assets/metrocdmx/linea12/zapata12.png',
    'zapotitlan12': 'assets/metrocdmx/linea12/zapotitlan12.png',
    'pantitlanA': 'assets/metrocdmx/lineaA/pantitlanA.png',
    'agricolaOrientalA': 'assets/metrocdmx/lineaA/agricolaOrientalA.png',
    'sanJuanA': 'assets/metrocdmx/lineaA/sanJuanA.png',
    'tepalcatesA': 'assets/metrocdmx/lineaA/tepalcatesA.png',
    'guelataoA': 'assets/metrocdmx/lineaA/guelataoA.png',
    'peñonViejoA': 'assets/metrocdmx/lineaA/peñonViejoA.png',
    'acatitlaA': 'assets/metrocdmx/lineaA/acatitlaA.png',
    'santaMartaA': 'assets/metrocdmx/lineaA/santaMartaA.png',
    'losReyesA': 'assets/metrocdmx/lineaA/losReyesA.png',
    'laPazA': 'assets/metrocdmx/lineaA/laPazA.png',
    'buenavistaB': 'assets/metrocdmx/lineaB/buenavistaB.png',
    'bosqueDeAragonB': 'assets/metrocdmx/lineaB/bosqueDeAragonB.png',
    'ciudadAztecaB': 'assets/metrocdmx/lineaB/ciudadAztecaB.png',
    'deportivoOceaniaB': 'assets/metrocdmx/lineaB/deportivoOceaniaB.png',
    'ecatepecB': 'assets/metrocdmx/lineaB/ecatepecB.png',
    'garibaldiB': 'assets/metrocdmx/lineaB/garibaldiB.png',
    'guerreroB': 'assets/metrocdmx/lineaB/guerreroB.png',
    'impulsoraB': 'assets/metrocdmx/lineaB/impulsoraB.png',
    'lagunillaB': 'assets/metrocdmx/lineaB/lagunillaB.png',
    'morelosB': 'assets/metrocdmx/lineaB/morelosB.png',
    'muzquizB': 'assets/metrocdmx/lineaB/muzquizB.png',
    'nezahualcoyotlB': 'assets/metrocdmx/lineaB/nezahualcoyotlB.png',
    'oceaniaB': 'assets/metrocdmx/lineaB/oceaniaB.png',
    'olimpicaB': 'assets/metrocdmx/lineaB/olimpicaB.png',
    'plazaAragonB': 'assets/metrocdmx/lineaB/plazaAragonB.png',
    'ricardoFloresMagonB': 'assets/metrocdmx/lineaB/ricardoFloresMagonB.png',
    'rioDeLosRemediosB': 'assets/metrocdmx/lineaB/rioDeLosRemediosB.png',
    'romeroRubioB': 'assets/metrocdmx/lineaB/romeroRubioB.png',
    'sanLazaroB': 'assets/metrocdmx/lineaB/sanLazaroB.png',
    'tepitoB': 'assets/metrocdmx/lineaB/tepitoB.png',
    'villaDeAragonB': 'assets/metrocdmx/lineaB/villaDeAragonB.png',
  };

  // final List<String> listaDeLineasMetro = ['lineaA', 'linea1', 'linea9', 'linea5', 'lineaB'];

  // Lista de letras finales de cada linea
  final List<String> listaDeLineasMetro = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '12',
    'A',
    'B'
  ];

  // Mapeo de caracter final a las líneas existentes
  final Map<String, String> nombreLinea = {
    '1': 'LINEA 1',
    '2': 'LINEA 2',
    '3': 'LINEA 3',
    '4': 'LINEA 4',
    '5': 'LINEA 5',
    '6': 'LINEA 6',
    '7': 'LINEA 7',
    '8': 'LINEA 8',
    '9': 'LINEA 9',
    '12': 'LINEA 12',
    'A': 'LINEA A',
    'B': 'LINEA B',
  };


  // Mapeo para asignar nuevos nombres a las estaciones
  final Map<String, String> asignarNuevosNombresMapa = {
    'pantitlan1': 'Pantitlan',
    'balbuena1': 'Balbuena',
    'balderas1': 'Balderas',
    'boulevarPtoAereo1': 'Boulevard Puerto Aereo',
    'candelaria1': 'Candelaria',
    'chapultepec1': 'Chapultepec',
    'cuauhtemoc1': 'Cuauhtemoc',
    'gomezFarias1': 'Gomez Farias',
    'insurgentes1': 'Insurgentes',
    'isabeLaCatolica1': 'Isabel la Catolica',
    'juanacatlan1': 'Juanacatlan',
    'merced1': 'Merced',
    'moctezuma1': 'Moctezuma',
    'observatorio1': 'Observatorio',
    'pinoSuarez1': 'Pino Suarez',
    'saltoDelAgua1': 'Salto del Agua',
    'sanLazaro1': 'San Lazaro',
    'sevilla1': 'Sevilla',
    'tacubaya1': 'Tacubaya',
    'zaragoza1': 'Zaragoza',
    'cuatroCaminos2': 'Cuatro Caminos',
    'allende2': 'Allende',
    'bellasArtes2': 'Bellas Artes',
    'chabacano2': 'Chabacano',
    'colegioMilitar2': 'Colegio Militar',
    'cuitlahuac2': 'Cuitlahuac',
    'ermita2': 'Ermita',
    'generalAnaya2': 'General Anaya',
    'hidalgo2': 'Hidalgo',
    'nativitas2': 'Nativitas',
    'normal2': 'Normal',
    'panteones2': 'Panteones',
    'pinoSuarez2': 'Pino Suarez',
    'popotla2': 'Popotla',
    'portales2': 'Portales',
    'revolucion2': 'Revolucion',
    'sanAntonioAbad2': 'San Antonio Abad',
    'sanCosme2': 'San Cosme',
    'tacuba2': 'Tacuba',
    'tasqueña2': 'Tasqueña',
    'viaducto2': 'Viaducto',
    'villaDeCortes2': 'Villa de Cortes',
    'xola2': 'Xola',
    'zocalo2': 'Zocalo /\nTenochtitlan',
    'indiosVerdes3': 'Indios Verdes',
    'balderas3': 'Balderas',
    'centroMedico3': 'Centro Medico',
    'copilco3': 'Copilco',
    'coyoacan3': 'Coyoacan',
    'deportivo18DeMarzo3': 'Deportivo 18 de Marzo',
    'divisionDelNorte3': 'Division del Norte',
    'etiopia3': 'Etiopia /\nPlaza de la Transparencia',
    'eugenia3': 'Eugenia',
    'guerrero3': 'Guerrero',
    'hidalgo3': 'Hidalgo',
    'hospitalGeneral3': 'Hospital General',
    'juarez3': 'Juarez',
    'laRaza3': 'La Raza',
    'miguelAngelDeQuevedo3': 'Miguel Angel\nDe Quevedo',
    'poderjudical3': 'Niños Heroes /\nPoder Judicial',
    'potrero3': 'Potrero',
    'tlatelolco3': 'Tlatelolco',
    'universidad3': 'Universidad',
    'viverosDerechosHumanos3': 'Viveros /\nDerechos Humanos',
    'zapata3': 'Zapata',
    'martinCarrera4': 'Martin Carrera',
    'bondojito4': 'Bondojito',
    'canalDelNorte4': 'Canal del Norte',
    'candelaria4': 'Candelaria',
    'consulado4': 'Consulado',
    'frayServando4': 'Fray Servando',
    'jamaica4': 'Jamaica',
    'morelos4': 'Morelos',
    'santaAnita4': 'Santa Anita',
    'talisman4': 'Talisman',
    'pantitlan5': 'Pantitlan',
    'aragon5': 'Aragon',
    'autobusesDelNorte5': 'Autobuses del Norte',
    'consulado5': 'Consulado',
    'eduardoMolina5': 'Eduardo Molina',
    'hangares5': 'Hangares',
    'institutoDelPetroleo5': 'Instituto del Petroleo',
    'laRaza5': 'La Raza',
    'misterios5': 'Misterios',
    'oceania5': 'Oceania',
    'politecnico5': 'Politecnico',
    'terminalAerea5': 'Terminal Aerea',
    'valleGomez5': 'Valle Gomez',
    'martinCarrera6': 'Martin Carrera',
    'azcapotzalco6': 'UAM Azcapotzalco',
    'deportivo18DeMarzo6': 'Deportivo 18 de Marzo',
    'elRosario6': 'El Rosario',
    'ferreria6': 'Ferreria /\nArena Ciudad de Mexico',
    'institutoDelPetroleo6': 'Instituto del Petroleo',
    'laVillaBasilica6': 'La Villa / Basilica',
    'lindavista6': 'Lindavista',
    'norte456': 'Norte 45',
    'tezozomoc6': 'Tezozomoc',
    'vallejo6': 'Vallejo',
    'elRosario7': 'El Rosario',
    'aquilesSerdan7': 'Aquiles Serdan',
    'auditorio7': 'Auditorio',
    'barrancaDelMuerto7': 'Barranca del Muerto',
    'camarones7': 'Camarones',
    'constituyentes7': 'Constituyentes',
    'mixcoac7': 'Mixcoac',
    'polanco7': 'Polanco',
    'refineria7': 'Refineria',
    'sanAntonio7': 'San Antonio',
    'sanJoaquin7': 'San Joaquin',
    'sanPedroDeLosPinos7': 'San Pedro de los Pinos',
    'tacuba7': 'Tacuba',
    'tacubaya7': 'Tacubaya',
    'garibaldi8': 'Garibaldi / Lagunilla',
    'aculco8': 'Aculco',
    'apatlaco8': 'Apatlaco',
    'atlalilco8': 'Atlalilco',
    'bellasArtes8': 'Bellas Artes',
    'cerroDeLaEstrella8': 'Cerro de la Estrella',
    'chabacano8': 'Chabacano',
    'constitucionDe19178': 'Constitucion de 1917',
    'coyuya8': 'Coyuya',
    'doctores8': 'Doctores',
    'escuadron2018': 'Escuadron 201',
    'iztacalco8': 'Iztacalco',
    'iztapalapa8': 'Iztapalapa',
    'laViga8': 'La Viga',
    'obrera8': 'Obrera',
    'saltoDelAgua8': 'Salto del Agua',
    'sanJuanDeLetran8': 'San Juan De Letran',
    'santaAnita8': 'Santa Anita',
    'uam8': 'UAM-I',
    'pantitlan9': 'Pantitlan',
    'centroMedico9': 'Centro Medico',
    'chabacano9': 'Chabacano',
    'chilpancingo9': 'Chilpancingo',
    'ciudadDeportiva9': 'Ciudad Deportiva',
    'jamaica9': 'Jamaica',
    'lazaroCardenas9': 'Lazaro Cardenas',
    'mixihuca9': 'Mixihuca',
    'patriotismo9': 'Patriotismo',
    'puebla9': 'Puebla',
    'tacubaya9': 'Tacubaya',
    'velodromo9': 'Velodromo',
    'atlalilco12': 'Atlalilco',
    'calle1112': 'Calle 11',
    'culhuacan12': 'Culhuacan',
    'ejeCentral12': 'Eje Central',
    'ermita12': 'Ermita',
    'hospital20DeNoviembre12': 'Hospital 20 de Noviembre',
    'insurgentesSur12': 'Insurgentes Sur',
    'lomasEstrella12': 'Lomas Estrella',
    'mexicaltzingo12': 'Mexicaltzingo',
    'mixcoac12': 'Mixcoac',
    'nopalera12': 'Nopalera',
    'olivos12': 'Olivos',
    'parqueDeLosVenados12': 'Parque de los Venados',
    'perifericoOriente12': 'Periferico Oriente',
    'sanAndresTomatlan12': 'San Andres Tomatlan',
    'tezonco12': 'Tezonco',
    'tlahuac12': 'Tlahuac',
    'tlaltenco12': 'Tlaltenco',
    'zapata12': 'Zapata',
    'zapotitlan12': 'Zapotitlan',
    'pantitlanA': 'Pantitlán',
    'agricolaOrientalA': 'Agricola Oriental',
    'sanJuanA': 'Canal de San Juan',
    'tepalcatesA': 'Tepalcates',
    'guelataoA': 'Guelatao',
    'peñonViejoA': 'Peñon Viejo',
    'acatitlaA': 'Acatitla',
    'santaMartaA': 'Santa Marta',
    'losReyesA': 'Los Reyes',
    'laPazA': 'La Paz',
    'buenavistaB': 'Buenavista',
    'bosqueDeAragonB': 'Bosque de Aragon',
    'ciudadAztecaB': 'Ciudad Azteca',
    'deportivoOceaniaB': 'Deportivo Oceania',
    'ecatepecB': 'Ecatepec',
    'garibaldiB': 'Garibaldi / Lagunilla',
    'guerreroB': 'Guerrero',
    'impulsoraB': 'Impulsora',
    'lagunillaB': 'Lagunilla',
    'morelosB': 'Morelos',
    'muzquizB': 'Muzquiz',
    'nezahualcoyotlB': 'Nezahualcoyotl',
    'oceaniaB': 'Oceania',
    'olimpicaB': 'Olimpica',
    'plazaAragonB': 'Plaza Aragon',
    'ricardoFloresMagonB': 'Ricardo Flores Magon',
    'rioDeLosRemediosB': 'Rio de los Remedios',
    'romeroRubioB': 'Romero Rubio',
    'sanLazaroB': 'San Lazaro',
    'tepitoB': 'Tepito',
    'villaDeAragonB': 'Villa de Aragon',
  };

  Future<void> obtenerUbicacionActual() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        posicionActual = position;
      });
      if (posicionActual != null) {
        //Cuando termine de obtener la ubicacion actual,
        //se procede a comparar respecto a todas las estaciones del metro
        await compararUbicaciones();
      }
    } catch (e) {
      print('Error al obtener la ubicación: $e');
    }
  }

  Future<void> compararUbicaciones() async {
    try {
      if (posicionActual != null) {
        double latitudUsuario = posicionActual!.latitude;
        double longitudUsuario = posicionActual!.longitude;

        //DECLARACION DE DISTANCIA MAXIMA REGULADA POR EL CONTROLADOR
        double distanciaMaxima = double.parse(distanciaController.text);

        for (String lineaMetro in listaDeLineasMetro) {
          CollectionReference obtenerEstacionesMetroBD =
          FirebaseFirestore.instance.collection('linea$lineaMetro');
          DocumentSnapshot estacionesSnapshot =
          await obtenerEstacionesMetroBD.doc('estaciones').get();
          Map<String, dynamic> datosEstacionesMetro =
          estacionesSnapshot.data() as Map<String, dynamic>;

          datosEstacionesMetro.forEach((nombreEstacionMetro, geoPoint) {
            if (geoPoint != null && geoPoint is GeoPoint) {
              double latitudEstacionMetro = geoPoint.latitude;
              double longitudEstacionMetro = geoPoint.longitude;

              double distancia = Geolocator.distanceBetween(
                latitudUsuario,
                longitudUsuario,
                latitudEstacionMetro,
                longitudEstacionMetro,
              );

              // Rango para encontrar estaciones
              if (distancia < distanciaMaxima) {
                setState(() {
                  estacionesCercanasMapa.add({
                    'nombre': nombreEstacionMetro,
                    'distanciaMetros': distancia,
                  });
                  listaCoordenadasEstaciones.add(geoPoint);
                });
              }
            }
          });
        }

        // Ordenamos la lista de coordenadas de estaciones de menor a mayor en base a distancia
        listaCoordenadasEstaciones.sort((a, b) => Geolocator.distanceBetween(
          latitudUsuario,
          longitudUsuario,
          a.latitude,
          a.longitude,
        ).compareTo(
          Geolocator.distanceBetween(
            latitudUsuario,
            longitudUsuario,
            b.latitude,
            b.longitude,
          ),
        ));
      } else {
        print('La ubicación actual no está disponible');
      }
    } catch (e) {
      print('Error al comparar las ubicaciones: $e');
    }
  }

  // PARA PC
  void abrirGoogleMapsPC(double latitudEstacionMetro, double longitudEstacionMetro) async {
    String url = 'https://www.google.com/maps/dir/?api=1';
    String latitud = posicionActual!.latitude.toString();
    String longitud = posicionActual!.longitude.toString();
    url += '&origin=$latitud,$longitud';
    url += '&destination=$latitudEstacionMetro,$longitudEstacionMetro';

    if (await canLaunch(url.toString())) {
      await launch(url.toString());
      print(
          'Lanzando Google Maps con las coordenadas iniciales: ($latitud, $longitud)');
      print(
          'Lanzando Google Maps con las coordenadas finales: ($latitudEstacionMetro, $longitudEstacionMetro)');
      print(url);
    } else {
      throw 'No se pudo abrir la URL: $url';
    }
  }

  // PARA ANDROID
  void abrirGoogleMapsAndroid(double latitudEstacionMetro, double longitudEstacionMetro) async {
    String googleMapsURL = 'google.navigation:q=$latitudEstacionMetro,$longitudEstacionMetro';
    AndroidIntent intent = AndroidIntent(
      action: 'action_view',
      data: googleMapsURL,
    );
    intent.launch();
  }

  //A
  String obtenerLinea(String nombreEstacionMetro) {
    String lineaMetro = '';
    if (nombreEstacionMetro.endsWith('B')) {
      lineaMetro = 'Línea B';
    } else if (nombreEstacionMetro.endsWith('A')) {
      lineaMetro = 'Línea A';
    } else if (nombreEstacionMetro.endsWith('12')) {
      lineaMetro = 'Línea 12';
    } else if (nombreEstacionMetro.endsWith('9')) {
      lineaMetro = 'Línea 9';
    } else if (nombreEstacionMetro.endsWith('8')) {
      lineaMetro = 'Línea 8';
    } else if (nombreEstacionMetro.endsWith('7')) {
      lineaMetro = 'Línea 7';
    } else if (nombreEstacionMetro.endsWith('6')) {
      lineaMetro = 'Línea 6';
    } else if (nombreEstacionMetro.endsWith('5')) {
      lineaMetro = 'Línea 5';
    } else if (nombreEstacionMetro.endsWith('4')) {
      lineaMetro = 'Línea 4';
    } else if (nombreEstacionMetro.endsWith('3')) {
      lineaMetro = 'Línea 3';
    } else if (nombreEstacionMetro.endsWith('2')) {
      lineaMetro = 'Línea 2';
    } else if (nombreEstacionMetro.endsWith('1')) {
      lineaMetro = 'Línea 1';
    }
    return lineaMetro;
  }

  String formatearDistanciaMaKM(double distanciaFormateada) {
    if (distanciaFormateada >= 1000) {
      double distanceKm = distanciaFormateada / 1000;
      return '${distanceKm.toStringAsFixed(1)} KM';
    } else {
      return '${distanciaFormateada.round()} M';
    }
  }

  void reiniciarWidget() {
    setState(() {
      distanciaController.clear();
      infoUbicacionActualVisible = false;
      botonMostrarEstacionesVisible = false;
      botonConfirmarDistanciaVisible = true;
      mostrarContenidoTabla = false;
      mostrarCeldaDistancia = true;
      datosCeldaConfirmados = false;
      botonVolverCargarPagina = false;
      botonVolverCargarPagina = false;
      botonVerConsejos = true;
      estacionesCercanasMapa.clear();
      listaCoordenadasEstaciones.clear();
    });
  }

  void retrasarObtenerUbicacionActual() {
    Future.delayed(Duration(seconds: 2), () {
      print('Han Pasado 2 segundos... Ejecutando');
      obtenerUbicacionActual();
      print('Se ejecuto correctamente');
    });
  }

  @override
  Widget build(BuildContext context) {
    double distanciaMaxima = 0;
    estacionesCercanasMapa.sort((a, b) =>
        a['distanciaMetros'].compareTo(b['distanciaMetros']));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubicar Estaciones Cercanas'),
        backgroundColor: const Color.fromARGB(255, 254, 126, 27),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(botonConfirmarDistanciaVisible)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Para que le genere las estaciones mas cercanas a su ubicacion actual, por favor, '
                    'ingrese en la siguiente celda la distancia en metros para generar el rango de busqueda.\n\n'
                    'Despues, confirme su distancia presionando el boton "Confirmar Distancia".',
                  style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ),
            if (botonMostrarEstacionesVisible)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Con la distancia ingresada y confirmada, ahora presione el boton "Mostrar Estaciones Cercanas".',
                  style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ),
            const SizedBox(height: 10),
            Row(
              children: [
                if(mostrarCeldaDistancia)
                  const SizedBox(height: 20),
                if(mostrarCeldaDistancia)
                Expanded(
                    child: TextField(
                      controller: distanciaController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Aqui ingrese los metros para generar el radio de busqueda',
                        contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                        border: OutlineInputBorder(),
                      ),
                      enabled: !datosCeldaConfirmados,
                    ),
                ),
                if(mostrarCeldaDistancia)
                  const SizedBox(width: 20),
                if(botonConfirmarDistanciaVisible)
                  ElevatedButton(
                    onPressed: () {
                      String input = distanciaController.text.trim();
                      botonConfirmarDistanciaVisible = false;
                      botonMostrarEstacionesVisible = true;
                      datosCeldaConfirmados = true;
                      botonVerConsejos = false;
                      setState(() {
                        estacionesCercanasMapa.clear();
                        listaCoordenadasEstaciones.clear();
                      });
                      if (input.isNotEmpty) {
                        try {
                          int distancia = int.parse(input);
                          setState(() {
                            distanciaMaxima = distancia.toDouble();
                          });
                        } catch (e) {
                          //Si no se puede convertir a un número entero, mostrar un mensaje de error.
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Error'),
                                content: const Text('Por favor, ingrese una distancia válida.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      reiniciarWidget();
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      } else {
                        //Si no se ingresa ningún valor, mostrar un mensaje pidiendo al usuario que ingrese uno.
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Error'),
                              content: const Text('Por favor, ingrese la distancia para poder generar el rango de busqueda.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    reiniciarWidget();
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: const Text('¡Confirmar Distancia!'),
                  ),
              ],
            ),
            if (botonMostrarEstacionesVisible)
              const SizedBox(height: 20),
            if (botonMostrarEstacionesVisible)
              Container(
                alignment: Alignment.center,
                child: Center(
                  child: ElevatedButton(
                    onPressed: (){
                      setState(() {
                        botonMostrarEstacionesVisible = false;
                        infoUbicacionActualVisible = true;
                        mostrarContenidoTabla = true;
                        mostrarCeldaDistancia = false;
                        botonVolverCargarPagina = true;
                        estacionesCercanasMapa.clear();
                        listaCoordenadasEstaciones.clear();
                      });
                      obtenerUbicacionActual();
                      //retrasarObtenerUbicacionActual(); -> Test
                    },
                    child: const Text('Mostrar Estaciones Cercanas'),
                  ),
                ),
              ),
            /*Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('aaaaaaa ayuda no le entiendo al flutter :(',
                style: const TextStyle(fontSize: 16.0),
              ),
            ),*/
            if (botonMostrarEstacionesVisible)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    '\nNota:\nEste proceso puede tardar desde varios segundos hasta unos minutos, dependiendo de la distancia ingresada y de su conexión a internet. Por favor, sea paciente...',
                    style: const TextStyle(fontSize: 12.0),
                    textAlign: TextAlign.center, // Para centrar el texto horizontalmente
                  ),
                ),
              ),
            if (infoUbicacionActualVisible)
              Container(
                alignment: Alignment.center,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: const TextStyle(fontSize: 16.0, color: Colors.black),
                        children: [
                          posicionActual != null
                              ? TextSpan(
                            text:
                            '¡Listo!\n'
                                'Se le ha generado mas abajo una tabla que incluye las estaciones mas cercanas en base a su ubicacion actual y a la distancia ingresada.\n\n'
                                'Si quiere volver a ingresar una nueva distancia, presione el boton "Volver a Cargar la Pagina".',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          )
                              : TextSpan(
                            text: 'Buscando estaciones cercanas...\n'
                                'Esto puede tardar varios segundos o minutos dependiendo de la distancia ingresada y de su velocidad de internet.',
                          ),
                          if (posicionActual != null)
                            TextSpan(
                              text:
                              '\n\nSu ubicación actual es:\n(${posicionActual!.latitude}, ${posicionActual!.longitude})',
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 20),
            if(botonConfirmarDistanciaVisible)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'Nota:\nEn algunos dispositivos celulares, la opcion "habilitar ubicacion"\ndebe ser activada manualmente.\n\nSi la APP no le pregunto si usted queria "habilitar la ubicacion",\nentonces debe de activarla manualmente. Para ello, vaya a:\n\nConfiguracion (Ajustes) -> Aplicaciones -> "SpotMetro MX" -> Permisos -> Habilitar Ubicacion.\n',
                  style: const TextStyle(fontSize: 12.0),
                  textAlign: TextAlign.center, // Para centrar el texto horizontalmente
                ),
              ),
            ),
            if (botonVerConsejos)
            Container(
              alignment: Alignment.center,
              child: Center(
                child: ElevatedButton(
                  onPressed: (){
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Consejos'),
                          content: SingleChildScrollView(
                            child: const Text(
                              '- Si se encuentra en la ZONA CENTRO de la CDMX, lo recomendable es asignar un radio de busqueda de 500 a 2,000 metros.\n'
                                  '\n- Si vive en el Estado de Mexico y se encuentra CERCA de las periferias de la CDMX, lo recomendable es asignar un radio de busqueda de 2,000 a 4,000 metros.\n'
                                  '\n- Si vive en el Estado de Mexico y se encuentra LEJOS de las periferias de la CDMX, lo recomendable es asignar un radio de busqueda de 4,000 a 10,000 metros.\n'
                                  '\nNota:\n'
                                  '\n- Si la tabla no le devolvio estaciones cercanas, intente ingresar una nueva distancia mayor a la que ingreso previamente.\n'
                                  '\n- La distancia mostrada en la tabla no es exacta y puede no coincidir al momento de generar la ruta en Google Maps. '
                                  'Esto se debe a los algoritmos que usa Google Maps al momento de generar la ruta ya que Google Maps contempla Calles, Avenidas, Rotondas, Puentes, Trafico Actual, Cierre de Vialidades, etc.',
                              style: TextStyle(fontSize: 12.0),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text('¡Ver consejos!'),
                ),
              ),
            ),
            if (botonVerConsejos)
            const SizedBox(height: 15),
            if (botonVolverCargarPagina)
            Container(
              alignment: Alignment.center,
              child: Center(
                child: ElevatedButton(
                  onPressed: (){
                    reiniciarWidget();
                  },
                  child: const Text('Volver a Cargar la Pagina'),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if(mostrarContenidoTabla)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 8.0,
                columns: const [
                  DataColumn(label: Text('Icono\nde la estacion', style: TextStyle(fontWeight: FontWeight.bold),)),
                  DataColumn(label: Text('Línea\nde metro', style: TextStyle(fontWeight: FontWeight.bold),)),
                  DataColumn(label: Text('Nombre\nde la estacion', style: TextStyle(fontWeight: FontWeight.bold),)),
                  DataColumn(label: Text('Distancia\nAproximada', style: TextStyle(fontWeight: FontWeight.bold),)),
                  DataColumn(label: Text('¿Cómo llegar\na la estacion?', style: TextStyle(fontWeight: FontWeight.bold),)),
                ],
                rows: estacionesCercanasMapa.map((estacion) {
                  String nombre = estacion['nombre'];
                  String nuevaLinea = obtenerLinea(nombre);
                  String nuevoNombre = asignarNuevosNombresMapa[nombre] ?? nombre;
                  return DataRow(
                    cells: [
                      DataCell(
                        GestureDetector(
                          onTap: () {
                            double latitudEstacionMetro = listaCoordenadasEstaciones[estacionesCercanasMapa.indexOf(estacion)].latitude;
                            double longitudEstacionMetro = listaCoordenadasEstaciones[estacionesCercanasMapa.indexOf(estacion)].longitude;
                            abrirGoogleMapsPC(latitudEstacionMetro, longitudEstacionMetro); // PARA PC
                            abrirGoogleMapsAndroid(latitudEstacionMetro, longitudEstacionMetro); // PARA ANDROID
                          },
                          child: Image.asset(
                            imagenesEstacionesMapa[estacion['nombre']] ?? 'assets/metrocdmx/placeholder.png',
                            width: 40,
                            height: 40,
                          ),
                        ),
                      ),
                      DataCell(Text(nuevaLinea)),
                      DataCell(Text(nuevoNombre)),
                      DataCell(Text(formatearDistanciaMaKM(estacion['distanciaMetros']))),
                      DataCell(
                        ElevatedButton(
                          onPressed: () {
                            double latitudEstacionMetro = listaCoordenadasEstaciones[estacionesCercanasMapa.indexOf(estacion)].latitude;
                            double longitudEstacionMetro = listaCoordenadasEstaciones[estacionesCercanasMapa.indexOf(estacion)].longitude;
                            abrirGoogleMapsPC(latitudEstacionMetro, longitudEstacionMetro); // PARA PC
                            abrirGoogleMapsAndroid(latitudEstacionMetro, longitudEstacionMetro); // PARA ANDROID
                          },
                          child: const Text('Generar Ruta'),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
