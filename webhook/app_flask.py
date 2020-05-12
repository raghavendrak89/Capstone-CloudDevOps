import sys
from flask import Flask, request, abort
import json
import requests

app = Flask(__name__)

@app.route('/argocd', methods=['POST'])
def webhook():
    p_json = json.loads(request.get_data())
    if p_json:
        print(p_json)
        slack_alert(p_json)
        return '', 20
    else:
        abort(400)

def slack_alert(alerts):
    attachments = []

    for alert in alerts:
        labels = alert['labels']
        if labels['application_operation_status'].lower() == 'succeeded':
                attachments.append({
                "title": "argocd alerts testing",
                "title_link": "https://dev-argocd.horizon.vmware.com/applications/testing",
                "color": "18be52",
                "text": ":white_check_mark: Application: `{}` operation state is `{}` with the message `{}` at `{}` \n Sync operation details are available at: `https://dev-argocd.horizon.vmware.com/applications/{}?operation=true` \n".format(labels['name'], labels['application_operation_status'], labels['application_operation_message'], labels['finished_at'], labels['name']),
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
                "color": "danger",
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
                "text": ":white_check_mark: Application: `{}` operation state is `{}` with the message `{}` at `{}` \n Sync operation details are available at: `https://dev-argocd.horizon.vmware.com/applications/{}?operation=true` \n".format(labels['name'], labels['application_operation_status'], labels['application_condition'], labels['finished_at'], labels['name']),
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
                "color": "danger",
                "mrkdwn_in": [
                    "fallback",
                    "pretext",
                    "text"
                ]
            })

            print({
                             "attachments": attachments
                })
    return True


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8885, debug=True)

