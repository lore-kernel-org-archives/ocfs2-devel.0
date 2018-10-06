From: Christoph Hellwig <hch@infradead.org>
Date: Sat, 6 Oct 2018 03:38:41 -0700
Subject: [Ocfs2-devel] [PATCH 05/15] vfs: check file ranges before
	cloning files
In-Reply-To: <153870030868.29072.14603423813271148877.stgit@magnolia>
References: <153870027422.29072.7433543674436957232.stgit@magnolia>
	<153870030868.29072.14603423813271148877.stgit@magnolia>
Message-ID: <20181006103841.GD25747@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, ocfs2-devel@oss.oracle.com, sandeen@redhat.com

> +EXPORT_SYMBOL(generic_clone_checks);

There doesn't seem to be any need to export this function.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
