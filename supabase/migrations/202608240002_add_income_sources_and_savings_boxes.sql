create table public.income_sources (
  id uuid primary key default gen_random_uuid(),
  family_id uuid not null references public.families(id) on delete cascade,
  name text not null,
  amount numeric(12,2) not null default 0 check (amount >= 0),
  active boolean not null default true,
  created_at timestamptz not null default now(),
  unique (family_id, name)
);

create table public.savings_boxes (
  id uuid primary key default gen_random_uuid(),
  family_id uuid not null references public.families(id) on delete cascade,
  name text not null,
  amount numeric(12,2) not null default 0 check (amount >= 0),
  active boolean not null default true,
  created_at timestamptz not null default now(),
  unique (family_id, name)
);

create index income_sources_family_idx on public.income_sources (family_id);
create index savings_boxes_family_idx on public.savings_boxes (family_id);

grant select, insert, update, delete on public.income_sources to authenticated;
grant select, insert, update, delete on public.savings_boxes to authenticated;

alter table public.income_sources enable row level security;
alter table public.savings_boxes enable row level security;

create policy "income_sources_member_all" on public.income_sources
for all to authenticated
using (family_id = current_family_id())
with check (family_id = current_family_id());

create policy "savings_boxes_member_all" on public.savings_boxes
for all to authenticated
using (family_id = current_family_id())
with check (family_id = current_family_id());
