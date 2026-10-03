create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  handle text unique not null,
  name text,
  bio text default ''
);
create table if not exists public.posts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references public.profiles(id) on delete cascade,
  handle text,
  kind text not null check (kind in ('post','reel','story')),
  caption text default '',
  media_url text,
  created_at timestamptz default now()
);
alter table public.profiles enable row level security;
alter table public.posts enable row level security;
create policy "read profiles" on public.profiles for select using (true);
create policy "upsert own profile" on public.profiles for insert with check (auth.uid() = id);
create policy "update own profile" on public.profiles for update using (auth.uid() = id);
create policy "read posts" on public.posts for select using (true);
create policy "insert own posts" on public.posts for insert with check (auth.uid() = user_id);
insert into storage.buckets (id, name, public) values ('media','media', true) on conflict (id) do nothing;
create policy "public read media" on storage.objects for select using (bucket_id = 'media');
create policy "auth upload media" on storage.objects for insert with check (bucket_id = 'media' and auth.role() = 'authenticated');
