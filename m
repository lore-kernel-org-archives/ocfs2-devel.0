From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 17 Sep 2009 11:40:33 -0700
Subject: [Ocfs2-devel] [GIT PULL] ocfs2 changes for 2.6.32
In-Reply-To: <alpine.LFD.2.01.0909170856050.4950@localhost.localdomain> (Linus
	Torvalds's message of "Thu, 17 Sep 2009 09:29:14 -0700 (PDT)")
References: <20090914221434.GA4507@mail.oracle.com>
	<alpine.LFD.2.01.0909141614350.4950@localhost.localdomain>
	<20090915000417.GC4507@mail.oracle.com>
	<alpine.LFD.2.01.0909141727150.4950@localhost.localdomain>
	<20090915005417.GD4507@mail.oracle.com>
	<alpine.LFD.2.01.0909141828070.4950@localhost.localdomain>
	<20090915040601.GE4507@mail.oracle.com>
	<alpine.LFD.2.01.0909150923180.4950@localhost.localdomain>
	<20090915214530.GA11060@mail.oracle.com>
	<alpine.LFD.2.01.0909152116180.4950@localhost.localdomain>
	<20090916044047.GA30453@mail.oracle.com>
	<alpine.LFD.2.01.0909170856050.4950@localhost.localdomain>
Message-ID: <adabpl9ct3y.fsf@cisco.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Joel Becker <Joel.Becker@oracle.com>, Mark Fasheh <mfasheh@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com


 >   int copy_file(const char *src, const char *dst)
 >   {
 >	/* Start a file copy */
 >	int cookie = copyfile(src, dst, 0);
 >
 >	/* Async case? */
 >	if (cookie > 0) {
 >		int ret;
 >
 >		while ((ret = copyfile_ctrl(cookie, COPYFILE_WAIT)) > 0)
 >			/* nothing */;
 >
 >		/* Error handling is shared for async/sync */
 >		cookie = ret;
 >	}
 >	if (cookie < 0) {
 >		perror("copyfile failed");
 >		return -1;
 >	}

I guess one bit of semantics to figure out is what happens if copyfile()
does the async case but then copyfile_ctrl() returns an error halfway
through... is the state of the dest file just undefined?

 - R.
