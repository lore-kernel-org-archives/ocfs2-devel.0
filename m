From: James Morris <jmorris@namei.org>
Date: Fri, 15 May 2009 09:25:33 +1000 (EST)
Subject: [Ocfs2-devel] [RFC] The reflink(2) system call v4.
In-Reply-To: <1242325533.21772.102.camel@localhost.localdomain>
References: <20090507221535.GA31624@mail.oracle.com> <4A039FF8.7090807@hp.com>
	<20090508031018.GB8611@mail.oracle.com>
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
	<1242325533.21772.102.camel@localhost.localdomain>
Message-ID: <alpine.LRH.2.00.0905150906580.4933@tundra.namei.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Joel Becker <Joel.Becker@oracle.com>, jim owens <jowens@hp.com>, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk, mtk.manpages@gmail.com, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Thu, 14 May 2009, Stephen Smalley wrote:

> And you can likely make preserve_security a simple bool (set from some
> caller-provided flag) rather than an int.  At which point the SELinux
> wiring for the new hook would be something like this:
> 
> If we are preserving security attributes on the reflink, then treat it
> like creating a link to an existing file;

Do we also need to somewhat consider it like a new file? e.g. in the case 
of create_sid being set (if different to the existing security attribute), 
I believe we need to fail the operation because security attributes are 
not preserved, and also decide which error code to return (the user may be 
confused if it's EACCES -- EINVAL might be better).  Similar for reflinks 
on a context mounted file system, although create_sid needs to be checked 
during inode instantiation (unless we, say, add set a preserve_sid flag 
which overrides create_sid and is cleared upon use).


- James
-- 
James Morris
<jmorris@namei.org>
