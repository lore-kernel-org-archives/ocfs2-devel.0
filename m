From: Tao Ma <tao.ma@oracle.com>
Date: Wed, 09 Jun 2010 21:43:40 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Remove the deprecated
	inode_setattr.
In-Reply-To: <20100609100126.GB15403@lst.de>
References: <1276073300-7360-1-git-send-email-tao.ma@oracle.com>
	<20100609091604.GX26335@laptop> <20100609100126.GB15403@lst.de>
Message-ID: <4C0F9A8C.2030609@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: Nick Piggin <npiggin@suse.de>, ocfs2-devel@oss.oracle.com, joel.becker@oracle.com, linux-fsdevel@vger.kernel.org

Christoph Hellwig wrote:
> Tao, can you rebase this in Al's vfs.git for-next queue (or just
> linux-next which includes it)
>
> There's lots of changes to the calling sequences in that area in there
> and having all conversions based ontop of that would make life a lot
> simpler for everyone.
>   
ok, so it looks I am too eager to merge the new truncate sequence into 
ocfs2. ;)

Regards,
Tao
