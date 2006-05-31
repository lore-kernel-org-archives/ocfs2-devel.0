From: Kurt Hackel <kurt.hackel@oracle.com>
Date: Wed, 31 May 2006 14:25:20 -0700
Subject: [Ocfs2-devel] dlm_pick_recovery_master algorithm?
In-Reply-To: <447E0302.2080109@google.com>
Message-ID: <20060531142520708.00000000956@khackel-us>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Daniel,

> Which node masters the $RECOVERY resource?  

As with the mastery of any lock resource, any/all nodes can race simultaneously to try to master the $RECOVERY resource.  There are some small differences in the mastery process for recovery to ensure that deadlocks don't occur, and to detect and handle node death.

> Where is that set?

Almost all of this is done in fs/ocfs2/dlm/dlmmaster.c and the eventual master is set in the same way as all other lock resources, using the assert_master message.

> What happens when that node dies?

As soon as a node is seen as dead (via the heartbeat callback), cleanup occurs on all of the locks contained within lock resources that node mastered.  This includes the $RECOVERY lockres, though there is a special case in place to ensure that the $RECOVERY lockres is re-mastered at that point instead of being recovered.  Once it is remastered with the new cluster membership, it continues as normal.

> Why can dlm_pick_recovery_master
> get the EX on $RECOVERY and still not be the recovery master?

The EX lock on the $RECOVERY lockres is only used to protect the begin_reco message (the message which tells other nodes which node to recover and which will be the new master).  After that message is sent to all living nodes, the EX is dropped.  If a node has been waiting on the EX and does get it, it checks to see if the begin_reco has been sent while it was waiting.  If so, it backs off and lets the recovery master continue.

One note on all of this: this is NOT how we would like to do recovery going forward, we just did not have a solid cluster membership service in place that we could use when the mastery/recovery code was written.  Once we do have a stable mechanism and API (stop/start/finish) to depend upon, I would like to rewrite the whole thing for lock-table-based mastery and much more sensible recovery.  As it stands, it's a brittle structure that has to continually try to detect node failures inline and make adjustments as recovery is ongoing, which is no fun.

Thanks!
-kurt
