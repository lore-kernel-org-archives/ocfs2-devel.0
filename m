From: Stephen Smalley <sds@tycho.nsa.gov>
Date: Tue, 12 May 2009 13:32:47 -0400
Subject: [Ocfs2-devel] [RFC] The reflink(2) system call v4.
In-Reply-To: <20090512172200.GC6896@mail.oracle.com>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<20090507221535.GA31624@mail.oracle.com> <4A039FF8.7090807@hp.com>
	<20090508031018.GB8611@mail.oracle.com>
	<20090511204011.GB30293@mail.oracle.com>
	<alpine.LRH.2.00.0905120819460.3090@tundra.namei.org>
	<20090511223414.GA28209@mail.oracle.com>
	<alpine.LRH.2.00.0905121107400.4463@tundra.namei.org>
	<1242130714.31807.25.camel@localhost.localdomain>
	<20090512172200.GC6896@mail.oracle.com>
Message-ID: <1242149567.31807.90.camel@localhost.localdomain>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <Joel.Becker@oracle.com>
Cc: James Morris <jmorris@namei.org>, jim owens <jowens@hp.com>, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk, mtk.manpages@gmail.com, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Tue, 2009-05-12 at 10:22 -0700, Joel Becker wrote:
> On Tue, May 12, 2009 at 08:18:34AM -0400, Stephen Smalley wrote:
> > On Tue, 2009-05-12 at 11:12 +1000, James Morris wrote:
> > > On Mon, 11 May 2009, Joel Becker wrote:
> > > 
> > > > > e.g. SELinux will need to perform some checks on the operation, then 
> > > > > calculate a new security context for the new file.
> > > > 
> > > > 	Do I need to pass in preserve_security as well so SELinux knows
> > > > what the ownership check determined?
> > > 
> > > Not for SELinux -- its security attributes are orthogonal to DAC, and it 
> > > will perform its own checks on them.
> > 
> > Is preserve_security supposed to also control the preservation of the
> > SELinux security attribute (security.selinux extended attribute)?  I'd
> > expect that either we preserve all the security-relevant attributes or
> > none of them.  And if that is the case, then SELinux has to know about
> > preserve_security in order to know what the security context of the new
> > inode will be.  
> 
> 	Thank you Stephen, you read my mind.  In the ocfs2 case, we're 
> expecting to just reflink the extended attribute structures verbatim in
> the preserve_security case.

And in the preserve_security==0 case, you'll be calling
security_inode_init_security() in order to get the attribute name/value
pair to assign to the new inode just as in the normal file creation
case?

>   So we would be ignoring whatever was set on
> the new_dentry by security_inode_reflink().  This gets us the best CoW
> sharing of the xattr extents, but I want to make sure that's "safe" in
> the preserve_security case.

security_inode_reflink() can't handle the initialization regardless, as
the inode doesn't yet exist at that point.

> > Also, if you are going to automatically degrade reflink(2) behavior
> > based on the owner_or_cap test, then you ought to allow the same to be
> > true if the security module vetoes the attempt to preserve attributes.
> > Either DAC or MAC logic may say that security attributes cannot be
> > preserved.  Your current logic will only allow graceful degradation in
> > the DAC case, but the MAC case will remain a hard failure.
> 
> 	I did not think of this, and its a very good point as well.  I'm
> not sure how to have the return value of security_inode_reflink()
> distinguish between "disallow the reflink" and "disallow
> preserve_security".  But since !preserve_security requires read access
> only, perhaps we move security_inode_reflink up higher and say:
> 
> 	error = security_inode_reflink(old_dentry, dir);
> 	if (error)
> 		preserve_security = 0;
> 
> Here security_inode_reflink() does not need new_dentry, because it isn't
> setting a security context.  If it's ok with the reflink, we'll be
> copying the extended attribute.  If it's not OK, it falls through to the
> inode_permission(inode, MAY_READ) check, which will check for plain old
> read access.
> 	What do we think?

I'd rather have two hooks, one to allow the security module to override
preserve_security and one to allow the security module to deny the
operation altogether.  The former hook only needs to be called if
preserve_security is not already cleared by the DAC logic.  The latter
hook needs to know the final verdict on preserve_security in order to
determine the right set of checks to apply, which isn't necessarily
limited to only checking read access.

But we don't need the new_dentry regardless.

-- 
Stephen Smalley
National Security Agency
