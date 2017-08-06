class Application

  @@items = ["Apples","Carrots","Pears"]
  @@cart = []

  def call(env)
    resp = Rack::Response.new
    req = Rack::Request.new(env)

    if req.path.match(/items/)
      @@items.each do |item|
        resp.write "#{item}\n"
      end
    elsif req.path.match(/search/)
      search_term = req.params["q"]
      resp.write handle_search(search_term)
    elsif req.path.match(/cart/) # creates the cart route
      if @@cart.empty? # if cart is empty =>
        resp.write "Your cart is empty"
      else 
        @@cart.each do |item|
          resp.write "#{item}\n" # => puts every item in cart
        end
      end
    elsif req.path.match(/add/) # if requested path matches add
      added_item = req.params["item"] # set item equal to param
      if @@items.include? added_item #== true # see if items includes item
        @@cart << added_item
        resp.write "added #{added_item}"
      else
        resp.write "We don't have that item!"
      end
    else
      resp.write "Path Not Found"
    end

    resp.finish
  end

  def handle_search(search_term)
    if @@items.include?(search_term)
      return "#{search_term} is one of our items"
    else
      return "Couldn't find #{search_term}"
    end
  end
end
