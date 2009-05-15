From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 15 May 2009 09:42:09 -0700
Subject: [Ocfs2-devel] [RFC] The reflink(2) system call v4.
In-Reply-To: <1242402925.29973.163.camel@localhost.localdomain>
References: <20090507221535.GA31624@mail.oracle.com> <4A039FF8.7090807@hp.com>
	<20090508031018.GB8611@mail.oracle.com>
	<20090511204011.GB30293@mail.oracle.com> <4A0B96C6.40702@mit.edu>
	<1242324765.21772.95.camel@localhost.localdomain>
	<20090514220029.GB30410@mail.oracle.com>
	<1242388905.29973.17.camel@localhost.localdomain>
	<20090515152212.GA31454@mail.oracle.com>
	<1242402925.29973.163.camel@localhost.localdomain>
Message-ID: <20090515164209.GD31454@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Andy Lutomirski <luto@mit.edu>, jim owens <jowens@hp.com>, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk, mtk.manpages@gmail.com, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Fri, May 15, 2009 at 11:55:25AM -0400, Stephen Smalley wrote:
> > 	I wasn't being specific to injected code.  Assume we have a
> > deliberate flag to reflinkat(2).  Then we provide reflink(3) in
> > userspace that does the fallback, keeping it out of the kernel.  Doesn't
> > that have the exact same problem?
> 
> You wouldn't always do the fallback in reflink(3), but instead provide a
> helper interface that would perform the fallback for applications that
> want that behavior.

	But isn't that reflink(3)?  And the application that wants to
know uses reflinkat(2)?
> 
> Consider a program that wants to always preserve attributes on the
> reflinks it creates.  If the interface allows the program to explicitly
> request that behavior and returns an error when the request cannot be
> honored, then the program knows that upon a successful return, the
> attributes were in fact preserved.  If the interface instead silently
> selects a behavior based on the current privileges of the process and
> gives no indication to the caller as to what behavior was selected, then
> the opportunity for error is great.

	I get that.  I'm looking at what the programming interface is.
What's the standard function for "I want the fallback behavior" called?
What's the standard function for "I want preserve security" called?
"int reflink(oldpath, newpath)" has to pick one of the behaviors.  Which
is it?

Joel

-- 

Life's Little Instruction Book #69

	"Whistle"

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
