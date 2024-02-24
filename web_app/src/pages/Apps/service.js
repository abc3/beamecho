import { request } from 'umi';
import { get, del, put, post } from '../../services/api';

export async function getApps() {
    return get('/api/apps');
}

export async function delApp(id) {
    return del(`/api/apps/${id}`);
}

export async function editApp(id, data) {
    return put(`/api/apps/${id}`, "app", data);
}

export async function addApp(data, options) {
    return post('/api/apps', "app", data, options);
}

export async function addApps(data, options) {
    return request('/api/apps', {
        method: 'POST',
        data: {
            app: {
                ...data,
            }
        },
        ...(options || {}),
    });
}

export async function getApp(id, options) {
    if (!id) return Promise.resolve({})
    return get(`/api/apps/${id}`);
}