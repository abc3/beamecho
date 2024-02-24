import { GithubOutlined } from '@ant-design/icons';
import { DefaultFooter } from '@ant-design/pro-components';
import React from 'react';

const Footer: React.FC = () => {
  return (
    // <div></div>
    <DefaultFooter
      copyright={false}
      style={{
        background: 'none',
      }}
      links={[
        // {
        //   key: 'Ant Design Pro',
        //   title: 'Ant Design Pro',
        //   href: 'https://pro.ant.design',
        //   blankTarget: true,
        // },
        {
          key: 'github',
          title: <GithubOutlined title='Github' />,
          href: 'https://github.com/abc3/beamecho',
          blankTarget: true,
        },
        //   {
        //     key: 'Ant Design',
        //     title: 'Ant Design',
        //     href: 'https://ant.design',
        //     blankTarget: true,
        //   },
      ]}
    />
  );
};

export default Footer;
