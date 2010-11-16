From: Jan Kara <jack@suse.cz>
Date: Tue, 16 Nov 2010 11:43:51 -0000
Subject: [Ocfs2-devel] [PATCH 1/6] fs: add hole punching to fallocate
In-Reply-To: <20101116111611.GA4757@quack.suse.cz>
References: <1289840723-3056-1-git-send-email-josef@redhat.com>
	<1289840723-3056-2-git-send-email-josef@redhat.com>
	<20101116111611.GA4757@quack.suse.cz>
Message-ID: <20101116114346.GB4757@quack.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Josef Bacik <josef@redhat.com>
Cc: david@fromorbit.com, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, cmm@us.ibm.com, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com

On Tue 16-11-10 12:16:11, Jan Kara wrote:
> On Mon 15-11-10 12:05:18, Josef Bacik wrote:
> > diff --git a/fs/open.c b/fs/open.c
> > index 4197b9e..ab8dedf 100644
> > --- a/fs/open.c
> > +++ b/fs/open.c
> > @@ -223,7 +223,7 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
> >  		return -EINVAL;
> >  
> >  	/* Return error if mode is not supported */
> > -	if (mode && !(mode & FALLOC_FL_KEEP_SIZE))
> > +	if (mode && (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE)))
>   Why not just:
> if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE)) ?
  And BTW, since FALLOC_FL_PUNCH_HOLE does not change the file size, should
not we enforce that FALLOC_FL_KEEP_SIZE is / is not set? I don't mind too
much which way but keeping it ambiguous (ignored) in the interface usually
proves as a bad idea in future when we want to further extend the interface...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
