From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 15 May 2009 08:22:13 -0700
Subject: [Ocfs2-devel] [RFC] The reflink(2) system call v4.
In-Reply-To: <1242388905.29973.17.camel@localhost.localdomain>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<20090507221535.GA31624@mail.oracle.com> <4A039FF8.7090807@hp.com>
	<20090508031018.GB8611@mail.oracle.com>
	<20090511204011.GB30293@mail.oracle.com> <4A0B96C6.40702@mit.edu>
	<1242324765.21772.95.camel@localhost.localdomain>
	<20090514220029.GB30410@mail.oracle.com>
	<1242388905.29973.17.camel@localhost.localdomain>
Message-ID: <20090515152212.GA31454@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Andy Lutomirski <luto@mit.edu>, jmorris@namei.org, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, mtk.manpages@gmail.com, jim owens <jowens@hp.com>, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

On Fri, May 15, 2009 at 08:01:45AM -0400, Stephen Smalley wrote:
> > 	Finally, how is this safer?  Don't get me wrong, I do respect
> > the concern - that's why I originally went with your proposal of
> > is_owner_or_cap().  But the fact is that if you've hijacked a process
> > with enough privileges, you *can* make the full reflink, and if your
> > hijacked process doesn't but does have read access, you *can* make the
> > NOPERMS reflink.  So doing it with the userspace code above is identical
> > to the kernel code, except that every userspace program has to handle it
> > themselves.
> 
> As Jamie said, we aren't talking about injecting arbitrary code into the
> process.  The failure scenario is quite similar to the setuid() one:
> arrange conditions such that the process lacks sufficient privileges to
> preserve attributes, and when it calls reflink(2) expecting to preserve
> the attributes, it will get no indication that they weren't preserved.
> At which point the data may be unwittingly exposed beyond its original
> constraints.

	I wasn't being specific to injected code.  Assume we have a
deliberate flag to reflinkat(2).  Then we provide reflink(3) in
userspace that does the fallback, keeping it out of the kernel.  Doesn't
that have the exact same problem?

Joel

-- 

"Same dancers in the same old shoes.
 You get too careful with the steps you choose.
 You don't care about winning but you don't want to lose
 After the thrill is gone."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
