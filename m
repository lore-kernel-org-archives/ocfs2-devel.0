From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 21 May 2014 15:29:22 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix umount hang while shutting
	down truncate log
In-Reply-To: <537C1848.4070202@huawei.com>
References: <537C1848.4070202@huawei.com>
Message-ID: <20140521152922.4789ca7d1bea10a7422cc686@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, 21 May 2014 11:06:48 +0800 Xue jiufei <xuejiufei@huawei.com> wrote:

> Revert the following patch because it may cause umount hang while
> shutting down truncate log.
> 5f82eaa502c75d881c1db7979f3c2bf2da6865f

I can find no such commit.

When referring to commits, please use the form

	c4028958b6ec ("WorkStruct: make allyesconfig")

so that people can still identify the commit when it has a different
hash.
