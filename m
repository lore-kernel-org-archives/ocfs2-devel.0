From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue, 25 Apr 2006 11:35:53 -0700
Subject: [Ocfs2-devel] OCFS2 features RFC
Message-ID: <20060425183553.GB10524@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The OCFS2 team is in the preliminary stages of planning major features for
our next cycle of development. The goal of this e-mail then is to stimulate
some discussion as to how features should be prioritized going forward. Some
disclaimers apply:

* The following list is very preliminary and is sure to change.

* I've probably missed some things.

* Development priorities within Oracle can be influenced but are ultimately
  up to management. That's not stopping anyone from contributing though, and
  patches are always welcome.

So I'll start with changes that can be completely contained within the file
system (no cluster stack changes needed):

-Sparse file support: Self explanatory. We need this for various reasons
 including performance, correctness and space usage.

-Htree support

-Extended attributes: This might be another area where we
 steal^H^H^H^H^Hcopy some good code from Ext3 :) On top of this one can
 trivially implement posix acls. We're not likely to support EA block
 sharing though as it becomes difficult to manage across the cluster.

-Removal of the vote mechanism: The most trivial dentry type network votes
 can go quite easily by replacing them with a cluster lock. This is critical
 in speeding up unlink and rename operations in the cluster. The remaining
 votes (mount, unmount, delete_inode) look like they'll require cluster
 stack adjustments.

-Data in inode blocks: Should speed up local node data operations with small
 files significantly.

-Shared writeable mmap: This looks like it might require changes to the
 kernel (outside of OCFS2). We need to investigate further...

Now on to file system features which require cluster stack changes. I'll
have alot more to say about the cluster stack in a bit, but it's worth
listing these out here for completeness.

-Cluster consistent Flock / Lockf

-Online file system resize

-Removal of remaining FS votes: If we can get rid of the delete_inode vote,
 I don't believe we'll need the mount / umount ones anymore (and if we still
 do, then a proper group services could handle that)

-Allow the file system to go "hard read only" when it loses it's connection
 to the disk, rather than the kernel panic we have today. This allows
 applications using the file system to gracefully shut down. Other
 applications on the system continue unharmed. "Hard read only" in the OCFS2
 context means that the RO node does not look mounted to the other nodes on
 that file system. Absolutely no disk writes are allowed.  File data and
 meta data can be stale or otherwise invalid. We never want to return
 invalid data to userspace, so file reads return -EIO.

As far as the existing cluster stack goes, currently most of the OCFS2 team
feels that the code has gone as far as it can and should go. It would
therefore be prudent to allow pluggable cluster stacks. Jeff Mahoney at
Novell has already done some integration work implementing a userspace
clustering interface. We probably want to do more in that area though.

There are several good reasons why we might want to integrate with external
cluster stacks. The most obvious is code reuse. The list of cluster stack
features we require for our next phase of development is very large (some
are listed below). There is no reason to implement those features unless
we're certain existing software doesn't provide them and can't be extended.
This will also allow a greater amount of choice for the end user. What stack
works well for one environment might not work as well for another. There's
also the fact that current resources are limited. It's enough work designing
and implementing a file system. If we can get out of the business of
maintaining a cluster stack, we should do so.

So the question then becomes, "What is it that we require of our cluster
stack going forward?"

- We'd like as much of it to be user space code as is possible and
  practical.

- The node manager should support dynamic cluster topology updates,
  including removing nodes from the cluster, propagating new configurations to
  existing nodes, etc.

- A pluggable fencing mechanism is a priority.

- We'd like some group services implementation to handle things like
  membership of a mount point, dlm domain/lockspace, etc.

- On the DLM side, we'd like things like directory based mastery, a range
  locking API, and some extra LVB recovery bits.

So that's it for now. Hopefully this will spurn some interesting discussion.
Please keep in mind that any of this is subject to change - cluster stack
requirements especially are things we've only recently begun discussing.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh at oracle.com
