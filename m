From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 7 Sep 2010 15:20:53 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Use the right group in nfs sync
	check.
In-Reply-To: <1283407434-6031-1-git-send-email-tao.ma@oracle.com>
References: <1283407434-6031-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20100907222052.GE4364@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Sep 02, 2010 at 02:03:54PM +0800, Tao Ma wrote:
> We have added discontig block group now, and now an inode
> can be allocated in an discontig block group. So get
> it in ocfs2_get_suballoc_slot_bit.

The first paragraph in your message confused me! It doesn't look like the
fix below is directly related to the discontig block group patches, correct?


> The old ocfs2_test_suballoc_bit gets group block no
> from the allocation inode which is wrong. Fix it by
> passing the right group.

Right, so this fix I can definitely see. Good catch...

Acked-by: Mark Fasheh <mfasheh@suse.com>
	--Mark

--
Mark Fasheh
