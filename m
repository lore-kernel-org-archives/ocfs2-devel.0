From: Tao Ma <tao.ma@oracle.com>
Date: Mon, 30 Aug 2010 14:15:49 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: properly set and use inode group
 alloc hint
In-Reply-To: <20100826200650.GP14548@wotan.suse.de>
References: <20100826200650.GP14548@wotan.suse.de>
Message-ID: <4C7B4C95.7050706@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 08/27/2010 04:06 AM, Mark Fasheh wrote:
> We were setting ac->ac_last_group in ocfs2_claim_suballoc_bits from
> res->sr_bg_blkno.  Unfortunately, res->sr_bg_blkno is going to be zero under
> normal (non-fragmented) circumstances. The discontig block group patches
> effectively turned off that feature. Fix this by correctly calculating what
> the next group hint should be.
>
> Signed-off-by: Mark Fasheh<mfasheh@suse.com>
> Tested-by: Goldwyn Rodrigues<rgoldwyn@suse.de>
Acked-by: Tao Ma <tao.ma@oracle.com>
