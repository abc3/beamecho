import { request, useRequest, history } from 'umi';

function access_token() {
    return localStorage.getItem("_bec_access_token")
}

export async function get(url, params, options) {
    console.log('call get()', url, params, options)
    return request(url, {
        method: 'GET',
        headers: {
            'Authorization': access_token(),
        },
        params: {
            ...params,
        },
        ...(options || {}),
    });
}

export async function post(url, name, data, options) {
    console.log('post', url, name, data, options)
    return request(url, {
        method: 'POST',
        headers: {
            'Authorization': access_token(),
        },
        data: {
            [name]: data
        },
        ...(options || {}),
    });
}

export async function put(url, name, data, options) {
    console.log('put', url, data, options)
    return request(url, {
        method: 'PUT',
        headers: {
            'Authorization': access_token(),
        },
        data: {
            [name]: data
        },
        ...(options || {}),
    });
}

export async function del(url, data, options) {
    console.log('del', url, data, options)
    return request(url, {
        method: 'DELETE',
        headers: {
            'Authorization': access_token(),
        },
        data: {
            app: {
                ...data,
            }
        },
        ...(options || {}),
    });
}