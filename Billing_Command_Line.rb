#Custom Exception to catch input with high/big values
class MaxLimitError < StandardError
end
#Custom Exception to catch input that contain 0
class ZeroQuantityError < StandardError
end

class Customer
  def initialize(customer_name)
    @customer_name = customer_name
    @shopping_cart = {}
  end

  #Can print the customer name by printing the customer object itself, without using a getter
  def to_s
    @customer_name
  end

  def display_shopping_cart
    @shopping_cart.each do |item, quantity|
      puts "-> #{item}, QTY: #{quantity}"
    end
    puts "\n"
  end

  def get_shopping_cart
    @shopping_cart
  end

  #Takes an array to fill the hash
  def add_item(item_details)
    @shopping_cart[item_details[0]] = item_details[1]
  end

  def delete_item
    display_shopping_cart
    print "Enter Deleting Item Name:"
    user_input = gets.chomp.downcase.to_sym           #Reasoning: hash keys are symbols in this program
    if @shopping_cart.has_key?(user_input)
      @shopping_cart.delete(user_input)
      puts "\nItem Deleted Successfully!\n\n"
    else
      puts "\nItem Wasnt Found, Please Check Spellings!\n\n"
    end
  end

end

class CandyShop
  #Only these six items will be sold for every Candy shop object
  #so they are assigned to a Class variable
  @@item_list = {:chocolate => 1000, :toffee => 10,
                 :crisps => 600, :soda => 150,
                 :popsicle => 70, :lolipop => 30}

  def display_items
    #Creating a menu to display items in the commandline
    puts "**********************"
    puts "*     Candy Shop     *"
    puts "**********************"
    #Using the each method with key, value pair to display all items
    @@item_list.each do |item, price|
      puts "-> #{item.capitalize}: Rs #{price}"
    end
    puts "**********************"
  end

  def select_item
    begin
      display_items
      print "Enter Item Name:"
      #downcased since ruby symbols are lowercase as per conventions
      user_input = gets.chomp.downcase

      if !@@item_list.has_key?(user_input.to_sym)
        #Basic raise is sufficient since only one exception will occur (The string is only for readability)
        raise "Invaid Item"
      end

    rescue
      puts "\nPlease Enter Correct Item Name!\n\n"
      #Sleep used throught the program to provide user time to read the error text
      sleep 0.5
      retry

    else
      #returns the item name as a symbol If everything proceded correctly
      user_input.to_sym
    end
  end

  def select_quantity
    begin
      print "Enter Quantity:"
      user_input = Integer(gets.chomp)

      if user_input > 50
        raise MaxLimitError
      elsif user_input <= 0
        raise ZeroQuantityError
      end

    rescue ArgumentError                    #ArgumentError could occur in user_input line
      puts "\nPlease Enter A Number!\n\n"
      sleep 0.5
      retry

    rescue MaxLimitError
      puts "\nShop Policy: Only 50 Per Customer ༼ つ ◕_◕ ༽つ\n\n"
      sleep 0.5
      retry

    rescue ZeroQuantityError
      puts "\nPlease Enter A Number Greater Than Zero!\n\n"
      sleep 0.5
      retry

    else
      #returns item quantity If no exception occured
      user_input
    end
  end

  #Uses the above methods to get name and quantity and then packs them in an array before returning them
  def shop_console
    item_name = select_item
    quantity = select_quantity
    [item_name, quantity]
  end

  def checkout(customer)
    total_price = 0
    shopping_cart = customer.get_shopping_cart
    puts "******************************"
    puts "             Bill             "
    puts " Customer: #{customer}"
    puts "******************************"
    shopping_cart.each do |item_name, item_quantity|
      #Since checking was done When inputting data to shopping cart,
      #we can compare CandyShop hash(item_list) with Customer cart without any risk of exceptions popin up
      price = @@item_list[item_name] * item_quantity
      puts "-> #{item_name.capitalize}, QTY:#{item_quantity} = Rs #{price}"
      total_price += price
    end
    puts "******************************"
    puts " Total Price: Rs #{total_price}"
    puts "******************************"
    sleep 10
  end

end

#Main Program
print "Enter Customer Name:"
customer_name = gets.chomp

candy_shop = CandyShop.new
customer = Customer.new(customer_name)
stop = false

#The program will always propmt customer to buy an item,
#otherwise there would be no item to view, delete or checkout
item_details = candy_shop.shop_console
customer.add_item(item_details)

#Any logic loop works here but, Until loop was implemented
#since it isnt common and is a unique feature of ruby
until stop do
  puts "Press:"
  puts " * 'Y' To Purchase Another Item"
  puts " * 'V' To View Shopping Cart"
  puts " * 'D' To Delete a Item"
  puts " * 'C' To Checkout"
  puts "--------------------------------"
  print "Select An Option:"
  customer_decision = gets.chomp.capitalize

  case customer_decision
  when "Y"
    item_details = candy_shop.shop_console
    customer.add_item(item_details)
  when "V"
    customer.display_shopping_cart
  when "D"
    customer.delete_item
  when "C"
    stop = true
  else
    puts "\nInvalid Input\n\n"
    time 0.5
  end
end
#the program ends with checkout showing the customer bill
candy_shop.checkout(customer)