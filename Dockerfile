# ============================================================
# PVR Cinemas Static Website — Production Docker Image
# Base: nginx:alpine (ultra-lightweight ~7MB)
# Built for: Production deployment
# ============================================================

FROM nginx:alpine

LABEL maintainer="DevOps Team <devops@pvrcinemas.com>"
LABEL app="pvr-cinemas-website"
LABEL version="1.0.0"
LABEL description="PVR Cinemas Static Movie Ticket Booking Website"

# Remove default nginx config and static files
RUN rm -rf /usr/share/nginx/html/*
RUN rm /etc/nginx/conf.d/default.conf

# Copy custom nginx config
COPY nginx.conf /etc/nginx/conf.d/pvr.conf

# Copy website source
COPY index.html /usr/share/nginx/html/index.html

# Set correct permissions
RUN chown -R nginx:nginx /usr/share/nginx/html && \
    chmod -R 755 /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Health check — confirms nginx serves the page
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
  CMD wget -qO- http://localhost:80/ | grep -c "PVR" || exit 1

# Run nginx in foreground (required for containers)
CMD ["nginx", "-g", "daemon off;"]
