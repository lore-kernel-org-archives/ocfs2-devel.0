Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8254430;
	Mon, 17 Mar 2025 06:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742192458; cv=none; b=ZIYAVWW9gsJbGMolAkNUnIN+l7TIfktzLqvR6+OPT+1Ynm8xkxsPaNZCu1LpyQvgzFFGLLtJRh4cmPAgpc8q+NFtpCBa9JBsBuhlg7SGNROyu0zRmqKJfOOZUGWW+0eMoh47oIbp5nETeedkLoKrvI9JbOdk4bmu5W/6rSMar5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742192458; c=relaxed/simple;
	bh=6avnnkGStpdEgMGZiPC/B0bGMi+/oYvepTgvlfgBaIE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Igu0Z59sOBLVYlqjiNp5x95KqSag/2lHCl6TSGT9B9DdP1K3Rdov4sfVphNgEPTN+9QS/cP8W9Keom2qhRwp9sXw9iJijXjsU7OXOxNisPJZLFg+eKChKBKcV+68bAEslUU0x1UqZRa8F4GuL+tIF5TnnOc/O+CDKSqsdEWJVL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gOMWfEu7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gOMWfEu7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE8D0C4CEE3;
	Mon, 17 Mar 2025 06:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742192457;
	bh=6avnnkGStpdEgMGZiPC/B0bGMi+/oYvepTgvlfgBaIE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gOMWfEu76MHTLqDkwpUi0pFmp1MHICZaHMPcOCEdObn4dUEflU2gSxICbcQxSvLj4
	 vDv17d7O1+EImlwwWF0Zo3Cm1AJjr9KgfGlc5+ts4E58qK5yMyLoajzmyaL00g8sYm
	 MvimnfktLOv2Sa6foWxubFmVU6YLKevK6Bxo6la27tKhF+uzcoDZ9rWYPh+uO0nVyf
	 p3BNEBXioWgBS/Syp3xV8wAH6SGFdlDsOABs5M94vV/xr3Y45+1icgD86B/n5r88Ei
	 Cw9WhRV89lMFUhwn6Hk5bBuGMRFmLt4YYePF3hFq+7Q280sad3CFn2oe2BAvfRBWhW
	 YBEgp/hfdRxQg==
Message-ID: <feb009f6-79b9-499e-a909-3d27c4fb9fad@kernel.org>
Date: Mon, 17 Mar 2025 07:20:54 +0100
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH linux-next] ocfs2: use sysfs_emit() instead of
 scnprintf().
To: xie.ludan@zte.com.cn, mark@fasheh.com
Cc: jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 akpm@linux-foundation.org, viro@zeniv.linux.org.uk, brauner@kernel.org,
 danielyangkang@gmail.com, dmantipov@yandex.ru, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20250315141640564lv7R0CwIRPsmittXXjLbB@zte.com.cn>
Content-Language: en-US
From: Jiri Slaby <jirislaby@kernel.org>
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <20250315141640564lv7R0CwIRPsmittXXjLbB@zte.com.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 15. 03. 25, 7:16, xie.ludan@zte.com.cn wrote:
> From: XieLudan <xie.ludan@zte.com.cn>
> 
> 
> Follow the advice in Documentation/filesystems/sysfs.rst:
> 
> show() should only use sysfs_emit() or sysfs_emit_at() when formatting
> 
> the value to be returned to user space.
> 
> 
> Signed-off-by: XieLudan <xie.ludan@zte.com.cn>
> 
> ---
> 
>   fs/ocfs2/cluster/heartbeat.c | 10 +++++-----
> 
>   1 file changed, 5 insertions(+), 5 deletions(-)
> 
> 
> diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
> 
> index 724350925aff..8282fc193906 100644
> 
> --- a/fs/ocfs2/cluster/heartbeat.c
> 
> +++ b/fs/ocfs2/cluster/heartbeat.c
> 
> @@ -1308,7 +1308,7 @@ static int o2hb_debug_open(struct inode *inode, 
> struct file *file)
> 
> case O2HB_DB_TYPE_REGION_NUMBER:
> 
> reg = (struct o2hb_region *)db->db_data;
> 
> -out += scnprintf(buf + out, PAGE_SIZE - out, "%d\n",
> 
> +out += sysfs_emit(buf + out, "%d\n",


This is wrong too [1].

[1] 
https://lore.kernel.org/all/9c552d9a-2d46-4069-a9c4-35fab857bfc3@kernel.org/

regards,
-- 
js
suse labs

