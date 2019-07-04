import React from "react";
import { format } from "date-fns";

export interface Tweet {
    id: number,
    timestamp: number,
    handle: string,
    content: string
}

export const TweetCard: React.FC<{
    tweet: Tweet
}> = ({
    tweet
}): JSX.Element => {
        let date = new Date(tweet.timestamp);
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

export default TweetCard
