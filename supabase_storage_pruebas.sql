-- ============================================================
-- STORAGE DE PRUEBAS
-- 1. Primero, ve a Storage (panel visual) y crea 3 buckets PÚBLICOS
--    con estos nombres exactos:
--      fotos-id-pruebas
--      fotos-frascos-pruebas
--      firmas-pruebas
-- 2. Luego corre este SQL para darles los mismos permisos seguros
--    que los buckets reales (solo autenticados pueden subir/editar).
-- ============================================================

create policy "Subir fotos-id-pruebas" on storage.objects
  for insert to authenticated with check (bucket_id = 'fotos-id-pruebas');
create policy "Subir fotos-frascos-pruebas" on storage.objects
  for insert to authenticated with check (bucket_id = 'fotos-frascos-pruebas');
create policy "Subir firmas-pruebas" on storage.objects
  for insert to authenticated with check (bucket_id = 'firmas-pruebas');

create policy "Actualizar fotos-id-pruebas" on storage.objects
  for update to authenticated using (bucket_id = 'fotos-id-pruebas');
create policy "Actualizar fotos-frascos-pruebas" on storage.objects
  for update to authenticated using (bucket_id = 'fotos-frascos-pruebas');
create policy "Actualizar firmas-pruebas" on storage.objects
  for update to authenticated using (bucket_id = 'firmas-pruebas');

create policy "Ver fotos-id-pruebas" on storage.objects for select to anon using (bucket_id = 'fotos-id-pruebas');
create policy "Ver fotos-frascos-pruebas" on storage.objects for select to anon using (bucket_id = 'fotos-frascos-pruebas');
create policy "Ver firmas-pruebas" on storage.objects for select to anon using (bucket_id = 'firmas-pruebas');
