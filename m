From: Gang He <ghe@suse.com>
Date: Thu, 07 Dec 2017 17:35:02 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: add trimfs dlm lock
In-Reply-To: <20171207153350.836f1eb9086a1d51ae2176bc@linux-foundation.org>
References: <1512652918-11777-1-git-send-email-ghe@suse.com>
	<20171207153350.836f1eb9086a1d51ae2176bc@linux-foundation.org>
Message-ID: <5A29DE36020000F9001C5F44@prv-mh.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello Andrew and All,

>>> Andrew Morton <akpm@linux-foundation.org> 12/08/17 7:34 AM >>>
On Thu,  7 Dec 2017 21:21:58 +0800 Gang He <ghe@suse.com> wrote:

> As you know, ocfs2 has support trim the underlying disk via
> fstrim command. But there is a problem, ocfs2 is a shared storage
> cluster file system, if the user configures a scheduled fstrim
> job on each file system node, this will trigger multiple nodes
> trim a shared disk simultaneously, it is very wasteful for CPU
> and IO consumption.
> Then, we introduce a trimfs dlm lock, which will make only one
> fstrim command is running on the shared disk among the cluster,
> the other fstrim command should be returned with -EBUSY errno.

Newly returning -EBUSY sounds a bit rude.  And non-backward-compatible. 
Would it be better for the other fstrim callers to wait until the
operation has completed then return success?
Gang: OK, that means, if multiple nodes trim a shared disk simultaneously,
only one node (get the lock first) do the real trimming operation, 
the other nodes will wait until that node finishes trimming, then return zero.
Does anyone has more comments? If not, I will do this change in v2.

Thanks
Gang 
