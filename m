From: Christoph Hellwig <hch@infradead.org>
Date: Mon, 19 Jan 2015 01:02:48 -0800
Subject: [Ocfs2-devel] [PATCH 03/17] quota: Add ->quota_{enable,
 disable} callbacks for VFS quotas
In-Reply-To: <1421412471-4747-4-git-send-email-jack@suse.cz>
References: <1421412471-4747-1-git-send-email-jack@suse.cz>
	<1421412471-4747-4-git-send-email-jack@suse.cz>
Message-ID: <20150119090248.GC27474@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com

On Fri, Jan 16, 2015 at 01:47:37PM +0100, Jan Kara wrote:
> +EXPORT_SYMBOL(dquot_quota_enable);

> +EXPORT_SYMBOL(dquot_quota_disable);

I can't find any modular users of this (in fact none outside this
file), so I'd suggest to keep these local.
