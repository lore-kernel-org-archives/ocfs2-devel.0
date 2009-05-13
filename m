From: Sage Weil <sage@newdream.net>
Date: Tue, 12 May 2009 21:30:22 -0700 (PDT)
Subject: [Ocfs2-devel] [RFC] The reflink(2) system call v4.
In-Reply-To: <20090512172802.GD6896@mail.oracle.com>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<20090507221535.GA31624@mail.oracle.com> <4A039FF8.7090807@hp.com>
	<20090508031018.GB8611@mail.oracle.com>
	<20090511204011.GB30293@mail.oracle.com>
	<Pine.LNX.4.64.0905120748310.18625@cobra.newdream.net>
	<20090512172802.GD6896@mail.oracle.com>
Message-ID: <Pine.LNX.4.64.0905122102210.18625@cobra.newdream.net>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <Joel.Becker@oracle.com>
Cc: jim owens <jowens@hp.com>, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk, mtk.manpages@gmail.com, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Tue, 12 May 2009, Joel Becker wrote:
> 	I'm not against two syscalls, but I'm not writing copyfile()
> here, just reflink().  Someone clearly could write copyfile() later and
> link into some of the same underlying mechanisms.

Ok, good.

> 	It's important to distinguish the semantics, though, and that's
> why I'm doing one thing.  For example, reflink() is a snapshot (a
> "reference-counted link") and has behaviors based on that.  libc should
> never fake it, because the callers expect those behaviors.  Whereas
> copyfile() would be fakeable in libc with a read/write cycle on
> filesystems that don't support it.  Things like that.
> 	Heck, I think you could use reflink() to create a copyfile() in
> libc that uses no additional syscall.  But you couldn't use copyfile()
> to create reflink().

Right, except that you _could_ implement the degraded (no CAP_CHOWN) 
reflink() behavior with a hypothetical copyfile().

I just think you should be sure that reflink() has _exactly_ the snapshot 
semantics that make sense, without compromises that try to capture some or 
all of copyfile() as well.  Assuming that a copyfile() type syscall also 
existed, would you really want reflink() to silently degrade to something 
that can be implemented via copyfile() when you lack CAP_CHOWN?

With the proposed reflink(), we might end up with a final API that looks 
something like:

 cowfile(src, dst, flags) - cow data and/or xattrs from src to dst
 reflink(src, dst) - snapshot src to dst, or if !CAP_CHOWN, cowfile() instead

A simpler reflink() would make that degradation non-mandatory, and 
trivially implemented in userspace by those who want it.

sage
