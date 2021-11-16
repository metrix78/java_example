
#Useful HTTP response codes
200 OK
201 Created
404 Not Found

How I would configure routes in other frameworks:

route 'addItem/#{id}/'
AddItem (string)
  201 (return ID)
  404 
  
route 'markItemComplete/#{id}/'
MarkItemComplete (ID)
  200 return ID
  404 

route 'unmarkItemComplete/#{id}/'
UnmarkComplete (ID)
  200 return ID
  404 

route 'deleteItem/#{id}/'
DeleteItem (ID)
  201 (return ID)
  404

route 'items/'
Items ()
  200

  
