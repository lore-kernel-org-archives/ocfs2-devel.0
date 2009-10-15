From: Jan Kara <jack@suse.cz>
Date: Thu, 15 Oct 2009 15:42:00 +0200
Subject: [Ocfs2-devel] [PATCH 1/3] ocfs2: Make ACLs always compiled	into
	the kernel
In-Reply-To: <20091015130344.GA5677@lst.de>
References: <1255611245-27340-1-git-send-email-jack@suse.cz>
	<1255611245-27340-2-git-send-email-jack@suse.cz>
	<20091015130344.GA5677@lst.de>
Message-ID: <20091015134200.GD5971@duck.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu 15-10-09 15:03:44, Christoph Hellwig wrote:
> On Thu, Oct 15, 2009 at 02:54:03PM +0200, Jan Kara wrote:
> > To become consistent with filesystems such as XFS or BTRFS, make posix
> > ACLs always compiled into the kernel. This also reduces possibility
> > of misconfiguration on admin's side.
> 
> Actually both XFS and btrfs have options for the acl code.  We don't
> have options for xattrs.
> 
> These days I probably wouldn't make acls optional anymore, though -
> there's very little code in the fs needed only for ACLs.
  Exactly, that's what we thought as well.

> > -#ifdef CONFIG_OCFS2_FS_POSIX_ACL
> >  	if (opts & OCFS2_MOUNT_POSIX_ACL)
> >  		seq_printf(s, ",acl");
> >  	else
> >  		seq_printf(s, ",noacl");
> > -#endif
> 
> It might be a good idea to always print acl here for backwards
> compatiblity.
  I don't understand here - why would printing 'acl' even if acls are
disabled be more backward compatible?
  Thanks for your comments.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
