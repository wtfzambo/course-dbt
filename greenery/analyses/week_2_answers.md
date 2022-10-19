# Week 2 questions

## Question 1

**How many users do we have?**

```sql
SELECT count_if(total_user_orders > 1) / count_if(total_user_orders > 0)
  FROM user_order_facts
```

`Answer: 79.8%`

## Question 2 

**What are good indicators of a user who will likely purchase again? What about indicators of users who are likely NOT to purchase again? If you had more data, what features would you want to look into to answer this question?**

I would suggest observing how frequency of orders and sessions on the website correlate with probability of purchasing, as well as session durations and number of interactions (lots of pageviews vs low pageviews, ...)

## Question 3

**Explain the marts models you added. Why did you organize the models in the way you did?**

I tried to create a structure that is relatively easy to follow from left to right, with few final, denormalized models as a combination of the original ones, that can quickly answer the most basic questions one may have about the most important Greenery entities (i.e. users and products).

## Tests
All of my tests passed. Admittedly, some of them are repeated tests from previous layers, and are pretty simple (unique, non nulls). In certain numerical fields I also applied the "no negatives" test to make sure that values that are supposed to be positive stay positive (e.g. price of an item or the cost of an order).

## Snapshots
The following orders changed status, and went from 'preparing' to 'shipped':
- 8385cfcd-2b3f-443a-a676-9756f7eb5404
- e24985f3-2fb3-456e-a1aa-aaf88f490d70
- 5741e351-3124-4de7-9dff-01a448e7dfd4
- 914b8929-e04a-40f8-86ee-357f2be3a2a2
- 05202733-0e17-4726-97c2-0520c024ab85
- 939767ac-357a-4bec-91f8-a7b25edd46c9
