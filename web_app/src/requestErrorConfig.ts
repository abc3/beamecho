import type { RequestOptions } from '@@/plugin-request/request';
import type { RequestConfig } from '@umijs/max';
import { message, notification } from 'antd';
import { history } from 'umi';

// Error handling scheme: Error type
enum ErrorShowType {
  SILENT = 0,
  WARN_MESSAGE = 1,
  ERROR_MESSAGE = 2,
  NOTIFICATION = 3,
  REDIRECT = 9,
}
// Response data format agreed with the backend
interface ResponseStructure {
  success: boolean;
  data: any;
  errorCode?: number;
  errorMessage?: string;
  showType?: ErrorShowType;
}

/**
 * @name Error handling
 * pro Comes with error handling, you can make your own changes here
 * @doc https://umijs.org/docs/max/request#配置
 */
export const errorConfig: RequestConfig = {
  // Error handling: umi@3’s error handling solution.
  errorConfig: {
    // error thrown
    errorThrower: (res) => {
      const { success, data, errorCode, errorMessage, showType } =
        res as unknown as ResponseStructure;
      if (!success) {
        const error: any = new Error(errorMessage);
        error.name = 'BizError';
        error.info = { errorCode, errorMessage, showType, data };
        throw error; // Throw a homemade error
      }
    },
    // Error receiving and handling
    errorHandler: (error: any, opts: any) => {
      if (opts?.skipErrorHandler) throw error;
      // The error thrown by our errorThrower.
      if (error.name === 'BizError') {
        const errorInfo: ResponseStructure | undefined = error.info;
        if (errorInfo) {
          const { errorMessage, errorCode } = errorInfo;
          switch (errorInfo.showType) {
            case ErrorShowType.SILENT:
              // do nothing
              break;
            case ErrorShowType.WARN_MESSAGE:
              message.warning(errorMessage);
              break;
            case ErrorShowType.ERROR_MESSAGE:
              message.error(errorMessage);
              break;
            case ErrorShowType.NOTIFICATION:
              notification.open({
                description: errorMessage,
                message: errorCode,
              });
              break;
            case ErrorShowType.REDIRECT:
              // TODO: redirect
              break;
            default:
              message.error(errorMessage);
          }
        }
      } else if (error.response) {
        // Axios mistake
        // The request was made successfully and the server responded with a status code, but the status code was outside the range of 2xx
        message.error(`Response status:${error.response.status}`);
        history.push('/user/login');
      } else if (error.request) {
        // The request was initiated successfully, but no response was received
        // \`error.request\` In the browser is an instance of XMLHttpRequest,
        // And in node.js it is an instance of http.ClientRequest
        message.error('None response! Please retry.');
      } else {
        // Something went wrong while sending the request
        message.error('Request error, please retry.');
      }
    },
  },

  // request interceptor
  requestInterceptors: [
    (config: RequestOptions) => {
      // Intercept request configuration for personalized processing.
      const url = config?.url?.concat('?token=xxx');
      return { ...config, url };
    },
  ],

  // response interceptor
  responseInterceptors: [
    (response) => {
      // Intercept response data for personalized processing
      const { data } = response as unknown as ResponseStructure;

      if (data?.success === false) {
        message.error('Request failed!');
      }
      return response;
    },
  ],
};
