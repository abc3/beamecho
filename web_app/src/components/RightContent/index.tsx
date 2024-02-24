import { QuestionCircleOutlined } from '@ant-design/icons';
import { SelectLang as UmiSelectLang, history } from '@umijs/max';
import { stringify } from 'querystring';
import React from 'react';

export type SiderTheme = 'light' | 'dark';

export const SelectLang = () => {
  return (
    <UmiSelectLang
      style={{
        padding: 4,
      }}
    />
  );
};

export const Question = () => {
  return (
    <div
      style={{
        display: 'flex',
        height: 26,
      }}
      onClick={() => {
        window.open('https://github.com/abc3/beamecho/issues');
      }}
    >
      <QuestionCircleOutlined />
    </div>
  );
};

export const Logout = () => {
  return (
    <div>
      <a onClick={() => {
        localStorage.removeItem("_bec_access_token");
        localStorage.removeItem("_bec_email");
        localStorage.removeItem("_bec_renewal_token");
        const { search, pathname } = window.location;
        const urlParams = new URL(window.location.href).searchParams;
        /** This method will navigate to the location specified by the redirect parameter */
        const redirect = urlParams.get('redirect');
        // Note: There may be security issues, please note
        if (window.location.pathname !== '/user/login' && !redirect) {
          history.replace({
            pathname: '/user/login',
            search: stringify({
              redirect: pathname + search,
            }),
          });
        }
      }}>logout</a>
    </div>
  );
};
