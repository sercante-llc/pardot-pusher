@isTest
global class PardotPusherHttpCalloutMock implements HttpCalloutMock {
    public List<HTTPRequest> capturedRequests = new List<HTTPRequest>();

    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        this.capturedRequests.add(req);
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'text/html');
        res.setStatusCode(301);
        return res;
    }
}