From: Jan Kara <jack@suse.cz>
Date: Sat, 17 Oct 2009 11:44:22 +0200
Subject: [Ocfs2-devel] [PATCH 1/3] ocfs2: Make ACLs always compiled	into
	the kernel
In-Reply-To: <20091015210731.GF3112@mail.oracle.com>
References: <1255611245-27340-1-git-send-email-jack@suse.cz>
	<1255611245-27340-2-git-send-email-jack@suse.cz>
	<20091015130344.GA5677@lst.de> <20091015134200.GD5971@duck.suse.cz>
	<20091015210731.GF3112@mail.oracle.com>
Message-ID: <20091017094422.GA31412@duck.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu 15-10-09 14:07:31, Joel Becker wrote:
> On Thu, Oct 15, 2009 at 03:42:00PM +0200, Jan Kara wrote:
> > On Thu 15-10-09 15:03:44, Christoph Hellwig wrote:
> > > On Thu, Oct 15, 2009 at 02:54:03PM +0200, Jan Kara wrote:
> > > > -#ifdef CONFIG_OCFS2_FS_POSIX_ACL
> > > >  	if (opts & OCFS2_MOUNT_POSIX_ACL)
> > > >  		seq_printf(s, ",acl");
> > > >  	else
> > > >  		seq_printf(s, ",noacl");
> > > > -#endif
> > > 
> > > It might be a good idea to always print acl here for backwards
> > > compatiblity.
> >   I don't understand here - why would printing 'acl' even if acls are
> > disabled be more backward compatible?
> 
> 	I think he's saying "if you don't provide any acl option at all,
> they will default to enabled but you will not print 'acl'.
  We will print 'acl' - what the code does is that
ocfs2_check_set_options() sets OCFS2_MOUNT_POSIX_ACL in case 'noacl' hasn't
been specified.

> 	I think the correct solution is to start mount_op with
> OCFS2_MOUNT_POSIX_ACL set.  This correctly describes the behavior.  Then
> 'case Opt_acl' only does the check for xattrs and 'case Opt_noacl' does
> the clearing of the option.
  This won't quite work because at the time parse_options is called during
mount, we don't have filesystem features available yet. That's why I go
through the hoops described above.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
