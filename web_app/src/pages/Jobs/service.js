import { get, del } from '../../services/api';

export async function getJobs() {
    return get('/api/jobs');
}

export async function delJob(id) {
    return del(`/api/jobs/${id}`);
}

export async function addJob(handler_id) {
    return get(`/api/jobs/${handler_id}/add`);
}

export async function restartJob(id) {
    return get(`/api/jobs/${id}/restart`);
}

export async function cancelJob(id) {
    return get(`/api/jobs/${id}/cancel`);
}