/**
 * @name proxy configuration
 * @see In the production environment, the proxy cannot take effect, so there is no configuration for the production environment
 * -------------------------------
 * The agent cannot take effect in the production environment
 * so there is no configuration of the production environment
 * For details, please see
 * https://pro.ant.design/docs/deploy
 *
 * @doc https://umijs.org/docs/guides/proxy
 */
export default {
  // If you need to customize the local development server, please uncomment and adjust as needed
  dev: {
    // localhost:8000/api/** -> https://preview.pro.ant.design/api/**
    '/api/sources': {
      // Address to be proxied
      target: 'http://127.0.0.1:4000',
      // If this is configured, you can proxy from http to https
      // Functions that depend on origin may need this, such as cookies
      changeOrigin: true,
    },
    '/api/apps': {
      target: 'http://127.0.0.1:4000',
      changeOrigin: true,
    },
    '/api/handlers': {
      target: 'http://127.0.0.1:4000',
      changeOrigin: true,
    },
    '/api/jobs': {
      target: 'http://127.0.0.1:4000',
      changeOrigin: true,
    },
    '/api/session': {
      target: 'http://127.0.0.1:4000',
      changeOrigin: true,
    },
    '/api/currentUser': {
      target: 'http://127.0.0.1:4000',
      changeOrigin: true,
    },
  },

  /**
   * @name Detailed proxy configuration
   * @doc https://github.com/chimurai/http-proxy-middleware
   */
  test: {
    // localhost:8000/api/** -> https://preview.pro.ant.design/api/**
    '/api/': {
      target: 'https://proapi.azurewebsites.net',
      changeOrigin: true,
      pathRewrite: { '^': '' },
    },
  },
  pre: {
    '/api/': {
      target: 'your pre url',
      changeOrigin: true,
      pathRewrite: { '^': '' },
    },
  },
};
