From: Jan Kara <jack@suse.cz>
Date: Tue, 20 Jan 2015 18:16:31 +0100
Subject: [Ocfs2-devel] [PATCH 09/17] quota: Make Q_XQUOTASYNC support
	VFS quota syncing
In-Reply-To: <20150119090914.GI27474@infradead.org>
References: <1421412471-4747-1-git-send-email-jack@suse.cz>
	<1421412471-4747-10-git-send-email-jack@suse.cz>
	<20150119090914.GI27474@infradead.org>
Message-ID: <20150120171631.GG3648@quack.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com

On Mon 19-01-15 01:09:14, Christoph Hellwig wrote:
> On Fri, Jan 16, 2015 at 01:47:43PM +0100, Jan Kara wrote:
> > Call ->quota_sync method from Q_XQUOTASYNC for better userspace
> > compatibility.
> 
> Q_XQUOTASYNC never did the equivalent to ->quota_sync, but rather was
> the equivalent to sys_syncfs which also happens to write out quotas.
> 
> Unless you have a really strong reason for wiring it up, I'd rather keep
> it as-is.
  OK, patch dropped.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
