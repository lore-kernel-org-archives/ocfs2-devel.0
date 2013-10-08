From: Joel Becker <jlbec@evilplan.org>
Date: Tue, 8 Oct 2013 11:17:50 -0700
Subject: [Ocfs2-devel] [PATCH 3/7] Differentiate between no_controld and
 with_controld
In-Reply-To: <52541AB6.4000004@suse.de>
References: <20130927170748.GA11716@shrek.lan>
	<20130927190232.GD26517@localhost> <5246EA2E.3090405@suse.de>
	<20131008000054.GJ5358@localhost> <52534F2A.6060901@suse.de>
	<20131008004335.GL5358@localhost> <52541AB6.4000004@suse.de>
Message-ID: <20131008181750.GM5358@localhost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Oct 08, 2013 at 09:46:14AM -0500, Goldwyn Rodrigues wrote:
> On 10/07/2013 07:43 PM, Joel Becker wrote:
> >No.  It should not be on disk, and it must not be permanent.  Consider a
> >cluster running at version 1.2.  One by one, each node is upgraded to a
> >new version of ocfs2 that supports the 1.3 protocol. Each node will
> >still reconnect to the cluster at 1.2 due to the third rule above.  But
> >when the entire cluster is taken down for maintenance, they will start
> >back up at 1.3.  In the future, we may even support online update to the
> >new version when every node has it.
> 
> Yes, the method I proposed works with what you mentioned and it is
> not permanent. Let me elaborate on what I said. A node on mount
> after setting up DLM would:
> 
> Requests a non-blocking EX lock on the protocol version file.
>   If it fails, it takes a PR lock on the version file.
>   If it succeeds, it writes it's own version info *overwriting* what
> was before and downconverts to PR lock. ie, even if there is a
> higher version in the file before.
> 
> This could be done with existing inode locks and no other locking
> infrastructure needs to be added.
> 
> This way if the first node is 1.2, the whole cluster will be 1.2
> even if a node with 1.3 joins. The first node decides what the
> entire cluster will be. Later, if all nodes have upgraded to 1.3,
> and the whole cluster restarts after a total cluster shutdown, the
> whole cluster will start with 1.3
> 
> The reason I proposed a file is because this is ocfs2 specific, and
> ideally should not be mixed with dlm stuff.

	I understood what you said, and the entire point of using the
network-based DLM is to stay away from disk structures for locking.
There is nothing wrong with using the DLM for DLM things.

Joel
-- 

"In the long run...we'll all be dead."
                                        -Unknown

			http://www.jlbec.org/
			jlbec at evilplan.org
