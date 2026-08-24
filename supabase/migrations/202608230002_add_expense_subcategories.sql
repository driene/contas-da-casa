create table public.subcategories (
  id uuid primary key default gen_random_uuid(),
  family_id uuid not null references public.families(id) on delete cascade,
  category_id uuid not null references public.categories(id) on delete cascade,
  name text not null,
  active boolean not null default true,
  created_at timestamptz not null default now(),
  unique (category_id, name)
);

grant select, insert, update, delete on public.subcategories to authenticated;
alter table public.subcategories enable row level security;
create policy "subcategories_member_all"
on public.subcategories
for all
to authenticated
using (family_id = current_family_id())
with check (family_id = current_family_id());

alter table public.expenses
  add column subcategory_id uuid references public.subcategories(id) on delete set null;

create index expenses_family_subcategory_idx
  on public.expenses (family_id, subcategory_id);
