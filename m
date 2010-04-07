From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Thu, 8 Apr 2010 00:03:46 +0800
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2:freeze-thaw: make it work -v4
In-Reply-To: <4BB2741B.7040603@oracle.com>
References: <201003300431.o2U1vol8024322@acsinet15.oracle.com>
	<4BB2741B.7040603@oracle.com>
Message-ID: <20100407160346.GA4166@laptop.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 10-03-30 14:58, Sunil Mushran wrote:
> http://lkml.org/lkml/2010/3/23/195
> http://git.kernel.org/?p=linux/kernel/git/viro/vfs-2.6.git;a=commitdiff;h=9cf4cacda31338a764e2cbe65cd51bb7f18f3a20
> 
> The interface is changing... for the better. We should be able to get
> away without the cluster lock timeout business.

I don't see how the patch helps us not use timeoutible cluster lock.
The patch doesn't touch unmount path. If it doesn't prevent an unmount, we
have the outstanding lock problem.

regards,
wengang.
