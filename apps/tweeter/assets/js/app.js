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
import { format } from "date-fns";

const client = new ApolloClient();

const Index = () => {
    var tweets = [{
        id: 1,
        handle: "handle",
        timestamp: 1559122600,
        body: "Lorem ipsum dolor sit amet"
    }]
    return (
        <section>
            {tweets.map(function (tweet, index) {
                let date = new Date(tweet.timestamp);
                let formatted_timestamp = format(date, 'MM/DD/YYYY hh:mma');
                return (
                    <div key={tweet.id} className="card" style={{ width: "18rem" }}>
                        <div className="card-body">
                            <h5 className="card-title">{tweet.handle}</h5>
                            <h6 className="card-subtitle">{formatted_timestamp}</h6>
                            <p className="card-text">{tweet.body}</p>
                        </div>
                    </div>)
            })}
        </section >
    )
}

ReactDOM.render(
    <ApolloProvider client={client}>
        <Index />
    </ApolloProvider>,
    document.getElementById("tweets")
);
