From: Jamie Lokier <jamie@shareable.org>
Date: Tue, 12 May 2009 21:36:09 +0100
Subject: [Ocfs2-devel] [RFC] The reflink(2) system call v2.
In-Reply-To: <20090511234624.GC28209@mail.oracle.com>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<20090507221535.GA31624@mail.oracle.com> <4A039FF8.7090807@hp.com>
	<20090511204924.GC30293@mail.oracle.com> <4A08AB5D.7090706@hp.com>
	<20090511234624.GC28209@mail.oracle.com>
Message-ID: <20090512203609.GH10436@shareable.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: jim owens <jowens@hp.com>, linux-fsdevel@vger.kernel.org, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk, mtk.manpages@gmail.com, linux-security-module@vger.kernel.org

Joel Becker wrote:
> 	Someone else pointed out that a naive user might reflink a block
> device file and expect the device contents to be copied-on-write.
> Obviously wrong if you understand filesystems, but let's just prevent
> that misunderstanding.  S_ISREG() it is.

I think S_ISLNK() should be allowed too if the filesystem allows, as
it is harmless, behaves as expected, saves a little space, and copying
symlink attributes is meaningful too.

-- Jamie
