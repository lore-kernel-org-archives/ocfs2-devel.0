From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 14 May 2009 15:00:29 -0700
Subject: [Ocfs2-devel] [RFC] The reflink(2) system call v4.
In-Reply-To: <1242324765.21772.95.camel@localhost.localdomain>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<20090507221535.GA31624@mail.oracle.com> <4A039FF8.7090807@hp.com>
	<20090508031018.GB8611@mail.oracle.com>
	<20090511204011.GB30293@mail.oracle.com> <4A0B96C6.40702@mit.edu>
	<1242324765.21772.95.camel@localhost.localdomain>
Message-ID: <20090514220029.GB30410@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Andy Lutomirski <luto@mit.edu>, jim owens <jowens@hp.com>, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk, mtk.manpages@gmail.com, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Thu, May 14, 2009 at 02:12:45PM -0400, Stephen Smalley wrote:
> On Wed, 2009-05-13 at 23:57 -0400, Andy Lutomirski wrote:
> > Joel Becker wrote:
> > > +
> > > +Preserving the security context of the source file obviously requires
> > > +the privilege to do so.  Callers that do not own the source file and do
> > > +not have CAP_CHOWN will get a new reflink with all non-security
> > > +attributes preserved; the security context of the new reflink will be
> > > +as a newly created file by that user.
> > > +
> > 
> > There are plenty of syscalls that require some privilege and fail if the 
> > caller doesn't have it.  But I can think of only one syscall that does 
> > *something different* depending on who called it: setuid.
> > 
> > Please search the web and marvel at the disasters caused by setuid's 
> > magical caller-dependent behavior (the sendmail bug is probably the most 
> > famous [1]).  This proposal for reflink is just asking for bugs where an 
> > attacker gets some otherwise privileged program to call reflink but to 
> > somehow lack the privileges (CAP_CHOWN, selinux rights, or whatever) to 
> > copy security attributes, thus exposing a link with the wrong permissions.
> > 
> > Would it really be that hard to have two syscalls, or a flag, or 
> > whatever, where one of them preserves all security attributes and 
> > *fails* if the caller isn't allowed to do that and the other one makes 
> > the caller own the new link?
> > 
> > 
> > [1] http://www.cs.berkeley.edu/~daw/papers/setuid-usenix02.pdf
> 
> Yes, I agree - the selection of whether or not to preserve the security
> attributes should be an explicit part of the kernel interface.  Then the
> application still has the freedom to fall back on the non-preserving
> form of the call if that is truly what it wants.

	Here's my problem.  Every single shell script now has to do:

    ln -r source target
    [ $? != 0 ] && ln -r --no-perms source target

Every single program now has to do:

    if (reflink(source, target) && errno == EPERM)
        reflinkat(AT_FDCWD, source, AT_FDCWD, target, 0, REFLINK_NOPERMS);

Because the 99% user wants a real snapshot, and doesn't want to have to
think about it.  The could, of course, code up their own permission
checks to see which variant of reflink to call, but it's still useless
(to them) boilerplate.
	Also, if the 'common' user has to use the reflinkat() call?
We've lost.
	Finally, how is this safer?  Don't get me wrong, I do respect
the concern - that's why I originally went with your proposal of
is_owner_or_cap().  But the fact is that if you've hijacked a process
with enough privileges, you *can* make the full reflink, and if your
hijacked process doesn't but does have read access, you *can* make the
NOPERMS reflink.  So doing it with the userspace code above is identical
to the kernel code, except that every userspace program has to handle it
themselves.

Joel

-- 

"Vote early and vote often." 
        - Al Capone

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
