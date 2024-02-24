import { PageContainer, FooterToolbar } from '@ant-design/pro-layout';
import { Button, message, Input, Card, Table, Tag, Badge, Dropdown, Menu } from 'antd';
import { EditTwoTone, PlayCircleTwoTone, SyncOutlined, CloseCircleTwoTone, DeleteTwoTone, DownOutlined } from '@ant-design/icons'
import { useRequest, history, useModel } from 'umi';
import { getJobs, delJob, restartJob, cancelJob } from './service';
import moment from 'moment';

const JobsList = (props) => {
    const { data, loading, run } = useRequest((values) => {
        console.log('form data', values);
        return getJobs();
    }, { throwOnError: true });
    let list = [];
    if (data && data.length > 0) {
        list = data.map((item, index) => ({ ...item, key: index }));
    }

    const columns = [
        {
            title: '#',
            dataIndex: 'key',
            key: 'key',
            // render: (name, item) => (
            //     <a onClick={() => history.push('/handlers/' + item.id)}> {name}</a >
            // )
        },
        {
            title: 'Status',
            dataIndex: 'status',
            key: 'status',
            render: (status) => {
                let color = 'red'
                switch (status) {
                    case 'scheduled':
                        color = 'blue'
                        break
                    case 'running':
                        color = 'blue'
                        break
                    case 'completed':
                        color = 'green'
                        break
                    case 'failed':
                        color = 'red'
                        break
                    case 'cancelled':
                        color = 'gray'
                        break
                }

                return <Tag color={color}>{status}</Tag>
            },
        },
        {
            title: 'Handler',
            dataIndex: 'name',
            key: 'name',
            render: (name, item) => {
                console.log(name, item)
                return <a onClick={() => history.push('/handlers/' + item.handler.id)}> {item.handler.name}</a >
            }
        },

        {
            title: 'Sent',
            dataIndex: 'sent_success',
            key: 'sent_success',
        },
        {
            title: 'Failed',
            dataIndex: 'sent_failed',
            key: 'sent_failed',
        },
        {
            title: 'Started',
            dataIndex: 'started_at',
            key: 'started_at',
            render: (date) => {
                return moment(date).format('HH:mm:ss DD/MM/YY')
            }
        },
        {
            title: 'Finished',
            dataIndex: 'finished_at',
            key: 'finished_at',
            render: (date) => {
                return moment(date).format('HH:mm:ss DD/MM/YY')
            }
        },
        {
            title: '',
            dataIndex: 'action',
            key: 'action',
            render: (action, item) => {
                const menu = (
                    <Menu>
                        <Menu.Item key="restart" disabled={false} onClick={() => {
                            restartJob(item.id)
                                .then((resp) => {
                                    message.success(`Job restarted successfully ${JSON.stringify(resp)}`);
                                    run();
                                })
                                .catch((error) => {
                                    message.error('Failed to restart job');
                                });
                        }}>
                            <SyncOutlined style={{ fontSize: 18, color: '#1890ff' }} /> Restart
                        </Menu.Item>
                        <Menu.Item key="stop" disabled={false} onClick={() => {
                            cancelJob(item.id)
                                .then((resp) => {
                                    message.success(`Response ${JSON.stringify(resp)}`);
                                    run();
                                })
                                .catch((error) => {
                                    message.error(`Failed to cancel job ${JSON.stringify(error)}`);
                                });
                        }}>
                            <CloseCircleTwoTone style={{ fontSize: 21 }} /> Cancel
                        </Menu.Item>
                        <Menu.Item key="delete" disabled={false} onClick={() => {
                            delJob(item.id)
                                .then((resp) => {
                                    message.success('Job deleted successfully');
                                    run();
                                })
                                .catch((error) => {
                                    message.error('Failed to delete job');
                                });
                        }}>
                            <DeleteTwoTone style={{ fontSize: 18 }} /> Delete
                        </Menu.Item>
                    </Menu>
                );
                return (
                    <Dropdown overlay={menu} trigger={['click']}>
                        <a className="ant-dropdown-link" onClick={e => e.preventDefault()}>
                            Action <DownOutlined />
                        </a>
                    </Dropdown>
                )
            }
        }

    ]

    return (
        <PageContainer>

            <Button type="primary" onClick={run} style={{ marginBottom: '15px' }}> Refresh</Button>
            <Card>

                <Table
                    loading={loading}
                    dataSource={list}
                    columns={columns} />
            </Card>
        </PageContainer>
    );
}
export default JobsList;