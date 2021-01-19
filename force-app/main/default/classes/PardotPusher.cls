/**
 * Creates Prospect record by Filling out Pardot form handler. 
 * Invocable from Process Builder, Flows, other APEX.
 * Pass in email address and Form Handler URL
 */
public with sharing class PardotPusher {
    private static final Integer HTTP_REQUESTS_PER_BATCH = 50;

    /**
     * Represents the Data that is passed in from Process Builder / Flows etc
     */
    public class Payload {
        @InvocableVariable(label='Pardot FormHandler URL')
        public String formhandlerURL;
        @InvocableVariable(label='Email Address')
        public String emailAddress;
    }

    @InvocableMethod(label='Post to Pardot')
    public static void postToPardot(List<Payload> payloads) {
        //Very quickly pass this request into the ASYNC Queue, eliminating delays for Users
        System.enqueueJob(new QueueablePardotCall (payloads));
    }

    /**
     * Handles Asynchronously firing each Payload to Pardot
     */
    public class QueueablePardotCall implements System.Queueable, Database.AllowsCallouts {
       //tracks which Payloads that should be sent out. This may be called recursively
        private final List<Payload> payloads;

        public QueueablePardotCall(List<Payload> payloads) {
            this.payloads = payloads;
        }

        public void execute(System.QueueableContext ctx) {
            //Depending on how many Payloads we are processing, we might hit the APEX limit of 100 Web Callouts
            List<Payload> remainingPayloads = new List<Payload>();
            Integer processedCount = 0;

            for(Payload payload : payloads) {
                if(processedCount < HTTP_REQUESTS_PER_BATCH ) {
                    String body = 'email=' + EncodingUtil.urlEncode(payload.emailAddress, 'UTF-8');
                    HttpRequest req = new HttpRequest();
                    req.setEndpoint(payload.formhandlerURL);
                    req.setMethod('POST');
                    req.setBody(body);
                    Http http = new Http();
                    //we fire it and don't care if it works as it likely will
                    http.send(req);
                    processedCount++;
                }
                else {
                    remainingPayloads.add(payload); //we will process this in the next batch of Payloads
                }
            }
            if(!remainingPayloads.isEmpty()) {
                System.enqueueJob(new QueueablePardotCall (remainingPayloads));
            }
        }
    }
}