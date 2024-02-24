import { PageContainer, FooterToolbar } from '@ant-design/pro-layout';
import { Button, message, Input, Card, Table, Tag, Badge, Menu, Dropdown } from 'antd';
import { EditTwoTone, FileAddOutlined, PlayCircleTwoTone, SyncOutlined, CloseCircleTwoTone, DeleteTwoTone, DownOutlined } from '@ant-design/icons'
import { useRequest, history, useModel } from 'umi';
import { getApps, delApp } from './service';

const SourcesList = (props) => {
    const { data, loading, run } = useRequest((values) => {
        return getApps();
    }, { throwOnError: true });

    let list = [];
    if (data && data.length > 0) {
        list = data.map((item, index) => ({ ...item, key: index }));
    }

    const columns = [
        {
            title: '#',
            dataIndex: 'key',
            key: 'key'
        },
        {
            title: 'Name',
            dataIndex: 'name',
            key: 'name',
            render: (name, item) => (
                <a onClick={() => history.push('/apps/' + item.id)}> {name}</a >
            )
        },
        {
            title: 'App Bundle ID',
            dataIndex: 'app_bundle_id',
            key: 'app_bundle_id',
            render: (name, item) => (
                <a onClick={() => history.push('/apps/' + item.id)}> {name}</a >
            )
        },
        {
            title: 'team_id',
            dataIndex: 'team_id',
            key: 'team_id'
        },
        {
            title: 'key_id',
            dataIndex: 'key_id',
            key: 'key_id'
        },
        {
            title: '',
            dataIndex: 'action',
            key: 'action',
            render: (action, item) => {
                const menu = (
                    <Menu>
                        <Menu.Item key="delete" disabled={false} onClick={() => {
                            delApp(item.id)
                                .then((resp) => {
                                    message.success('App deleted successfully');
                                    run();
                                })
                                .catch((error) => {
                                    message.error('Failed to delete app');
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
                history.push('/apps/new')
            }} style={{ marginBottom: '15px' }}> + Add new App</Button>
            <Card>

                <Table
                    loading={loading}
                    dataSource={list.map((item, index) => ({ ...item, key: index }))}
                    columns={columns} />
            </Card>
        </PageContainer>
    );
}
export default SourcesList;