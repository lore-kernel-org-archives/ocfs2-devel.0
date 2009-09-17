From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Thu, 17 Sep 2009 15:51:47 +0800
Subject: [Ocfs2-devel] [PATCH 0/2] ocfs2: add trace event support for
 ocfs2
In-Reply-To: <200909170419.n8H4JFWY027973@rgminet13.oracle.com>
References: <200909170419.n8H4JFWY027973@rgminet13.oracle.com>
Message-ID: <4AB1EA93.6060908@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Wengang Wang wrote:
> following patches add trace event support for ocfs2.
> for tracepoint, see Documentation/trace/tracepoints.txt
> for trace events, see Documentation/trace/events.txt
> 
> the first patch add file include/trace/events/ocfs2.h to kernel tree. it is used
> to store trace declarations. it's contents are self-explained.
> NOTE that each ocfs2 header file should be above "#include <linux/tracepoint.h>"
> 
> the second one is an example which adds trace event to ocfs2_file_aio_read().
> NOTE that CREATE_TRACE_POINTS must be defined before including trace/event/ocfs2.h
> when trace event is used.

and CREATE_TRACE_POINTS should be defined in only one .c file please.

regards,
wengang.

> 
> enable/disable the trace event:
> 1) debugfs is need to be mount for using trace event.
> 	mount -t debugfs debugfs /sys/kernel/debug(or somewhere else)
> 2) enable/disable some specific event,
> 	echo '1'/'0'>/sys/kernel/debug/tracing/events/ocfs2/ocfs2_file_aio_read/enable
> 3) to see the trace log,
> 	cat /sys/kernel/debug/tracing/trace
> 
> an output example is:
> [root at cool ocfs2_file_aio_read]# cat /sys/kernel/debug/tracing/trace
> # tracer: nop                                      
> #                                                  
> #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
> #              | |       |          |         |    
>              cat-2587  [001]   708.929889: ocfs2_file_aio_read: 0xf544bed8 0xf544bf5c 1 0
> 
>              cat-2587  [000]   708.944128: ocfs2_file_aio_read: 0xf544bed8 0xf544bf5c 1 43
> 
> examples of using filter.
> 1) if pid is 0, do the trace:
> 	echo "common_pid == 0" >/sys/kernel/debug/tracing/events/ocfs2/ocfs2_file_aio_read/filter
> 2) if group id not 0, do the trace:
> 	echo "common_tgid != 0" >filter
> 
> for filter expression, so far, see http://article.gmane.org/gmane.linux.kernel/887690?
> 
> 
