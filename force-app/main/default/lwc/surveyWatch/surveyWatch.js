import { LightningElement, track } from 'lwc';
import { subscribe, onError } from 'lightning/empApi';
import getRecentSurveys from '@salesforce/apex/SurveyWatchController.getRecentSurveys';
import testEvent from '@salesforce/apex/SurveyWatchController.testEvent';

export default class SurveyWatch extends LightningElement {
    @track displayRecords = [];
    subscription = {};
    channelName = '/event/Survey_Submission__e';

    connectedCallback() {
        this.loadData();

        onError((error) => {
            console.error('EMP API error:', JSON.stringify(error));
        });

        this.handleSubscribe();
    }

    loadData() {
        getRecentSurveys()
            .then((result) => {
                this.displayRecords = result;
            })
            .catch((error) => {
                console.error('Error fetching surveys:', error);
            });
    }

    buttonTestEvent() {
        console.log('Trying to call testEvent');
        testEvent()
            .then((result) => {
                console.log('testEvent result:', result);
            })
            .catch((error) => {
                console.error('Error calling testEvent:', error);
            });
    }

    handleSubscribe() {
        const messageCallback = (response) => {
            setTimeout(() => {
                this.loadData();
            }, 400);
        };

        subscribe(this.channelName, -1, messageCallback).then((response) => {
            console.log('Successfully subscribed to : ', response.channel);
            this.subscription = response;
        });
    }

    get hasRecords() {
        return this.displayRecords && this.displayRecords.length > 0;
    }
}
