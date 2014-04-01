From: Mark Fasheh <mfasheh@suse.de>
Date: Tue, 1 Apr 2014 10:48:32 -0700
Subject: [Ocfs2-devel] [PATCH] Ocfs2: Rollback alloc_dinode counts
	when	ocfs2_block_group_set_bits() failed
In-Reply-To: <5339689C.1060807@gmail.com>
References: <5339689C.1060807@gmail.com>
Message-ID: <20140401174832.GI4488@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Mar 31, 2014 at 09:07:40PM +0800, Younger Liu wrote:
>   After updating alloc_dinode counts in ocfs2_alloc_dinode_update_counts(),
> if ocfs2_alloc_dinode_update_bitmap() failed, there is a rare case that some
> space may be lost.
>   So, we rollback alloc_dinode counts when ocfs2_block_group_set_bits() failed.
> 
> Signed-off-by: Younger Liu <younger.liucn@gmail.com>
> Cc: Mark Fasheh <mfasheh@suse.de>

Thanks for the latest version fo this patch Younger, it looks good.
	--Mark

Reviewed-by: Mark Fasheh <mfasheh@suse.de>

--
Mark Fasheh
