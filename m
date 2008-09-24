From: Mark Fasheh <mfasheh@suse.com>
Date: Wed, 24 Sep 2008 02:02:05 -0700
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2: Add posix ACL support in ocfs2
	v1
In-Reply-To: <48D9F3EA.9090205@oracle.com>
References: <48D3725A.1030701@oracle.com>
	<1221817381-11133-1-git-send-email-tiger.yang@oracle.com>
	<20080923071118.GV4563@wotan.suse.de> <48D9F3EA.9090205@oracle.com>
Message-ID: <20080924090205.GZ4563@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Sep 24, 2008 at 04:01:46PM +0800, Tiger Yang wrote:
> Mark Fasheh wrote:
> >I think we also need some acl-specific handling of chmod in ocfs2_setattr.
> >See ext3_acl_chmod, where it's called and what it does.
> OK. I will add it later after learning ext3.

Great, thanks.


> >Err, this is a pretty bad place for a call which must do work only if we're
> >succesfull in creating the inode. A better place would be a few lines up,
> >maybe even just before the call to 'ocfs2_add_entry()', so that an acl
> >failure won't result in a non-acl-copied inode which is accessible from a
> >directory.
> I put this function here because ocfs2_xattr_set need start transaction.
> So I put it after commit transaction.
> 
> To avoid the issue you mentioned, I modify it to the following
> -       status = ocfs2_init_acl(inode, dir);
> +       if (!status) {
> +               if (ocfs2_init_acl(inode, dir))
> +                       mlog(0, "Init acl error\n");
> +       }
> is this acceptable?

It might be better if we can add the acls before the directory entry. This
means though that you'll have to add them as part of the current
transaction. I think this requires a few changes:
	- Add code to reserve the meta data alloc file
		- Symlinks will need this if the link name is so large it
		  won't allow inline EA's.
		- 512 byte blocks will need to always reserve a block for
		  the external EA block
	- If the acl value won't fit inline, reserve more clusters from the
	  cluster allocator.
	- Add the proper number of credits to those already passed to
	  ocfs2_start_trans(). I think the common case will be zero, but
	  when we attach an external ea block or have a value in an extent,
	  we'll need more.
	- Pass the handle, and allocators through to ocfs2_init_acl()
	  so that it can all be done in the current transaction.

Thanks,
	--Mark

--
Mark Fasheh
