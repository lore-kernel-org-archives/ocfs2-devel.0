From: Tiger Yang <tiger.yang@oracle.com>
Date: Tue, 05 Jun 2012 13:20:21 +0800
Subject: [Ocfs2-devel] one issue, someone may give some help,thanks
In-Reply-To: <71604351584F6A4EBAE558C676F37CA417BC1D78@H3CMLB02-EX.srv.huawei-3com.com>
References: <71604351584F6A4EBAE558C676F37CA417BC1D78@H3CMLB02-EX.srv.huawei-3com.com>
Message-ID: <4FCD9715.1000200@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 06/05/2012 11:23 AM, Guozhonghua wrote:
>
> ??Hi?I am using ocfs2 for test and find one issue, would someone
> give some help about it.
>
> ??
>
> ??The background is that we are using ocfs2 over iSCSI on Ubuntu
> 12.04, with kernel version 3.2.0-23.
>
> ??Linux 3.2.0-23-generic x86_64 GNU/Linux
>
> ??
>
> ??We changed the configuration file of iSCSI, initiatorname.iscsi
> file, so as to restart the iSCSI service with the command "service
> open-iscsi restart".
>
> ??After the restart of iscsi service, the device that ocfs2 using is
> missed, and the log is written to kern.log as below:
>
> ??Jun 5 09:10:06 vmc-7 kernel: [45946.187897] sd 6:0:0:13: [sde]
> Attached SCSI disk
>
> ??Jun 5 09:10:07 vmc-7 kernel: [45946.439225]
> (o2hb-692FC96E2F,2786,5):o2hb_bio_end_io:389 ERROR: IO Error -19
>
> ??Jun 5 09:10:07 vmc-7 kernel: [45946.439673]
> (o2hb-692FC96E2F,2786,5):o2hb_do_disk_heartbeat:1017 ERROR: status = -19
>
> ??Jun 5 09:10:07 vmc-7 kernel: [45947.117979]
> (o2hb-58592532BC,2804,2):o2hb_bio_end_io:389 ERROR: IO Error -19
>
> ??Jun 5 09:10:07 vmc-7 kernel: [45947.118413]
>
> ??... ... .... ...
>
> ??(o2hb-58592532BC,2804,0):o2hb_bio_end_io:389 ERROR: IO Error -19
>
> ??Jun 5 09:10:53 vmc-7 kernel: [45993.143578]
> (o2hb-58592532BC,2804,0):o2hb_do_disk_heartbeat:1017 ERROR: status = -19
>
> ??
>
> ??The heartbeat timeout is 31 seconds configured as below.
>
> ??# O2CB_HEARTBEAT_THRESHOLD: Iterations before a node is considered
> dead.
>
> ??O2CB_HEARTBEAT_THRESHOLD=31
>
O2CB_HEARTBEAT_THRESHOLD = 31 means time out is 60 seconds, not 31 seconds.
You can read the ocfs2 faq about this:
O2CB_HEARTBEAT_THRESHOLD = (((timeout in secs) / 2) + 1)

Tiger
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20120605/72a2091f/attachment.html 
