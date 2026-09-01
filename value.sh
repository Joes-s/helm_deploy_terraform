#!/bin/bash

REGION="ap-northeast-2"
VALUES_FILE="./charts/myapp/values.yaml"

# host 입력 받기
read -p "새로운 host 입력 (예: www.example.com): " NEW_HOST

# ACM에서 첫 번째 인증서 ARN 가져오기
ARN=$(aws acm list-certificates \
  --region "$REGION" \
  --query "CertificateSummaryList[0].CertificateArn" \
  --output text | xargs)


if [ -z "$ARN" ] || [ "$ARN" == "None" ]; then
  echo -e "\e[31m❌ ACM 인증서를 찾지 못했습니다.\e[0m"
  exit 1
fi

# 대상 파일 존재 여부 확인
if [ ! -f "$VALUES_FILE" ]; then
  echo -e "\e[31m❌ $VALUES_FILE 파일을 찾을 수 없습니다.\e[0m"
  exit 1
fi


# host 변경
sed -i -E "s/^([[:space:]]*host:[[:space:]]*).*/\1$NEW_HOST/" "$VALUES_FILE"
# arn변경
sed -i -E "s/^([[:space:]]*certificateArn:[[:space:]]*).*/\1$ARN/" "$VALUES_FILE"

echo "values.yaml 수정 완료"
echo "host: $NEW_HOST"
echo "certificateArn: $ARN"