From: Jamie Lokier <jamie@shareable.org>
Date: Tue, 12 May 2009 21:24:57 +0100
Subject: [Ocfs2-devel] [RFC] The reflink(2) system call v4.
In-Reply-To: <4A0975B1.90703@hp.com>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<20090507221535.GA31624@mail.oracle.com> <4A039FF8.7090807@hp.com>
	<20090508031018.GB8611@mail.oracle.com>
	<20090511204011.GB30293@mail.oracle.com>
	<20090512113152.GE6585@logfs.org> <4A0975B1.90703@hp.com>
Message-ID: <20090512202457.GF10436@shareable.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: jim owens <jowens@hp.com>
Cc: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>, Joel Becker <Joel.Becker@oracle.com>, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk, mtk.manpages@gmail.com, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org

jim owens wrote:
> It passes the test that 99% of the time for any user (including
> root), "it just works the way I want it to".  In my experience,
> root and setuid programs really don't want to take ownership,
> they want to replicate it.

Unfortunately in the other 1%, as I've explained in detail in another
mail, it's a lot of work and sometimes impossible for a program to set
the attributes to be those of a new file.

Whereas an explicit choice between snapshot attributes and new-file
attributes never causes problems, because it's trivial to provide the
automatic "-p" switch by trying one then the other.

To human-optimise, make your reflink _program_ do that.
Humans don't call system calls themselves :-)

> The behavior matches "cp -p" or "tar -x"

Actually it doesn't, but even if it did, not having any way to turn
off the "-p" would be just as annoying as if you couldn't do that with "cp".

If you like root to have "cp -p", put it in /root/.bashrc :-)

-- Jamie
