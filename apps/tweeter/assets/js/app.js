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

import React from "react";
import ReactDOM from "react-dom";

const Index = () => {
    return (
        <section>
            <div className="card" style={{ width: "18rem" }}>
                <div className="card-body">
                    <h5 className="card-title">tweet.handle</h5>
                    <h6 className="card-subtitle">tweet.timestamp</h6>
                    <p className="card-text">tweet.body</p>
                </div>
            </div>
        </section >
    )
}

ReactDOM.render(<Index />, document.getElementById("tweets"));
