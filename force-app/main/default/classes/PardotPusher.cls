/**
 * Creates Prospect record by Filling out Pardot form handler. 
 * Invocable from Process Builder, Flows, other APEX.
 * Pass in email address and Form Handler URL
 */
public with sharing class PardotPusher {

    public class Payload {
        @InvocableVariable(label='Pardot FormHandler URL')
        public String formhandlerURL;
        @InvocableVariable(label='Email Address')
        public String emailAddress;
    }

    @InvocableMethod(label='Post to Pardot')
    public static void postToPardot(List<Payload> payloads) {
        // If bulk, only post first to avoid overloading Form Handler
        Payload p = payloads[0];
        String body = 'email=' + EncodingUtil.urlEncode(p.emailAddress, 'UTF-8');
        System.enqueueJob(new QueueablePardotCall (p.formhandlerURL, 'POST', body));
    }

   public class QueueablePardotCall implements System.Queueable, Database.AllowsCallouts {
        private final String url;
        private final String method;
        private final String body;

        public QueueablePardotCall(String url, String method, String body) {
            this.url = url;
            this.method = method;
            this.body = body;
        }

        public void execute(System.QueueableContext ctx) {
            HttpRequest req = new HttpRequest();
            req.setEndpoint(url);
            req.setMethod(method);
            req.setBody(body);
            Http http = new Http();
            //we fire it and don't care if it works as it likely will
            http.send(req);
        }
    }
}