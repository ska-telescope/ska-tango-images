{{/*
Range Parser for environment variables
*/}}
{{- define "tango-util.rangeparser" }}
- name: {{ tpl .env_name $ }}
  value: {{ tpl .env_value $ }}
{{- end }}