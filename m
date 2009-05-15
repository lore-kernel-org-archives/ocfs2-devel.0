From: Stephen Smalley <sds@tycho.nsa.gov>
Date: Fri, 15 May 2009 11:55:25 -0400
Subject: [Ocfs2-devel] [RFC] The reflink(2) system call v4.
In-Reply-To: <20090515152212.GA31454@mail.oracle.com>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<20090507221535.GA31624@mail.oracle.com> <4A039FF8.7090807@hp.com>
	<20090508031018.GB8611@mail.oracle.com>
	<20090511204011.GB30293@mail.oracle.com> <4A0B96C6.40702@mit.edu>
	<1242324765.21772.95.camel@localhost.localdomain>
	<20090514220029.GB30410@mail.oracle.com>
	<1242388905.29973.17.camel@localhost.localdomain>
	<20090515152212.GA31454@mail.oracle.com>
Message-ID: <1242402925.29973.163.camel@localhost.localdomain>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <Joel.Becker@oracle.com>
Cc: Andy Lutomirski <luto@mit.edu>, jim owens <jowens@hp.com>, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk, mtk.manpages@gmail.com, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Fri, 2009-05-15 at 08:22 -0700, Joel Becker wrote:
> On Fri, May 15, 2009 at 08:01:45AM -0400, Stephen Smalley wrote:
> > > 	Finally, how is this safer?  Don't get me wrong, I do respect
> > > the concern - that's why I originally went with your proposal of
> > > is_owner_or_cap().  But the fact is that if you've hijacked a process
> > > with enough privileges, you *can* make the full reflink, and if your
> > > hijacked process doesn't but does have read access, you *can* make the
> > > NOPERMS reflink.  So doing it with the userspace code above is identical
> > > to the kernel code, except that every userspace program has to handle it
> > > themselves.
> > 
> > As Jamie said, we aren't talking about injecting arbitrary code into the
> > process.  The failure scenario is quite similar to the setuid() one:
> > arrange conditions such that the process lacks sufficient privileges to
> > preserve attributes, and when it calls reflink(2) expecting to preserve
> > the attributes, it will get no indication that they weren't preserved.
> > At which point the data may be unwittingly exposed beyond its original
> > constraints.
> 
> 	I wasn't being specific to injected code.  Assume we have a
> deliberate flag to reflinkat(2).  Then we provide reflink(3) in
> userspace that does the fallback, keeping it out of the kernel.  Doesn't
> that have the exact same problem?

You wouldn't always do the fallback in reflink(3), but instead provide a
helper interface that would perform the fallback for applications that
want that behavior.

Consider a program that wants to always preserve attributes on the
reflinks it creates.  If the interface allows the program to explicitly
request that behavior and returns an error when the request cannot be
honored, then the program knows that upon a successful return, the
attributes were in fact preserved.  If the interface instead silently
selects a behavior based on the current privileges of the process and
gives no indication to the caller as to what behavior was selected, then
the opportunity for error is great.

-- 
Stephen Smalley
National Security Agency
