From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 17 Sep 2009 16:00:37 -0700
Subject: [Ocfs2-devel] [PATCH] [RFC] Mount option trap for users
In-Reply-To: <20090915092424.GB12169@duck.suse.cz>
References: <20090914145622.GK24075@duck.suse.cz>
	<20090914194404.GA28473@mail.oracle.com>
	<20090915092424.GB12169@duck.suse.cz>
Message-ID: <20090917230037.GG11402@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Sep 15, 2009 at 11:24:24AM +0200, Jan Kara wrote:
> On Mon 14-09-09 12:44:05, Joel Becker wrote:
> > On Mon, Sep 14, 2009 at 04:56:22PM +0200, Jan Kara wrote:
> > >   OCFS2 mount option 'acl' is a small trap for users. When xattr feature
> > > is not enabled and 'acl' mount option is specified, it is just silently
> > > cleared during mount. IMHO that's not a good behavior - when admin requests
> > > ACLs and we are not able to provide them, we should just fail the mount.
> > 
> > 	See
> > http://www.mail-archive.com/ocfs2-devel at oss.oracle.com/msg03836.html for
> > previous discussion.
>   Thanks for the pointer. I didn't know about this discussion. Actually,
> this is a bit different situation because you won't so easily disable the
> feature on the filesystem as opposed to just booting a kernel without ACL
> support.
>   Also filesystems like ext3/ext4/reiserfs just silently enable the XATTR
> feature when you use is for the first time and the kernel supports it (for
> these filesystems XATTRs are implemented as COMPAT features). OCFS2 will
> fail the syscall (and it cannot really silently enable the feature because
> it is an INCOMPAT one) so that's a difference anyway... So I still think
> my change makes sence.

Another thing to consider is which scenario is more likely - a user
compiling their kernel without acl support (because really, all major
distros have this turned on), or a user mounts an existing (nor newly
created with the wrong mkfs options) ocfs2 file system with '-oacl' that
doesn't have acl turned on in the feature flags.

Regarding other file systems, I really wish we could do it their way, but as
Jan points out we can't magically enable acls like they can and we
definitely can't assume they're always on. So really, today's behavior is
*NOT* like those file systems in the first place - instead of magically
enabling the feature, we silently ignore the acl flag.
	--Mark

--
Mark Fasheh
