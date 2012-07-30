From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Mon, 30 Jul 2012 15:48:38 -0000
Subject: [Ocfs2-devel] [PATCH 0/8] Set bi_rw when alloc bio before call
	bio_add_page.
In-Reply-To: <201207301514247032532@gmail.com>
References: <201207301514247032532@gmail.com>
Message-ID: <20120730153935.GE4547@phenom.dumpdata.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: majianpeng <majianpeng@gmail.com>
Cc: axboe <axboe@kernel.dk>, "chris.mason" <chris.mason@fusionio.com>, viro <viro@ZenIV.linux.org.uk>, tytso <tytso@mit.edu>, "adilger.kernel" <adilger.kernel@dilger.ca>, shaggy <shaggy@kernel.org>, mfasheh <mfasheh@suse.com>, jlbec <jlbec@evilplan.org>, bpm <bpm@sgi.com>, elder <elder@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, jfs-discussion <jfs-discussion@lists.sourceforge.net>, ocfs2-devel <ocfs2-devel@oss.oracle.com>, xfs <xfs@oss.sgi.com>

On Mon, Jul 30, 2012 at 03:14:28PM +0800, majianpeng wrote:
> When exec bio_alloc, the bi_rw is zero.But after calling bio_add_page,

What about submit_bio? That sets the bi_rw as well?
> it will use bi_rw.
> Fox example, in functiion __bio_add_page,it will call merge_bvec_fn().

function.
> The merge_bvec_fn of raid456 will use the bi_rw to judge the merge.
> >> if ((bvm->bi_rw & 1) == WRITE)
> >> return biovec->bv_len; /* always allow writes to be mergeable */

So what does that mean? Without this patch what happens?

> 
> 
> Jianpeng Ma (8):

Can you collapse all of this in just one patch?

>   Evalue bio->bi_rw after calling bio_alloc() and before calling

It is 'evaluate'
>     bio_add_page().
>   Evalue bio->bi_rw after calling bio_alloc() and before calling    
>     bio_add_page().
>   Evalue bio->bi_rw after calling bio_alloc() and before calling    
>     bio_add_page().
>   Evalue bio->bi_rw after calling bio_alloc() and before calling    
>     bio_add_page().
>   Evalue bio->bi_rw after calling bio_alloc() and before calling    
>     bio_add_page().
>   Evalue bio->bi_rw after calling bio_alloc() and before calling    
>     bio_add_page().
>   Evalue bio->bi_rw after calling bio_alloc() and before calling    
>     bio_add_page().
>   Evalue bio->bi_rw after calling bio_alloc() and before calling    
>     bio_add_page().
> 
>  block/blk-lib.c                     |    1 +
>  drivers/block/xen-blkback/blkback.c |    1 +

I am not really sure if that is correct. Does 'submit_bio' not do the
job properly?

>  fs/btrfs/check-integrity.c          |    1 +
>  fs/direct-io.c                      |    1 +
>  fs/ext4/page-io.c                   |    1 +
>  fs/jfs/jfs_metapage.c               |    1 +
>  fs/ocfs2/cluster/heartbeat.c        |    8 +++++---
>  fs/xfs/xfs_aops.c                   |    2 ++
>  fs/xfs/xfs_buf.c                    |    1 +
>  9 files changed, 14 insertions(+), 3 deletions(-)
> 
> -- 
> 1.7.9.5
