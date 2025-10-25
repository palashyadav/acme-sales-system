# Acme Widget Co — Basket System (Proof of Concept) - Ruby

## Overview
This Ruby proof of concept simulates a shopping basket system for **Acme Widget Co**.

It calculates basket totals, including **offers** and **delivery rules**, using a clean and extensible object-oriented architecture.

---

## 🧠 Design

### Classes
- **Product** — represents a product (code, name, price)
- **Catalogue** — stores all products by code
- **Basket** — handles adding products and computing totals
- **Offer (abstract)** — base class for promotions
- **RedWidgetHalfPriceOffer** — implements “Buy one red widget, get second half price”
- **DeliveryRule** — defines tiered delivery costs

---

## 💰 Pricing Rules
| Product | Code | Price |
|----------|------|-------|
| Red Widget | R01 | $32.95 |
| Green Widget | G01 | $24.95 |
| Blue Widget | B01 | $7.95 |

### Delivery Costs
- Under $50 → $4.95  
- Under $90 → $2.95  
- $90 or more → Free  

### Offer
**Buy one Red Widget, get the second half price.**

---

## 🚀 Usage
```bash
ruby basket.rb
