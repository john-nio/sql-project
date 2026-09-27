# E-Commerce Customer Churn Analysis (SQL)

Exploratory analysis of customer churn for an e-commerce platform, written in MySQL. The goal is to find out which customer characteristics — complaints, tenure, order recency, satisfaction, order category, and payment/device habits — are associated with churn, and where those characteristics compound into especially high-risk segments.

## Dataset

- **Source:** `ecommerce_customers_complete` table, `ecommerce_churn` database (5,630 customers, 20 columns)
- **Target variable:** `Churn` (1 = churned, 0 = retained)
- **Key fields used:** `Tenure`, `Complain`, `SatisfactionScore`, `DaySinceLastOrder`, `PreferedOrderCat`, `PreferredPaymentMode`, `PreferredLoginDevice`

## Questions Explored

1. Overall churn rate
2. Does complaining relate to churn?
3. Does churn change across tenure groups?
4. Does time since last order relate to churn?
5. Which preferred order categories churn most — and are the group sizes trustworthy?
6. Is satisfaction score consistently related to churn?
7. Does churn differ by payment method or login device?
8. Among complainers, does satisfaction score still separate churners from non-churners?
9. Do low tenure and a recent complaint compound to push churn even higher?
10. Which combined segments (tenure × complaint × satisfaction × recency) carry the greatest retention risk?

## Key Findings

- **Baseline churn rate is ~16.8%.**
- **Complaints roughly triple churn risk:** 10.9% churn for customers who haven't complained vs. 31.7% for those who have.
- **Tenure is the strongest single driver:** customers with under 2 months' tenure churn at 51.8%, dropping sharply to ~6-7% for 2-19 months and ~3% for 20+ months. Customers with missing tenure data churn at an unusually high 30.7%, worth flagging as a data-quality issue rather than a real segment.
- **Order category matters, but sample sizes vary a lot:** Mobile Phone (27.5%) and Mobile (27.2%) categories churn highest, Grocery lowest (4.9%) — but Grocery has only 410 customers vs. 2,050 for Laptop & Accessory, so that comparison needs a caveat rather than a confident ranking.
- **Satisfaction score is *not* consistently protective** — churn actually rises from 11.5% at score 1 to 23.8% at score 5, the opposite of what you'd expect. This likely reflects customers rating satisfaction high right before leaving, or a labeling/scale quirk, and is worth a follow-up note rather than a clean "higher satisfaction → lower churn" story.
- **Complaints and low tenure compound:** new customers (<2 months) who also complained churn at 72.9%, vs. 39.4% for new customers with no complaint and 5.7% for 20+ month tenure customers who did complain — tenure and complaints interact rather than acting independently.
- **Highest-risk combined segment:** customers with missing tenure, a complaint on file, high satisfaction score, and an order in the last 0-3 days churn at 85.2% (n=27). Several new-customer segments (under 2 months, complained, ordered recently) sit in the 60-78% churn range with sample sizes of 30-110 — these are the clearest retention-risk pockets in the data.

## Repo Structure

```
ecommerce-churn-analysis/
├── data_source/
│   └── ecommerce_customers.csv
├── query.sql
└── README.md
```

## Tools

- MySQL (queries written and run against a local `ecommerce_churn` database)

## Notes / Next Steps

- Missing `Tenure` and `DaySinceLastOrder` values show meaningfully different churn behavior than non-missing rows — treating "Missing" as its own bucket (rather than imputing) was the right call here and turned up a real signal.
- The satisfaction score finding is counterintuitive and worth digging into further (e.g., checking whether it's collected at signup vs. at time of complaint/cancellation).
- Small-sample categories (e.g., Grocery, Others) should be flagged with sample size whenever they're cited, since a few customers can swing the rate a lot.
