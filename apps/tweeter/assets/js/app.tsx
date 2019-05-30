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
import React, { useState, useReducer } from "react";
import ReactDOM from "react-dom";
import { format } from "date-fns";
import gql from 'graphql-tag';
import { Query } from 'react-apollo';

const client = new ApolloClient();

interface Tweet {
    id: number,
    timestamp: number,
    handle: string,
    content: string
}

const TweetCard: React.FC<{
    tweet: Tweet
}> = ({
    tweet
}): JSX.Element => {
        let date = new Date();
        let formatted_timestamp = format(date, 'MM/DD/YYYY hh:mma');
        return (
            <div key={tweet.id} className="card" style={{ width: "18rem" }}>
                <div className="card-body">
                    <h5 className="card-title">{tweet.handle}</h5>
                    <h6 className="card-subtitle">{formatted_timestamp}</h6>
                    <p className="card-text">{tweet.content}</p>
                </div>
            </div>
        )
    }

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
        </section >
    )
}

ReactDOM.render(
    <ApolloProvider client={client}>
        <Index />
    </ApolloProvider>,
    document.getElementById("tweets")
);
