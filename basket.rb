require 'bigdecimal'
require 'bigdecimal/util'

# Represents a product with code, name, and price
class Product
  attr_reader :code, :name, :price

  def initialize(code, name, price)
    @code = code
    @name = name
    @price = price.to_d # Use BigDecimal for precise currency calculations
  end
end

# Stores all products and allows lookup by product code
class Catalogue
  def initialize(products)
    @products = {}
    products.each { |p| @products[p.code] = p }
  end

  # Find a product by code, raise error if not found
  def find(code)
    product = @products[code]
    raise "Unknown product code: #{code}" unless product
    product
  end
end

# Handles tiered delivery costs based on subtotal
class DeliveryRule
  def initialize(rules)
    @rules = rules.sort_by { |amount, _| amount } # Ensure rules are sorted
  end

  # Calculate delivery cost for a given subtotal
  def calculate(subtotal)
    @rules.each_cons(2) do |(limit, cost), (next_limit, _)|
      return cost.to_d if subtotal < next_limit.to_d
    end
    0.to_d # Free delivery for subtotal above highest threshold
  end
end

# Base class for offers (strategy pattern)
class Offer
  def apply(_items)
    0.to_d # Default: no discount
  end
end

# Implements "Buy one Red Widget, get second half price"
class RedWidgetHalfPriceOffer < Offer
  RED_CODE = 'R01'

  def apply(items)
    reds = items.select { |item| item.code == RED_CODE }
    return 0.to_d if reds.empty?
    pairs = reds.count / 2 # Only pairs qualify for half price
    half_price = (reds.first.price / 2).round(2, BigDecimal::ROUND_HALF_UP)
    pairs * half_price
  end
end

# Represents the shopping basket
class Basket
  attr_reader :items

  def initialize(catalogue:, delivery_rule:, offers: [])
    @catalogue = catalogue
    @delivery_rule = delivery_rule
    @offers = offers
    @items = []
  end

  # Add a product by code
  def add(code)
    @items << @catalogue.find(code)
  end

  # Calculate total cost including offers and delivery
  def total
    subtotal = items.map(&:price).sum
    discount = @offers.map { |offer| offer.apply(items) }.sum
    discounted_total = subtotal - discount
    delivery = @delivery_rule.calculate(discounted_total)
    (discounted_total + delivery).round(2).to_s('F') # Round to 2 decimals for display
  end
end

# Demo / Test runs
if __FILE__ == $PROGRAM_NAME
  # Create catalogue of products
  catalogue = Catalogue.new([
    Product.new('R01', 'Red Widget', 32.95),
    Product.new('G01', 'Green Widget', 24.95),
    Product.new('B01', 'Blue Widget', 7.95)
  ])

  # Define delivery rules
  delivery_rule = DeliveryRule.new([
    [0, 4.95],
    [50, 2.95],
    [90, 0]
  ])

  # Define offers
  offers = [RedWidgetHalfPriceOffer.new]

  # Sample baskets with expected totals for verification
  baskets = {
    %w[B01 G01] => '37.85',
    %w[R01 R01] => '54.37',
    %w[R01 G01] => '60.85',
    %w[B01 B01 R01 R01 R01] => '98.27'
  }

  # Test each basket and print results
  baskets.each do |products, expected|
    basket = Basket.new(catalogue: catalogue, delivery_rule: delivery_rule, offers: offers)
    products.each { |code| basket.add(code) }
    puts "#{products.join(', ')} => $#{basket.total} (Expected $#{expected})"
  end
end
