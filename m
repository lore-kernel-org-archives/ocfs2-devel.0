From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Wed, 6 Jul 2011 14:48:47 +0800
Subject: [Ocfs2-devel] [PATCH 0/3] ocfs2: fix slow deleting
In-Reply-To: <20110706064115.GA15159@laptop.jp.oracle.com>
References: <201107060529.p665TY59014082@acsmt356.oracle.com>
	<4E13FE03.5060005@oracle.com>
	<20110706064115.GA15159@laptop.jp.oracle.com>
Message-ID: <20110706064847.GB15159@laptop.jp.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 11-07-06 14:41, Wengang Wang wrote:
> On 11-07-05 23:17, Sunil Mushran wrote:
> > On 07/05/2011 09:38 PM, Wengang Wang wrote:
> > >There is a use case that the app deletes huge number(XX kilo) of files in every
> > >5 minutes. The deletions of some specific files are extreamly slow(costing
> > >xx~xxx seconds). That is unacceptable.
> > >
> > >Reading out the dir entries and the relavent inodes cost time. And we are doing
> > >that with i_mutex held, it causes unlink path waiting on the mutex for long time.
> > >
> > >fix:
> > >We drops and retake the mutex in the duration giving change to unlink to go on.
> > >Also, for live nodes, one node only scan and recover this slot where the node
> > >resides(helps performance). And always do it at each scan time. For those dead
> > >(not mounted), we do it when we "should". And for dead slots, no dropping-retaking
> > >mutex is needed.
> > 
> > Yes, this is a good issue to tackle. I will read the patch in greater detail
> > later. But offhand, I have two comments.
> > 
> > 1. "should" is not descriptive. I am assuming you mean do it only during
> > actual recovery. If so, that would be incorrect. Say node 0 unlinks a file
> > that was being used by node 1. Node 0 dies. Recovery will notice that
> > that inode is active and not delete it. If node 1 dies, or is unable
> > to delete
> > the file for any other reason, then our only hope is orphan scan.
> 
> Sorry. the "should" doesn't mean a actual recovery. I meant when 
> "os->os_seqno == seqno", the orginal condition determining whether we do
> queue the scans.
> 
> > 
> > 2. All nodes have to scan all slots. Even live slots. I remember we did for
> > a reason. And that reason should be in the comment in the patch written
> > by Srini.
> 
> Oh... I will check Srini's patch.
The whole description is the following:

-------------
When a dentry is unlinked, the unlinking node takes an EX on the dentry
lock
before moving the dentry to the orphan directory. Other nodes that have
this dentry in cache have a PR on the same dentry lock.  When the EX is
requested, the other nodes flag the corresponding inode as
MAYBE_ORPHANED
during downconvert.  The inode is finally deleted when the last node to
iput
the inode sees that i_nlink==0 and the MAYBE_ORPHANED flag is set.

A problem arises if a node is forced to free dentry locks because of
memory
pressure. If this happens, the node will no longer get downconvert
notifications for the dentries that have been unlinked on another node.
If it also happens that node is actively using the corresponding inode
and
happens to be the one performing the last iput on that inode, it will
fail
to delete the inode as it will not have the MAYBE_ORPHANED flag set.

This patch fixes this shortcoming by introducing a periodic scan of the
orphan directories to delete such inodes. Care has been taken to
distribute
the workload across the cluster so that no one node has to perform the
task
all the time.
---------------

I didn't see the reason All nodes have to scan all slots. If there is
one, the "load balance"? Or the real reason is not in the description?

thanks,
wengang.
