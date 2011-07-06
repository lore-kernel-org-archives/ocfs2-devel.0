From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Wed, 6 Jul 2011 12:38:29 +0800
Subject: [Ocfs2-devel] [PATCH 0/3] ocfs2: fix slow deleting
Message-ID: <201107060529.p665TY59014082@acsmt356.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

There is a use case that the app deletes huge number(XX kilo) of files in every
5 minutes. The deletions of some specific files are extreamly slow(costing
xx~xxx seconds). That is unacceptable.

Reading out the dir entries and the relavent inodes cost time. And we are doing
that with i_mutex held, it causes unlink path waiting on the mutex for long time.

fix:
We drops and retake the mutex in the duration giving change to unlink to go on.
Also, for live nodes, one node only scan and recover this slot where the node
resides(helps performance). And always do it at each scan time. For those dead
(not mounted), we do it when we "should". And for dead slots, no dropping-retaking
mutex is needed.
