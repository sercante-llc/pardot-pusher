@isTest
global class PardotPusherHttpCalloutMock implements HttpCalloutMock {
    public HTTPRequest capturedRequest {get;set;}

    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        this.capturedRequest = req;
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'text/html');
        res.setStatusCode(301);
        return res;
    }
}