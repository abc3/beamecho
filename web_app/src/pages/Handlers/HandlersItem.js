import React from 'react';
import { useEffect, useState } from 'react';
import { useParams } from 'react-router-dom';
import { PageContainer, FooterToolbar } from '@ant-design/pro-layout';
import { Button, Checkbox, Form, message, Input, InputNumber, Select, Radio, Card, Table, Tag, Badge, Row, Col } from 'antd';
import { useRequest, history } from 'umi';
import { addHandler, getHandler, sendHandler, editHandler, sourceQuery } from './service';
import { getSources } from '../Sources/service';
import { getApps } from '../Apps/service';
import { addJob } from '../Jobs/service';

const onFinish = async (values) => {
  const { id, ...restValues } = values;
  let action;
  let actionMessage;
  let errorMessage;

  if (id) {
    action = () => editHandler(id, restValues);
    actionMessage = 'Handler successfully updated';
    errorMessage = 'Failed to update handler';
  } else {
    action = () => addHandler(restValues);
    actionMessage = 'Handler successfully created';
    errorMessage = 'Failed to create handler';
  }

  try {
    const response = await action();

    if (response && response.data) {
      message.success(actionMessage);
      if (!id)
        history.push(`/handlers/${response.data.id}`);
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

const HandlersItem = (props) => {
  let { id } = useParams();
  const [form] = Form.useForm();

  const onPush = async () => {
    const response = await addJob(id);
    console.log('response', response);
    if (response.data) {
      message.success('Handler successfully added to the queue');
    } else {
      message.error('Failed to send data to the server.');
    }
  };

  const { data, loading, run } = useRequest(() => {
    return getHandler(id)
  }, { throwOnError: true });

  useEffect(() => {
    if (data) {
      form.setFieldsValue(data);
    }
  }, [data]);

  const apps = useRequest((values) => {
    console.log('form data', values);
    console.log('appsData', values);
    return getApps();
  }, { throwOnError: true });
  let appsData = []
  if (apps.data) {
    appsData = apps.data.map((item) => ({
      value: item.id,
      label: item.name
    }));
  }

  const [query_columns, setQueryColumns] = useState([]);

  const handleSourceChange = async () => {
    const value = form.getFieldValue('source_id');
    const query = form.getFieldValue('query');
    const result = await sourceQuery(value, query);
    if (result.data) {
      setQueryColumns(result.data);
      // form.setFieldsValue({ ...form.getFieldsValue(), query: query });
    }
    if (result.error) {
      message.error(result.error);
    }
  };

  const sources = useRequest(() => {
    return getSources();
  }, { throwOnError: true });
  let sourcesData = []
  if (sources.data) {
    sourcesData = sources.data.map((item) => ({
      value: item.id,
      label: item.name
    }));
  }

  return (
    <PageContainer>
      <Button onClick={() => {
        history.push('/handlers')
      }} style={{ marginBottom: '15px', marginRight: '15px' }}> ← Back to Handlers</Button>
      <Button onClick={onPush} style={{ marginTop: '15px' }} disabled={!id}>Push</Button>
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
            label="Name"
            name="name"
            rules={[
              {
                required: true,
                message: 'Please input the name!',
              },
            ]}
          >
            <Input />
          </Form.Item>

          <Form.Item
            label="Source"
            name="source_id"
            rules={[
              {
                required: true,
                message: 'Please input the Source!',
              },
            ]}
          >
            <Select
              loading={sources.loading}
              options={sourcesData}
            />
          </Form.Item>

          <Form.Item
            label="Query"
            name="query"
            rules={[
              {
                required: true,
                message: 'Please input the query!',
              },
            ]}
          >
            <Input.TextArea rows={9} placeholder="SELECT * FROM some_table" />
          </Form.Item>

          <Row gutter={16}>
            <Col span={8}></Col>
            <Col span={8}>
              <Button style={{ marginBottom: 9 }} onClick={() => handleSourceChange()}>Fetch Columns from Source for Query</Button>
            </Col>
          </Row>

          <Form.Item
            label="Columns"
          >
            {query_columns && query_columns.map((column) => (
              <Tag key={column}>{column}</Tag>
            ))}
          </Form.Item>

          <Form.Item
            label="Device Token Column"
            name="device_token"
            rules={[
              {
                required: true,
                message: 'Please select a device token!',
              },
            ]}
          >
            <Select>
              {query_columns && query_columns.map((column) => (
                <Select.Option key={column} value={column}>
                  {column}
                </Select.Option>
              ))}
            </Select>
          </Form.Item>

          <Form.Item
            label="Template"
            name="template"
            initialValue={JSON.stringify({
              "aps": {
                "alert": "Your message {{ column_from_query }}"
              }
            }, null, 2)}
            rules={[
              {
                required: true,
                message: 'Please input the template!',
              },
            ]}
          >
            <Input.TextArea rows={9} />
          </Form.Item>

          {/* <Form.Item
            label="Active"
            name="active"
            valuePropName="checked"
          >
            <Checkbox />
          </Form.Item> */}

          {/* <Form.Item
            label="Check Type"
            name="check_type"
          // rules={[
          //     {
          //         required: true,
          //         message: 'Please input the check type!',
          //     },
          // ]}
          >
            <Select
              defaultValue="interval"
              disabled
              options={[{
                value: 'interval', label: 'Interval'
              }]}
            />

          </Form.Item> */}

          {/* <Form.Item
            label="Check Interval, mins"
            name="check_interval"
            rules={[
              {
                required: true,
                message: 'Please input the check interval!',
              },
            ]}
          >
            <InputNumber />
          </Form.Item> */}

          <Form.Item
            label="App ID"
            name="app_id"
            rules={[
              {
                required: true,
                message: 'Please input the App ID!',
              },
            ]}
          >
            <Select
              loading={apps.loading}
              options={appsData}
            />
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

      {/* <Button onClick={() => {
                history.push('/sources/new')
            }} style={{ marginTop: '15px', marginLeft: '15px' }}> Cancel</Button> */}

    </PageContainer >
  );
}
export default HandlersItem;
