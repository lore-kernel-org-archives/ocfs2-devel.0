From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 13 May 2009 11:27:23 -0700
Subject: [Ocfs2-devel] [RFC] The reflink(2) system call v4.
In-Reply-To: <1242235438.9974.46.camel@localhost.localdomain>
References: <alpine.LRH.2.00.0905120819460.3090@tundra.namei.org>
	<20090511223414.GA28209@mail.oracle.com>
	<alpine.LRH.2.00.0905121107400.4463@tundra.namei.org>
	<1242130714.31807.25.camel@localhost.localdomain>
	<20090512172200.GC6896@mail.oracle.com>
	<1242149567.31807.90.camel@localhost.localdomain>
	<20090512180339.GG6896@mail.oracle.com>
	<4A0A2698.2000208@schaufler-ca.com>
	<20090513164259.GA32316@mail.oracle.com>
	<1242235438.9974.46.camel@localhost.localdomain>
Message-ID: <20090513182723.GD32316@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: James Morris <jmorris@namei.org>, jim owens <jowens@hp.com>, linux-security-module@vger.kernel.org, mtk.manpages@gmail.com, Casey Schaufler <casey@schaufler-ca.com>, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

On Wed, May 13, 2009 at 01:23:58PM -0400, Stephen Smalley wrote:
> File capabilities live under security.*, but ACLs predate the security
> namespace and live in the system namespace as
> "system.posix_acl_access" (and if a directory, there is also a
> "system.posix_acl_default" attribute that specifies the default ACL for
> new files in that directory).
> 
> In the preserve_security==0 case, you'd want to:
> - drop all attributes under security.* on the new inode,
> - set (security.<name>, value) to the name:value pair provided by
> security_inode_init_security(),
> - set system.posix_acl_access to the default ACL associated with the
> parent directory (the "system.posix_acl_default" attribute on the
> parent).
> 
> The latter two steps are what is already done in the new inode creation
> code path, so you hopefully can just reuse that code.

	I am absolutely expecting to reuse that code.  I was just
trying to make sure I didn't miss any steps prior to the normal
new-inode stuff.  Thanks.

Joel

-- 

 The zen have a saying:
 "When you learn how to listen, ANYONE can be your teacher."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
