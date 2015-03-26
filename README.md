# Customer-Invoice-System
The subject is to invoice orders. To invoice is to change the state of an order (to change it from the state “pending” to “invoiced”). On an order, we have one and one only reference to an ordered product of a certain quantity. The quantity can be different to other orders. The same reference can be ordered on several different orders. The state of the order will be changed into “invoiced” if the ordered quantity is either less or equal to the quantity which is in stock according to the reference of the ordered product. New orders, cancellations of orders, and entries of quantities in the stock are taken into account.

#Grammar
```
system invoice
 
nothing
  --skip
 
add_type(product_id: STRING)
  -- e.g. add("nuts")
  -- product types must be declared in advance of orders
 
add_product(a_product: STRING; quantity: INTEGER)
  -- e.g. add_product("nuts", 1000)
  -- adds 1000 nuts to stock
 
add_order (a_order: ARRAY[ TUPLE[ pid:STRING; no:INTEGER ] ] )
  -- e.g. place_order(<<["nuts", 5], ["bolts", 12]>> )
  -- system assigns a unique order ID seen at the output
  -- if successful, items removed from stock
 
invoice(order_id: INTEGER)
  -- e.g. do_invoice(1)
  -- change order ID 1 from pending to invoiced
 
cancel_order(order_id: INTEGER)
  -- e.g. cancel_order(1)
  -- items are returned to stock
  -- order_id is freed up
```
#Output
```
->add_product("bolts",100)
  report:      ok
  id:          0
  products:    bolts,hammers,nuts
  stock:       bolts->100
  orders:      
  carts:       
  order_state: 
...
```
#Status/error reporting

The order of error checking on the arguments of input commands decreases from high precedence at the top to low at the bottom. Only the first error, in precedence order, is reported to the user at the output.
```
add_type(a_product: STRING)
  product type must be non-empty string
  product type already in database

add_product(a_product: STRING ; a_quantity: INTEGER)
  quantity added must be positive
  product not in database

add_order(a_order: ARRAY[TUPLE[pid: STRING; no: INTEGER]])
  no more order ids left
  cart must be non-empty
  quantity added must be positive
  some products in order not valid
  duplicate products in order array
  not enough in stock

invoice(order_id: INTEGER)
  order id is not valid
  order already invoiced

cancel_order(order_id: INTEGER)
  order id is not valid
```
#To Do:
- write more acceptance tests
- write unit tests
- stronger contracts
- design documentation (and comments)

#License
MIT © Ursula Sarracini
