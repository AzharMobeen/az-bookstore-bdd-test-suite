function fn() {
    var env = karate.env; // get java system property 'karate.env'
    karate.log('karate.env system property was:', env);
    if (!env) {
        env = 'dev'; // a custom 'intelligent' default
        karate.log('karate.env set to "dev" as default.');
    }
    let config;
    if (env === 'prod') {
        config = {
            baseUrl: 'https://prod-url.com'
        }
    } else if (env === 'stag') {
        config = {
            baseUrl: 'https://stag-url.com'
        }
    } else if (env === 'dev') {
        let port = karate.properties['karate.port'] || '8080'
        config = {
            baseUrl: 'http://localhost:' + port
        }
    } else {
        throw 'Unknown environment [' + env + '].'
    }

    // don't waste time waiting for a connection or if servers don't respond within 0,3 seconds
    karate.configure('connectTimeout', 300);
    karate.configure('readTimeout', 300);
    return config;
}