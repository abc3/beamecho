import React from 'react';
import { useEffect, useState } from 'react';
import { PlusOutlined } from '@ant-design/icons';
import { useParams } from 'react-router-dom';
import { PageContainer, FooterToolbar } from '@ant-design/pro-layout';
import { Button, Checkbox, Form, message, Input, InputNumber, Select, Radio, Card, Table, Tag, Upload } from 'antd';
import { useRequest, history, useModel } from 'umi';
import { getApp, editApp, addApp } from './service';

const onFinish = async (values) => {
    if (values.key_file.file) {
        const reader = new FileReader();
        const file = values.key_file.file;
        reader.readAsDataURL(file);
        const result = await new Promise((resolve, reject) => {
            reader.onload = e => resolve(e.target.result);
            reader.onerror = error => reject(error);
        });
        values.key_file = result;
    }

    const { id, ...restValues } = values;
    let action;
    let actionMessage;
    let errorMessage;

    if (id) {
        action = () => editApp(id, restValues);
        actionMessage = 'App successfully updated';
        errorMessage = 'Failed to update App';
    } else {
        action = () => addApp(restValues);
        actionMessage = 'App successfully created';
        errorMessage = 'Failed to create App';
    }

    try {
        const response = await action();

        if (response && response.data) {
            message.success(actionMessage);
            if (!id)
                history.push(`/apps/${response.data.id}`);
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

const AppsItem = (props) => {
    const { id } = useParams();
    const [form] = Form.useForm();
    const { data, loading, run } = useRequest(() => {
        return getApp(id)
    }, { throwOnError: true });
    useEffect(() => {
        if (data) {
            form.setFieldsValue(data);
        }
    }, [data]);

    return (
        <PageContainer>
            <Button onClick={() => {
                history.push('/apps')
            }} style={{ marginBottom: '15px', marginRight: '15px' }}> ← Back to Apps</Button>
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
                        <Select defaultValue="auth_key" disabled options={[{ label: 'Auth Key', value: 'auth_key' }]} />
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
                        label="Team ID"
                        name="team_id"
                        rules={[
                            {
                                required: true,
                                message: 'Please input your Team ID!',
                            },
                        ]}
                    >
                        <Input />
                    </Form.Item>

                    <Form.Item
                        label="Key ID"
                        name="key_id"
                        rules={[
                            {
                                required: true,
                                message: 'Please input your Key ID!',
                            },
                        ]}
                    >
                        <Input />
                    </Form.Item>

                    <Form.Item
                        label="App Bundle ID"
                        name="app_bundle_id"
                        rules={[
                            {
                                required: true,
                                message: 'Please input your App Bundle ID!',
                            },
                        ]}
                    >
                        <Input />
                    </Form.Item>

                    <Form.Item
                        label="Key File"
                        name="key_file"
                        rules={[
                            {
                                required: true,
                                message: 'Please input your Key File!',
                            },
                        ]}
                    // getValueFromEvent={normFile}
                    >
                        {/* <Input.TextArea rows={9} /> */}
                        <Upload listType="picture-card" beforeUpload={() => false} >
                            <button
                                style={{
                                    border: 0,
                                    background: 'none',
                                }}
                                type="button"
                            >
                                <PlusOutlined />
                                <div style={{ marginTop: 8 }}>Upload</div>
                            </button>
                        </Upload>
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
export default AppsItem;