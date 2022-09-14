{{/*
Expand the name of the chart.
*/}}
{{- define "tlsmon.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "tlsmon.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "tlsmon.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "tlsmon.labels" -}}
helm.sh/chart: {{ include "tlsmon.chart" . }}
{{ include "tlsmon.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "tlsmon.selectorLabels" -}}
app.kubernetes.io/name: {{ include "tlsmon.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "tlsmon.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "tlsmon.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Verify all credentials have been set.
*/}}
{{- if (not .Values.credentials.stripe.webhook) }}
{{- fail "Missing credentials 'stripe.webhook'" }}
{{- end }}

{{- if (not .Values.credentials.stripe.secret) }}
{{- fail "Missing credentials 'stripe.secret'" }}
{{- end }}

{{- if (not .Values.credentials.stripe.publishableKey) }}
{{- fail "Missing credentials 'stripe.publishableKey'" }}
{{- end }}

{{- if (not .Values.credentials.stripe.priceId) }}
{{- fail "Missing credentials 'stripe.priceId'" }}
{{- end }}

{{- if (not .Values.credentials.stripe.first100Id) }}
{{- fail "Missing credentials 'stripe.first100Id'" }}
{{- end }}

{{- if (not .Values.credentials.database.url) }}
{{- fail "Missing credentials 'database.url'" }}
{{- end }}

{{- if (not .Values.credentials.stripe.webhook) }}
{{- fail "Missing credentials 'stripe.webhook'" }}
{{- end }}

{{- if (not .Values.credentials.mailjet.apiKey) }}
{{- fail "Missing credentials 'mailjet.apiKey'" }}
{{- end }}

{{- if (not .Values.credentials.mailjet.secretKey) }}
{{- fail "Missing credentials 'mailjet.secretKey'" }}
{{- end }}
