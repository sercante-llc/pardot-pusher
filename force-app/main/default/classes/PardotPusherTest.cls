@isTest
private class PardotPusherTest {
    
    @isTest
    static void shouldMakeHttpCallout() {
        //arrange
        List<PardotPusher.Payload> payloads = new List<PardotPusher.Payload>();

        //Build out 200 requests
        for(Integer i = 0; i<200; i++) {
            payloads.add(buildPayload('bob'+i+'@email.com','https://coolurlhere'+i));
        }

        PardotPusherHttpCalloutMock httpMock = new PardotPusherHttpCalloutMock();

        //act
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, httpMock);
            PardotPusher.postToPardot(payloads);
        Test.stopTest();

        //assert
        for(Integer i=0; i<200; i++) { //we are testing that 200 http calls are being made
            HttpRequest result = httpMock.capturedRequests.get(i);
            System.assertEquals('https://coolurlhere'+i, result.getEndpoint());
            System.assertEquals('email=bob'+i+'%40email.com', result.getBody());
        }
    }

    private static PardotPusher.Payload buildPayload(String email, String url) {
        PardotPusher.Payload p = new PardotPusher.Payload();
        p.emailAddress = email;
        p.formhandlerURL = url;
        return p;
    }
}
