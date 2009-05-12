From: jim owens <jowens@hp.com>
Date: Tue, 12 May 2009 13:45:45 -0400
Subject: [Ocfs2-devel] [RFC] The reflink(2) system call v4.
In-Reply-To: <Pine.LNX.4.64.0905120838040.18625@cobra.newdream.net>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<20090507221535.GA31624@mail.oracle.com> <4A039FF8.7090807@hp.com>
	<20090508031018.GB8611@mail.oracle.com>
	<20090511204011.GB30293@mail.oracle.com>
	<Pine.LNX.4.64.0905120748310.18625@cobra.newdream.net>
	<4A09945C.2080002@hp.com>
	<Pine.LNX.4.64.0905120838040.18625@cobra.newdream.net>
Message-ID: <4A09B5C9.1000307@hp.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sage Weil <sage@newdream.net>
Cc: Joel Becker <Joel.Becker@oracle.com>, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk, mtk.manpages@gmail.com, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org

Sage Weil wrote:
> Maybe not, but that's a separate question from the interface issue.  We 
> shouldn't preclude the possibility creating tools that preserve attributes 
> (or warn if they can't) and tools that simply want to cow data to a new 
> file.  AFAICS reflink(2) as proposed doesn't quite let you do either one 
> without extra hackery to compensate for its dual-mode behavior. If this 
> thread has demonstrated anything, it's that some users want snapshot-like 
> semantics (cp -p) and some want cowfile()-like semantics (cp).  What is 
> the benefit of combining the two into a single call?  If I want 
> snapshot-like semantics, I would rather get -EPERM if I lack the necessary 
> permissions than silently get an approximation.

I'm not fighting against two syscalls but the reason I like
the V4 definition is the opposite of knowing I failed to snapshot.

It is really because in my experience as both root on multi-user
systems and basic untrusted user, when root copies something from
a user there are only two desired outcomes:

  1) cp -p

  2) cp, chown "someone" , chgrp "somegroup", chmod "new rights"

The common mistake is wanting #1 and forgetting the -p so it
then produces an error and has to be fixed.

Using root's default attributes is almost never desired.

So with this reflink() definition, normal users get their own
attributes and root automatically gets preserve but can change
them later.

IMO this is optimized for humans, and I don't really know
of any privileged daemon things that are setuid and
want to not preserve attributes.  Do you have examples?

jim
