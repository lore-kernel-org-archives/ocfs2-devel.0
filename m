Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25609207A0E
	for <ocfs2-devel@lists.linux.dev>; Wed, 16 Oct 2024 11:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729079251; cv=none; b=D4uXAsBupuPimmE1KZDhoyXcmCWTypOFdm869gERgW0bdllBSi3PBYH5unrM7uN8Gltzy7LVvCq9z4AKX54KReB8GqkoBVyDqCnQIgBLBzVd9XD4Uxvt8LxHFcy/y7RKYlfHwKfuyqotBdYtEQkC2e2iq9idcNvnNk6qsSVKAUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729079251; c=relaxed/simple;
	bh=tlHft1EJdQzxrRXlLxm5JUvW/z4CeHmMsD1MAtqEzmI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qNRYl6tImbO5kc2cD9meGy407hvX1sFuT+O4C1UxxJ1LtZxo+RPf9oNjSid4NcH3Osz/m36G7nVJdvAoygRKQ3dUMv6RK/SyemCp/evyCpIVgxuWiRqkcUUKFXc3/kF0AsRSDrbUAx56VkKzSb1yLnyHDSM73DRIGLU5FfwN9JI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=ufQaqT3z; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="ufQaqT3z"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1729079237; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=qV5cbP5FSAp1k3vbuhSr1pDDjuOA47thiqFPaWyuvc4=;
	b=ufQaqT3zsEHWdin3weJvv0EbUQdU2LPZ/NrZqC4LeFrvYBsE/WTkofOlz1C3/SpLZ4jbqeUK43bFL0YNaUDHg0mt6mehtWaw04ugGquI5UtNOgEJszgSuqId/Pj3oh8Q9get9hqxfUJEQQ2KpgSlpDTfJJ4pWZqYcvQkEM+klBA=
Received: from 30.221.129.144(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WHHP2Hl_1729079235 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 16 Oct 2024 19:47:17 +0800
Message-ID: <f34f1b3e-7b31-49ab-ad32-ad63d8194c5f@linux.alibaba.com>
Date: Wed, 16 Oct 2024 19:47:15 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4] ocfs2: pass u64 to ocfs2_truncate_inline maybe
 overflow
To: Edward Adam Davis <eadavis@qq.com>, akpm <akpm@linux-foundation.org>
Cc: jlbec@evilplan.org, l@damenly.org, linux-kernel@vger.kernel.org,
 mark@fasheh.com, ocfs2-devel@lists.linux.dev,
 syzbot+81092778aac03460d6b7@syzkaller.appspotmail.com,
 syzkaller-bugs@googlegroups.com
References: <21d7a0d6-faac-4914-8907-1d7d983953f2@linux.alibaba.com>
 <tencent_D48DB5122ADDAEDDD11918CFB68D93258C07@qq.com>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <tencent_D48DB5122ADDAEDDD11918CFB68D93258C07@qq.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/16/24 7:43 PM, Edward Adam Davis wrote:
> Syzbot reported a kernel BUG in ocfs2_truncate_inline.
> There are two reasons for this: first, the parameter value passed is greater
> than ocfs2_max_inline_data_with_xattr, second, the start and end parameters
> of ocfs2_truncate_inline are "unsigned int".
> 
> So, we need to add a sanity check for byte_start and byte_len right before
> ocfs2_truncate_inline() in ocfs2_remove_inode_range(), if they are greater
> than ocfs2_max_inline_data_with_xattr return -EINVAL.
> 
> Reported-by: syzbot+81092778aac03460d6b7@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=81092778aac03460d6b7
> Signed-off-by: Edward Adam Davis <eadavis@qq.com>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
> V1 -> V2: move sanity check to ocfs2_remove_inode_range
> V2 -> V3: use ocfs2_max_inline_data_with_xattr return value replace UINT_MAX
> V3 -> V4: rename variable, modify return value and comments
> 
>  fs/ocfs2/file.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index ad131a2fc58e..47121ee4b4df 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -1784,6 +1784,14 @@ int ocfs2_remove_inode_range(struct inode *inode,
>  		return 0;
>  
>  	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
> +		int id_count = ocfs2_max_inline_data_with_xattr(inode->i_sb, di);
> +
> +		if (byte_start > id_count || byte_start + byte_len > id_count) {
> +			ret = -EINVAL;
> +			mlog_errno(ret);
> +			goto out;
> +		}
> +
>  		ret = ocfs2_truncate_inline(inode, di_bh, byte_start,
>  					    byte_start + byte_len, 0);
>  		if (ret) {

