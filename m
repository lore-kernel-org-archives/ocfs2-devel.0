From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 12 May 2009 10:28:02 -0700
Subject: [Ocfs2-devel] [RFC] The reflink(2) system call v4.
In-Reply-To: <Pine.LNX.4.64.0905120748310.18625@cobra.newdream.net>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<20090507221535.GA31624@mail.oracle.com> <4A039FF8.7090807@hp.com>
	<20090508031018.GB8611@mail.oracle.com>
	<20090511204011.GB30293@mail.oracle.com>
	<Pine.LNX.4.64.0905120748310.18625@cobra.newdream.net>
Message-ID: <20090512172802.GD6896@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sage Weil <sage@newdream.net>
Cc: jim owens <jowens@hp.com>, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk, mtk.manpages@gmail.com, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Tue, May 12, 2009 at 08:04:21AM -0700, Sage Weil wrote:
> To me, a simple 'cp' type operation (assuming it gets wired up the way it 
> could) seems like at least as common a use case than a 'snapshot' 
> operation.  I know that's not what your main goal here, but I don't 
> understand the resistance to two syscalls.  Mixing the two might give you 
> the right answer in many cases, but certainly not all, and it makes for 
> confusing application interface semantics that we won't be able to change 
> down the line.

	I'm not against two syscalls, but I'm not writing copyfile()
here, just reflink().  Someone clearly could write copyfile() later and
link into some of the same underlying mechanisms.
	It's important to distinguish the semantics, though, and that's
why I'm doing one thing.  For example, reflink() is a snapshot (a
"reference-counted link") and has behaviors based on that.  libc should
never fake it, because the callers expect those behaviors.  Whereas
copyfile() would be fakeable in libc with a read/write cycle on
filesystems that don't support it.  Things like that.
	Heck, I think you could use reflink() to create a copyfile() in
libc that uses no additional syscall.  But you couldn't use copyfile()
to create reflink().

Joel

-- 

"Lately I've been talking in my sleep.
 Can't imagine what I'd have to say.
 Except my world will be right
 When love comes back my way."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
