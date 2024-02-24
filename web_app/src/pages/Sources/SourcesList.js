import { PageContainer, FooterToolbar } from '@ant-design/pro-layout';
import { Button, message, Input, Card, Table, Tag, Badge, Menu, Dropdown } from 'antd';
import { EditTwoTone, FileAddOutlined, PlayCircleTwoTone, SyncOutlined, CloseCircleTwoTone, DeleteTwoTone, DownOutlined } from '@ant-design/icons'
import { useRequest, history, useModel } from 'umi';
import { getSources, delSource } from './service';

const SourcesList = (props) => {
    const { data, loading, run } = useRequest((values) => {
        console.log('form data', values);
        return getSources();
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
                <a onClick={() => history.push('/sources/' + item.id)}> {name}</a >
            )
        },
        {
            title: 'Type',
            dataIndex: 'type',
            render: (status) => {
                return <Tag color="blue">PostgreSQL</Tag>
            }
        },
        {
            title: 'Host',
            dataIndex: 'host',
            key: 'name',
            render: (name, item) => (
                <a onClick={() => history.push('/sources/' + item.id)}> {name}</a >
            )
        },
        {
            title: 'Port',
            dataIndex: 'dbport',
            key: 'dbport'
        },
        {
            title: 'User',
            dataIndex: 'dbuser',
            key: 'dbuser'
        },
        {
            title: '',
            dataIndex: 'action',
            key: 'action',
            render: (action, item) => {
                const menu = (
                    <Menu>
                        <Menu.Item key="delete" disabled={false} onClick={() => {
                            delSource(item.id)
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
                history.push('/sources/new')
            }} style={{ marginBottom: '15px' }}> + Add new source</Button>
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