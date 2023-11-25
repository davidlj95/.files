// Generated by Finicky Kickstart (not anymore :P)
// https://finicky-kickstart.vercel.app/
// Save as ~/.finicky.js

const personalBrowser = {
    name: "Google Chrome",
    profile: "Default"
};

module.exports = {
    defaultBrowser: "Google Chrome",
    handlers: [
        {
            match: ({url}) => url.host.endsWith("notion.so"),
            browser: {
                name: "Notion",
            },
        },
        {
            match: ({url}) => url.host.endsWith("linkedin.com"),
            browser: personalBrowser,
        }
    ]
}
