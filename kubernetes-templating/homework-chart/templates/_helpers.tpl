{{/*
Expand the namespace of the chart.
*/}}
{{- define "homework.namespace" }}
{{- default .Values.namespace -}}
{{ end -}}