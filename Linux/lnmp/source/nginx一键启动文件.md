# Nginx 一键启动

文件路径 `/etc/init.d/nginx` ，具体源码如下：

## 普通的 nginx 启停脚本

```sh
#!/bin/sh

DAEMON=/server/nginx/sbin/nginx
NAME = nginx

nginx_start(){
    ${DAEMON}
}

nginx_stop(){
    ${DAEMON} -s stop
}

nginx_quit(){
    ${DAEMON} -s quit
}

nginx_reload(){
    ${DAEMON} -s reload
}

nginx_restart(){
    ${DAEMON} -s reopen
}

nginx_test(){
    ${DAEMON} -t
}

case "$1" in
    start)
        log_daemon_msg "Starting  ${NAME}"
        nginx_start
        ;;
    stop)
        log_daemon_msg "Stopping $NAME"
        nginx_stop
        ;;
    restart)
        log_daemon_msg "Restarting $DESC" "$NAME"


    *)
        log_action_msg "Usage: ${NAME} {start|stop|restart|reload|status|configtest}"
        exit 1


        # Check configuration before stopping nginx
        if ! test_config; then
            log_end_msg 1 # Configuration error
            exit $?
        fi

        stop_nginx
        case "$?" in
            0|1)
                start_nginx
                case "$?" in
                    0) log_end_msg 0 ;;
                    1) log_end_msg 1 ;; # Old process is still running
                    *) log_end_msg 1 ;; # Failed to start
                esac
                ;;
            *)
                # Failed to stop
                log_end_msg 1
                ;;
        esac
        ;;
    reload|force-reload)
        log_daemon_msg "Reloading $DESC configuration" "$NAME"

        # Check configuration before stopping nginx
        #
        # This is not entirely correct since the on-disk nginx binary
        # may differ from the in-memory one, but that's not common.
        # We prefer to check the configuration and return an error
        # to the administrator.
        if ! test_config; then
            log_end_msg 1 # Configuration error
            exit $?
        fi

        reload_nginx
        log_end_msg $?
        ;;
    configtest|testconfig)
        log_daemon_msg "Testing $DESC configuration"
        test_config
        log_end_msg $?
        ;;
    status)
        status_of_proc -p $PID "$DAEMON" "$NAME" && exit 0 || exit $?
        ;;
    upgrade)
        log_daemon_msg "Upgrading binary" "$NAME"
        upgrade_nginx
        log_end_msg $?
        ;;
    rotate)
        log_daemon_msg "Re-opening $DESC log files" "$NAME"
        rotate_logs
        log_end_msg $?
        ;;
    *)
        echo "Usage: $NAME {start|stop|restart|reload|force-reload|status|configtest|rotate|upgrade}" >&2
        exit 3
        ;;
esac
```
