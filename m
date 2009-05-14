From: Stephen Smalley <sds@tycho.nsa.gov>
Date: Thu, 14 May 2009 14:25:33 -0400
Subject: [Ocfs2-devel] [RFC] The reflink(2) system call v4.
In-Reply-To: <1242324387.21772.92.camel@localhost.localdomain>
References: <20090507221535.GA31624@mail.oracle.com>
	<4A039FF8.7090807@hp.com> <20090508031018.GB8611@mail.oracle.com>
	<20090511204011.GB30293@mail.oracle.com>
	<alpine.LRH.2.00.0905120819460.3090@tundra.namei.org>
	<20090511223414.GA28209@mail.oracle.com>
	<alpine.LRH.2.00.0905121107400.4463@tundra.namei.org>
	<1242130714.31807.25.camel@localhost.localdomain>
	<20090512172200.GC6896@mail.oracle.com>
	<1242149567.31807.90.camel@localhost.localdomain>
	<20090512180339.GG6896@mail.oracle.com>
	<1242151493.31807.94.camel@localhost.localdomain>
	<1242324387.21772.92.camel@localhost.localdomain>
Message-ID: <1242325533.21772.102.camel@localhost.localdomain>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <Joel.Becker@oracle.com>
Cc: James Morris <jmorris@namei.org>, jim owens <jowens@hp.com>, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk, mtk.manpages@gmail.com, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Thu, 2009-05-14 at 14:06 -0400, Stephen Smalley wrote:
> On Tue, 2009-05-12 at 14:04 -0400, Stephen Smalley wrote:
> > On Tue, 2009-05-12 at 11:03 -0700, Joel Becker wrote:
> > > On Tue, May 12, 2009 at 01:32:47PM -0400, Stephen Smalley wrote:
> > > > On Tue, 2009-05-12 at 10:22 -0700, Joel Becker wrote:
> > > > > On Tue, May 12, 2009 at 08:18:34AM -0400, Stephen Smalley wrote:
> > > > > > Is preserve_security supposed to also control the preservation of the
> > > > > > SELinux security attribute (security.selinux extended attribute)?  I'd
> > > > > > expect that either we preserve all the security-relevant attributes or
> > > > > > none of them.  And if that is the case, then SELinux has to know about
> > > > > > preserve_security in order to know what the security context of the new
> > > > > > inode will be.  
> > > > > 
> > > > > 	Thank you Stephen, you read my mind.  In the ocfs2 case, we're 
> > > > > expecting to just reflink the extended attribute structures verbatim in
> > > > > the preserve_security case.
> > > > 
> > > > And in the preserve_security==0 case, you'll be calling
> > > > security_inode_init_security() in order to get the attribute name/value
> > > > pair to assign to the new inode just as in the normal file creation
> > > > case?
> > > 
> > > 	Oh, absolutely.
> > > 	As an aside, do inodes ever have more than one security.*
> > > attribute?  It would appear that security_inode_init_security() just
> > > returns one attribute, but what if I had a system running under SMACK
> > > and then changed to SELinux?  Would my (existing) inode then have
> > > security.smack and security.selinux attributes?
> > 
> > No, there would be no security.selinux attribute and the file would be
> > treated as having a well-defined 'unlabeled' attribute by SELinux.  Not
> > something you have to worry about.
> > 
> > > > > > Also, if you are going to automatically degrade reflink(2) behavior
> > > > > > based on the owner_or_cap test, then you ought to allow the same to be
> > > > > > true if the security module vetoes the attempt to preserve attributes.
> > > > > > Either DAC or MAC logic may say that security attributes cannot be
> > > > > > preserved.  Your current logic will only allow graceful degradation in
> > > > > > the DAC case, but the MAC case will remain a hard failure.
> > > > > 
> > > > > 	I did not think of this, and its a very good point as well.  I'm
> > > > > not sure how to have the return value of security_inode_reflink()
> > > > > distinguish between "disallow the reflink" and "disallow
> > > > > preserve_security".  But since !preserve_security requires read access
> > > > > only, perhaps we move security_inode_reflink up higher and say:
> > > > > 
> > > > > 	error = security_inode_reflink(old_dentry, dir);
> > > > > 	if (error)
> > > > > 		preserve_security = 0;
> > > > > 
> > > > > Here security_inode_reflink() does not need new_dentry, because it isn't
> > > > > setting a security context.  If it's ok with the reflink, we'll be
> > > > > copying the extended attribute.  If it's not OK, it falls through to the
> > > > > inode_permission(inode, MAY_READ) check, which will check for plain old
> > > > > read access.
> > > > > 	What do we think?
> > > > 
> > > > I'd rather have two hooks, one to allow the security module to override
> > > > preserve_security and one to allow the security module to deny the
> > > > operation altogether.  The former hook only needs to be called if
> > > > preserve_security is not already cleared by the DAC logic.  The latter
> > > > hook needs to know the final verdict on preserve_security in order to
> > > > determine the right set of checks to apply, which isn't necessarily
> > > > limited to only checking read access.
> > > 
> > > 	Ok, is that two hooks or one hook with specific error returns?
> > > I don't care, it's up to the LSM group.  I just can't come up with a
> > > good distinguishing set of names if its two hooks :-)
> > 
> > I suppose you could coalesce them into a single hook ala:
> > 	error = security_inode_reflink(old_dentry, dir, &preserve_security);
> > 	if (error)
> > 		return (error);
> 
> On second thought (agreeing with Andy about making the interface
> explicit wrt preserve_security), I don't expect us to ever override
> preserve_security from SELinux, so you can just pass it in by value.

And you can likely make preserve_security a simple bool (set from some
caller-provided flag) rather than an int.  At which point the SELinux
wiring for the new hook would be something like this:

If we are preserving security attributes on the reflink, then treat it
like creating a link to an existing file; else treat it like creating a
new file.  Read access will also be checked in the non-preserving case
by virtue of the separate inode_permission call.

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 2fcad7c..20ef414 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2667,6 +2667,17 @@ static int selinux_inode_symlink(struct inode *dir, struct dentry *dentry, const
 	return may_create(dir, dentry, SECCLASS_LNK_FILE);
 }
 
+static int selinux_inode_reflink(struct dentry *dentry, struct inode *dir,
+				bool preserve_security)
+{
+	struct inode_security_struct *isec = dentry->d_inode->i_security;
+
+	if (preserve_security)
+		return may_link(dir, dentry, MAY_LINK);
+	else
+		return may_create(dir, dentry, isec->sclass);
+}
+
 static int selinux_inode_mkdir(struct inode *dir, struct dentry *dentry, int mask)
 {
 	return may_create(dir, dentry, SECCLASS_DIR);
@@ -5357,6 +5368,7 @@ static struct security_operations selinux_ops = {
 	.inode_link =			selinux_inode_link,
 	.inode_unlink =			selinux_inode_unlink,
 	.inode_symlink =		selinux_inode_symlink,
+	.inode_reflink =		selinux_inode_reflink,
 	.inode_mkdir =			selinux_inode_mkdir,
 	.inode_rmdir =			selinux_inode_rmdir,
 	.inode_mknod =			selinux_inode_mknod,



-- 
Stephen Smalley
National Security Agency
