From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Mar 29 21:10:54 2004
Subject: [Ocfs2-devel] Can you check the patch for bug 48 and commit?
In-Reply-To: <37FBBA5F3A361C41AB7CE44558C3448E03B65E4C@PDSMSX403.ccr.corp.intel.com>
References: <37FBBA5F3A361C41AB7CE44558C3448E03B65E4C@PDSMSX403.ccr.corp.intel.com>
Message-ID: <20040330031050.GB10672@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Mar 30, 2004 at 10:53:13AM +0800, Zhang, Sonic wrote:
> Hi Mark,
> 
> Can you check the patch for bug 48 in the attachment and commit? I haven't
> found it in the svn tree.
That's because I was still looking at the signals part of the patch :)
I needed to do some reading in schedule() to make sure what I though was
going on, really is. Also, I think the correct approach is to do both, the
signal handling, *and* to define the timeout value itself as a function of
HZ, rather than a hard number of jiffies.

> This patch adds lines of signal process code, which makes the thread
> ocfs_volume_thread() really go to sleep after receive the SIGTERM signal.
> So, it gives routine ocfs_journal_set_unmounted() a chance to run and
> check the lock status before thread ocfs_volume_thread() wakes up.
You need to update from cvs because half of that patch is already in. Also,
can you make the same NPTL fix in it that I did for ocfs_commit_thread? See
the svn logs to know what I'm talking about.
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
