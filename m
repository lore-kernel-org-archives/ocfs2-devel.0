Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C9BA24113D
	for <ocfs2-devel@lists.linux.dev>; Mon, 18 May 2026 01:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779068264; cv=none; b=ufnpKEtueEoWvyoDMgAp5bVcztdNdj4QFDl7+nfU2H0O3t1CDLL1e9/l8f6EPbBJ4Bc7ZJykbo1kAgDhIBUJWZcgsJvaSVZriGdqX/lp8jU1y9HkQ1vHuNXLmjk7AUMJhul3gx0gyz6Gl+Xg2WLNzCiaPwCx0UmDIxs96967JCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779068264; c=relaxed/simple;
	bh=e5AbEdxc74VyTtMdQ47+WaR/VFcBZJVsh3vG6A1+wT0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y2JU1eV3sLsLK9RPsFb+NWHqizHvfjExH2OrH4hqhaVtrEuWf3FKFBCYNXTFZ5jfdtJvuQXp41mFntrYOhBCPg0QHwwAYP5t2fA+E42gGO9ng2vCTKjt6Gc+kcK1QgnXC1OJIgVJDWJAbuXxGx9Pb44pxdzfMTU/r6KDcuQgwXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=m1hXpkRH; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="m1hXpkRH"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779068260; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=G2A8yq+atc45C9TkkOViHo8ROyU1Q4Q+TbyHIReW5Ys=;
	b=m1hXpkRHCUIqhk5pArwoc+FOfOo9zJDNWOrunkmvR8x0VDwIUuVo3KLIP/3utfXCvOBMl4r/NUHko0BDpX8cs8Yad39F34UdwDmEOT7XruiuxYnG6ggqSbyIn9HUHJNDUGWOdPkMVTdBbpAi0h1yh1N4U3GlaUPNz835qzjhj0c=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R471e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0X32gD3I_1779068257;
Received: from 30.221.129.172(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X32gD3I_1779068257 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 18 May 2026 09:37:38 +0800
Message-ID: <ead6ed9a-e198-48aa-bb63-03049a3b08b9@linux.alibaba.com>
Date: Mon, 18 May 2026 09:37:37 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] ocfs2: reject dinodes whose i_rdev disagrees with the
 file type
To: Michael Bommarito <michael.bommarito@gmail.com>,
 akpm <akpm@linux-foundation.org>
Cc: ZhengYuan Huang <gality369@gmail.com>, ocfs2-devel@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>
References: <20260517111015.3187935-1-michael.bommarito@gmail.com>
 <20260517111015.3187935-3-michael.bommarito@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260517111015.3187935-3-michael.bommarito@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/17/26 7:10 PM, Michael Bommarito wrote:
> id1.dev1.i_rdev is the device-number arm of the ocfs2_dinode id1
> union and is only meaningful for character and block device
> inodes.  For any other user-visible file type the on-disk value
> must be zero.
> 
> ocfs2_populate_inode() currently runs
> 
>     inode->i_rdev = huge_decode_dev(le64_to_cpu(fe->id1.dev1.i_rdev));
> 
> unconditionally, before the S_IFMT switch decides whether the
> inode is a special file.  As a result, an i_rdev value present on
> a non-device inode is silently published into the in-core inode.
> A subsequent forced re-read or in-core mode mutation (cluster
> peer with raw write access to the shared LUN, on-disk corruption,
> or a separately forged dinode) can then expose the attacker-
> controlled device number to init_special_inode() without ever
> showing an unusual i_mode at validation time.
> 
> System inodes (OCFS2_SYSTEM_FL) legitimately use the bitmap1 and
> journal1 arms of the same union: allocator inodes encode i_used
> / i_total in the bitmap1 arm and the journal encodes ij_flags /
> ij_recovery_generation in the journal1 arm.  Those byte
> sequences are not an i_rdev and a non-zero pattern there is the
> on-disk norm, not an integrity violation.  Restrict the cross-
> check to non-system inodes; that is the full surface where
> i_rdev semantics apply and is also the full surface an
> unprivileged consumer of the volume can see.
> 
> Following the i_mode canonicalisation in patch 1, S_ISCHR /
> S_ISBLK covers the whole device-inode space; this check operates
> correctly on its own, but the canonicalised i_mode makes the
> predicate exhaustive.
> 
> Fixes: b657c95c1108 ("ocfs2: Wrap inode block reads in a dedicated function.")
> Cc: stable@vger.kernel.org
> Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
> Assisted-by: Claude:claude-opus-4-7

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/inode.c | 38 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 38 insertions(+)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index fb592bf3e5f31..305e22cc9b1d9 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -1533,6 +1533,44 @@ int ocfs2_validate_inode_block(struct super_block *sb,
>  		}
>  	}
>  
> +	/*
> +	 * id1.dev1.i_rdev is the device-number arm of the id1 union and
> +	 * is only meaningful for character and block device inodes.  For
> +	 * any other regular user-visible file type the on-disk value
> +	 * must be zero.  ocfs2_populate_inode() currently runs
> +	 *
> +	 *     inode->i_rdev = huge_decode_dev(le64_to_cpu(fe->id1.dev1.i_rdev));
> +	 *
> +	 * unconditionally, before the S_IFMT switch decides whether the
> +	 * inode is a special file.  As a result, an i_rdev value present
> +	 * on a non-device inode is silently published into the in-core
> +	 * inode; a subsequent forced re-read or in-core mode mutation
> +	 * (cluster peer with raw write access to the shared LUN,
> +	 * on-disk corruption, or a separately forged dinode) can then
> +	 * expose the attacker-controlled device number to
> +	 * init_special_inode() without ever showing an unusual i_mode
> +	 * at validation time.
> +	 *
> +	 * System inodes (OCFS2_SYSTEM_FL) legitimately use the bitmap1
> +	 * and journal1 arms of the same union (allocator i_used /
> +	 * i_total counters and the journal ij_flags /
> +	 * ij_recovery_generation pair); those bytes are not an i_rdev
> +	 * and must not be checked here.  Restrict the cross-check to
> +	 * non-system inodes, which is the full attacker-controllable
> +	 * surface.
> +	 */
> +	if (!(le32_to_cpu(di->i_flags) & OCFS2_SYSTEM_FL) &&
> +	    !S_ISCHR(le16_to_cpu(di->i_mode)) &&
> +	    !S_ISBLK(le16_to_cpu(di->i_mode)) &&
> +	    di->id1.dev1.i_rdev != 0) {
> +		rc = ocfs2_error(sb,
> +				 "Invalid dinode #%llu: non-device mode 0%o with i_rdev %llu\n",
> +				 (unsigned long long)bh->b_blocknr,
> +				 le16_to_cpu(di->i_mode),
> +				 (unsigned long long)le64_to_cpu(di->id1.dev1.i_rdev));
> +		goto bail;
> +	}
> +
>  	if (le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL) {
>  		struct ocfs2_inline_data *data = &di->id2.i_data;
>  

