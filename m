From: Jan Kara <jack@suse.cz>
Date: Tue, 13 Oct 2009 22:12:10 +0200
Subject: [Ocfs2-devel] [PATCH] [RFC] Mount option trap for users
In-Reply-To: <20091013194615.GA23257@mail.oracle.com>
References: <20090914145622.GK24075@duck.suse.cz>
	<20090914194404.GA28473@mail.oracle.com>
	<20090915092424.GB12169@duck.suse.cz>
	<20090917230037.GG11402@wotan.suse.de>
	<20091006171743.GF22781@duck.suse.cz>
	<20091013194615.GA23257@mail.oracle.com>
Message-ID: <20091013201210.GE31440@duck.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue 13-10-09 12:46:16, Joel Becker wrote:
> On Tue, Oct 06, 2009 at 07:17:43PM +0200, Jan Kara wrote:
> > On Thu 17-09-09 16:00:37, Mark Fasheh wrote:
> > > On Tue, Sep 15, 2009 at 11:24:24AM +0200, Jan Kara wrote:
> > > > On Mon 14-09-09 12:44:05, Joel Becker wrote:
> > > > > On Mon, Sep 14, 2009 at 04:56:22PM +0200, Jan Kara wrote:
> > > > > >   OCFS2 mount option 'acl' is a small trap for users. When xattr feature
> > > > > > is not enabled and 'acl' mount option is specified, it is just silently
> > > > > > cleared during mount. IMHO that's not a good behavior - when admin requests
> > > > > > ACLs and we are not able to provide them, we should just fail the mount.
> > > > > 
> > > > > 	See
> > > > > http://www.mail-archive.com/ocfs2-devel at oss.oracle.com/msg03836.html for
> > > > > previous discussion.
> 
> 	Checked the discussion again.  What really struck me was:
> 
>             Chris and Cristoph pointed out that btrfs and xfs always
>     assume '-o acl,user_xattr' if the feature is compiled in.  They are
>     always on.  btrfs only disables acls with '-o noacl'.  Might be
>     worth considering.
> 
> > > >   Also filesystems like ext3/ext4/reiserfs just silently enable the XATTR
> > > > feature when you use is for the first time and the kernel supports it (for
> > > > these filesystems XATTRs are implemented as COMPAT features). OCFS2 will
> > > > fail the syscall (and it cannot really silently enable the feature because
> > > > it is an INCOMPAT one) so that's a difference anyway... So I still think
> > > > my change makes sence.
> 
> 	Sure, you can't enable INCOMPAT features.  But you can use them
> if they are already enabled.  Why can't we just use acls when the driver
> supports them and the filesystem has xattrs already?
  We can but that's a bit separate issue. What I'm advocating is:
When user explicitely asks for acls via a mount option and the filesystem
does not have the feature enabled, just fail the mount instead of ignoring
the 'acl' mount option.
  Behavior that makes most sence to me is - when user does not specify any
particular mount option, use acls iff the filesystem has the feature
enabled.
  When user specifies 'acl' mount option, fail the mount if the filesystem
does not have the feature enabled or kernel is not able to support acls,
otherwise mount the filesystem with acls.
  When user specifies 'noacl', don't use acls (but see below).

> > > Regarding other file systems, I really wish we could do it their way, but as
> > > Jan points out we can't magically enable acls like they can and we
> > > definitely can't assume they're always on. So really, today's behavior is
> > > *NOT* like those file systems in the first place - instead of magically
> > > enabling the feature, we silently ignore the acl flag.
> 
> 	Actually, I just realized where we really differ from the other
> filesystems.  We're clustered, but CONFIG_OCFS2_POSIX_ACL isn't a
> feature flag.  We can, in theory, have two nodes.  Both have xattrs
> enabled, but only one has acls compiled into the kernel.  Now we're
> fucked.
> 	As far as I can tell, there is no way for the non-acl driver to
> notice that other nodes are using acls and reject the mount.  Thoughts?
  Hmm, this is nasty. I see two possible solutions:
a) Use acls iff xattr feature is enabled (i.e., mount options do not
influence whether acls are used or not), don't let kernel without
CONFIG_OCFS2_POSIX_ACL mount the filesystem with xattr feature enabled.
That should guarantee consistency among nodes but it can be inconvenient
at times (you'd have to disable xattrs via tunefs.ocfs2 to temporarily
disable acls and thus you'd loose all acl settings).

b) Introduce superblock bit 'mounted_with_acls'. The first node in the
cluster either sets this bit or leaves it zero. Other nodes then refuse
to mount the filesystem inconsistently with the bit setting (so if the bit
is set, nodes without CONFIG_OCFS2_POSIX_ACL cannot mount the fs).

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
