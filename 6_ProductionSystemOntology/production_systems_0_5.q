[QueryGroup="Basic Queries"] @collection [[
[QueryItem="Sensors"]
PREFIX sosa: <http://www.w3.org/ns/sosa/>
PREFIX cd: <http://ontologies.ift.at/clean_drilling_ontology/0.1/>

SELECT ?sensor ?sr
WHERE
{
	?sensor a sosa:Sensor .
  	?sensor cd:samplingrate ?sr .
}

[QueryItem="TemperatureSensor"]
PREFIX cd: <http://ontologies.ift.at/clean_drilling_ontology/0.1/>

SELECT ?sensor
WHERE
{
  ?sensor a cd:TemperatureSensor .
}

[QueryItem="Experiments"]
PREFIX time: <http://www.w3.org/2006/time#>
PREFIX cd: <http://ontologies.ift.at/clean_drilling_ontology/0.1/>

SELECT ?name ?start ?stop
WHERE
{
  	?experiment a cd:Experiment .
	?experiment rdfs:label ?name .
	?experiment time:hasBeginning ?start .
	?experiment time:hasEnd ?stop .
}

[QueryItem="Boreholes"]
PREFIX cd: <http://ontologies.ift.at/clean_drilling_ontology/0.1/>


SELECT ?borehole ?holenumber ?row ?column
WHERE
{
  	?borehole 	a cd:Borehole ;
			cd:holenumber ?holenumber ;
			cd:positionRow ?row ;
			cd:positionColumn ?column .

}

[QueryItem="Tools"]
PREFIX : <http://ontologies.ift.at/production_systems.ttl/0.5/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX cd: <http://ontologies.ift.at/clean_drilling_ontology/0.1/>

SELECT ?toolname ?diameter ?vendor
WHERE
{
  	?tool 	a :Tool ;
		rdfs:label ?toolname ;
		cd:drillDiameter ?diameter ;
		cd:vendor ?vendor .
}

[QueryItem="Plates"]
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX cd: <http://ontologies.ift.at/clean_drilling_ontology/0.1/>

SELECT ?couponid ?thickness
WHERE
{
  	?plate 	a cd:Plate ;
		rdfs:label ?couponid .
}
]]

[QueryGroup="FancyStuff"] @collection [[
[QueryItem="BoreholeWithCoatedTool"]
PREFIX ps: <http://ontologies.ift.at/production_systems.ttl/0.5/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX cd: <http://ontologies.ift.at/clean_drilling_ontology/0.1/>

SELECT ?holenumber ?row ?column ?toolname
WHERE
{
  	?borehole 	a cd:Borehole ;
			cd:holenumber ?holenumber ;
			cd:positionRow ?row ;
			cd:positionColumn ?column.
	?process		ps:createsFeature ?borehole ;
			ps:usesTool 	?tool.
	?tool		rdfs:label	?toolname.
	?tool		a		cd:CoatedDrill.
}

[QueryItem="ForceSignalsForParticularPhase"]
PREFIX : <http://ontologies.ift.at/production_systems.ttl/0.5/>
PREFIX cd: <http://ontologies.ift.at/clean_drilling_ontology/0.1/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX ssn: <https://www.w3.org/ns/ssn/>
PREFIX sosa: <http://www.w3.org/ns/sosa/>
PREFIX time: <http://www.w3.org/2006/time#>

SELECT ?sensorname ?datatable ?process
WHERE
{
  	?sensor	a cd:ForceSensor ;
		cd:datatable ?datatable ;
		rdfs:label ?sensorname .
	?rig sosa:hosts ?sensor.
	?rig :executesProcess ?process.
}

[QueryItem="ToolsWithPowerMeasurements"]

]]
