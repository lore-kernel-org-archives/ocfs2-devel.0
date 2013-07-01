From: Joel Becker <jlbec@evilplan.org>
Date: Mon, 1 Jul 2013 15:44:44 -0700
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: xattr: remove useless free
 space checking
In-Reply-To: <51C2C4E5.1030107@oracle.com>
References: <1371709057-11469-1-git-send-email-junxiao.bi@oracle.com>
	<1371709057-11469-2-git-send-email-junxiao.bi@oracle.com>
	<51C2C4E5.1030107@oracle.com>
Message-ID: <20130701224443.GB965@localhost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jun 20, 2013 at 05:01:25PM +0800, Jeff Liu wrote:
> On 06/20/2013 02:17 PM, Junxiao Bi wrote:
> 
> > free space checking will be done in ocfs2_xattr_ibody_init().
> > So remove here.
> > 
> > Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> 
> Reviewed-by: Jie Liu <jeff.liu@oracle.com>

Acked-by: Joel Becker <jlbec@evilplan.org>

> 
> > ---
> >  fs/ocfs2/xattr.c |    7 -------
> >  1 file changed, 7 deletions(-)
> > 
> > diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> > index 3bb0708..7de1a78 100644
> > --- a/fs/ocfs2/xattr.c
> > +++ b/fs/ocfs2/xattr.c
> > @@ -2759,13 +2759,6 @@ static int ocfs2_xattr_ibody_set(struct inode *inode,
> >  
> >  	down_write(&oi->ip_alloc_sem);
> >  	if (!(oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL)) {
> > -		if (!ocfs2_xattr_has_space_inline(inode, di)) {
> > -			ret = -ENOSPC;
> > -			goto out;
> > -		}
> > -	}
> > -
> > -	if (!(oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL)) {
> >  		ret = ocfs2_xattr_ibody_init(inode, xs->inode_bh, ctxt);
> >  		if (ret) {
> >  			if (ret != -ENOSPC)
> 
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel

-- 

 Brain: I shall pollute the water supply with this DNAdefibuliser,
        turning everyone into mindless slaves.
 Pinky: What about the people who drink bottled water?
 Brain: Pinky, people who pay 5 dollars for a bottle of water are
        already mindless slaves.

			http://www.jlbec.org/
			jlbec at evilplan.org
