From: Stephen Smalley <sds@tycho.nsa.gov>
Date: Tue, 12 May 2009 08:18:34 -0400
Subject: [Ocfs2-devel] [RFC] The reflink(2) system call v4.
In-Reply-To: <alpine.LRH.2.00.0905121107400.4463@tundra.namei.org>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<20090507221535.GA31624@mail.oracle.com> <4A039FF8.7090807@hp.com>
	<20090508031018.GB8611@mail.oracle.com>
	<20090511204011.GB30293@mail.oracle.com>
	<alpine.LRH.2.00.0905120819460.3090@tundra.namei.org>
	<20090511223414.GA28209@mail.oracle.com>
	<alpine.LRH.2.00.0905121107400.4463@tundra.namei.org>
Message-ID: <1242130714.31807.25.camel@localhost.localdomain>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: James Morris <jmorris@namei.org>
Cc: Joel Becker <Joel.Becker@oracle.com>, jim owens <jowens@hp.com>, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk, mtk.manpages@gmail.com, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Tue, 2009-05-12 at 11:12 +1000, James Morris wrote:
> On Mon, 11 May 2009, Joel Becker wrote:
> 
> > > e.g. SELinux will need to perform some checks on the operation, then 
> > > calculate a new security context for the new file.
> > 
> > 	Do I need to pass in preserve_security as well so SELinux knows
> > what the ownership check determined?
> 
> Not for SELinux -- its security attributes are orthogonal to DAC, and it 
> will perform its own checks on them.

Is preserve_security supposed to also control the preservation of the
SELinux security attribute (security.selinux extended attribute)?  I'd
expect that either we preserve all the security-relevant attributes or
none of them.  And if that is the case, then SELinux has to know about
preserve_security in order to know what the security context of the new
inode will be.  

Also, if you are going to automatically degrade reflink(2) behavior
based on the owner_or_cap test, then you ought to allow the same to be
true if the security module vetoes the attempt to preserve attributes.
Either DAC or MAC logic may say that security attributes cannot be
preserved.  Your current logic will only allow graceful degradation in
the DAC case, but the MAC case will remain a hard failure.

> Other LSMs should operate similarly (there is also the CAP_CHOWN check 
> which the LSM may hook), although if not, the flag can be added later if 
> required.
> 
> 
> - James
-- 
Stephen Smalley
National Security Agency
