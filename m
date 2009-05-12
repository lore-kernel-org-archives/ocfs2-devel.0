From: Stephen Smalley <sds@tycho.nsa.gov>
Date: Tue, 12 May 2009 08:01:56 -0400
Subject: [Ocfs2-devel] [RFC] The reflink(2) system call v4.
In-Reply-To: <alpine.LRH.2.00.0905120819460.3090@tundra.namei.org>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<20090507221535.GA31624@mail.oracle.com> <4A039FF8.7090807@hp.com>
	<20090508031018.GB8611@mail.oracle.com>
	<20090511204011.GB30293@mail.oracle.com>
	<alpine.LRH.2.00.0905120819460.3090@tundra.namei.org>
Message-ID: <1242129716.31807.8.camel@localhost.localdomain>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: James Morris <jmorris@namei.org>
Cc: Joel Becker <Joel.Becker@oracle.com>, jim owens <jowens@hp.com>, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk, mtk.manpages@gmail.com, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Tue, 2009-05-12 at 08:27 +1000, James Morris wrote:
> On Mon, 11 May 2009, Joel Becker wrote:
> 
> > and other security attributes (in all, I'm gonna call that the "security
> > context") as well.  So I defined reflink() as such.  This meant
> 
> "security context" is an term associated with SELinux, so you may want to 
> use something like "security attributes" or "security state" to avoid 
> confusing people.
> 
> > +	error = security_inode_reflink(old_dentry, dir);
> > +	if (error)
> > +		return error;
> 
> We'll need the new_dentry now, to set up new security state before the 
> dentry is instantiated.

I don't think the inode exists yet for the new_dentry (not until after
the call to i_op->reflink), and thus we cannot set up the new inode
state at the point of security_inode_reflink().  We will need the
filesystem to call into the security module to get the right security
attribute name/value pair when creating the new inode, just as with
normal inode creation, unless it is preserving the name/value pair from
the original.  The security_inode_init_security() hook is for that
purpose - you can see its usage in existing filesystems when creating
new inodes.

> e.g. SELinux will need to perform some checks on the operation, then 
> calculate a new security context for the new file.
> 
> 
> - James
-- 
Stephen Smalley
National Security Agency
