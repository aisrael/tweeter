// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"

import ApolloClient from 'apollo-boost';
import { ApolloProvider } from 'react-apollo';
import React from "react";
import ReactDOM from "react-dom";
import { Query } from 'react-apollo';
import * as TweetsQL from './tweetsql';
import TweetCard, { Tweet } from './tweet_card';
import TweetForm from './tweet_form';

const client = new ApolloClient();

const Tweets = () => {
    return (
        <section>
            <div className="col">
                <div className="row">
                    <Query query={TweetsQL.LIST_TWEETS}>
                        {({ loading, error, data }: { loading: any, error: any, data: any }) => {
                            if (loading) return 'Loading...';
                            if (error) return `Error! ${error.message}`;

                            return (
                                <div>
                                    {
                                        data.tweets.map((tweet: Tweet, index: number) => {
                                            return (<TweetCard key={tweet.id} tweet={tweet} />)
                                        })
                                    }
                                </div>
                            );
                        }}
                    </Query>
                </div>
            </div>
        </section >
    )
}

ReactDOM.render(
    <ApolloProvider client={client}>
        <TweetForm />
        <Tweets />
    </ApolloProvider>,
    document.getElementById("tweets")
);
