@isTest
private class PardotPusherTest {
    
    @isTest
    static void shouldMakeHttpCallout() {
        //arrange
        List<PardotPusher.Payload> payloads = new List<PardotPusher.Payload>();
        PardotPusher.Payload payload1 = new PardotPusher.Payload();
        payload1.emailAddress = 'bob@email.com';
        payload1.formhandlerURL = 'https://coolurlhere';
        payloads.add(payload1);
        PardotPusherHttpCalloutMock httpMock = new PardotPusherHttpCalloutMock();

        //act
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, httpMock);
            PardotPusher.postToPardot(payloads);
        Test.stopTest();

        //assert
        HTTPRequest result = httpMock.capturedRequest;
        System.assertEquals('https://coolurlhere', result.getEndpoint());
        System.assertEquals('email=bob%40email.com', result.getBody());
    }
}
