From: Andy Johnson <johnsonzjo@gmail.com>
Date: Wed Mar 28 08:28:02 2007
Subject: [Ocfs2-devel] mount gnenerates an error : "Unable to access cluster
	service while starting heartbeat"
Message-ID: <147a89290703280827w67339993y32557cfd8067733a@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello,
I have ocfs2-tools-1.2.3. ( built from sources)
I try:
 mount /dev/vg1/cluster /mnt/ocfs2/
and get:
ocfs2_hb_ctl: Unable to access cluster service while starting heartbeat
mount.ocfs2: Error when attempting to run /sbin/ocfs2_hb_ctl: "Operation not
permitted"

What can be the cause of this error ? Any ideas?

(I tried it after service heartbeat stop)

Regards,
Andy
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20070328/8e58374a/attachment.html
