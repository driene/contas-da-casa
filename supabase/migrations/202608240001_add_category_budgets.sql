alter table public.categories
  add column if not exists budget_amount numeric(12,2),
  add constraint categories_budget_amount_check check (budget_amount is null or budget_amount >= 0);

alter table public.subcategories
  add column if not exists budget_amount numeric(12,2),
  add constraint subcategories_budget_amount_check check (budget_amount is null or budget_amount >= 0);
