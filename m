From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 11 Aug 2009 09:37:48 -0700
Subject: [Ocfs2-devel] New update for sync in reflink. [Re: some
 thoughts about data integrity test for reflink.]
In-Reply-To: <4A80C989.80301@oracle.com>
References: <4A1C8708.8050704@oracle.com>
	<1243389610.6616.30.camel@tristan-laptop.cn.oracle.com>
	<4A1DDFCF.4060203@oracle.com> <4A1E3B9A.7000807@oracle.com>
	<20090528171406.GA315@mail.oracle.com>
	<4A7C4708.9030303@oracle.com>
	<20090808001005.GE30923@mail.oracle.com>
	<4A7D8B92.5090906@oracle.com>
	<20090810185934.GB31168@mail.oracle.com>
	<4A80C989.80301@oracle.com>
Message-ID: <20090811163747.GA1788@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Aug 11, 2009 at 09:29:45AM +0800, Tao Ma wrote:
> Joel Becker wrote:
> We may call filemap_fdatawait after we drop the locks of new_inode since 
> it is just about the old inode's data writeback(And actually at the very 
> top of __ocfs2_reflink where we call filemap_fdatawrite, we don't have 
> i_mutex of new inode locked, so these 2 functions are both outside of 
> new_inode's i_mutex lock)? And what' more, now the new inode is still in 
> orphan dir, so other nodes or process should not be able to touch its 
> data at that time.

	You're right that the data writeout is from the source inode.
And we want to start the fdatawrite as soon as we've locked the source
inode, which is why we do it at the very top of __ocfs2_reflink().  If
you really want to do the fdatawaite outside of the new inode's mutex,
that's up to you.  I figured we'd do it inside the cluster lock so that
the refcounted areas are on disk before the journal commits the reflink,
but since file is in the orphan dir, it won't be visible someone uses
the tools to pull it out.

> ocfs2_cow_sync_writeback is used to sync data to the new clusters after 
> CoW in writeback mode, so it can't be removed.

	Oh, right.  Good catch.

Joel

-- 

Life's Little Instruction Book #226

	"When someone hugs you, let them be the first to let go."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
