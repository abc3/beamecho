import { PageContainer, FooterToolbar } from '@ant-design/pro-layout';
import { Button, message, Input, Card, Table, Tag, Badge, Menu, Dropdown } from 'antd';
import { EditTwoTone, FileAddOutlined, PlayCircleTwoTone, SyncOutlined, CloseCircleTwoTone, DeleteTwoTone, DownOutlined } from '@ant-design/icons'
import { useRequest, history, useModel } from 'umi';
import { getHandlers, delHandler } from './service';
import { addJob } from '../Jobs/service';
import moment from 'moment';

const HandlersList = (props) => {
    const { data, loading, run } = useRequest((values) => {
        console.log('form data', values);
        return getHandlers();
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
            title: 'Name',
            dataIndex: 'name',
            key: 'name',
            render: (name, item) => (
                <a onClick={() => history.push('/handlers/' + item.id)}> {name}</a >
            )
        },
        // {
        //     title: 'Active',
        //     dataIndex: 'active',
        //     key: 'active',
        //     render: (active) => (
        //         <Badge status={active ? 'success' : 'error'} text={active ? 'Active' : 'Inactive'} />
        //     ),
        // },
        // {
        //     title: 'Check Type',
        //     dataIndex: 'check_type',
        //     key: 'check_type',
        // },
        // {
        //     title: 'Check Interval',
        //     dataIndex: 'check_interval',
        //     key: 'check_interval',
        // },
        {
            title: 'App',
            dataIndex: 'app',
            key: 'app',
            render: (name, item) => {
                return <a onClick={() => history.push('/apps/' + item.app.id)}> {item.app.name}</a >
            }
        },
        {
            title: 'Source',
            dataIndex: 'source',
            key: 'source',
            render: (name, item) => {
                return <a onClick={() => history.push('/sources/' + item.source.id)}> {item.source.name}</a >
            }
        },
        {
            title: 'Created',
            dataIndex: 'inserted_at',
            key: 'inserted_at',
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
                        <Menu.Item key="add_job" disabled={false} onClick={() => {
                            addJob(item.id)
                                .then((resp) => {
                                    message.success(`Job added successfully ${resp}`);
                                    run();
                                })
                                .catch((error) => {
                                    message.error(`Failed to add job ${error}`);
                                });
                        }}>
                            <FileAddOutlined style={{ fontSize: 18 }} /> Push
                        </Menu.Item>
                        <Menu.Item key="delete" disabled={false} onClick={() => {
                            delHandler(item.id)
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
            <Button type="primary" onClick={() => {
                history.push('/handlers/new')
            }} style={{ marginBottom: '15px' }}> + Add new Handler</Button>
            <Card>

                <Table
                    loading={loading}
                    dataSource={list}
                    columns={columns} />
            </Card>
        </PageContainer>
    );
}
export default HandlersList;