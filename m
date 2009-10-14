From: Jan Kara <jack@suse.cz>
Date: Wed, 14 Oct 2009 20:11:48 +0200
Subject: [Ocfs2-devel] [PATCH] [RFC] Mount option trap for users
In-Reply-To: <20091014162751.GX11402@wotan.suse.de>
References: <20090914194404.GA28473@mail.oracle.com>
	<20090915092424.GB12169@duck.suse.cz>
	<20090917230037.GG11402@wotan.suse.de>
	<20091006171743.GF22781@duck.suse.cz>
	<20091013194615.GA23257@mail.oracle.com>
	<20091014002752.GA19960@lst.de>
	<20091014003859.GP23257@mail.oracle.com>
	<20091014094129.GA12701@duck.suse.cz>
	<20091014100335.GB4530@mail.oracle.com>
	<20091014162751.GX11402@wotan.suse.de>
Message-ID: <20091014181148.GH12701@duck.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed 14-10-09 09:27:51, Mark Fasheh wrote:
> On Wed, Oct 14, 2009 at 03:03:35AM -0700, Joel Becker wrote:
> > On Wed, Oct 14, 2009 at 11:41:29AM +0200, Jan Kara wrote:
> > > On Tue 13-10-09 17:38:59, Joel Becker wrote:
> > > > 	You *are* paying attention :-)  I believe this is for hysterical
> > > > raisins.  We copied ext3 on this.  I'm totally in support of ripping
> > > > ACLs out of Kconfig.
> > >   Yes, this would certainly simplify the situation. And looking at the
> > > code, disabling CONFIG_OCFS2_POSIX_ACL does not seem to bring any
> > > significant code-size or speed advantage... So I'm in favor of this.
> > 
> > 	So let's do this:
> > 
> > 1) Rip out CONFIG_OCFS2_POSIX_ACL.  The code is always built in.
> > 2) Always enable acls if a filesystem has xattrs.  This is a noop if no
> >    one ever calls setacl.
> > 3) If a user explicitly puts -oacl on the mount command line, but the
> >    filesystem doesn't have xattrs, fail the mount.  This is a safe place
> >    to catch people changing kernels, as a too-old kernel driver likely
> >    doesn't have xattrs anyway.
> > 4) If a user explicitly puts -onoacl on the mount command line, they get
> >    what they asked for.
> > 
> > 	This behavior matches the other 'modern' filesystems.  The only
> > weirdness is in the cluster case, and the most common users will be
> > using released versions with ACL support.  Anyone compiling recent
> > drivers or kernels can't leave the support out.
> > 	Mark, Jan?
> 
> Yes, yes, yes and yes.  ;)
  OK, so should I implement it? Or Joel, will you take care of it?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
