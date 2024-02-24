import React from 'react';
import { useEffect, useState } from 'react';
import { useParams } from 'react-router-dom';
import { PageContainer, FooterToolbar } from '@ant-design/pro-layout';
import { Button, Checkbox, Form, message, Input, InputNumber, Select, Radio, Card, Table, Tag, Badge } from 'antd';
import { useRequest, history, useModel } from 'umi';
import { addSource, editSource, getSource } from './service';

const onFinish = async (values) => {
    const { id, ...restValues } = values;
    let action;
    let actionMessage;
    let errorMessage;

    if (id) {
        action = () => editSource(id, restValues);
        actionMessage = 'Source successfully updated';
        errorMessage = 'Failed to update Source';
    } else {
        action = () => addSource(restValues);
        actionMessage = 'Source successfully created';
        errorMessage = 'Failed to create Source';
    }

    try {
        const response = await action();

        if (response && response.data) {
            message.success(actionMessage);
            if (!id)
                history.push(`/sources/${response.data.id}`);
        } else {
            message.error(errorMessage);
        }

        console.log('response', response);
    } catch (error) {
        console.error('Failed to perform action:', error);
        message.error(errorMessage);
    }
};

const onFinishFailed = (errorInfo) => {
    console.log('Failed:', errorInfo);
};

const SourcesItem = (props) => {
    const { id } = useParams();
    console.log("Props SourcesItem", props, id);

    const initialValues = {
        remember: true,
        dbport: 5432,
        use_ssl: false,
        ip_version: 'v4'
    }

    const [form] = Form.useForm();

    const { data, loading, run } = useRequest(() => {
        return getSource(id)
    }, { throwOnError: true });
    if (data) {
        form.setFieldsValue(data);
    }

    return (
        <PageContainer>
            <Button onClick={() => {
                history.push('/sources')
            }} style={{ marginBottom: '15px', marginRight: '15px' }}> ← Back to Sources</Button>
            <Card loading={loading}>
                <Form
                    form={form}
                    labelCol={{
                        span: 8,
                    }}
                    wrapperCol={{
                        span: 16,
                    }}
                    style={{
                        maxWidth: 600,
                    }}
                    initialValues={initialValues}
                    onFinish={onFinish}
                    onFinishFailed={onFinishFailed}
                    autoComplete="off"
                >
                    <Form.Item name="id" initialValue={id} hidden>
                        <Input />
                    </Form.Item>

                    <Form.Item
                        label="Type"
                        name="type"
                        rules={[
                            {
                                // required: true,
                                message: 'Please select a type!',
                            },
                        ]}
                    >
                        <Select defaultValue="PostgreSQL" disabled options={[{ label: 'Auth Key', value: 'auth_key' }]} />
                    </Form.Item>

                    <Form.Item
                        label="Name"
                        name="name"
                        rules={[
                            {
                                required: true,
                                message: 'Please input name!',
                            },
                        ]}
                    >
                        <Input />
                    </Form.Item>
                    <Form.Item
                        label="Host"
                        name="host"
                        rules={[
                            {
                                required: true,
                                message: 'Please input your host!',
                            },
                        ]}
                    >
                        <Input />
                    </Form.Item>

                    <Form.Item
                        label="Password"
                        name="dbpass"
                        rules={[
                            {
                                required: true,
                                message: 'Please input your password!',
                            },
                        ]}
                    >
                        <Input.Password />
                    </Form.Item>

                    <Form.Item
                        label="Database Name"
                        name="dbname"
                        rules={[
                            {
                                required: true,
                                message: 'Please input your name!',
                            },
                        ]}
                    >
                        <Input />
                    </Form.Item>

                    <Form.Item
                        label="Database User"
                        name="dbuser"
                        rules={[
                            {
                                required: true,
                                message: 'Please input your user!',
                            },
                        ]}
                    >
                        <Input />
                    </Form.Item>

                    <Form.Item
                        label="Port"
                        name="dbport"
                        rules={[
                            {
                                required: true,
                                message: 'Please input your port!',
                            },
                        ]}
                    >
                        <InputNumber min={1} max={65535} />
                    </Form.Item>

                    <Form.Item
                        label="Use SSL"
                        name="use_ssl"
                        valuePropName="checked"
                    >
                        <Checkbox />
                    </Form.Item>

                    <Form.Item
                        label="IP Version"
                        name="ip_version"
                    >
                        <Radio.Group>
                            <Radio value="v4">IPv4</Radio>
                            <Radio value="v6">IPv6</Radio>
                        </Radio.Group>
                    </Form.Item>

                    <Form.Item
                        wrapperCol={{
                            offset: 8,
                            span: 16,
                        }}
                    >
                        <Button type="primary" htmlType="submit">
                            {id ? 'Update' : 'Create'}
                        </Button>
                    </Form.Item>
                </Form>

            </Card>

            {/* <Button type="primary" onClick={onFill} style={{ marginTop: '15px' }}> Save</Button> */}
            {/* <Button onClick={() => {
                history.push('/sources/new')
            }} style={{ marginTop: '15px', marginLeft: '15px' }}> Cancel</Button> */}

        </PageContainer >
    );
}
export default SourcesItem;