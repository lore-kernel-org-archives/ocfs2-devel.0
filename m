From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 11 May 2006 13:55:53 -0700
Subject: [Ocfs2-devel] OCFS2 features RFC
In-Reply-To: <44634CAB.C8CD.0002.0@novell.com>
References: <20060425183553.GB10524@ca-server1.us.oracle.com>
	<446398D3.7010508@suse.com> <44634CAB.C8CD.0002.0@novell.com>
Message-ID: <20060511205553.GW12236@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, May 11, 2006 at 02:40:46PM -0600, Paul Taysom wrote:
> What make the online file system resize tricky is updating all the
> allocation chains.  The last block of each of the existing chains needs
> to be updated to point to the new blocks in the chains.

	Nope, not tricky at all.  As clean new allocation groups, we
just insert them at the front of the chains.  The new chain has a
pointer to the existing chains initialized by userspace.  The chain
allocator inode has its chain pointers moved to the new group as a
single write during the in-kernel update.  Only one block write to
update all chains in the inode.

> Would it be possible to get rid of chains and just compute the next
> block in the chain?

	You can't mathematically compute the next group for anything
other than the cluster allocator.  In addition, the chain-reorder logic
allows fewer reads to find a relatively empty chain, an optimization
we'd lose.

Joel

-- 

"One of the symptoms of an approaching nervous breakdown is the
 belief that one's work is terribly important."
         - Bertrand Russell 

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
