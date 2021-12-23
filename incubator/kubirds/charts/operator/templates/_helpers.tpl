{{/*
Expand the name of the chart.
*/}}
{{- define "kubirds-operator.name" -}}
{{- $chartName := printf "kubirds-%s" .Chart.Name }}
{{- default $chartName .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "kubirds-operator.fullname" -}}
{{- $chartName := printf "kubirds-%s" .Chart.Name }}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default $chartName .Values.nameOverride }}
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
{{- define "kubirds-operator.chart" -}}
{{- $chartName := printf "kubirds-%s" .Chart.Name }}
{{- printf "%s-%s" $chartName .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "kubirds-operator.labels" -}}
helm.sh/chart: {{ include "kubirds-operator.chart" . }}
{{ include "kubirds-operator.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: kubirds
{{- end }}

{{/*
Selector labels
*/}}
{{- define "kubirds-operator.selectorLabels" -}}
app.kubernetes.io/name: {{ include "kubirds-operator.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "kubirds-operator.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "kubirds-operator.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
