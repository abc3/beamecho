export default [
  {
    path: '/user',
    layout: false,
    routes: [{ name: 'user', path: '/user/login', component: './User/Login' }],
  },

  {
    path: '/handlers',
    name: 'Handlers',
    icon: 'interaction',
    hideChildrenInMenu: true,
    routes: [
      {
        path: '/handlers/',
        component: './Handlers/HandlersList',
      },
      {
        path: '/handlers/new',
        name: 'New Handler',
        component: './Handlers/HandlersItem',
      },
      {
        path: '/handlers/:id',
        name: 'Handler',
        component: './Handlers/HandlersItem',
      },
    ]
  },
  {
    path: '/jobs',
    name: 'Jobs',
    icon: 'send',
    hideChildrenInMenu: true,
    routes: [
      {
        path: '/jobs/',
        component: './Jobs/JobsList',
      },
      // {
      //   path: '/handlers/new',
      //   name: 'New Handler',
      //   component: './Handlers/HandlersItem',
      // },
      // {
      //   path: '/handlers/:id',
      //   name: 'Handler',
      //   component: './Handlers/HandlersItem',
      // },
    ]
  },
  {
    path: '/apps',
    name: 'Apps',
    icon: 'shop',
    hideChildrenInMenu: true,
    routes: [
      {
        path: '/apps/',
        // name: 'Jobs Live',
        component: './Apps/AppsList',
      },
      {
        path: '/apps/new',
        name: 'New App',
        component: './Apps/AppsItem',
      },
      {
        path: '/apps/:id',
        name: 'App',
        component: './Apps/AppsItem',
      },
    ]
  },

  {
    path: '/sources',
    name: 'Sources',
    icon: 'database',
    hideChildrenInMenu: true,
    routes: [
      {
        path: '/sources/',
        // name: 'Jobs Live',
        component: './Sources/SourcesList',
      },
      {
        path: '/sources/new',
        name: 'New Source',
        component: './Sources/SourcesItem',
      },
      {
        path: '/sources/:id',
        name: 'Source',
        component: './Sources/SourcesItem',
      },
    ]
  },

  // { name: 'Settings', icon: 'setting', path: '/list1', component: './Sources/SourcesList' },

  { path: '/', redirect: '/handlers' },
  { path: '*', layout: false, component: './404' },

  // { path: '/welcome', name: 'welcome', icon: 'smile', component: './Welcome' },
  // {
  //   path: '/admin',
  //   name: 'Admin',
  //   icon: 'crown',
  //   access: 'canAdmin',
  //   routes: [
  //     { path: '/admin', redirect: '/admin/sub-page' },
  //     { path: '/admin/sub-page', name: 'Secondary management page', component: './Admin' },
  //   ],
  // },
  // { name: 'List', icon: 'table', path: '/list', component: './TableList' },  
];
