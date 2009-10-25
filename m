From: Christoph Hellwig <hch@lst.de>
Date: Sun, 25 Oct 2009 08:20:04 +0100
Subject: [Ocfs2-devel] [PATCH 1/3] ocfs2: Make ACLs always compiled into
	the kernel
In-Reply-To: <20091015134200.GD5971@duck.suse.cz>
References: <1255611245-27340-1-git-send-email-jack@suse.cz>
	<1255611245-27340-2-git-send-email-jack@suse.cz>
	<20091015130344.GA5677@lst.de> <20091015134200.GD5971@duck.suse.cz>
Message-ID: <20091025072004.GB17121@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Oct 15, 2009 at 03:42:00PM +0200, Jan Kara wrote:
> > > -#ifdef CONFIG_OCFS2_FS_POSIX_ACL
> > >  	if (opts & OCFS2_MOUNT_POSIX_ACL)
> > >  		seq_printf(s, ",acl");
> > >  	else
> > >  		seq_printf(s, ",noacl");
> > > -#endif
> > 
> > It might be a good idea to always print acl here for backwards
> > compatiblity.
>   I don't understand here - why would printing 'acl' even if acls are
> disabled be more backward compatible?

Sorry. misparsed the patch - ignore this comment.
