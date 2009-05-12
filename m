From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 12 May 2009 11:28:33 -0700
Subject: [Ocfs2-devel] [RFC] The reflink(2) system call v4.
In-Reply-To: <1242151493.31807.94.camel@localhost.localdomain>
References: <20090508031018.GB8611@mail.oracle.com>
	<20090511204011.GB30293@mail.oracle.com>
	<alpine.LRH.2.00.0905120819460.3090@tundra.namei.org>
	<20090511223414.GA28209@mail.oracle.com>
	<alpine.LRH.2.00.0905121107400.4463@tundra.namei.org>
	<1242130714.31807.25.camel@localhost.localdomain>
	<20090512172200.GC6896@mail.oracle.com>
	<1242149567.31807.90.camel@localhost.localdomain>
	<20090512180339.GG6896@mail.oracle.com>
	<1242151493.31807.94.camel@localhost.localdomain>
Message-ID: <20090512182833.GI6896@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: James Morris <jmorris@namei.org>, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, mtk.manpages@gmail.com, jim owens <jowens@hp.com>, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

On Tue, May 12, 2009 at 02:04:53PM -0400, Stephen Smalley wrote:
> On Tue, 2009-05-12 at 11:03 -0700, Joel Becker wrote:
> > 	As an aside, do inodes ever have more than one security.*
> > attribute?  It would appear that security_inode_init_security() just
> > returns one attribute, but what if I had a system running under SMACK
> > and then changed to SELinux?  Would my (existing) inode then have
> > security.smack and security.selinux attributes?
> 
> No, there would be no security.selinux attribute and the file would be
> treated as having a well-defined 'unlabeled' attribute by SELinux.  Not
> something you have to worry about.

	Even if I've run rstorecon?  Basically, I'm trying to understand
if, in the !preserve_security case, ocfs2 can just do "link up the
existing xattrs, then set whatever we got from
security_inode_init_security()", or if we have to go through and delete
all security.* attributes before installing the result of
security_inode_init_security().

> > > I'd rather have two hooks, one to allow the security module to override
> > > preserve_security and one to allow the security module to deny the
> > > operation altogether.  The former hook only needs to be called if
> > > preserve_security is not already cleared by the DAC logic.  The latter
> > > hook needs to know the final verdict on preserve_security in order to
> > > determine the right set of checks to apply, which isn't necessarily
> > > limited to only checking read access.
> > 
> > 	Ok, is that two hooks or one hook with specific error returns?
> > I don't care, it's up to the LSM group.  I just can't come up with a
> > good distinguishing set of names if its two hooks :-)
> 
> I suppose you could coalesce them into a single hook ala:
> 	error = security_inode_reflink(old_dentry, dir, &preserve_security);
> 	if (error)
> 		return (error);

	What fits in with the LSM convention.  That's more important
than one-hook-vs-two.

Joel

-- 

"Gone to plant a weeping willow
 On the bank's green edge it will roll, roll, roll.
 Sing a lulaby beside the waters.
 Lovers come and go, the river roll, roll, rolls."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
