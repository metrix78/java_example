API Standards
===

General
---
* REST not RPC
* Use nouns but no verbs
* GET method and query parameters should not alter the state
* Use singular nouns
* Use sub-resources for relations
* Handle Errors with HTTP status codes
* Non-RESTful Operations 

HTTP Verbs / Response Status'
---
Acceptable request / responses pairs
#####GET - Used to retrieve resources **NEVER ALTER STATE**
* **200 OK** - Completed without exception - Payload in response body
* **400 BAD REQUEST** - Payload should include a standard error payload
	* Validation errors - ```ValidationUtils.assertValidEmail("email", request.getEmail());```
	* Totally bogus requests
* **401 NOT AUTHORIZED** - The requests requires valid authentication credentials
	* Request received with valid creds but not allowed access to resource
	* Not to be confused with NOT AUTHENTICATED
* **404 NOT FOUND**
	* The system handles the response when an exception is thrown that extends NotFoundException - ```throw new ThingNotFoundException();```
	* **DO NOT** return empty resources with a 200
* **500 INTERNAL SERVER ERROR** - System error - The front end should handle but if we see this we have an bug in the backend

#####PUT - Used to alter state of a resource
* **200 OK** - Completed without exception - **NO PAYLOAD**
* **400 BAD REQUEST** - Payload should include a standard error payload
	* Validation errors - ```ValidationUtils.assertValidEmail("email", request.getEmail());```
	* Totally bogus requests
* **401 NOT AUTHORIZED** - The requests requires authorization **SYSTEM HANDLED**
* **403 FORBIDDEN** - Unauthorized request
	* Valid request but no permissions to modify this resource
	* Not to be confused with NOT AUTHENTICATED
* **404 NOT FOUND** 
	* The system handles the response when an exception is thrown that extends NotFoundException - ```throw new ThingNotFoundException();```
* **500 INTERNAL SERVER ERROR** - System error - The front end should handle but if we see this we have an bug in the backend

#####POST - Used to create a resource
* **201 OK** - Completed without exception and the LOCATION header is populated - **NO PAYLOAD**
* **400 BAD REQUEST** - Payload should include a standard error payload
	* Validation errors - ```ValidationUtils.assertValidEmail("email", request.getEmail());```
	* Totally bogus requests
* **401 NOT AUTHORIZED** - The requests requires authorization **SYSTEM HANDLED**
* **403 FORBIDDEN** - Unauthorized request
	* Valid request but no permissions create this resource
	* Not to be confused with NOT AUTHENTICATED
* **404 NOT FOUND**
	* The system handles the response when an exception is thrown that extends NotFoundException - ```throw new ThingNotFoundException();```
* **409 CONFLICT** - Resource already exists
	* The system handles the response when an exception is thrown that extends AlreadyExistsException - ```throw new ThingAlreadyExistsException();```
* **500 INTERNAL SERVER ERROR** - System error - The front end should handle but if we see this we have an bug in the backend

#####DELETE - Used to remove a resource
* **200 OK** - Completed without exception - **NO PAYLOAD**
* **400 BAD REQUEST** - Payload should include a standard error payload
	* Validation errors - ```ValidationUtils.assertValidEmail("email", request.getEmail());```
	* Totally bogus requests
* **401 NOT AUTHORIZED** - The requests requires authorization **SYSTEM HANDLED**
* **403 FORBIDDEN** - Unauthorized request
	* Valid request but no permissions to remove this resource
	* Not to be confused with NOT AUTHENTICATED	
* **404 NOT FOUND**
	* The system handles the response when an exception is thrown that extends NotFoundException - ```throw new OpenHouseNotFoundException();```
* **500 INTERNAL SERVER ERROR** - System error - The front end should handle but if we see this we have an bug in the backend
 
#####Response Examples
* 400 - Simple - Not generally used, but could be used in cases where an empty payload was sent.  Generally handled as a validation error.
```json
{
  "type": "http://httpstatus.es/401",
  "title": "What did you do!?",
  "status": 400,
  "detail": "You tried send something we didn't expect"
}
```
* 400 - Validation - General case for 400's
```json
{
  "type": "http://httpstatus.es/400",
  "title": "There are 1 error(s) that need to be addressed",
  "status": 400,
  "detail": "MessageBodyValidationException",
  "errors": [
    {
      "field": "PROFANITY",
      "message": "Uh oh. Something tripped our profanity filters"
    }
  ]
}
```
* 401 - Not authenticated.  401's are special and cause the browser to invalidate credentials
```json
{
  "type": "http://httpstatus.es/401",
  "title": "Full authentication is required to access this resource",
  "status": 401,
  "detail": "Full authentication is required to access this resource"
}
```
* 404 - Not found
```json
{
  "type": "http://httpstatus.es/404",
  "title": "The thing cannot be found",
  "status": 404,
  "detail": "ThingNotFoundException"
}
```



Non-RESTful Operations 
---

To enable execution of non-CRUD operations against actionable resources.
 
* Execute action:
	* Path: ```/path/to/resource/_action```
	* HTTP Method: POST
	* Request body: `{"action" : "sync", "properties" : { "fieldName": "value" }}` Properties field is optional.
	* HTTP status
		* **200 OK**action request was received and completed.
		* **202 ACCEPTED** action request is accepted and indicating that process is either running or completed. Return location to get action status.
		* **400 BAD REQUEST** an unsupported action type was request
		* **409 CONFLICT** if action cannot be execute because it is currently running.
 	* Controller implementation details:
		* To support action against a resource, the resource class must apply the `@AllowedActions` annotation with all supported action types as arguments.
		* Add ActionRequest subtype as an argument to your `_action` controller method. Note that a controller can have multiple
		 `_action` endpoints, but they must be unique.
		* Optionally, add location header with URL to `[GET]/path/to/resource/_action`
		* For 200 response, method may return an ActionView subtype. Sample JSON response:
			```	
				"url": "/path/to/resource",
				"actions": [
					{
						"type": "sync",
						"status": "<in progress|completed|failed>",
						"started": <timestamp>,
						"completed": <timestamp>
					},
					{
						"type": "clone",
						"status": "<in progress|completed|failed>",
						"started": <timestamp>,
						"completed": <timestamp>
					}
				]
			 ```
 * Get action status (not required):
 	* Path: ```/path/to/resource/_action```
 	* HTTP Method: GET
  	* HTTP status
    	* **200 OK**
    * Controller implementation details:
    	* Controller method returns an ActionView.
    	
    	
#####ActionView
```
public class ActionView implements Serializable {
   
   	private String resourceURL;
   	private Set<Action> actions;
   
   	@Getter
   	@Setter
   	static class Action {
   		private ActionType type;
   		private String status;
   		private LocalDateTime startedAt;
   		private LocalDateTime endedAt;
   	}
   
     public enum ActionType {
       batchjob,
       copy,
       clone,
       draft,
       dispatch,
       dropAndRefresh,
       generate,
       imageResize,
       lock,
       publish,
       unpublish,
       reorder,
       releaseLock,
       reload,
       refresh,
       report,
       replace,
       resendEmail,
       reset,
       resize,
       retrigger,
       trigger,
       swich,
       sync,
       syncAndSave
     }
```
    	

