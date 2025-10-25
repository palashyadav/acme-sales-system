# Acme Widget Co — Basket System (Proof of Concept) - Ruby

## Overview
This Ruby program simulates a shopping basket for Acme Widget Co.
It calculates totals including product prices, special offers, and delivery charges.

## How it Works
1. **Products**: `Product` class stores code, name, and price.
2. **Catalogue**: Stores all products and provides lookup by code.
3. **Basket**: Stores items, calculates totals, applies offers and delivery charges.
4. **Offers**: Currently only `RedWidgetHalfPriceOffer` (buy one red widget, get second half price).
5. **Delivery**: Applied after discounts:
   - < $50 → $4.95
   - $50–$89.99 → $2.95
   - $90+ → free
6. **Total** = (sum of item prices - offer discounts) + delivery charge

## Assumptions
- Offers apply only to exact product codes.
- Delivery cost is based on discounted subtotal.
- Prices use `BigDecimal` for precise currency calculations.
- No taxes applied (not specified in task).
- The system is extensible for more offers or delivery rules.

## Pricing Rules
| Product      | Code | Price  |
|------------- |------|-------|
| Red Widget   | R01  | $32.95 |
| Green Widget | G01  | $24.95 |
| Blue Widget  | B01  | $7.95  |

## Usage
Run the program:

```bash
ruby basket.rb
