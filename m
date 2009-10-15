From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 15 Oct 2009 14:07:31 -0700
Subject: [Ocfs2-devel] [PATCH 1/3] ocfs2: Make ACLs always compiled into
 the kernel
In-Reply-To: <20091015134200.GD5971@duck.suse.cz>
References: <1255611245-27340-1-git-send-email-jack@suse.cz>
	<1255611245-27340-2-git-send-email-jack@suse.cz>
	<20091015130344.GA5677@lst.de> <20091015134200.GD5971@duck.suse.cz>
Message-ID: <20091015210731.GF3112@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Oct 15, 2009 at 03:42:00PM +0200, Jan Kara wrote:
> On Thu 15-10-09 15:03:44, Christoph Hellwig wrote:
> > On Thu, Oct 15, 2009 at 02:54:03PM +0200, Jan Kara wrote:
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

	I think he's saying "if you don't provide any acl option at all,
they will default to enabled but you will not print 'acl'.
	I think the correct solution is to start mount_op with
OCFS2_MOUNT_POSIX_ACL set.  This correctly describes the behavior.  Then
'case Opt_acl' only does the check for xattrs and 'case Opt_noacl' does
the clearing of the option.

Joel

-- 

"People with narrow minds usually have broad tongues."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
