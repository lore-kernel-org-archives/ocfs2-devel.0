From: Jamie Lokier <jamie@shareable.org>
Date: Tue, 12 May 2009 21:29:19 +0100
Subject: [Ocfs2-devel] [RFC] The reflink(2) system call v4.
In-Reply-To: <4A09B5C9.1000307@hp.com>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<20090507221535.GA31624@mail.oracle.com> <4A039FF8.7090807@hp.com>
	<20090508031018.GB8611@mail.oracle.com>
	<20090511204011.GB30293@mail.oracle.com>
	<Pine.LNX.4.64.0905120748310.18625@cobra.newdream.net>
	<4A09945C.2080002@hp.com>
	<Pine.LNX.4.64.0905120838040.18625@cobra.newdream.net>
	<4A09B5C9.1000307@hp.com>
Message-ID: <20090512202919.GG10436@shareable.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: jim owens <jowens@hp.com>
Cc: Sage Weil <sage@newdream.net>, Joel Becker <Joel.Becker@oracle.com>, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk, mtk.manpages@gmail.com, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org

jim owens wrote:
> Using root's default attributes is almost never desired.
                                     ^^^^^^

Exactly.  When it is desired, it shouldn't be impossible :-)

Setting attributes to those of a new file outside the kernel requires
parsing /proc/mounts and knowing filesystem-type-specific things,
among other things.  Ugly stuff - should never be written.  Don't make
such ugly stuff be written (and fail when /proc isn't mounted).

There is also the principle of least surprise...  Shell scripts which
behave differently for root - that's asking for trouble.

-- Jamie
