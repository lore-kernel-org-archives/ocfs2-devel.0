From: Shaya Potter <spotter@cs.columbia.edu>
Date: Fri, 15 May 2009 13:01:10 -0400
Subject: [Ocfs2-devel] [RFC] The reflink(2) system call v4.
In-Reply-To: <20090515164209.GD31454@mail.oracle.com>
References: <20090507221535.GA31624@mail.oracle.com> <4A039FF8.7090807@hp.com>
	<20090508031018.GB8611@mail.oracle.com>
	<20090511204011.GB30293@mail.oracle.com> <4A0B96C6.40702@mit.edu>
	<1242324765.21772.95.camel@localhost.localdomain>
	<20090514220029.GB30410@mail.oracle.com>
	<1242388905.29973.17.camel@localhost.localdomain>
	<20090515152212.GA31454@mail.oracle.com>
	<1242402925.29973.163.camel@localhost.localdomain>
	<20090515164209.GD31454@mail.oracle.com>
Message-ID: <4A0D9FD6.7070307@cs.columbia.edu>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> On Fri, May 15, 2009 at 11:55:25AM -0400, Stephen Smalley wrote:
>>> 	I wasn't being specific to injected code.  Assume we have a
>>> deliberate flag to reflinkat(2).  Then we provide reflink(3) in
>>> userspace that does the fallback, keeping it out of the kernel.  Doesn't
>>> that have the exact same problem?
>> You wouldn't always do the fallback in reflink(3), but instead provide a
>> helper interface that would perform the fallback for applications that
>> want that behavior.
> 
> 	But isn't that reflink(3)?  And the application that wants to
> know uses reflinkat(2)?
>> Consider a program that wants to always preserve attributes on the
>> reflinks it creates.  If the interface allows the program to explicitly
>> request that behavior and returns an error when the request cannot be
>> honored, then the program knows that upon a successful return, the
>> attributes were in fact preserved.  If the interface instead silently
>> selects a behavior based on the current privileges of the process and
>> gives no indication to the caller as to what behavior was selected, then
>> the opportunity for error is great.
> 
> 	I get that.  I'm looking at what the programming interface is.
> What's the standard function for "I want the fallback behavior" called?
> What's the standard function for "I want preserve security" called?
> "int reflink(oldpath, newpath)" has to pick one of the behaviors.  Which
> is it?

whenever there's hidden fallback behavior that changes the security
semantics you will cause programming error.

the only correct way for an application to code that want the fallback
functionality

if (initial_behavior()) {
	if (fallback_behavior()) {
		some sort of error
	}
}

as that way the application knows what occured.  if that logic is
wrapped in a single function (like , you would have to dosomething like

if (ret == initial_and_fallbakc()) {
	if (ret == 0) {
		fallback = 0;
	} else if (ret == 1) {
		fallback == 1;
	} else {
		some sort of error
	}
}

which is much more prone to error.

at the end of the day, a single function that has hidden fallback
behavior does not really save lines of code in a well written
application.  it does however make it easier to write a poorly written
application that can cause security problems.
