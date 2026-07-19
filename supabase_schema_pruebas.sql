-- ============================================================
-- SCHEMA DE PRUEBAS - mismo proyecto, datos totalmente separados
-- Corre esto en SQL Editor → New Query → Run
-- ============================================================

create schema if not exists pruebas;

create table pruebas.empleados (
  id text primary key,
  nombre text not null unique,
  pin text,
  creado_en timestamptz default now()
);

create table pruebas.pacientes (
  id text primary key,
  nombre text not null,
  plan_medico text,
  telefono text,
  email text,
  direccion text,
  autorizado text,
  foto_id_url text,
  creado_en timestamptz default now()
);
create index idx_pruebas_pacientes_nombre on pruebas.pacientes (lower(nombre));

create table pruebas.entregas (
  id text primary key,
  paciente_nombre text not null,
  ubicacion text not null,
  autorizado text,
  notas text,
  codigo_barras text,
  foto_frasco_url text,
  fecha_registro timestamptz default now(),
  entregado boolean default false,
  fecha_entrega timestamptz,
  recogio_por text
);
create index idx_pruebas_entregas_paciente on pruebas.entregas (lower(paciente_nombre));
create index idx_pruebas_entregas_entregado on pruebas.entregas (entregado);

create table pruebas.medicamentos (
  id text primary key,
  entrega_id text references pruebas.entregas(id) on delete cascade,
  nombre text not null,
  presentacion text,
  controlado boolean default false,
  estado text default 'pendiente',
  motivo text,
  fecha timestamptz,
  recogio_por text,
  firma_url text,
  deuda_estado text default 'ninguna',
  deuda_monto text,
  entrega_parcial jsonb,
  pagos jsonb default '[]'::jsonb
);
create index idx_pruebas_medicamentos_entrega on pruebas.medicamentos (entrega_id);

create table pruebas.auditoria (
  id text primary key,
  fecha timestamptz default now(),
  empleado text,
  accion text,
  detalle text
);

create table pruebas.papelera (
  id text primary key,
  tipo text not null,
  datos jsonb not null,
  fecha_borrado timestamptz default now(),
  borrado_por text
);

-- Seguridad: mismo criterio que el proyecto real (solo autenticados)
alter table pruebas.empleados enable row level security;
alter table pruebas.pacientes enable row level security;
alter table pruebas.entregas enable row level security;
alter table pruebas.medicamentos enable row level security;
alter table pruebas.auditoria enable row level security;
alter table pruebas.papelera enable row level security;

create policy "Autenticados empleados pruebas" on pruebas.empleados for all to authenticated using (true) with check (true);
create policy "Autenticados pacientes pruebas" on pruebas.pacientes for all to authenticated using (true) with check (true);
create policy "Autenticados entregas pruebas" on pruebas.entregas for all to authenticated using (true) with check (true);
create policy "Autenticados medicamentos pruebas" on pruebas.medicamentos for all to authenticated using (true) with check (true);
create policy "Autenticados auditoria pruebas" on pruebas.auditoria for all to authenticated using (true) with check (true);
create policy "Autenticados papelera pruebas" on pruebas.papelera for all to authenticated using (true) with check (true);

-- Permitir que la API (PostgREST) use este schema
grant usage on schema pruebas to authenticated, anon;
grant all on all tables in schema pruebas to authenticated;
grant select on all tables in schema pruebas to anon;

-- ============================================================
-- PASO MANUAL EN EL PANEL (no se hace por SQL):
-- Ve a Settings → API → busca "Exposed schemas" (o "Schema config")
-- y agrega "pruebas" a la lista (además de "public").
-- Guarda los cambios.
-- ============================================================
