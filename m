From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Thu, 15 May 2014 12:26:20 +0800
Subject: [Ocfs2-devel] [PATCH 0/3] ocfs2: o2net: fix packets lost issue when
	reconnect
Message-ID: <1400127983-9774-1-git-send-email-junxiao.bi@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


Hi,

After the tcp connection is established between two ocfs2 nodes, an idle
timer will be set to check its state periodically, if no messages are
received during this time, idle timer will timeout, it will shutdown
the connection and try to rebuild, so pending message in tcp queues will
be lost. This may cause the whole ocfs2 cluster hung. 
This is very possible to happen when network state goes bad. Do the
reconnect is useless, it will fail if network state doesn't recover.
Just waiting there for network recovering may be a good idea, it will
not lost messages and some node will be fenced until cluster goes into
split-brain state, for this case, Tcp user timeout is used to override
the tcp retransmit timeout. It will timeout after 25 days, user should
have notice this through the provided log and fix the network, if they
don't, ocfs2 will fall back to original reconnect way.
The following is the serial of patches to fix the bug. Please help review.

Thanks,
Junxiao.
