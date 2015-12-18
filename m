From: Mark Fasheh <mfasheh@suse.de>
Date: Fri, 18 Dec 2015 15:28:46 -0800
Subject: [Ocfs2-devel] The root cause analysis about buffer read getting
 starvation
In-Reply-To: <20151218090939.GB10744@desktop.lab.bej.apac.novell.com>
References: <56736AAA020000F9001A9EEA@relay2.provo.novell.com>
	<20151218090939.GB10744@desktop.lab.bej.apac.novell.com>
Message-ID: <20151218232846.GN11072@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Dec 18, 2015 at 05:09:39PM +0800, Eric Ren wrote:
> Hi all,
> 
> On Thu, Dec 17, 2015 at 08:08:42AM -0700, He Gang wrote: 
> > Hello Mark and all,
> > In the past days, I and Eric were looking at a customer issue, the customer is complaining that buffer reading sometimes lasts too much time ( 1 - 10 seconds) in case reading/writing the same file from different nodes concurrently, some day ago I sent a mail to the list for some discussions, you can read some details via the link https://oss.oracle.com/pipermail/ocfs2-devel/2015-December/011389.html.
> > But, this problem does not happen under SLES10 (sp1 - sp4), the customer upgraded his Linux OS to SLES11(sp3 or sp4), the problem happened, this is why the customer complains, he hope we can give a investigation, to see how to make OCFS2 buffer reading/writing behavior be consistent with SLES10.
> > According to our code reviewing and some testings, we found that the root cause to let buffer read get starvation.
> > The suspicious code in aops.c 
> >  274 static int ocfs2_readpage(struct file *file, struct page *page)
> >  275 {
> >  276         struct inode *inode = page->mapping->host;
> >  277         struct ocfs2_inode_info *oi = OCFS2_I(inode);
> >  278         loff_t start = (loff_t)page->index << PAGE_CACHE_SHIFT;
> >  279         int ret, unlock = 1;
> >  280         long delta;
> >  281         struct timespec t_enter, t_mid1, t_mid2, t_exit;
> >  282
> >  283         trace_ocfs2_readpage((unsigned long long)oi->ip_blkno,
> >  284                              (page ? page->index : 0));
> >  285
> >  286         ret = ocfs2_inode_lock_with_page(inode, NULL, 0, page);  <<= here, using nonblock way to get lock will bring many times retry, spend too much time
> >  287         if (ret != 0) {
> >  288                 if (ret == AOP_TRUNCATED_PAGE)
> >  289                         unlock = 0;
> >  290                 mlog_errno(ret);
> >  291                 goto out;
> >  292         }
> >  293
> >  294         if (down_read_trylock(&oi->ip_alloc_sem) == 0) {  <<= here, the same problem with above
> >  295                 /*
> >  296                  * Unlock the page and cycle ip_alloc_sem so that we don't
> >  297                  * busyloop waiting for ip_alloc_sem to unlock
> >  298                  */
> >  299                 ret = AOP_TRUNCATED_PAGE;
> >  300                 unlock_page(page);
> >  301                 unlock = 0;
> >  302                 down_read(&oi->ip_alloc_sem);
> >  303                 up_read(&oi->ip_alloc_sem);
> >  304                 goto out_inode_unlock;
> >  305         }
> > 
> > 
> > As you can see, using nonblock way to get lock will bring many time retry, spend too much time.
> > We can't modify the code to using block way to get the lock, as this will bring a dead lock.
> > Actually, we did some testing when trying to use block way to get the lock here, the deadlock problems were encountered.
> > But, in SLES10 source code, there is not any using nonblock way to get lock in buffer reading/writing, this is why buffer reading/writing are very fair to get IO when reading/writing the same file from multiple nodes. 
> SLES10 with kernel version about 2.6.16.x, used blocking way, i.e. down_read(), wich has the
> potential deaklock between page lock / ip_alloc_sem when one node get the cluster lock and
> does writing and reading on same file on it. This deadlock was fixed by this commit:

You are correct here - the change was introduced to solve a deadlock between
page lock and ip_alloc_sem(). Basically, ->readpage is going to be called
with the page lock held and we need to be aware of that.


> ---
> commit e9dfc0b2bc42761410e8db6c252c6c5889e178b8
> Author: Mark Fasheh <mark.fasheh@oracle.com>
> Date:   Mon May 14 11:38:51 2007 -0700
> 
>     ocfs2: trylock in ocfs2_readpage()
> 
>     Similarly to the page lock / cluster lock inversion in ocfs2_readpage, we
>     can deadlock on ip_alloc_sem. We can down_read_trylock() instead and just
>     return AOP_TRUNCATED_PAGE if the operation fails.
> 
>     Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index 8e7cafb..3030670 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -222,7 +222,10 @@ static int ocfs2_readpage(struct file *file, struct page *page)
>                 goto out;
>         }
> 
> -       down_read(&OCFS2_I(inode)->ip_alloc_sem);
> +       if (down_read_trylock(&OCFS2_I(inode)->ip_alloc_sem) == 0) {
> +               ret = AOP_TRUNCATED_PAGE;
> +               goto out_meta_unlock;
> +       }
> 
>         /*
>          * i_size might have just been updated as we grabed the meta lock.  We
> @@ -258,6 +261,7 @@ static int ocfs2_readpage(struct file *file, struct page *page)
>         ocfs2_data_unlock(inode, 0);
>  out_alloc:
>         up_read(&OCFS2_I(inode)->ip_alloc_sem);
> +out_meta_unlock:
>         ocfs2_meta_unlock(inode, 0);
>  out:
>         if (unlock)
> ---
> 
> But somehow with this patch, performance in the scenario become very bad. I don't how this could happen? because the reading node just has only one
> thread reading the shared file, then down_read_trylock() should always get ip_alloc_sem successfully, right? if not, who else may race ip_alloc_sem?

Hmm, there's only one thread and it can't get the lock? Any chance you might
put some debug prints around where we acquire ip_alloc_sem? It would be
interesting to see where it get taken to prevent this from happening.
	--Mark

--
Mark Fasheh
