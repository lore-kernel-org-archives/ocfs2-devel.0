From: Christoph Hellwig <hch@infradead.org>
Date: Mon, 19 Jan 2015 01:09:14 -0800
Subject: [Ocfs2-devel] [PATCH 09/17] quota: Make Q_XQUOTASYNC support
	VFS quota syncing
In-Reply-To: <1421412471-4747-10-git-send-email-jack@suse.cz>
References: <1421412471-4747-1-git-send-email-jack@suse.cz>
	<1421412471-4747-10-git-send-email-jack@suse.cz>
Message-ID: <20150119090914.GI27474@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com

On Fri, Jan 16, 2015 at 01:47:43PM +0100, Jan Kara wrote:
> Call ->quota_sync method from Q_XQUOTASYNC for better userspace
> compatibility.

Q_XQUOTASYNC never did the equivalent to ->quota_sync, but rather was
the equivalent to sys_syncfs which also happens to write out quotas.

Unless you have a really strong reason for wiring it up, I'd rather keep
it as-is.
