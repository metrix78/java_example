
#Useful HTTP response codes
200 OK
201 Created
404 Not Found

How I would configure routes in other frameworks:

GET -> route 'item/#{id}/'
  200 (return ID)
  404 
  
POST -> route 'item/'
  201 return ID
  404 

PUT -> route 'item/#{id}/'
  200 return ID
  404 


DELETE -> route 'item/#{id}/'
DeleteItem (ID)
  200 (return ID)
  404

GET -> route 'items/'
  200 (return ID)
  404 
  
