// https://umijs.org/config/
import { defineConfig } from '@umijs/max';
import { join } from 'path';
import defaultSettings from './defaultSettings';
import proxy from './proxy';
import routes from './routes';
const { REACT_APP_ENV = 'dev' } = process.env;
export default defineConfig({
  /**
   * @name Enable hash mode
   * @description Make the build output include a hash suffix. Usually used for incremental releases and to avoid browser cache loading.
   * @doc https://umijs.org/docs/api/config#hash
   */
  hash: true,
  history: {
    type: 'hash',
  },
  /**
   * @name Compatibility settings
   * @description Setting up ie11 may not be perfectly compatible, need to check all the dependencies used.
   * @doc https://umijs.org/docs/api/config#targets
   */
  // targets: {
  //   ie: 11,
  // },
  /**
   * @name Configuration of the routing, files not included in the routing will not be compiled
   * @description Only supports configuration of path, component, routes, redirect, wrappers, title
   * @doc https://umijs.org/docs/guides/routes
   */
  // umi routes: https://umijs.org/docs/routing
  routes,
  /**
   * @name Theme configuration
   * @description Although it's called theme, it's actually just setting less variables
   * @doc Theme setting of antd https://ant.design/docs/react/customize-theme-cn
   * @doc Theme configuration of umi https://umijs.org/docs/api/config#theme
   */
  theme: {
    // If you don't want to dynamically set the theme using configProvide, set this to default
    // Only when set to variable, can use configProvide to dynamically set primary colors
    'root-entry-name': 'variable',
  },
  /**
   * @name Internationalization configuration of moment
   * @description If you have no requirement for internationalization, enabling it can reduce the js bundle size
   * @doc https://umijs.org/docs/api/config#ignoremomentlocale
   */
  ignoreMomentLocale: true,
  /**
   * @name Proxy configuration
   * @description Can let your local server proxy to your server, so you can access server data
   * @see Note that proxy can only be used during local development, cannot be used after build.
   * @doc Introduction to proxy https://umijs.org/docs/guides/proxy
   * @doc Proxy configuration https://umijs.org/docs/api/config#proxy
   */
  proxy: proxy[REACT_APP_ENV as keyof typeof proxy],
  /**
   * @name Fast refresh configuration
   * @description A nice hot update component, can retain state during updates
   */
  fastRefresh: true,
  //============== Below are all the max plugin configurations ===============
  /**
   * @name Data flow plugin
   * @doc https://umijs.org/docs/max/data-flow
   */
  model: {},
  /**
   * A global initial data flow, can be used to share data between plugins
   * @description Can be used to store some global data, like user information, or some global state, global initial state is created at the very start of the Umi project.
   * @doc https://umijs.org/docs/max/data-flow#Global-initial-state
   */
  initialState: {},
  /**
   * @name Layout plugin
   * @doc https://umijs.org/docs/max/layout-menu
   */
  title: 'BeamEcho',
  layout: {
    locale: true,
    ...defaultSettings,
  },
  /**
   * @name moment2dayjs plugin
   * @description Replace moment in the project with dayjs
   * @doc https://umijs.org/docs/max/moment2dayjs
   */
  moment2dayjs: {
    preset: 'antd',
    plugins: ['duration'],
  },
  /**
   * @name Internationalization plugin
   * @doc https://umijs.org/docs/max/i18n
   */
  locale: {
    default: 'en-US',
    antd: true,
    // default true, when it is true, will use `navigator.language` overwrite default
    // baseNavigator: true,
  },
  /**
   * @name antd plugin
   * @description Built-in babel import plugin
   * @doc https://umijs.org/docs/max/antd#antd
   */
  antd: {},
  /**
   * @name Network request configuration
   * @description Based on axios and ahooks's useRequest, it provides a set of unified network request and error handling scheme.
   * @doc https://umijs.org/docs/max/request
   */
  request: {},
  /**
   * @name Access control plugin
   * @description Based on the initialState, must enable initialState first
   * @doc https://umijs.org/docs/max/access
   */
  access: {},
  /**
   * @name Additional scripts in <head>
   * @description Configure additional scripts in <head>
   */
  headScripts: [
    // Solve the problem of white screen on initial load
    {
      src: '/scripts/loading.js',
      async: true,
    },
  ],
  //================ pro plugin configurations =================
  presets: ['umi-presets-pro'],
  /**
   * @name Configuration for the openAPI plugin
   * @description Generate server and mock based on openapi specification, can reduce a lot of boilerplate code
   * @doc https://pro.ant.design/zh-cn/docs/openapi/
   */
  // openAPI: [
  //   {
  //     requestLibPath: "import { request } from '@umijs/max'",
  //     // Or use the online version
  //     // schemaPath: "https://gw.alipayobjects.com/os/antfincdn/M%24jrzTTYJN/oneapi.json"
  //     schemaPath: join(__dirname, 'oneapi.json'),
  //     mock: false,
  //   },
  //   {
  //     requestLibPath: "import { request } from '@umijs/max'",
  //     schemaPath: 'https://gw.alipayobjects.com/os/antfincdn/CA1dOm%2631B/openapi.json',
  //     projectName: 'swagger',
  //   },
  // ],
  mfsu: {
    strategy: 'normal',
  },
  esbuildMinifyIIFE: true,
  requestRecord: {},
});
