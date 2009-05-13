From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 13 May 2009 09:43:00 -0700
Subject: [Ocfs2-devel] [RFC] The reflink(2) system call v4.
In-Reply-To: <4A0A2698.2000208@schaufler-ca.com>
References: <20090508031018.GB8611@mail.oracle.com>
	<20090511204011.GB30293@mail.oracle.com>
	<alpine.LRH.2.00.0905120819460.3090@tundra.namei.org>
	<20090511223414.GA28209@mail.oracle.com>
	<alpine.LRH.2.00.0905121107400.4463@tundra.namei.org>
	<1242130714.31807.25.camel@localhost.localdomain>
	<20090512172200.GC6896@mail.oracle.com>
	<1242149567.31807.90.camel@localhost.localdomain>
	<20090512180339.GG6896@mail.oracle.com>
	<4A0A2698.2000208@schaufler-ca.com>
Message-ID: <20090513164259.GA32316@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: James Morris <jmorris@namei.org>, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, mtk.manpages@gmail.com, jim owens <jowens@hp.com>, Stephen Smalley <sds@tycho.nsa.gov>, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

On Tue, May 12, 2009 at 06:47:04PM -0700, Casey Schaufler wrote:
> Joel Becker wrote:
> > 	Oh, absolutely.
> > 	As an aside, do inodes ever have more than one security.*
> > attribute?
> 
> ACLs, capability sets and Smack labels can all exist on a file at
> the same time. I know of at least one effort underway to create a
> multiple-label LSM.

	So ACLs and cap sets live under security.*?  That's good.

> > Would my (existing) inode then have
> > security.smack and security.selinux attributes?
> >   
> 
> Yup. It happens all the time. Whenever someone converts a Fedora
> system to Smack they end up with a filesystem full of unused selinux
> labels. It does no harm.

	At that runtime, sure.  But with reflink(), we may be reflinking
someone else's inode, and if we have to drop its security state, we
should clean the unused labels just in case they go back to selinux (or
back to smack, etc).  But if they are all under security.*, it's easy to
do.

Thanks!
Joel

-- 

Life's Little Instruction Book #173

	"Be kinder than necessary."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
