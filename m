From: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 6 Aug 2020 20:49:38 -0700
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: fix ocfs2 corrupt when
 iputting an inode
In-Reply-To: <e24ca852-7c37-f12e-ed38-0fa0ac7c5c93@gmail.com>
References: <ef080ca3-5d74-e276-17a1-d9e7c7e662c9@huawei.com>
	<e24ca852-7c37-f12e-ed38-0fa0ac7c5c93@gmail.com>
Message-ID: <20200806204938.5f0bab0e265c279c275ce806@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, 1 Jun 2020 17:01:51 +0800 Joseph Qi <jiangqi903@gmail.com> wrote:

> 
> 
> On 2020/5/26 15:55, Wangyan wrote:
> > In this condition, it will cause an bug on error.
> > ocfs2_mkdir()
> >   ->ocfs2_mknod()
> >     ->ocfs2_mknod_locked()
> >       ->__ocfs2_mknod_locked()
> >         //Assume inode->i_generation is genN.
> >         ->inode->i_generation = osb->s_next_generation++;
> >         // The inode lockres has been initialized.
> >         ->ocfs2_populate_inode()
> >         ->ocfs2_create_new_inode_locks()
> >             ->An error happened, returned value is non-zero
> >       // free the start_bit x in bg_blkno
> >       ->ocfs2_free_suballoc_bits()
> >     ->...  /* Another process execute mkdir success in this place,
> >               and it occupied the start_bit x in bg_blkno
> >               which has been freed before. Its inode->i_generation
> >               is genN + 1 */
> >     ->iput(inode)
> >       ->evict()
> >         ->ocfs2_evict_inode()
> >           ->ocfs2_delete_inode()
> >             ->ocfs2_inode_lock()
> >               ->ocfs2_inode_lock_update()
> >                 /* Bug on here, genN != genN + 1 */
> >                 ->mlog_bug_on_msg(inode->i_generation !=
> >                   le32_to_cpu(fe->i_generation))
> > 
> > So, we need not to reclaim the inode when the inode->ip_inode_lockres
> > has been initialized. It will be freed in iput().
> > 
> > Signed-off-by: Yan Wang <wangyan122@huawei.com>
> > Reviewed-by: Jun Piao <piaojun@huawei.com>
> > ---
> >  fs/ocfs2/namei.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
> > index e61fdd8972ec..5302992d2bee 100644
> > --- a/fs/ocfs2/namei.c
> > +++ b/fs/ocfs2/namei.c
> > @@ -640,7 +640,8 @@ static int ocfs2_mknod_locked(struct ocfs2_super *osb,
> >  	status = __ocfs2_mknod_locked(dir, inode, dev, new_fe_bh,
> >  				    parent_fe_bh, handle, inode_ac,
> >  				    fe_blkno, suballoc_loc, suballoc_bit);
> > -	if (status < 0) {
> > +	if (status < 0 && !(OCFS2_I(inode)->ip_inode_lockres.l_flags &
> > +				OCFS2_LOCK_INITIALIZED)) {
> 
> Each condition in separate line may be better:
> 
> if (status < 0 &&
>     !(OCFS2_I(inode)->ip_inode_lockres.l_flags & OCFS2_LOCK_INITIALIZED))
> 
> And you've missed a fixed tag:
> Fixes: b1529a41f777 ("ocfs2: should reclaim the inode if '__ocfs2_mknod_locked' returns an error")

And to this one?
