From: Christoph Hellwig <hch@lst.de>
Date: Tue Sep 20 15:27:17 2005
Subject: [Ocfs2-devel] [PATCH] remove ocfs2_write_blocks
In-Reply-To: <20050920202439.GE18764@ca-server1.us.oracle.com>
References: <20050918103617.GA23648@lst.de>
	<20050920202439.GE18764@ca-server1.us.oracle.com>
Message-ID: <20050920202719.GA8021@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Sep 20, 2005 at 01:24:39PM -0700, Mark Fasheh wrote:
> Thanks - committed.
> 
> I took some liberties with the patch:
> - merged it with the newest version of buffer_head_io.c (it got some
>   readonly goodness since your patch was created)
> - added a couple minor cleanups of my own
> - you forgot to update a comment, which I did

I think you lost the get_bh() that zab added after I submitted the
patch.
