From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Fri, 8 Jul 2011 11:54:37 +0800
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2: drop and retake
 orphan_dir.i_mutex in ocfs2_recover_orphans
In-Reply-To: <20110708022858.GD3013@laptop.jp.oracle.com>
References: <201107060539.p665dq41013976@acsmt357.oracle.com>
	<4E162991.4090505@oracle.com>
	<20110708022858.GD3013@laptop.jp.oracle.com>
Message-ID: <20110708035437.GA10544@laptop.jp.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 11-07-08 10:28, Wengang Wang wrote:
> On 11-07-07 14:48, Sunil Mushran wrote:
> > This is too hacky for mainline. May work as a temp fix only.

<snip>

> > >  	trace_ocfs2_recover_orphans(slot);
> > >
> > >+cnt_scan:
> > >  	ocfs2_mark_recovering_orphan_dir(osb, slot);
> > >-	ret = ocfs2_queue_orphans(osb, slot,&inode);
> > >+	ret = ocfs2_queue_orphans(osb, slot,&inode,&pos);
> > >  	ocfs2_clear_recovering_orphan_dir(osb, slot);
> > 
> > The slot is being marked and cleared multiple times. I am unsure what the
> > ramifications are, but it does not look right.
> 
> I will look at this more...

Per my understand, ocfs2_mark_recovering_orphan_dir() is used to avoid
dead lock only.

ABBA lock.
A: inode lock(cluster lock) on inode to delete
B: inode lock on orphan_dir inode

the ocfs2_delete_inode() path takes in AB.
the ocfs2_recover_orphans() path takes in BA on a different node.

Since AB are both required and then released within ocfs2_queue_orphans(), calling
ocfs2_mark_recovering_orphan_dir() multiple times is not a problem.

Opition?

thanks,
wengang.
