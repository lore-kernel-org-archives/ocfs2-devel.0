From: Joel Becker <jlbec@evilplan.org>
Date: Tue, 5 Jan 2016 23:47:15 +0000
Subject: [Ocfs2-devel] [PATCH] add OCFS2_LOCK_IGNORE_BLOCKED arg_flags
 to ocfs2_cluster_lock() to prevent hang
In-Reply-To: <568B2089.6060902@oracle.com>
References: <1450828550-23168-1-git-send-email-tariq.x.saeed@oracle.com>
	<20151230003456.GR11072@wotan.suse.de>
	<568ADCC1.7090503@oracle.com> <20160105003532.GA819@wotan.suse.de>
	<568B2089.6060902@oracle.com>
Message-ID: <20160105234715.GP29804@ZenIV.linux.org.uk>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Jan 05, 2016 at 09:46:49AM +0800, Junxiao Bi wrote:
> Hi Mark,
> 
> We may fix this issue in another way, without recursive locking and
> without refactoring. We can check before asking for the second locking,
> if lock is already hold, then skip the second locking, do you agree
> fixing like this?

Hey Junxiao,

What is to prevent the second lock from being dropped while in the
middle of the operation?

Joel

-- 
