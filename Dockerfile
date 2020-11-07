FROM sonarsource/sonar-scanner-cli:latest
# FROM newtmitch/sonar-scanner:4.0.0-alpine

LABEL "com.github.actions.name"="SonarQube Scan"
LABEL "com.github.actions.description"="Static Code Analysis with SonarQube"
LABEL "com.github.actions.icon"="shield"
LABEL "com.github.actions.color"="blue"

LABEL version="0.0.1"
LABEL repository="https://github.com/krazykid/sonarqube-action"
LABEL maintainer="krazykid"

RUN apk add --no-cache ca-certificates jq

COPY entrypoint.sh /entrypoint.sh
RUN chmod 0755 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
