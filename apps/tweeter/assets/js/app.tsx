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
import gql from 'graphql-tag';
import { Query } from 'react-apollo';
import TweetCard from './tweet_card.tsx';

const client = new ApolloClient();

const LIST_TWEETS = gql`
{
    tweets {
        id
        handle
        content
    }
}
`

const Index = () => {
    return (
        <section>
            <div className="col">
                <div className="row">
                    <Query query={LIST_TWEETS}>
                        {({ loading, error, data }) => {
                            if (loading) return 'Loading...';
                            if (error) return `Error! ${error.message}`;

                            return (
                                <div>
                                    {
                                        data.tweets.map(function (tweet, index) {
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
        <Index />
    </ApolloProvider>,
    document.getElementById("tweets")
);
