From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 05 Jul 2011 23:17:39 -0700
Subject: [Ocfs2-devel] [PATCH 0/3] ocfs2: fix slow deleting
In-Reply-To: <201107060529.p665TY59014082@acsmt356.oracle.com>
References: <201107060529.p665TY59014082@acsmt356.oracle.com>
Message-ID: <4E13FE03.5060005@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 07/05/2011 09:38 PM, Wengang Wang wrote:
> There is a use case that the app deletes huge number(XX kilo) of files in every
> 5 minutes. The deletions of some specific files are extreamly slow(costing
> xx~xxx seconds). That is unacceptable.
>
> Reading out the dir entries and the relavent inodes cost time. And we are doing
> that with i_mutex held, it causes unlink path waiting on the mutex for long time.
>
> fix:
> We drops and retake the mutex in the duration giving change to unlink to go on.
> Also, for live nodes, one node only scan and recover this slot where the node
> resides(helps performance). And always do it at each scan time. For those dead
> (not mounted), we do it when we "should". And for dead slots, no dropping-retaking
> mutex is needed.

Yes, this is a good issue to tackle. I will read the patch in greater detail
later. But offhand, I have two comments.

1. "should" is not descriptive. I am assuming you mean do it only during
actual recovery. If so, that would be incorrect. Say node 0 unlinks a file
that was being used by node 1. Node 0 dies. Recovery will notice that
that inode is active and not delete it. If node 1 dies, or is unable to 
delete
the file for any other reason, then our only hope is orphan scan.

2. All nodes have to scan all slots. Even live slots. I remember we did for
a reason. And that reason should be in the comment in the patch written
by Srini.
