From: Jan Kara <jack@suse.cz>
Date: Thu, 20 Nov 2008 16:19:45 +0100
Subject: [Ocfs2-devel] [PATCH 26/29] ocfs2: Add quota calls for
	allocation and	freeing of inodes and space
In-Reply-To: <20081106000629.GX15154@wotan.suse.de>
References: <122488610212-git-send-email-jack@suse.cz>
	<12248861041253-git-send-email-jack@suse.cz>
	<20081106000629.GX15154@wotan.suse.de>
Message-ID: <20081120151944.GD20118@duck.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed 05-11-08 16:06:29, Mark Fasheh wrote:
> On Sat, Oct 25, 2008 at 12:08:19AM +0200, Jan Kara wrote:
> > diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> > index 9af16e0..75cdb0e 100644
> > --- a/fs/ocfs2/file.c
> > +++ b/fs/ocfs2/file.c
> > @@ -35,6 +35,7 @@
> >  #include <linux/mount.h>
> >  #include <linux/writeback.h>
> >  #include <linux/falloc.h>
> > +#include <linux/quotaops.h>
> >  
> >  #define MLOG_MASK_PREFIX ML_INODE
> >  #include <cluster/masklog.h>
> > @@ -56,6 +57,7 @@
> >  #include "suballoc.h"
> >  #include "super.h"
> >  #include "xattr.h"
> > +#include "quota.h"
> >  
> >  #include "buffer_head_io.h"
> >  
> > @@ -536,6 +538,8 @@ static int __ocfs2_extend_allocation(struct inode *inode, u32 logical_start,
> >  	enum ocfs2_alloc_restarted why;
> >  	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> >  	struct ocfs2_extent_tree et;
> > +	u32 total_clusters = clusters_to_add;
> > +	int did_quota = 0;
> >  
> >  	mlog_entry("(clusters_to_add = %u)\n", clusters_to_add);
> >  
> > @@ -584,6 +588,12 @@ restart_all:
> >  		goto leave;
> >  	}
> >  
> > +	if (!did_quota && vfs_dq_alloc_space_nodirty(inode,
> > +	    ocfs2_clusters_to_bytes(osb->sb, total_clusters))) {
> > +		status = -EDQUOT;
> > +		goto leave;
> > +	}
> > +	did_quota = 1;
> >  restarted_transaction:
> >  	/* reserve a write to the file entry early on - that we if we
> >  	 * run out of credits in the allocation path, we can still
> > @@ -654,6 +664,9 @@ restarted_transaction:
> >  	     OCFS2_I(inode)->ip_clusters, (long long)i_size_read(inode));
> >  
> >  leave:
> > +	if (status < 0 && did_quota)
> > +		vfs_dq_free_space(inode,
> > +			ocfs2_clusters_to_bytes(osb->sb, total_clusters));
> 
> Shouldn't you subtract clusters_to_add clusters instead of total_clusters
> here? In theory, we could have allocated *some* of the inode but failed
> during a later pass.
  True, actually to be correct WRT crash in the middle of the allocation,
we have to release unused quota before we restart a transaction and then ask
for remaining blocks again - quota operation must always belong to the same
transaction as the allocation itself. It should be fixed now.

> > @@ -956,11 +972,47 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
> >  		}
> >  	}
> >  
> > -	handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
> > -	if (IS_ERR(handle)) {
> > -		status = PTR_ERR(handle);
> > -		mlog_errno(status);
> > -		goto bail_unlock;
> > +	if ((attr->ia_valid & ATTR_UID && attr->ia_uid != inode->i_uid) ||
> > +	    (attr->ia_valid & ATTR_GID && attr->ia_gid != inode->i_gid)) {
> > +		credits = OCFS2_INODE_UPDATE_CREDITS;
> > +		if (attr->ia_valid & ATTR_UID && attr->ia_uid != inode->i_uid
> > +		    && OCFS2_HAS_RO_COMPAT_FEATURE(sb,
> > +		    OCFS2_FEATURE_RO_COMPAT_USRQUOTA)) {
> > +			oinfo = sb_dqinfo(sb, USRQUOTA)->dqi_priv;
> > +			status = ocfs2_lock_global_qf(oinfo, 1);
> > +			if (status < 0)
> > +				goto bail_unlock;
> > +			credits += ocfs2_calc_qinit_credits(sb, USRQUOTA) +
> > +				ocfs2_calc_qdel_credits(sb, USRQUOTA);
> > +			locked[USRQUOTA] = 1;
> > +		}
> > +		if (attr->ia_valid & ATTR_GID && attr->ia_gid != inode->i_gid
> > +		    && OCFS2_HAS_RO_COMPAT_FEATURE(sb,
> > +		    OCFS2_FEATURE_RO_COMPAT_GRPQUOTA)) {
> > +			oinfo = sb_dqinfo(sb, GRPQUOTA)->dqi_priv;
> > +			status = ocfs2_lock_global_qf(oinfo, 1);
> > +			if (status < 0)
> > +				goto bail_unlock;
> > +			credits += ocfs2_calc_qinit_credits(sb, GRPQUOTA) +
> > +				   ocfs2_calc_qdel_credits(sb, GRPQUOTA);
> > +			locked[GRPQUOTA] = 1;
> > +		}
> > +		handle = ocfs2_start_trans(osb, credits);
> > +		if (IS_ERR(handle)) {
> > +			status = PTR_ERR(handle);
> > +			mlog_errno(status);
> > +			goto bail_unlock;
> > +		}
> > +		status = vfs_dq_transfer(inode, attr) ? -EDQUOT : 0;
> > +		if (status < 0)
> > +			goto bail_commit;
> 
> Ok, so this will all cause syncing on the global quota file because we need
> to transfer one record to/from another? Is there any better way?
  Yes, we take exclusive lock on global quota file because this file might
be the first file user ever has (or the last file source user has) and so
we have to create new quota structure for him (remove quota structure
respectively). This is a rare case but has to be taken care of. Of course,
we could play similar tricks as we do in ocfs2_dquot_initialize() to
optimize for the common case where shared lock is enough because all
structures already exist. But I felt chown/chgrp is rare enough so for now
I took the simple way. If this is a problem, it can be changed.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
