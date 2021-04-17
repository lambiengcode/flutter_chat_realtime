module.exports = {
  apps: [{
    name: 'realtime-chat',
    script: 'dist/index.js',
    args: 'index.js',
    wait_ready: true,
    watch: true,
    error_file: './logs/err.log',
    out_file: './logs/out.log',
    log_file: './logs/combined.log',
    log_date_format: 'YYYY-MM-DD HH:mm:ss:SSSS',
    min_uptime: 10000,
    max_restarts: 3
  }]
};