import gql from 'graphql-tag';

export const LIST_TWEETS = gql`
{
    tweets {
        id
        handle
        content
        timestamp
    }
}
`

export const CREATE_TWEET = gql`
    mutation CreateTweet($handle: String!, $content: String!) {
        createTweet(handle: $handle, content: $content) {
            uuid
        }
    }
`
