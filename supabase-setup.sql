-- ============================================================
-- YANAR - Supabase Database Setup
-- Run this entire file in: Supabase Dashboard → SQL Editor → New Query
-- ============================================================

-- 1. PROFILES (users)
create table if not exists profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  username text unique not null,
  email text unique not null,
  display_name text,
  university text,
  college text,
  branch text,
  year text,
  created_at timestamptz default now()
);

-- 2. POSTS
create table if not exists posts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references profiles(id) on delete cascade not null,
  type text not null default 'info', -- info | question | opportunity | resource
  title text,
  body text,
  tags text[] default '{}',
  files jsonb default '[]',
  target_university text,
  target_college text,
  target_branch text,
  target_year text,
  created_at timestamptz default now()
);

-- 3. LIKES
create table if not exists likes (
  id uuid primary key default gen_random_uuid(),
  post_id uuid references posts(id) on delete cascade not null,
  user_id uuid references profiles(id) on delete cascade not null,
  created_at timestamptz default now(),
  unique(post_id, user_id)
);

-- 4. COMMENTS
create table if not exists comments (
  id uuid primary key default gen_random_uuid(),
  post_id uuid references posts(id) on delete cascade not null,
  user_id uuid references profiles(id) on delete cascade not null,
  parent_id uuid references comments(id) on delete cascade,
  body text not null,
  created_at timestamptz default now()
);

-- 5. COMMENT LIKES
create table if not exists comment_likes (
  id uuid primary key default gen_random_uuid(),
  comment_id uuid references comments(id) on delete cascade not null,
  user_id uuid references profiles(id) on delete cascade not null,
  unique(comment_id, user_id)
);

-- ============================================================
-- ROW LEVEL SECURITY (RLS) - makes data safe & public
-- ============================================================

alter table profiles enable row level security;
alter table posts enable row level security;
alter table likes enable row level security;
alter table comments enable row level security;
alter table comment_likes enable row level security;

-- PROFILES: anyone can read, only owner can write
create policy "profiles_read" on profiles for select using (true);
create policy "profiles_insert" on profiles for insert with check (auth.uid() = id);
create policy "profiles_update" on profiles for update using (auth.uid() = id);

-- POSTS: anyone can read, authenticated users can insert, owner can delete
create policy "posts_read" on posts for select using (true);
create policy "posts_insert" on posts for insert with check (auth.uid() = user_id);
create policy "posts_delete" on posts for delete using (auth.uid() = user_id);

-- LIKES: anyone can read, authenticated users manage their own
create policy "likes_read" on likes for select using (true);
create policy "likes_insert" on likes for insert with check (auth.uid() = user_id);
create policy "likes_delete" on likes for delete using (auth.uid() = user_id);

-- COMMENTS: anyone can read, authenticated users can insert
create policy "comments_read" on comments for select using (true);
create policy "comments_insert" on comments for insert with check (auth.uid() = user_id);
create policy "comments_delete" on comments for delete using (auth.uid() = user_id);

-- COMMENT LIKES
create policy "comment_likes_read" on comment_likes for select using (true);
create policy "comment_likes_insert" on comment_likes for insert with check (auth.uid() = user_id);
create policy "comment_likes_delete" on comment_likes for delete using (auth.uid() = user_id);

-- ============================================================
-- REALTIME (enable live updates)
-- ============================================================
alter publication supabase_realtime add table posts;
alter publication supabase_realtime add table comments;
alter publication supabase_realtime add table likes;

-- ============================================================
-- STORAGE BUCKET for file uploads
-- ============================================================
insert into storage.buckets (id, name, public) values ('yanar-files', 'yanar-files', true)
on conflict do nothing;

create policy "public_read_files" on storage.objects for select using (bucket_id = 'yanar-files');
create policy "auth_upload_files" on storage.objects for insert with check (bucket_id = 'yanar-files' and auth.role() = 'authenticated');
create policy "owner_delete_files" on storage.objects for delete using (bucket_id = 'yanar-files' and auth.uid() = owner);

-- ============================================================
-- Done! Your YANAR database is ready.
-- ============================================================
