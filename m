From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Fri, 9 Sep 2011 17:22:49 -0500
Subject: [Ocfs2-devel] Can recovery be done in process context (as opposed
	to kthread)?
Message-ID: <CAJtY7HVYZ3Uoy0QzBpUsrK68O9C6iUPkBe_YP6JCRskGHao9GA@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

I finally got back to improve the recovery procedure by offloading
work to work queues. However, I would like to know if we can
completely do away with ocfs2rec kthread. The process would just mark
the nodes which need recovery and offload the work on the work queues
and wait until all is over.

The reason for doing it this way is to make the mount process
killable. Currently the dlm locks are taken by ocfs2rec kthread while
the mount waits in uninterruptible sleep while the recovery happens.

This would help the High Availability software which send signals to
mount procedure if it does not complete within timeout. This usually
happens when journal takes a long time to replay; especially for nodes
waiting for recovery to complete and not doing the actual recovery.

Consider one node down procedure in the middle of I/O on a mounted
system as well.

We could keep the kthread with co-ordination as well.

-- 
Goldwyn
