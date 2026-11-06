Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793962116;
	b=Ghe6t0LTx7pkUO9t7uO3TLUsOMjKFADXKwho1bUAmcVu7hntApKrbtwF/Br5rmI1KhOr
	 tOf3q6kF0yMxqpPNyZOKb18KTxfs4UT/GtX3CHh1/sNt/m0xXv087aUubQmv5GRNsRPKN
	 OEcmvITIYmRFaRMg88T1DPU5GZHOhpmLh0iTXjKC5FXrJo1JwxXclZtjBUTMEulKnsu23
	 X7S2wh0dQfJbVP3dHLsF95xMX5mFLhzhryhu/pOqwbVQ03mvMFfRGup8uFoY5cExBsvEG
	 3Ax+fplxi4D4DkXo/Ta3R/ZsuoY4QT2oH/3/FKnL17VTW42fye1AxCt8deT8eFIkt7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793962116;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=EuyzFCqPqARXYqnCv55IFuociJVAuDpv0cxINb1cfgM=;
	b=Bi0BV5ugLPwMZT8v943xntCGd7HLiKHyaac+U9xTDMwAAeABKN4IXK63sUJPi9dItY+z
	 OOnZy2eEKxsVcSBKr13Lav0dz+rvFVbjTw5jH7ngkmYVsD+F4Oenf7HNWOlEtjn8/0RDR
	 P/h6zHV3GwMjhQ7F+/68lbVzWqXumL4yTxVJxjWqM/FdGSx8Dwqnu6Pwu5jAeyB71acFD
	 HGWTqkJKBsnNPZjjvcTFW0ESfFX6160aZD3j7yX/TRDed7P1gQ7LSQFQIS71A/eQ8X2hU
	 F0rp21g4jBezBcN1kYr2Q7UGF+eGytQ0EWrPYx50Ql/tYuzHAOQnBntOngUlJjqlBkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D88606D805
	for <ocfs2-devel@lists.linux.dev>; Fri,  6 Nov 2026 10:48:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 54D88606D805
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6A6C168BEB; Fri,  6 Nov 2026 11:48:31 +0100 (CET)
Date: Fri, 6 Nov 2026 11:48:31 +0100
From: Christoph Hellwig <hch@lst.de>
To: Heming Zhao <heming.zhao@suse.com>
Cc: joseph.qi@linux.alibaba.com, mark@fasheh.com, jlbec@evilplan.org,
	hch@lst.de, ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v5 2/4] ocfs2: switch DIO read path from
 buffer_head to iomap
Message-ID: <20261106104831.GB5746@lst.de>
References: <20261105071930.16399-1-heming.zhao@suse.com> <20261105071930.16399-3-heming.zhao@suse.com>
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105071930.16399-3-heming.zhao@suse.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Nov 05, 2026 at 03:19:26PM +0800, Heming Zhao wrote:
> Migrates the DIO read path from the legacy buffer_head infrastructure
> to the modern and more efficient iomap framework.
> 
> Under the current code, ocfs2 holds a cluster lock during DIO via
> ocfs2_iocb_set_rw_locked(), and releases the cluster lock in
> ocfs2_dio_end_io() via ocfs2_iocb_clear_rw_locked(). The lock level is
> stashed in iocb->private.
> 
> However, iomap DIO owns that field (it stores a bio there for polled I/O
> and unconditionally clears it before calling ->end_io). Any side-channel
> state packed into iocb->private is corrupted, which trips the end_io
> lock-state check.
> 
> Instead, encode the unlock level by passing distinct iomap_dio_ops methods
> (ocfs2_iomap_dio_ops_pr for PRMODE or ocfs2_iomap_dio_ops_ex for EXMODE).
> Additionally, the *_iter() functions use the split __iomap_dio_rw() +
> iomap_dio_complete() API so they can determine unambiguously, from the
> return value, whether the completion handler already dropped the lock
> (real I/O, sync or -EIOCBQUEUED) or whether the caller must drop it
> (no I/O issued, or buffered fallback).
> 
> The new function ocfs2_iomap_begin() performs a similar role to
> ocfs2_get_block(). While ocfs2_get_block() retrieves only one block per
> call, ocfs2_iomap_begin() can handle multiple blocks at once. Limit the
> map offset and length in ocfs2_iomap_begin() to OCFS2_MAX_LOGICAL_BLOCK
> to avoid overflow issues.
> 
> Co-developed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> ---
>  fs/ocfs2/Kconfig    |   1 +
>  fs/ocfs2/aops.c     | 111 ++++++++++++++++++++++++++++++++++++++++++++
>  fs/ocfs2/aops.h     |   4 ++
>  fs/ocfs2/file.c     |  62 +++++++++++++++++++++----
>  fs/ocfs2/ocfs2_fs.h |   3 ++
>  5 files changed, 172 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/ocfs2/Kconfig b/fs/ocfs2/Kconfig
> index 2514d36cbe01..bf1678a5eb01 100644
> --- a/fs/ocfs2/Kconfig
> +++ b/fs/ocfs2/Kconfig
> @@ -7,6 +7,7 @@ config OCFS2_FS
>  	select CRC32
>  	select QUOTA
>  	select QUOTA_TREE
> +	select FS_IOMAP
>  	select FS_POSIX_ACL
>  	select LEGACY_DIRECT_IO
>  	help
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index 0f7502de9b8d..8e4d31cb85db 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -4,6 +4,7 @@
>   */
>  
>  #include <linux/fs.h>
> +#include <linux/iomap.h>
>  #include <linux/slab.h>
>  #include <linux/highmem.h>
>  #include <linux/pagemap.h>
> @@ -2534,6 +2535,116 @@ static ssize_t ocfs2_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
>  				    ocfs2_dio_end_io, 0);
>  }
>  
> +static int ocfs2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
> +		unsigned int flags, struct iomap *iomap, struct iomap *srcmap)
> +{
> +	int ret;
> +	struct ocfs2_map_block map;
> +	struct ocfs2_inode_info *oi = OCFS2_I(inode);
> +	u8 blkbits = inode->i_blkbits;
> +
> +	if ((offset >> blkbits) > OCFS2_MAX_LOGICAL_BLOCK)
> +		return -EINVAL;
> +
> +	/*
> +	 * Calculate the first and last logical blocks respectively.
> +	 */
> +	map.lblk = offset >> blkbits;
> +	map.len = min_t(loff_t, (offset + length - 1) >> blkbits,
> +			OCFS2_MAX_LOGICAL_BLOCK) - map.lblk + 1;
> +	map.flags = 0;
> +
> +	if (flags & IOMAP_WRITE) {
> +		return -EOPNOTSUPP;
> +	} else {

No need for an else after a return..

> +	/*
> +	 * Before returning to iomap, let's ensure the allocated mapping
> +	 * covers the entire requested length for atomic writes.
> +	 */
> +	if (flags & IOMAP_ATOMIC) {

IOMAP_ATOMIC is never set for reads.

