From: Louis Rilling <Louis.Rilling@kerlabs.com>
Date: Wed, 18 Jun 2008 13:40:43 +0200
Subject: [Ocfs2-devel] [BUGFIX][PATCH 3/3] configfs: Fix failing
	symlink() making	rmdir() fail
In-Reply-To: <20080617221528.GA29091@mail.oracle.com>
References: <1213724243-29183-1-git-send-email-louis.rilling@kerlabs.com>
	<1213724243-29183-4-git-send-email-louis.rilling@kerlabs.com>
	<20080617221528.GA29091@mail.oracle.com>
Message-ID: <20080618114043.GB30804@localhost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <Joel.Becker@oracle.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Tue, Jun 17, 2008 at 03:15:28PM -0700, Joel Becker wrote:
> On Tue, Jun 17, 2008 at 07:37:23PM +0200, Louis Rilling wrote:
> > For the parent's rmdir() case, we can use the same solution as with mkdir() vs
> > rmdir(). For the target's rmdir() case, we cannot, since we do not and cannot
> > lock the target's inode while in symlink(). Fortunately, once create_link()
> > terminates, no further operation can fail in symlink(). So we first reorder the
> > operations in create_link() to attach the new symlink to its target in last
> > place, and second handle symlink creation failure the same way as a new item
> > creation failure.
> 
> 	Oh, no, ugh.  We don't want to create vfs objects first and ask
> questions later.  Otherwise we wouldn't need ATTACHING - we'd just
> create the symlink, then check dropping.
> 	If you have ATTACHING set, the rmdir cannot continue - you can
> check dropping at that time.  That is, you keep the DROPPING check where
> it is - if it is already set, you know that rmdir() is going to complete
> successfully.  You can bail before even calling configfs_create_link().
> If, however, it isn't set, your ATTACHING protects you from rmdir
> throughout.

The problem is rmdir() of the target item (see below). ATTACHING only protects
us from rmdir() of the parent. This is the exact reason why I attach the link to
the target in last place, where we know that we won't have to rollback.
	And AFAICS, creating a VFS object can not hurt as long as we hold the
parent i_mutex, right? Otherwise there already is a problem in
configfs_attach_item() where a failure in populate_attrs() leads to rollback the
creation of the VFS object already created for the item.

>  
> 	sl = kmalloc(sizeof(struct configfs_symlink), GFP_KERNEL);
>  	if (sl) {
>  		sl->sl_target = config_item_get(item);
>  		spin_lock(&configfs_dirent_lock);
> 		if (target_sd->s_type & CONFIGFS_USET_DROPPING) {
> 			spin_unlock(&configfs_dirent_lock);
> 			config_item_put(item);
> 			kfree(sl);
> 			return -ENOENT;
> 			/*
> 		 	* Force rmdir() of parent_item to wait until we know
> 		 	* if we succeed.
> 		 	*/
> 			parent_sd->s_type |= CONFIGFS_USET_ATTACHING;
> 		}
> 		list_add(&sl->sl_list, &target_sd->s_links);
>  		spin_unlock(&configfs_dirent_lock);
>  		ret = configfs_create_link(sl, parent_item->ci_dentry,
>  					   dentry);
> 		spin_lock(&configfs_dirent_lock);
> 		parent_sd->s_type &= ~CONFIGFS_USET_ATTACHING;
> 		if (ret) {

Here, if detach_prep() of the target failed because of the link attached above,
it had no means to retry. rmdir() of the target fails because of this
temporary link, which results in a failing symlink() making rmdir() of the
target fail.

> 			list_del_init(&sl->sl_list);
>  			spin_unlock(&configfs_dirent_lock);
>  			config_item_put(item);
>  			kfree(sl);
>  		} else
> 			spin_unlock(&configfs_dirent_lock);
>  	}
>  
>  	return ret;
> 

-- 
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes
-------------- next part --------------
A non-text attachment was scrubbed...
Name: not available
Type: application/pgp-signature
Size: 189 bytes
Desc: Digital signature
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20080618/a5fe5a67/attachment-0001.bin 
