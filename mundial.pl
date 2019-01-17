#!/usr/bin/perl
use strict;
use warnings;
srand;

# Con este script gane un juego en donde había que adivinar quien iba a ser el campeon de la copa FIFA 2010.

# El script toma en cuenta un valor numérico asignado a cada pais de acuerdo a la tasa de pago en sitios de apuestas
# en caso de ser ser campeon. 
# Se hacen millones de simulaciones y finalmente muestra el que mas resulto ganador en esas simulaciones.

# Como medida de seguridad, termine editando los nombres de los paises por nombres ficticios. Si alguien corria el script
# sin mi permiso no sabria a que pais corresponde el ganador.

my %equipos = 	(
			'Boringa' => 4,
 			'Boyoneros' => 30,
			'Chutamocha' => 5.5,
			'Pepinia' => 6.5,
			'TT United' => 8,
			'Zungalandia' => 25,
			'Mandos Medios' => 20,
			'Telecos' => 30,
			'IT' => 25,
			'Microfonos FC' => 30,
			'Taragui S.A.' => 20,
			'Cazadores de Osos' => 25,
			'El Gran Ajo' => 25,
			'Viejos Fastidados Asociados' => 40,
			'Comepebetes' => 80,
			'Jugadores que viven en el casino' => 50,
			'Inutiles' => 50,
			'Vienenborrachos' => 100,
			'Choritos' => 80,
			'Nopaganelasado' => 200,
			'Obsecuentes' => 50,
			'Dominados' => 100,
			'Garcas FC' => 150,
			'Banania' => 80,
			'Bulteros' => 100,
			'Entrometidos' => 80,
			'Ratones' => 500,
			'Alcahuetes' => 150,
			'Mochis' => 999,
			'Titeres' => 999,
			'Vagos' => 300,
			'Futboleros' => 999,
		);

my @paises = keys %equipos;

my %chances;
my @cupones = ();

my $constante = 100;
foreach my $pais (@paises){
	my $max = 50;
	my $min = 2;
	my $random = int( rand($max - $min + 1)) + $min;
	my $calc = int($constante / $equipos{$pais} * $random);
	$chances{$pais} = $calc;
	foreach (1 .. $calc){
		push(@cupones,$pais);
	}
}

my @urna = rand(@cupones);

#foreach my $ctry (sort keys %chances){
#		print "$ctry tiene $chances{$ctry} chances \n";
#}

print "\n";

my $intentos = 10000000;

my %ganadores = %equipos;

foreach my $ctry (keys %ganadores){
	$ganadores{$ctry} = 0;
}

foreach (1 .. $intentos){
	my $seleccion = $cupones[rand @cupones];
	$ganadores{$seleccion}++;
}

#system('clear');
my $nn = 1;
foreach my $name (sort { $ganadores{$b} <=> $ganadores{$a} } keys %ganadores) {
	printf "$nn) %-40s salio campeon el %s%% de las veces\n", $name, $ganadores{$name}/$intentos * 100;
	$nn++;
}
