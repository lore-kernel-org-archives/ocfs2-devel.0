From: Jamie Lokier <jamie@shareable.org>
Date: Fri, 15 May 2009 02:20:31 +0100
Subject: [Ocfs2-devel] [RFC] The reflink(2) system call v4.
In-Reply-To: <20090514220029.GB30410@mail.oracle.com>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<20090507221535.GA31624@mail.oracle.com> <4A039FF8.7090807@hp.com>
	<20090508031018.GB8611@mail.oracle.com>
	<20090511204011.GB30293@mail.oracle.com> <4A0B96C6.40702@mit.edu>
	<1242324765.21772.95.camel@localhost.localdomain>
	<20090514220029.GB30410@mail.oracle.com>
Message-ID: <20090515012031.GA26694@shareable.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> 	Here's my problem.  Every single shell script now has to do:
> 
>     ln -r source target
>     [ $? != 0 ] && ln -r --no-perms source target

No, they'll obviously do

    ln -Rr source target

It is not a burden to type that.

(Where -R == your -r --no-perms, and -R -r together means try -R then -r).

> Every single program now has to do:
> 
>     if (reflink(source, target) && errno == EPERM)
>         reflinkat(AT_FDCWD, source, AT_FDCWD, target, 0, REFLINK_NOPERMS);

Yes if that's what they want.

> Because the 99% user wants a real snapshot,

A quick poll based on emails in these threads says >50% doesn't want a real snapshot :-)

But even at 99%, what about the other 1%?

As I've explained, it is _impossible_ for userspace to do "ln -r" thing
itself in some conditions given your system call.

> and doesn't want to have to think about it.

The problem with the "automatic" switch is that it isn't obvious, so
people will make mistaken assumptions when using it.

If they _want_ the automatic switch, then a few moments of thought
doesn't matter.  Make it easy if you care: like "ln -Rr" in scripts
and a flag REFLINK_PERMS_IF_ALLOWED in the system call.

This is especially so with reflink(), because the userspace code if
you _didn't_ want the automatic change are tricky to write (and
extremely difficult to get right), so authors will either not bother,
or do it badly.

And test suites for programs using reflink() will pass nicely, yet the
code may still be broken because ordinary users can't test the "other
user's files" cases.

> The could, of course, code up their own permission
> checks to see which variant of reflink to call, but it's still useless
> (to them) boilerplate.

Why wouldn't you just do the two calls?  It's much easier.  But even
that goes away with REFLINK_PERMS_IF_ALLOWED (and conversely
REFLINK_PERMS_STRICT).

(Note it's not just permissions - it's also timestamps, group,
xattrs. The flag names could reflect that).

> 	Also, if the 'common' user has to use the reflinkat() call?  We've lost.

Provide a reflink() call in libc.  Problem solved.

Heck, provide separate reflink() and cowlink() calls in libc if you
don't like a flag.

> 	Finally, how is this safer?  Don't get me wrong, I do respect
> the concern - that's why I originally went with your proposal of
> is_owner_or_cap().  But the fact is that if you've hijacked a process
> with enough privileges, you *can* make the full reflink, and if your
> hijacked process doesn't but does have read access, you *can* make the
> NOPERMS reflink.

If you can trick a process into unexpected behaviour, it doesn't mean
you can make it do just anything.  It means you can trick specific
checks and assumptions that the program makes into being wrong,
because you made something behave in a way the authors didn't expect.
Building on that, sometimes the trick is enough to make a backdoor.

Which is why file system calls should behave in a simple way that
don't surprise anyone.

> So doing it with the userspace code above is identical
> to the kernel code, except that every userspace program has to handle it
> themselves.

No because not every userspace program _wants_ that behaviour.

So you have these problems if it's forced in the kernel:

    - Userspace programs that _don't want_ a "full reflink" but have the
      privilege to do to.  Sometimes they can't do the chmod/etc. to
      fix the attributes after _at all_ (think setgid-directories
      among other things - it's *hard* to simulate that in userspace
      and never quite right).

    - Sometimes fixing up afterwards would be a security race
      condition - the temporary unwanted permissions can be looser
      looser than the process wants to expose in the new directory.

What I'm seeing is that for the benefit of saving exactly one line in
some userspace programs - a line which is quite helpful in showing
what the program intends - it will cost about 1000 lines of code
(which is still slightly broken) in other userspace programs, and I
can think of a number of those programs already.  Not pretty.

If you don't like the two calls, just add a flag which means try one
then the other.  Then it's clear what the app is requesting, and
invites authors to decide what behaviour they want, trivially.

-- Jamie
