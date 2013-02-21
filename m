From: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 21 Feb 2013 14:15:07 -0800
Subject: [Ocfs2-devel] [PATCH] the ac->ac_allow_chain_relink=0 won't
 disable group relink
In-Reply-To: <1361433259-15336-1-git-send-email-xiaowei.hu@oracle.com>
References: <1361433259-15336-1-git-send-email-xiaowei.hu@oracle.com>
Message-ID: <20130221141507.c91be59d.akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, 21 Feb 2013 15:54:19 +0800
xiaowei.hu at oracle.com wrote:

> ocfs2_block_group_alloc_discontig() disables chain relink by setting
> ac->ac_allow_chain_relink = 0 because it grabs clusters from multiple
> cluster groups. It doesn't keep the credits for all chain relink,but
> ocfs2_claim_suballoc_bits overrides this in this call trace:
> ocfs2_block_group_claim_bits()->ocfs2_claim_clusters()->
> __ocfs2_claim_clusters()->ocfs2_claim_suballoc_bits()
> ocfs2_claim_suballoc_bits set ac->ac_allow_chain_relink = 1; then call
> ocfs2_search_chain() one time and disable it again, and then we run
> out of credits.
> 
> Fix is to allow relink by default and disable it in
> ocfs2_block_group_alloc_discontig.

What is the end-user impact of this bug?

Please always include this info in changelogs to help other to decide
which kernel version(s) need the patch, thanks.
