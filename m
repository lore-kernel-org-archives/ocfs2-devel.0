From: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 3 Aug 2020 17:45:54 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: change slot number type s16 to u16
In-Reply-To: <d1d2686d-6aa1-d241-73cd-c438e23183a2@suse.com>
References: <20200627001259.19757-1-junxiao.bi@oracle.com>
	<825033cb-10d5-7eb6-8b86-94987f05cf77@suse.com>
	<1cead90f-0c37-b75f-3d86-520f19eb55c4@linux.alibaba.com>
	<d1d2686d-6aa1-d241-73cd-c438e23183a2@suse.com>
Message-ID: <20200803174554.32619bbe8a5222c661d58d28@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, 3 Aug 2020 14:43:23 +0800 Gang He <ghe@suse.com> wrote:

> Could you help to commit this patch to Linus git tree? since this patch 
> will fix the latest patch (ocfs2: fix value of OCFS2_INVALID_SLOT).
> So far, the current ocfs2 code under Linus git tree does NOT work.

It's in the queue for 5.9-rc1, with a cc:stable.
