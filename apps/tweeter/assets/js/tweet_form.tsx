import React from "react";
import gql from 'graphql-tag';
import { Mutation } from "react-apollo";
import * as TweetsQL from './tweetsql';


export const TweetForm: React.FC<{}> = ({ }): JSX.Element => {
    let content: HTMLInputElement
    let handle: HTMLInputElement

    return (
        <section>
            <div className="col-4">
                <div className="row">
                    <Mutation mutation={TweetsQL.CREATE_TWEET}
                        refetchQueries={(data) => {
                            console.log("data => ", data);
                            return [{ query: TweetsQL.LIST_TWEETS, variables: {} }];
                        }}
                    >
                        {(createTweet, { data }) => (
                            <form acceptCharset="UTF-8" onSubmit={e => {
                                e.preventDefault();
                                console.log("createTweet()")
                                console.log("content:", content.value)
                                console.log("handle:", handle.value)
                                createTweet({ variables: { content: content.value, handle: handle.value } });
                            }}>
                                <div className="form-group">
                                    <label htmlFor="tweet_handle">Handle</label>
                                    <input className="form-control" id="tweet_handle" type="text" ref={node => {
                                        if (node) {
                                            handle = node;
                                        }
                                    }} />
                                </div>

                                <div className="form-group">
                                    <label htmlFor="tweet_content">Content</label>
                                    <input className="form-control" id="tweet_content" type="text" ref={node => {
                                        if (node) {
                                            content = node;
                                        }
                                    }} />
                                </div>

                                <div className="form-group">
                                    <button className="btn btn-primary" type="submit">Save</button>
                                </div>
                            </form>
                        )}
                    </Mutation>
                </div>
            </div>
        </section >)
}

export default TweetForm
