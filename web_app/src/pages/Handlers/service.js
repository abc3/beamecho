import { request } from 'umi';
import { get, put, post, del } from '../../services/api';

export async function getHandlers() {
    return get('/api/handlers');
}

export async function getHandler(id) {
    if (!id) return Promise.resolve({})
    return get(`/api/handlers/${id}`);
}

export async function editHandler(id, data) {
    return put(`/api/handlers/${id}`, "handler", data);
}

export async function addHandler(data, options) {
    return post('/api/handlers', "handler", data, options);
}

export async function sourceQuery(sourceId, query) {
    const data = {
        source_id: sourceId,
        query: query
    }
    return post('/api/handlers/source_query', "source_query", data);
}

// export async function getHandler(id, options) {
//     if (!id) return Promise.resolve({})
//     return request(`/api/handlers/${id}`, {
//         method: 'GET',
//         ...(options || {}),
//     });
// }

export async function delHandler(id) {
    return del(`/api/handlers/${id}`);
}

export async function sendHandler(id, options) {
    if (!id) return Promise.resolve({})
    return request(`/api/handlers/${id}/send`, {
        method: 'GET',
        ...(options || {}),
    });
}