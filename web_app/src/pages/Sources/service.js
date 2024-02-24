import { request } from 'umi';
import { get, del, put, post } from '../../services/api';

export async function getSources() {
    return get('/api/sources');
}

export async function getSource(id, options) {
    if (!id) return Promise.resolve({})
    return get(`/api/sources/${id}`);
}

export async function delSource(id) {
    return del(`/api/sources/${id}`);
}

export async function editSource(id, data) {
    return put(`/api/sources/${id}`, "source", data);
}

export async function addSource(data, options) {
    return post('/api/sources', "source", data, options);
}


// export async function addSources(data, options) {
//     return post('/api/sources', "app", data, options);
// }
