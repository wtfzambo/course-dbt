## Question 1

**What is our overall conversion rate?**

```sql
select count(case when total_checkout = 1 then session_guid end) / count(session_guid)
  from int_session_user_events
```

`Answer: 62.5%`

## Question 2 

**What is our conversion rate by product?**

```sql
select
    product_guid
    , product_name
    , total_checkout / total_page_view
from dim_products
```

## Question 3

**Which orders changed from week 2 to week 3?**

Since last week I had ran the first `dbt snapshot` command late, the changed orders were in the source table, therefore, nothing changes from my answer in week 2.
The orders that changed status as of today are:
- 8385cfcd-2b3f-443a-a676-9756f7eb5404
- e24985f3-2fb3-456e-a1aa-aaf88f490d70
- 5741e351-3124-4de7-9dff-01a448e7dfd4
- 914b8929-e04a-40f8-86ee-357f2be3a2a2
- 05202733-0e17-4726-97c2-0520c024ab85
- 939767ac-357a-4bec-91f8-a7b25edd46c9
