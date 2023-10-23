//////// DEV CBLUNA ////////
const String supabaseUrl = 'https://supabase.cbluna-dev.com';
const String anonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyAgCiAgICAicm9sZSI6ICJhbm9uIiwKICAgICJpc3MiOiAic3VwYWJhc2UiLAogICAgImlhdCI6IDE2NTc2OTU2MDAsCiAgICAiZXhwIjogMTgxNTQ2MjAwMAp9.8h6s6K2rRn20SOc7robvygAWNhZsSWD4xFRdIZMyYVI';
const redirectUrl = '$supabaseUrl/arux-change-pass/#/change-password/token';
const themeId = String.fromEnvironment('themeId', defaultValue: '2');

String bonitaConnectionUrl = 'https://arux.cbluna-dev.com/arux/api';

///////////////////////////////////////////////////////////////////////

//const String moneda = 'USD';

///////////////////////////////////////////////////////////////////////
const String queryPartidasPush = '''select
  partidas_sap.id_partidas_pk,
  proveedores.sociedad,
  partidas_sap.referencia,
  round(partidas_sap.importe::numeric,2),
  partidas_sap.moneda,
  round(partidas_sap.importe::numeric,2),
  partidas_sap.dias_pago,
  CASE
  WHEN proveedores.descuento is not null THEN proveedores.descuento
  ELSE 0
  END,
  CASE
  WHEN round(((partidas_sap.importe * proveedores.descuento) /100)::numeric,2) is not null 
    then round(((partidas_sap.importe * proveedores.descuento) /100)::numeric,2)
  ELSE 0
  END,
  CASE
  WHEN round((partidas_sap.importe - (partidas_sap.importe * proveedores.descuento) /100)::numeric,2) IS NOT NULL 
    THEN round((partidas_sap.importe - (partidas_sap.importe * proveedores.descuento) /100)::numeric,2)
  ELSE 0
  END,
  esquemas.id_esquema_pk,
  estatus.id_estatus_pk

FROM
  proveedores

INNER JOIN 
  partidas_sap ON id_proveedor_pk = id_proveedor_fk
INNER JOIN
  "ConfigProveedor" ON "ConfigProveedor".id_proveedor_fk = proveedores.id_proveedor_pk
INNER JOIN 
  esquemas ON "ConfigProveedor".id_esquema_fk = esquemas.id_esquema_pk
INNER JOIN
  estatus ON id_estatus_fk = id_estatus_pk

WHERE 
  id_estatus_pk = 7
  AND esquemas.id_esquema_pk = 1 AND ''';

///////////////////////////////////////////////////////////////////////
const String queryPartidasPull = '''select
  partidas_sap.id_partidas_pk,
  proveedores.sociedad,
  partidas_sap.referencia,
  round(partidas_sap.importe::numeric,2),
  partidas_sap.moneda,
  round(partidas_sap.importe::numeric,2),
  partidas_sap.dias_pago,
  CASE
  WHEN proveedores.descuento is not null THEN proveedores.descuento
  ELSE 0
  END,
  CASE
  WHEN round(((partidas_sap.importe * proveedores.descuento) /100)::numeric,2) is not null 
    then round(((partidas_sap.importe * proveedores.descuento) /100)::numeric,2)
  ELSE 0
  END,
  CASE
  WHEN round((partidas_sap.importe - (partidas_sap.importe * proveedores.descuento) /100)::numeric,2) IS NOT NULL 
    THEN round((partidas_sap.importe - (partidas_sap.importe * proveedores.descuento) /100)::numeric,2)
  ELSE 0
  END,
  esquemas.id_esquema_pk,
  estatus.id_estatus_pk

FROM
  proveedores

INNER JOIN 
  partidas_sap ON id_proveedor_pk = id_proveedor_fk 
INNER JOIN
  "ConfigProveedor" ON "ConfigProveedor".id_proveedor_fk = proveedores.id_proveedor_pk
INNER JOIN 
  esquemas ON "ConfigProveedor".id_esquema_fk = esquemas.id_esquema_pk
INNER JOIN
  estatus ON id_estatus_fk = id_estatus_pk
  
WHERE 
  id_estatus_pk = 7
  AND(
  esquemas.id_esquema_pk = 2
  OR esquemas.id_esquema_pk = 3 )
  AND ''';

const String queryPartidas =
    "SELECT partidas_sap.id_partidas_pk,proveedores.sociedad ,partidas_sap.no_doc_partida,partidas_sap.importe_ml,partidas_sap.ml,partidas_sap.importe ,partidas_sap.dias_pago,partidas_sap.descuento_porc_pp,partidas_sap.descuento_cant_pp,partidas_sap.pronto_pago,esquemas.id_esquema_pk FROM proveedores INNER JOIN partidas_sap ON id_proveedor_pk = id_proveedor_fk INNER JOIN esquemas ON id_esquema_fk = id_esquema_pk WHERE ";
const String partidasProveedores = "";
const String queryRegistroFacturas = "";
const String querySeguimientoFacturas = "";
const String queryTablero = '''select
      proveedores.id_proveedor_pk::int,
      proveedores.sociedad,
      round (partidas_sap.importe::numeric,2)::float,
      partidas_sap.id_partidas_pk::varchar,
      esquemas.nombre_esquema::varchar,
      round(((partidas_sap.importe::numeric * proveedores.descuento::numeric) /100),2)::float as dpp,
      round((partidas_sap.importe::numeric / sum(partidas_sap.importe::numeric) over() *100),2)::float as equivalencia,
      partidas_sap.fecha_registro::timestamp
    from
      proveedores
      INNER JOIN partidas_sap ON id_proveedor_pk = id_proveedor_fk
      inner join "ConfigProveedor" on proveedores.id_proveedor_pk="ConfigProveedor".id_proveedor_fk
   inner join esquemas on esquemas.id_esquema_pk= "ConfigProveedor".id_esquema_fk
    where ''';
const String queryTablero2 = ''' 
    union all

    select
     count(proveedores.id_proveedor_pk)::int,
     'Total',
     round(sum(partidas_sap.importe::numeric),2)::float,
     count(partidas_sap.id_partidas_pk)::varchar,
     'Esquemas',
     round((sum((partidas_sap.importe::numeric * proveedores.descuento::numeric) /100)),2)::float as dpp,
     round((sum(partidas_sap.importe::numeric) * 100 / sum(partidas_sap.importe::numeric)),2)::float as equivalencia,
     current_date::timestamp
    from
     proveedores
     INNER JOIN partidas_sap ON id_proveedor_pk = id_proveedor_fk
     inner join "ConfigProveedor" on proveedores.id_proveedor_pk="ConfigProveedor".id_proveedor_fk
   inner join esquemas on esquemas.id_esquema_pk= "ConfigProveedor".id_esquema_fk
     where ''';
