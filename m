From: James Morris <jmorris@namei.org>
Date: Fri, 15 May 2009 23:35:09 +1000 (EST)
Subject: [Ocfs2-devel] [RFC] The reflink(2) system call v4.
In-Reply-To: <1242388467.29973.11.camel@localhost.localdomain>
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
	<alpine.LRH.2.00.0905150906580.4933@tundra.namei.org>
	<1242388467.29973.11.camel@localhost.localdomain>
Message-ID: <alpine.LRH.2.00.0905152319140.12694@tundra.namei.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Joel Becker <Joel.Becker@oracle.com>, jim owens <jowens@hp.com>, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk, mtk.manpages@gmail.com, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Fri, 15 May 2009, Stephen Smalley wrote:

> The create_sid is not relevant in the preserve_security==1 case; the
> filesystem will always preserve the security context from the original
> inode on the new inode in that case.  The create_sid won't ever be used
> in that case, as it only gets applied if the filesystem calls
> security_inode_init_security() to obtain the attribute (name, value)
> pair for a new inode, and the filesystem will only do that in the
> preserve_security==0 case.

Ok.  Does this break the idea of create_sid, though?  i.e. it will be 
ignored when a new file is created via reflink(), potentially allowing DAC 
to determine whether MAC labeling policy is enforced, and is also not 
consistent with the way fsuid is handled.


- James
-- 
James Morris
<jmorris@namei.org>
