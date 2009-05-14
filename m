From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Date: Thu, 14 May 2009 20:43:52 +0200
Subject: [Ocfs2-devel] [RFC] The reflink(2) system call v4.
In-Reply-To: <4A0975B1.90703@hp.com>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<20090507221535.GA31624@mail.oracle.com> <4A039FF8.7090807@hp.com>
	<20090508031018.GB8611@mail.oracle.com>
	<20090511204011.GB30293@mail.oracle.com>
	<20090512113152.GE6585@logfs.org> <4A0975B1.90703@hp.com>
Message-ID: <20090514184351.GA911@logfs.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: jim owens <jowens@hp.com>
Cc: Joel Becker <Joel.Becker@oracle.com>, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk, mtk.manpages@gmail.com, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org

[ Delayed response - mailserver was dead. ]

On Tue, 12 May 2009 09:12:17 -0400, jim owens wrote:
> 
> >Because if it is, I would call that behaviour rather confusing.  A
> >system call that behaves differently depending on who calls it - or
> >on whether the binary is installed suid root - is something I would like
> >to avoid.
> 
> Avoiding that just gives us other confusing operations unless
> you have a really good alternative.
> 
> This design is very elegant, I wish I had thought of it :)
> 
> It passes the test that 99% of the time for any user (including
> root), "it just works the way I want it to".  In my experience,
> root and setuid programs really don't want to take ownership,
> they want to replicate it.
> 
> The behavior matches "cp -p" or "tar -x" and yes those are not
> system calls but so what.  What matters is the documentation is
> clear about what happens and the most useful result occurs.

If what you want is copyfile(2), this is a poor design because it
usually does what you want and sometimes doesn't.  If what you want is
reflink(2), this may be acceptable.  Not sure.  I personally would
prefer to get -EPERM or something instead of altered behaviour.

So you can count me in with the people that propose two seperate system
calls.

J?rn

-- 
They laughed at Galileo.  They laughed at Copernicus.  They laughed at
Columbus. But remember, they also laughed at Bozo the Clown.
-- unknown
