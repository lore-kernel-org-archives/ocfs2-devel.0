From: Christoph Hellwig <hch@lst.de>
Date: Wed, 9 Jun 2010 12:01:26 +0200
Subject: [Ocfs2-devel] [PATCH] ocfs2: Remove the deprecated
	inode_setattr.
In-Reply-To: <20100609091604.GX26335@laptop>
References: <1276073300-7360-1-git-send-email-tao.ma@oracle.com>
	<20100609091604.GX26335@laptop>
Message-ID: <20100609100126.GB15403@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Nick Piggin <npiggin@suse.de>
Cc: Tao Ma <tao.ma@oracle.com>, ocfs2-devel@oss.oracle.com, joel.becker@oracle.com, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>

Tao, can you rebase this in Al's vfs.git for-next queue (or just
linux-next which includes it)

There's lots of changes to the calling sequences in that area in there
and having all conversions based ontop of that would make life a lot
simpler for everyone.
