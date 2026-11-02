# 베이스: 공식 NGINX 경량 이미지 (방식 A: 웹 서버 베이스 + 정적 콘텐츠 교체)
FROM nginx:alpine

# 커스텀 포인트 1: 이미지 메타데이터 (이미지 식별/관리 용도)
LABEL org.opencontainers.image.title="my-custom-nginx" \
      org.opencontainers.image.description="Codyssey dev workstation mission"

# 커스텀 포인트 2: 환경 변수 (설정과 코드 분리 연습)
ENV APP_ENV=dev

# 커스텀 포인트 3: 기본 페이지를 내 정적 콘텐츠로 교체
COPY app/ /usr/share/nginx/html/

# 커스텀 포인트 4: 헬스체크 (컨테이너가 정상 응답 중인지 Docker가 주기적으로 확인)
HEALTHCHECK --interval=30s --timeout=3s CMD wget -qO- http://localhost/ >/dev/null || exit 1

EXPOSE 80
