# Pardot Pusher
An way to add a send to Pardot button for Lightning in salesforce.

Push records from the CRM to Pardot on demand
With process builder and an APEX class, we can create a way for prospects to be created in Pardot by having Salesforce automations (apex) fill out a Pardot Form Handler.

Example Process flow is
1. Add Lead/Contact to "Sync to Pardot" campaign
2. Process Builder sees this, checks to make sure we aren't already a Pardot Prospect.
3. If not currently a Prospect, kicks off APEX code
4. Apex Code fills out Kiosk mode Pardot Form Handler with just the email address to create record in Pardot
5. Pardot < - > Salesforce sync occurs, matches existing Lead/Contact, and syncs all the CRM fields to Pardot.

## Pardot Setup
### Form Handler
We need some sort of record creating activity in Pardot to occur. One way we can do this is by a Pardot Form Handler. We want the form handler to have a name that is meaningful for the sales team to recognize that this isn’t actually the Lead/Contact filling out a form. ‘Sync from Salesforce’ is probably a good name. 

#### Kiosk Mode ON:
Use the https://pi.pardot.com URL for the form handler as cookies aren’t in play and we are not likely to change URLs on company name change if we use Pardot.
Completion Actions:
Have a completion action that will zero out any scoring for the form handler that may occur. By default, this means we want to -50 points.

### Alternatives
We can also make this work with Zapier to use the Pardot API method within Zapier to create the record. The Apex code talks to a Zapier Webhook, which then creates the record in Pardot. Or a different MAS platform.

## Salesforce Setup
### Process Builder
We need a triggering ‘something’ in the CRM to happen which we can build a Process Builder or Flow against. This example is a Salesforce Campaign such as “Send to Pardot” (or Contacts as New Pardot Prospects” as in the screen shot). 
We build the process builder from the Campaign Member Object looking for the Campaign name(s) or IDs plus the Contact Pardot URL is blank as well as the Lead Pardot URL being blank. On the Campaign Member object both the Contact and Lead both exist so it’s one of the few objects we can do this with.

### Remote Site Settings
We need to grant permission for Salesforce to ‘talk’ to Pardot. So we need to set up a remote site setting. Use the pi.pardot.com version of the form handler as this tends to change less with re-branding

