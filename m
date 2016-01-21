From: rwxybh <rwxybh@126.com>
Date: Thu, 21 Jan 2016 16:34:04 +0800
Subject: [Ocfs2-devel] ocfs2: o2hb: not fence self if storage down
References: <1453259619-5347-1-git-send-email-junxiao.bi@oracle.com>
Message-ID: <20160121163403031308148@126.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi, junxiao!


We can't find correct fencing log after a node fencing itself. 
We know there is log such as following in source code:

printk(KERN_ERR "*** ocfs2 is very sorry to be fencing this "
      "system by restarting ***\n");

But we NEVER found this message from /var/log/message or last "demsg".

Do u mean we can find this message from local fs log after applying this patch set?

Or any way to find this output (without netconsole), thx?



rwxybh
 
From: Junxiao Bi
Date: 2016-01-20 11:13
To: ocfs2-devel
CC: mfasheh
Subject: [Ocfs2-devel] ocfs2: o2hb: not fence self if storage down
Hi,
 
This serial of patches is to fix the issue that when storage down,
all nodes will fence self due to write timeout.
With this patch set, all nodes will keep going until storage back
online, except if the following issue happens, then all nodes will
do as before to fence self.
1. io error got
2. network between nodes down
3. nodes panic
 
Junxiao Bi (6):
      ocfs2: o2hb: add negotiate timer
      ocfs2: o2hb: add NEGO_TIMEOUT message
      ocfs2: o2hb: add NEGOTIATE_APPROVE message
      ocfs2: o2hb: add some user/debug log
      ocfs2: o2hb: don't negotiate if last hb fail
      ocfs2: o2hb: fix hb hung time
 
fs/ocfs2/cluster/heartbeat.c |  181 ++++++++++++++++++++++++++++++++++++++++--
1 file changed, 175 insertions(+), 6 deletions(-)
 
Thanks,
Junxiao.
 
_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel at oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20160121/7b9ef8eb/attachment.html 
