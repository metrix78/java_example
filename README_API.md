
#Useful HTTP response codes
200 OK
201 Created
404 Not Found

How I would configure routes in other frameworks:

GET -> route 'item/#{id}/'
  201 (return ID)
  404 
  
POST -> route 'item/#{id}/'
MarkItemComplete (ID)
  200 return ID
  404 

DELETE -> route 'item/#{id}/'
DeleteItem (ID)
  201 (return ID)
  404

GET -> route 'items/'
  201 (return ID)
  404 
  
