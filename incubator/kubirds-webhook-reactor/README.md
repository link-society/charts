# Webhook message

This Docker image sends a json [gotempl](https://github.com/link-society/gotempl) message to a webhook

It can be used with several popular webhooks as

- [Teams](https://docs.microsoft.com/microsoftteams/platform/webhooks-and-connectors/how-to/add-incoming-webhook)
- [Slack](https://api.slack.com/messaging/webhooks)
- [Telegram](https://core.telegram.org/bots/api#setwebhook)
- [Discord](https://discord.com/developers/docs/resources/webhook)
- [Facebook](https://developers.facebook.com/docs/graph-api/webhooks/)
- [Whatsapp](https://developers.facebook.com/docs/whatsapp/api/webhooks/)
- [Instagram](https://developers.facebook.com/docs/instagram-api/guides/webhooks/)
- [Github](https://docs.github.com/en/developers/webhooks-and-events/webhooks/creating-webhooks)
- [Gitlab](https://docs.gitlab.com/ee/user/project/integrations/webhooks.html)
- [Jira](https://developer.atlassian.com/server/jira/platform/webhooks/)
- [Trading view](https://www.tradingview.com/support/solutions/43000529348-about-webhooks/)

## Helm values

| Variable | Default | Description |
| --- | --- | --- |
| `webhook` | | webhook URL |
| `payload` | | send a json payload templated with [gotempl](https://github.com/link-society/) |
| `method` | `POST`| HTTP method |
| `headers` | `Content-Type: application/json` | [gotempl](https://github.com/link-society/) HTTP headers to send |
| `cookies` | `''` | [gotempl](https://github.com/link-society/) HTTP cookies to send |
| `curlConfig` | `''` | [gotempl](https://github.com/link-society/) cURL config to use |
| `curlArgs` | `''` | [gotempl](https://github.com/link-society/) cURL args to use |
| `triggers` | `{ success, failure }` | [Kubirds reactor triggers](https://kubirds.com/docs/concepts/reactor/schema/#triggers) |
| `emptySelectorBehavior` | `MatchAll` | [Kubirds reactor emptySelectorBehavior](https://kubirds.com/docs/concepts/reactor/schema/#emptyselectorbehavior) |
| `env` | `[]` | [Kubirds reactor env vars](https://kubirds.com/docs/concepts/reactor/schema/#env) |
| `envFrom` | `[]` | [Kubirds reactor envFrom vars](https://kubirds.com/docs/concepts/reactor/schema/#envFrom) |

## Examples of Helm chart installation

Those examples notify a Teams channel about any up/down Kubirds unit with the remainder payload message `'<unit_name> is up/down'`

File payload.json

```json
{ "text": "{{ .Env.UNIT_NAME }} is {{ if eq .Env.UNIT_STATE 0 }}up{{ else }}down {{ end }}" }
```

### Basic example

```bash
$ helm install healthcheck-teams \
  charts.link-society.com/incubator/kubirds-webhook-reactor \
  --set-file payload="payload.json" \
  --set webhook="https://mykey.webhook.office.com"
```

### Dynamic URL

env.yaml
```yaml
- name: TEAMS_KEY
  valueFrom:
    secretKeyRef:
      name: healthcheck-teams
      key: TEAMS_KEY
```

```bash
$ helm install healthcheck-teams \
  charts.link-society.com/incubator/kubirds-webhook-reactor \
  --set-file payload="payload.json" \
  --set webhook="https://\$\{TEAMS_KEY}.webhook.office.com" \
  --set-file env="env.yaml"
```

### Notify only when status change

File triggers.yaml
```yaml
success: false
failure: false
fixed: true
regression: true
```

```bash
$ helm install healthcheck-teams \
  charts.link-society.com/incubator/kubirds-webhook-reactor \
  --set-file payload="payload.json" \
  --set webhook="https://mykey.webhook.office.com"
  --set-file triggers="triggers.yaml"
```

### Use a proxy

```bash
$ helm install healthcheck-teams \
  charts.link-society.com/incubator/kubirds-webhook-reactor \
  --set-file payload="payload.json" \
  --set webhook="https://mykey.webhook.office.com"
  --set curlArgs="--proxy 42.42.62.42"
```

### Handle only some units

According to units with `metadata.labels` equal `unit-to-observe: true`

unitSelector.yaml
```yaml
unit-to-observe: true
```

```bash
$ helm install healthcheck-teams \
  charts.link-society.com/incubator/kubirds-webhook-reactor \
  --set-file payload="payload.json" \
  --set webhook="https://mykey.webhook.office.com"
  --set-file unitSelector="unitSelector.yaml"
```
