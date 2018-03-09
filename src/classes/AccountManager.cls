/**
 * Created by rvivek on 2/11/2018.
 */

@RestResource(urlMapping='/Accounts/*/contacts')
global with sharing class AccountManager {

    @HttpGet
    global static Account getAccount() {
        RestRequest request = RestContext.request;
        // grab the caseId from the end of the URL
        String accountId = request.requestURI.substring(request.requestURI.lastIndexOf('/'),
                request.requestURI.lastIndexOf('/')+1);
        String[] queryparams = request.requestURI.split('/');

        system.debug('------');
        for (String str : queryparams) {
            system.debug(str);
        }
        system.debug('------'+queryparams[4]);

        Account account = [Select Id,Name,(Select Id,Name from contacts) from Account where Id=:queryparams[4]];
        return account;

    }
}