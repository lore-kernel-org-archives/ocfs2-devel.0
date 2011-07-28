From: Joel Becker <jlbec@evilplan.org>
Date: Thu, 28 Jul 2011 03:14:48 -0700
Subject: [Ocfs2-devel] [PATCH 0/3] ocfs2: fix slow deleting
In-Reply-To: <4E16ABA1.6050702@oracle.com>
References: <201107060529.p665TY59014082@acsmt356.oracle.com>
	<4E13FE03.5060005@oracle.com> <4E154FEA.5030406@oracle.com>
	<4E1610C2.7060509@oracle.com> <4E16166B.3080808@oracle.com>
	<4E16ABA1.6050702@oracle.com>
Message-ID: <20110728101448.GF9495@noexit.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jul 08, 2011 at 12:02:57AM -0700, Srinivas Eeda wrote:
> Below is excerpts from Joel's email for the same question :)
> 
> >	Currently, orphan scan just iterate all the slots and call
> >  ocfs2_queue_recovery_completion, but I don't think it is proper for a node
> >  to query another mounted one since that node will query it by
> >  itself.
> 
> 	Node 1 has an inode it was using.  The dentry went away due to
> memory pressure.  Node 1 closes the inode, but it's on the free list.
> The node has the open lock.
> 	Node 2 unlinks the inode.  It grabs the dentry lock to notify
> others, but node 1 has no dentry and doesn't get the message.  It
> trylocks the open lock, sees that another node has a PR, and does
> nothing.
> 	Later node 2 runs its orphan dir.  It igets the inode, trylocks
> the open lock, sees the PR still, and does nothing.
> 	Basically, we have to trigger an orphan iput on node 1.  The
> only way for this to happen is if node 1 runs node 2's orphan dir.  This
> patch exists because that wasn't happening.

	What he said.  And yes, I know I'm late to the party.

Joel

-- 

"Lately I've been talking in my sleep.
 Can't imagine what I'd have to say.
 Except my world will be right
 When love comes back my way."

			http://www.jlbec.org/
			jlbec at evilplan.org
