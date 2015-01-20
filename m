From: Jan Kara <jack@suse.cz>
Date: Tue, 20 Jan 2015 18:08:29 +0100
Subject: [Ocfs2-devel] [PATCH 03/17] quota: Add ->quota_{enable,
 disable} callbacks for VFS quotas
In-Reply-To: <20150119090248.GC27474@infradead.org>
References: <1421412471-4747-1-git-send-email-jack@suse.cz>
	<1421412471-4747-4-git-send-email-jack@suse.cz>
	<20150119090248.GC27474@infradead.org>
Message-ID: <20150120170829.GE3648@quack.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com

On Mon 19-01-15 01:02:48, Christoph Hellwig wrote:
> On Fri, Jan 16, 2015 at 01:47:37PM +0100, Jan Kara wrote:
> > +EXPORT_SYMBOL(dquot_quota_enable);
> 
> > +EXPORT_SYMBOL(dquot_quota_disable);
> 
> I can't find any modular users of this (in fact none outside this
> file), so I'd suggest to keep these local.
  OK, we can do that. I've exported the functions because in principle
filesystems are free to provide own .quota_enable function and then may
want to call dquot_quota_enable() from there but currently nobody needs
that so let's export them only if there are real users.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
