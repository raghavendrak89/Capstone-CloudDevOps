"""imports"""
import json
from flask import Flask, request, abort, jsonify

APP = Flask(__name__)

@APP.route('/health')
def test_webhook():
    """Demonstrate docstrings and does nothing really."""
    return 'Hello World from Python Flask webhook!'

@APP.route('/argocd', methods=['POST'])
def webhook():
    """Demonstrate docstrings and does nothing really."""
    p_json = json.loads(request.get_data())
    if p_json:
        slack_alert(p_json)
        return {'state', 'success'}
    else:
        abort(400)
    return {'state', 'failed'}

def slack_alert(alerts):
    """Demonstrate docstrings and does nothing really."""
    attachments = []

    for alert in alerts:
        labels = alert['labels']
        if labels['application_operation_status'].lower() == 'succeeded':
            attachments.append({
                "title": "argocd alerts testing",
                "title_link": "https://dev-argocd.horizon.vmware.com/applications/testing",
                "color": "18be52",
                "text": ":white_check_mark: Application",
                "fields": [
                    {
                        "title": "Application Health Status",
                        "value": "`{}`".format(labels['application_health_status']),
                        "short": "true"
                    },
                    {
                        "title": "Repo Sync Status",
                        "value": "`{}`".format(labels['application_reposync_status']),
                        "short": "true"
                    },
                    {
                        "title": "RepoSync Operation State",
                        "value": "`{}`".format(labels['application_operation_status']),
                        "short": "true"
                    },
                    {
                        "title": "Repository",
                        "value": "`{}`".format(labels['source_repo_url']),
                        "short": "true"
                    }
                ],
                "footer": "",
                "mrkdwn_in": [
                    "fallback",
                    "pretext",
                    "text"
                ]
            })
        else:
            attachments.append({
                "title": "argocd alerts testing",
                "title_link": "https://dev-argocd.horizon.vmware.com/applications/testing",
                "color": "be1818",
                "text": ":white_check_mark: Application",
                "fields": [
                    {
                        "title": "Application Health Status",
                        "value": "`{}`".format(labels['application_health_status']),
                        "short": "true"
                    },
                    {
                        "title": "Repo Sync Status",
                        "value": "`{}`".format(labels['application_reposync_status']),
                        "short": "true"
                    },
                    {
                        "title": "RepoSync Operation State",
                        "value": "`{}`".format(labels['application_operation_status']),
                        "short": "true"
                    },
                    {
                        "title": "Repository",
                        "value": "`{}`".format(labels['source_repo_url']),
                        "short": "true"
                    }
                ],
                "footer": "",
                "mrkdwn_in": [
                    "fallback",
                    "pretext",
                    "text"
                ]
            })
        return {'State': 'Success'}


if __name__ == '__main__':
    # load pretrained model as CLF
    APP.run(host='0.0.0.0', port=8885, debug=True)
