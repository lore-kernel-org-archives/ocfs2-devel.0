From: Sunil Mushran <Sunil.Mushran@oracle.com>
Date: Fri Apr 16 14:11:56 2004
Subject: [Ocfs2-devel] A possible bug in kernel 2.6 porting
In-Reply-To: <37FBBA5F3A361C41AB7CE44558C3448E03B65E6A@PDSMSX403.ccr.corp.intel.com>
References: <37FBBA5F3A361C41AB7CE44558C3448E03B65E6A@PDSMSX403.ccr.corp.intel.com>
Message-ID: <40802FF6.1090707@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In mount volume we let the nmthread loop OCFS_HEARTBEAT_INIT
times before signaling the mount thread via the osb->nm_init_event
wait queue. This is done inorder to stabilize the nmthread.

This should be the obvious place to start the investigation.

Or you could hit alt-sysrq-t during the mount to see where the mount
thread is "lounging".

Zhang, Sonic wrote:

>Hi,
>
>When mount an OCFS volume for the first time, the delay before the mount
>succeeds is much longer than that under kernel 2.4. Normally, it takes
>more than 3 minutes under kernel 2.6, while it is only several seconds
>under kernel 2.4.
>
>I think this is a bug in kernel 2.6 porting.
>
>
>
>*********************************************
>Sonic Zhang
>Software Engineer
>Intel China Software Lab
>Tel: (086)021-52574545-1667
>iNet: 752-1667
>********************************************* 
>
>_______________________________________________
>Ocfs2-devel mailing list
>Ocfs2-devel@oss.oracle.com
>http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>  
>
