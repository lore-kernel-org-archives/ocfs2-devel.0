From: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 6 Aug 2020 20:49:10 -0700
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: clear links count in
 ocfs2_mknod() if an error occurs
In-Reply-To: <09b83918-89aa-2f5c-bbbf-ea4470386bfe@gmail.com>
References: <d8147c41-fb2b-bdf7-b660-1f3c8448c33f@huawei.com>
	<09b83918-89aa-2f5c-bbbf-ea4470386bfe@gmail.com>
Message-ID: <20200806204910.6fa489d7aabd5c8026f4c704@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, 1 Jun 2020 16:30:30 +0800 Joseph Qi <jiangqi903@gmail.com> wrote:

> Hi,
> 
> On 2020/5/26 15:45, Wangyan wrote:
> > In this condition, the inode can not be wiped when error happened.
> > ocfs2_mkdir()
> >   ->ocfs2_mknod()
> >     ->ocfs2_mknod_locked()
> >       ->__ocfs2_mknod_locked()
> >         ->ocfs2_set_links_count() // i_links_count is 2
> >     -> ... // an error accrue, goto roll_back or leave.
> >     ->ocfs2_commit_trans()
> >     ->iput(inode)
> >       ->evict()
> >         ->ocfs2_evict_inode()
> >           ->ocfs2_delete_inode()
> >             ->ocfs2_inode_lock()
> >               ->ocfs2_inode_lock_update()
> >                 ->ocfs2_refresh_inode()
> >                   ->set_nlink();    // inode->i_nlink is 2 now.
> >             /* if wipe is 0, it will goto bail_unlock_inode */
> >             ->ocfs2_query_inode_wipe()
> >               ->if (inode->i_nlink) return; // wipe is 0.
> >             /* inode can not be wiped */
> >             ->ocfs2_wipe_inode()
> > So, we need clear links before the transaction committed.
> > 
> > Signed-off-by: Yan Wang <wangyan122@huawei.com>
> > Reviewed-by: Jun Piao <piaojun@huawei.com>
> > ---
> >  fs/ocfs2/namei.c | 14 ++++++++++++--
> >  1 file changed, 12 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
> > index 5381020aaa9a..e61fdd8972ec 100644
> > --- a/fs/ocfs2/namei.c
> > +++ b/fs/ocfs2/namei.c
> > @@ -453,8 +453,12 @@ static int ocfs2_mknod(struct inode *dir,
> >  leave:
> >  	if (status < 0 && did_quota_inode)
> >  		dquot_free_inode(inode);
> > -	if (handle)
> > +	if (handle) {
> > +		if (status < 0 && new_fe_bh != NULL)
> > +			ocfs2_set_links_count((struct ocfs2_dinode *)
> > +					new_fe_bh->b_data, 0);
> 
> Seems no need to do this rollback under handle?
> Only if (status < 0 && new_fe_bh) will be okay.
> 
> >  		ocfs2_commit_trans(osb, handle);
> > +	}
> > 
> >  	ocfs2_inode_unlock(dir, 1);
> >  	if (did_block_signals)
> > @@ -598,6 +602,8 @@ static int __ocfs2_mknod_locked(struct inode *dir,
> >  leave:
> >  	if (status < 0) {
> >  		if (*new_fe_bh) {
> > +			if (fe)
> > +				ocfs2_set_links_count(fe, 0);
> 
> Leave this to caller will be enough.

Are we still awaiting a response to these review comments?
