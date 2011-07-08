From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Fri, 08 Jul 2011 00:02:57 -0700
Subject: [Ocfs2-devel] [PATCH 0/3] ocfs2: fix slow deleting
In-Reply-To: <4E16166B.3080808@oracle.com>
References: <201107060529.p665TY59014082@acsmt356.oracle.com>	<4E13FE03.5060005@oracle.com>	<4E154FEA.5030406@oracle.com>
	<4E1610C2.7060509@oracle.com> <4E16166B.3080808@oracle.com>
Message-ID: <4E16ABA1.6050702@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Below is excerpts from Joel's email for the same question :)

>	Currently, orphan scan just iterate all the slots and call
>  ocfs2_queue_recovery_completion, but I don't think it is proper for a node
>  to query another mounted one since that node will query it by
>  itself.

	Node 1 has an inode it was using.  The dentry went away due to
memory pressure.  Node 1 closes the inode, but it's on the free list.
The node has the open lock.
	Node 2 unlinks the inode.  It grabs the dentry lock to notify
others, but node 1 has no dentry and doesn't get the message.  It
trylocks the open lock, sees that another node has a PR, and does
nothing.
	Later node 2 runs its orphan dir.  It igets the inode, trylocks
the open lock, sees the PR still, and does nothing.
	Basically, we have to trigger an orphan iput on node 1.  The
only way for this to happen is if node 1 runs node 2's orphan dir.  This
patch exists because that wasn't happening.


On 7/7/2011 1:26 PM, Sunil Mushran wrote:
> On 07/07/2011 01:02 PM, Sunil Mushran wrote:
>> On 07/06/2011 11:19 PM, Srinivas Eeda wrote:
>>> On 7/5/2011 11:17 PM, Sunil Mushran wrote:
>>>> 2. All nodes have to scan all slots. Even live slots. I remember we
>>>> did for
>>>> a reason. And that reason should be in the comment in the patch 
>>>> written
>>>> by Srini.
>>> When a node unlinks a file it inserts an entry into it's own orphan
>>> slot. If another node is the last one to close the file and dentry got
>>> flushed then it will not do the cleanup as it doesn't know the file was
>>> orphaned. The file will remain in the orphan slot  till the node 
>>> umounts
>>> and the same slot is reused again. To overcome this problem a node has
>>> to rescan all slots(including live slots) and try to do the cleanup.
>> The qs is not why are we scanning all live slots on all nodes. As in,
>> why not just recover the local slot. There was a reason for that.
>> Yes, we have to recover unused slots for the reason listed previously.
>
> bleh.... let me rephrase.
>
> The qs is why are we scanning all live slots on all nodes. Wengangs
> patch limits the scanning to the local (live) slot only. And I remember
> we had a reason for it.
