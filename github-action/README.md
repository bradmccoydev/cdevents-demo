# GitHub Action for sending a CDEvent

Runs CLI commands for sending a CDEvent.

## Usage

### Inputs

- `source`- *Required* Source
- `subject_id` - *Required* Subject ID
- `subject_pipeline_name`- *Required* Subject Pipeline Name
- `subject_url`- *Required* Subject URL

### Example

```yaml
on: push
name: Main Workflow
jobs:
  sendCDEvent:
    name: Send CDEvent
    runs-on: ubuntu-latest
    steps:
    - name: send CDEvent
      uses: bradmccoydev/cdevents-demo/github-action@main
      with:
        source: 'my/first/cdevent/program'
        subject_id: 'myPipelineRun1'
        subject_pipeline_name: 'myPipeline'
        subject_url: 'https://example.com/myPipeline'
        version: 0.0.1
```
