alter table public.expenses
  add column if not exists series_id uuid,
  add column if not exists series_type text,
  add column if not exists sequence_number integer,
  add column if not exists sequence_total integer;

alter table public.expenses drop constraint if exists expenses_series_type_check;
alter table public.expenses add constraint expenses_series_type_check check (series_type is null or series_type in ('recurring', 'installment'));
alter table public.expenses drop constraint if exists expenses_sequence_check;
alter table public.expenses add constraint expenses_sequence_check check ((sequence_number is null and sequence_total is null) or (sequence_number >= 1 and sequence_total >= sequence_number));

create index if not exists expenses_family_date_idx on public.expenses (family_id, expense_date desc);
create index if not exists expenses_family_category_idx on public.expenses (family_id, category_id);
create index if not exists expenses_family_paid_by_idx on public.expenses (family_id, paid_by_user_id);
