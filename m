From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 16 Dec 2008 17:30:22 -0800
Subject: [Ocfs2-devel] [PATCH 9/9] ocfs2/dlm: Fix race during lockres
	mastery
In-Reply-To: <1229471363-15887-10-git-send-email-sunil.mushran@oracle.com>
References: <1229471363-15887-1-git-send-email-sunil.mushran@oracle.com>
	<1229471363-15887-10-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20081217013022.GC8791@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Dec 16, 2008 at 03:49:23PM -0800, Sunil Mushran wrote:
> dlm_get_lock_resource() is supposed to return a lock resource with a proper
> master. If multiple concurrent threads attempt to lookup the lockres for the
> same lockid while the lock mastery in underway, one or more threads are likely
> to return a lockres without a proper master.
> 
> This patch makes the threads wait in dlm_get_lock_resource() while the mastery
> is underway, ensuring all threads return the lockres with a proper master.
> 
> This issue is known to be limited to users using the flock() syscall. For all
> other fs operations, the ocfs2 dlmglue layer serializes the dlm op for each
> lockid.
> 
> Patch fixes Novell bz#425491
> https://bugzilla.novell.com/show_bug.cgi?id=425491

Btw, removed the bz url because the bug isn't globally readable. I don't
know if that's an official policy or anything, I just figured that since
only a limited set could read it...
	--Mark

--
Mark Fasheh
