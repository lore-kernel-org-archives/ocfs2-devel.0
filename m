From: Jan Kara <jack@suse.cz>
Date: Tue, 17 Apr 2012 09:44:08 +0200
Subject: [Ocfs2-devel] [PATCH 19/27] ocfs2: Convert to new freezing
	mechanism
In-Reply-To: <20120417021921.GC31464@dhcp-172-17-9-228.mtv.corp.google.com>
References: <1334592845-22862-1-git-send-email-jack@suse.cz>
	<1334592845-22862-20-git-send-email-jack@suse.cz>
	<20120417021921.GC31464@dhcp-172-17-9-228.mtv.corp.google.com>
Message-ID: <20120417074408.GB7198@quack.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <jlbec@evilplan.org>
Cc: Jan Kara <jack@suse.cz>, Al Viro <viro@ZenIV.linux.org.uk>, dchinner@redhat.com, LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com

On Mon 16-04-12 19:19:21, Joel Becker wrote:
> On Mon, Apr 16, 2012 at 06:13:57PM +0200, Jan Kara wrote:
> > Protect ocfs2_page_mkwrite() and ocfs2_file_aio_write() using the new
> > freeze protection. We also protect several ioctl entry points which
> > were missing the protection.
> > 
> > CC: Mark Fasheh <mfasheh@suse.com>
> > CC: Joel Becker <jlbec@evilplan.org>
> > CC: ocfs2-devel at oss.oracle.com
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> Acked-by: Joel Becker <jlbec@evilplan.org>
  Thanks. Added.

								Honza

> > ---
> >  fs/ocfs2/file.c  |   11 +++++++++--
> >  fs/ocfs2/ioctl.c |   14 ++++++++++++--
> >  fs/ocfs2/mmap.c  |    2 ++
> >  3 files changed, 23 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> > index 061591a..9b1e3d4 100644
> > --- a/fs/ocfs2/file.c
> > +++ b/fs/ocfs2/file.c
> > @@ -1971,6 +1971,7 @@ int ocfs2_change_file_space(struct file *file, unsigned int cmd,
> >  {
> >  	struct inode *inode = file->f_path.dentry->d_inode;
> >  	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> > +	int ret;
> >  
> >  	if ((cmd == OCFS2_IOC_RESVSP || cmd == OCFS2_IOC_RESVSP64) &&
> >  	    !ocfs2_writes_unwritten_extents(osb))
> > @@ -1985,7 +1986,12 @@ int ocfs2_change_file_space(struct file *file, unsigned int cmd,
> >  	if (!(file->f_mode & FMODE_WRITE))
> >  		return -EBADF;
> >  
> > -	return __ocfs2_change_file_space(file, inode, file->f_pos, cmd, sr, 0);
> > +	ret = mnt_want_write_file(file);
> > +	if (ret)
> > +		return ret;
> > +	ret = __ocfs2_change_file_space(file, inode, file->f_pos, cmd, sr, 0);
> > +	mnt_drop_write_file(file);
> > +	return ret;
> >  }
> >  
> >  static long ocfs2_fallocate(struct file *file, int mode, loff_t offset,
> > @@ -2261,7 +2267,7 @@ static ssize_t ocfs2_file_aio_write(struct kiocb *iocb,
> >  	if (iocb->ki_left == 0)
> >  		return 0;
> >  
> > -	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
> > +	sb_start_write(inode->i_sb);
> >  
> >  	appending = file->f_flags & O_APPEND ? 1 : 0;
> >  	direct_io = file->f_flags & O_DIRECT ? 1 : 0;
> > @@ -2434,6 +2440,7 @@ out_sems:
> >  		ocfs2_iocb_clear_sem_locked(iocb);
> >  
> >  	mutex_unlock(&inode->i_mutex);
> > +	sb_end_write(inode->i_sb);
> >  
> >  	if (written)
> >  		ret = written;
> > diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
> > index a1a1bfd..d9c352b 100644
> > --- a/fs/ocfs2/ioctl.c
> > +++ b/fs/ocfs2/ioctl.c
> > @@ -926,7 +926,12 @@ long ocfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
> >  		if (get_user(new_clusters, (int __user *)arg))
> >  			return -EFAULT;
> >  
> > -		return ocfs2_group_extend(inode, new_clusters);
> > +		status = mnt_want_write_file(filp);
> > +		if (status)
> > +			return status;
> > +		status = ocfs2_group_extend(inode, new_clusters);
> > +		mnt_drop_write_file(filp);
> > +		return status;
> >  	case OCFS2_IOC_GROUP_ADD:
> >  	case OCFS2_IOC_GROUP_ADD64:
> >  		if (!capable(CAP_SYS_RESOURCE))
> > @@ -935,7 +940,12 @@ long ocfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
> >  		if (copy_from_user(&input, (int __user *) arg, sizeof(input)))
> >  			return -EFAULT;
> >  
> > -		return ocfs2_group_add(inode, &input);
> > +		status = mnt_want_write_file(filp);
> > +		if (status)
> > +			return status;
> > +		status = ocfs2_group_add(inode, &input);
> > +		mnt_drop_write_file(filp);
> > +		return status;
> >  	case OCFS2_IOC_REFLINK:
> >  		if (copy_from_user(&args, (struct reflink_arguments *)arg,
> >  				   sizeof(args)))
> > diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
> > index 9cd4108..d150372 100644
> > --- a/fs/ocfs2/mmap.c
> > +++ b/fs/ocfs2/mmap.c
> > @@ -136,6 +136,7 @@ static int ocfs2_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
> >  	sigset_t oldset;
> >  	int ret;
> >  
> > +	sb_start_pagefault(inode->i_sb);
> >  	ocfs2_block_signals(&oldset);
> >  
> >  	/*
> > @@ -165,6 +166,7 @@ static int ocfs2_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
> >  
> >  out:
> >  	ocfs2_unblock_signals(&oldset);
> > +	sb_end_pagefault(inode->i_sb);
> >  	return ret;
> >  }
> >  
> > -- 
> > 1.7.1
> > 
> 
> -- 
> 
> Life's Little Instruction Book #197
> 
> 	"Don't forget, a person's greatest emotional need is to 
> 	 feel appreciated."
> 
> 			http://www.jlbec.org/
> 			jlbec at evilplan.org
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
