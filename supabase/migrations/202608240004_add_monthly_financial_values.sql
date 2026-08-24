create table public.monthly_financial_values (
  id uuid primary key default gen_random_uuid(),
  family_id uuid not null references public.families(id) on delete cascade,
  value_type text not null check (value_type in ('income','box')),
  target_id uuid not null,
  value_month date not null check (value_month = date_trunc('month', value_month)::date),
  amount numeric(12,2) not null check (amount >= 0),
  created_at timestamptz not null default now(),
  unique (family_id, value_type, target_id, value_month)
);

create index monthly_financial_values_family_month_idx on public.monthly_financial_values (family_id, value_month desc);
grant select, insert, update, delete on public.monthly_financial_values to authenticated;
alter table public.monthly_financial_values enable row level security;
create policy "monthly_financial_values_member_all" on public.monthly_financial_values
for all to authenticated
using (family_id = current_family_id())
with check (family_id = current_family_id());

insert into public.monthly_financial_values (family_id,value_type,target_id,value_month,amount)
select family_id,'income',id,date_trunc('month',current_date)::date,amount from public.income_sources;

insert into public.monthly_financial_values (family_id,value_type,target_id,value_month,amount)
select family_id,'box',id,date_trunc('month',current_date)::date,amount from public.savings_boxes;
