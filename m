From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 16 Sep 2010 09:29:40 -0700
Subject: [Ocfs2-devel] [PATCH 0/3] ocfs2: Resolve the problem of
	truncate log flush.
In-Reply-To: <4C91DA92.9050805@oracle.com>
References: <4C91B707.8030502@oracle.com>
	<20100916064134.GC12578@mail.oracle.com>
	<4C91DA92.9050805@oracle.com>
Message-ID: <20100916162940.GD12578@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Sep 16, 2010 at 04:51:30PM +0800, Tao Ma wrote:
> >	Assuming we want to force jbd2 out, which is heavy as you point
> >out, can't we just sync the filesystem?  Wouldn't that work without
> >adding ocfs2cmt?
> I am just worried about the locking. My current solution call
> ocfs2_start_checkpoint which only wakeup checkpoint_event. We have
> no chance of locking and what's more, ocfs2cmt seems to work
> steadily for several years.

	I'd love to example the locking.  Assuming we are outside a
handle but probably inside i_mutex for the file we are growing, what
would the locking be like for ocfs2_sync_fs()?  Starting a handle and
waiting on jbd2 should absolutely be safe
(jbd2_journal_start_commit()/jbd2_log_wait_commit()).  It's flushing the
truncate log under another i_mutex.  I think it's gotta be safe, because
we take truncate_log->i_mutex under another inode's i_mutex when
truncating.

> So maybe we can add a work to ocfs2_wq and let it do the
> ocfs2_sync_fs()? I am just afraid of blocking ocfs2_wq like what
> orphan scan did recently. You know that. ;)

	I would be wary of that too.  I think the locking should work
inline, though.

Joel

-- 

None of our men are "experts."  We have most unfortunately found
it necessary to get rid of a man as soon as he thinks himself an
expert -- because no one ever considers himself expert if he really
knows his job.  A man who knows a job sees so much more to be done
than he has done, that he is always pressing forward and never
gives up an instant of thought to how good and how efficient he is.
Thinking always ahead, thinking always of trying to do more, brings
a state of mind in which nothing is impossible. The moment one gets
into the "expert" state of mind a great number of things become
impossible.
	- From Henry Ford Sr., "My Life and Work"

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
