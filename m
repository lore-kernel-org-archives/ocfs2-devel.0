From: Mark Fasheh <mfasheh@suse.de>
Date: Fri, 18 Dec 2015 15:23:19 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: dlm: fix recursive locking deadlock
In-Reply-To: <566F7054.8030501@oracle.com>
References: <1450058259-30682-1-git-send-email-junxiao.bi@oracle.com>
	<566EC6A8020000F90002219D@relay2.provo.novell.com>
	<566E5BA5.5030308@oracle.com>
	<20151214191827.GF11072@wotan.suse.de>
	<566F7054.8030501@oracle.com>
Message-ID: <20151218232319.GM11072@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Dec 15, 2015 at 09:43:48AM +0800, Junxiao Bi wrote:
> Hi Mark,
> 
> On 12/15/2015 03:18 AM, Mark Fasheh wrote:
> > On Mon, Dec 14, 2015 at 02:03:17PM +0800, Junxiao Bi wrote:
> >>> Second, this issue can be reproduced in old Linux kernels (e.g. 3.16.7-24)? there should not be any regression issue? 
> >> Maybe just hard to reproduce, ocfs2 supports recursive locking.
> > 
> > In what sense? The DLM might but the FS should never be making use of such a
> > mechanism (it would be for userspace users).
> See commit 743b5f1434f5 ("ocfs2: take inode lock in
> ocfs2_iop_set/get_acl()"), it used recursive locking and caused a
> deadlock, the call trace is in this patch's log.

Ahh ok so it's part of the buggy patch.


> > We really can't add recursive locks without this getting rejected upstream.
> > There's a whole slew of reasons why we don't like those in the kernel.
> Is there any harm to support this lock in kernel?

Yeah so you can google search on why recursive locks are considered harmful
by many programmers and in the Linux Kernel they are a big 'No No'. We used
to have one recursive lock (the 'big kernel lock') which took a large effort
to clean up.

Most objections are going to come down to the readability of the code and
the nasty bugs that can come about as a result. Here's a random blog post I
found explaining some of this:

http://blog.stephencleary.com/2013/04/recursive-re-entrant-locks.html

I'm pretty sure Linus has a rant about it somewhere too you can find.


But basically your approach to fixing situations like this is going to be
refactoring the code in a readable manner such that the lock is only taken
once per code path.

Hope that all helps,
	--Mark


--
Mark Fasheh
