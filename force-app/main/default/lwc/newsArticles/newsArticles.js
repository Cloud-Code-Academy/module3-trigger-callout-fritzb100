import { LightningElement, track } from 'lwc';
import getNewsArticles from '@salesforce/apex/NewsArticleController.getNewsArticles';

export default class NewsArticles extends LightningElement {
    @track articles;
    @track error;

    connectedCallback() {
        this.fetchNewsArticles();
    }

    fetchNewsArticles() {
        getNewsArticles()
            .then((result) => {
                this.articles = result;
                this.error = undefined;
            })
            .catch((error) => {
                this.error = error;
                this.articles = undefined;
            });
    }
    handleRefresh() {
        this.fetchNewsArticles();
    }
}