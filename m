From: Stephen Smalley <sds@tycho.nsa.gov>
Date: Mon, 18 May 2009 10:33:15 -0400
Subject: [Ocfs2-devel] [RFC] The reflink(2) system call v4.
In-Reply-To: <1242651759.20082.4.camel@localhost.localdomain>
References: <4A039FF8.7090807@hp.com> <20090508031018.GB8611@mail.oracle.com>
	<20090511204011.GB30293@mail.oracle.com> <4A0B96C6.40702@mit.edu>
	<1242324765.21772.95.camel@localhost.localdomain>
	<20090514220029.GB30410@mail.oracle.com>
	<1242388905.29973.17.camel@localhost.localdomain>
	<20090515152212.GA31454@mail.oracle.com>
	<1242402925.29973.163.camel@localhost.localdomain>
	<20090515164209.GD31454@mail.oracle.com>
	<20090515205335.GB25787@mail.oracle.com>
	<1242651759.20082.4.camel@localhost.localdomain>
Message-ID: <1242657195.20082.23.camel@localhost.localdomain>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <Joel.Becker@oracle.com>
Cc: Andy Lutomirski <luto@mit.edu>, jim owens <jowens@hp.com>, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk, mtk.manpages@gmail.com, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Mon, 2009-05-18 at 09:02 -0400, Stephen Smalley wrote:
> On Fri, 2009-05-15 at 13:53 -0700, Joel Becker wrote:
> > On Fri, May 15, 2009 at 09:42:09AM -0700, Joel Becker wrote:
> > > On Fri, May 15, 2009 at 11:55:25AM -0400, Stephen Smalley wrote:
> > > > Consider a program that wants to always preserve attributes on the
> > > > reflinks it creates.  If the interface allows the program to explicitly
> > > > request that behavior and returns an error when the request cannot be
> > > > honored, then the program knows that upon a successful return, the
> > > > attributes were in fact preserved.  If the interface instead silently
> > > > selects a behavior based on the current privileges of the process and
> > > > gives no indication to the caller as to what behavior was selected, then
> > > > the opportunity for error is great.
> > > 
> > > 	I get that.  I'm looking at what the programming interface is.
> > > What's the standard function for "I want the fallback behavior" called?
> > > What's the standard function for "I want preserve security" called?
> > > "int reflink(oldpath, newpath)" has to pick one of the behaviors.  Which
> > > is it?
> > 
> > 	Ok, I've been casting about how to solve the concern and provide
> > a decent interface.  I'm not about to give up on either.  I think,
> > though, that we do have to let the application signal its intent to the
> > system.  And if we're doing that, let's add a little flexibility.
> > 	I think the interface will be this (ignoring the reflinkat(2)
> > bit for now):
> > 
> > int reflink(const char *oldpath, const char *newpath, int preserve);
> > 
> > - Data and xattrs are reflinked always.
> > - 'preserve is a bitfield describing which attributes to keep across the
> >   reflink:
> >  * REFLINK_ATTR_OWNER - Keeps uid/gid the same.  Requires ownership or
> >    CAP_CHOWN.
> >  * REFLINK_ATTR_SECURITY - Keeps the security state (SELinux/SMACK/etc)
> >    the same.  This requires REFLINK_ATTR_OWNER (the security state makes
> >    no sense if the ownership changes).  If not set, the filesystem wipes
> >    all security.* xattrs and reinitializes with
> >    security_inode_init_security() just like a new file.
> >  * REFLINK_ATTR_MODE - Keeps the mode bits the same.  Requires ownership
> >    or CAP_FOWNER.
> >  * REFLINK_ATTR_ACL - Keeps the ACLs the same.  Requires
> >    REFLINK_ATTR_MODE, as ACLs have to get adjusted when the mode
> >    changes, and so you can't keep them the same if the mode wasn't
> >    preserved.  If not set, the filesystem reinits the ACLs as for a new
> >    file.
> > - REFLINK_ATTR_NONE is 0 and REFLINK_ATTR_ALL is ~0.
> > 
> > 	That's all the relevant attributes.  The timestamps behave as
> > already described (ctime is now, mtime matches the source), which is the
> > only sane behavior for this sort of thing.
> > 	So, a copy program would reflink(source, target,
> > REFLINK_ATTR_NONE), a snapshot program would reflink(source, target,
> > REFLINK_ATTR_ALL), and someone wanting the fallback behavior can do it
> > easily.
> > 	In the kernel, security_inode_reflink() gets passed the preserve
> > bits.  It's responsible for determining whether REFLINK_ATTR_SECURITY is
> > allowed (vfs_reflink() will already have asserted REFLINK_ATTR_OWNER).
> > It may do other checks on the reflink and the preserve bits, that's up
> > to the LSM.
> >         For scripting, we add the we add the '-p' and '-P' to "ln -r":
> > 
> > - ln -r == reflink(source, target, REFLINK_ATTR_NONE);
> > - ln -r -P == reflink(source, target, REFLINK_ATTR_ALL);
> > - ln -r -p == the fallback behavior.  This is like cp(1), where "cp -p"
> >   is best-effort.
> > 
> > 	Does this make everyone happy?
> 
> For simplicity and robustness, I would only support the none or all
> flags, i.e. preserve can be a simple bool.  I don't think you really
> want to deal with the individual flags, and I don't see a use case for
> them.

Or possibly only distinguish preserve-dac from preserve-mac, e.g.
REFLINK_ATTR_NONE (preserve none),
REFLINK_ATTR_DAC (preserve uid, gid, mode, and ACLs ala cp -p)
REFLINK_ATTR_MAC (preserve MAC security label ala cp -c)
REFLINK_ATTR_ALL (preserve all)

-- 
Stephen Smalley
National Security Agency
