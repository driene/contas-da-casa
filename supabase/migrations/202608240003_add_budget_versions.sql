create table public.budget_versions (
  id uuid primary key default gen_random_uuid(),
  family_id uuid not null references public.families(id) on delete cascade,
  target_type text not null check (target_type in ('category','subcategory')),
  target_id uuid not null,
  effective_month date not null check (effective_month = date_trunc('month', effective_month)::date),
  amount numeric(12,2) not null check (amount >= 0),
  created_at timestamptz not null default now(),
  unique (family_id, target_type, target_id, effective_month)
);

create index budget_versions_family_month_idx on public.budget_versions (family_id, effective_month desc);
grant select, insert, update, delete on public.budget_versions to authenticated;
alter table public.budget_versions enable row level security;
create policy "budget_versions_member_all" on public.budget_versions
for all to authenticated
using (family_id = current_family_id())
with check (family_id = current_family_id());

insert into public.budget_versions (family_id,target_type,target_id,effective_month,amount)
select c.family_id,'category',c.id,date_trunc('year',current_date)::date,c.budget_amount
from public.categories c
where c.budget_amount is not null and c.budget_amount > 0
  and not exists (select 1 from public.subcategories s where s.category_id=c.id);

insert into public.budget_versions (family_id,target_type,target_id,effective_month,amount)
select s.family_id,'subcategory',s.id,date_trunc('year',current_date)::date,s.budget_amount
from public.subcategories s
where s.budget_amount is not null and s.budget_amount > 0;
