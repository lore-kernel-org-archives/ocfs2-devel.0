Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E78F9D9
	for <ocfs2-devel@lists.linux.dev>; Fri,  1 Nov 2024 12:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730465615; cv=none; b=reE4ilHhGfQGv0ucCA63qK+HZNQMSjuLSBKPwVWIWGVSVjaQYMd5N8rmPQpZCVMPJERSeG7VXa8P+kVE/NDgMsCGqLVF6CEjdgPUgX+8N2vB6vedYnVsMgS46JwpIeung8FuqrLrvYi3i9KOtMiO9cfIpvc5LkSYnqKlICaxDHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730465615; c=relaxed/simple;
	bh=dRt8Wt33a+gJr4pdbe3BFWFJKSsT0SiGi9tnumU4C9o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pHLKbgyZCNo7covtGqUJ7Fdb9UGMfFrJmeeYgPNwAF2CWDLV8gWghVvj2BDPwilCk0Xf4o3xJ8E6YYAZDqTamvCgWUw4FMl/xkrH6awonPCcljXb/NKyasl9BGscfO77NYvT+bd7VpKuNBgoVC7eDsChD0WRoSu8OjvR7DM5Dlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=fwloVO1R; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="fwloVO1R"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1730465604; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=YZOjb27QH5lTJMffOv2w8pz522mkN3F8THfiuw78qFY=;
	b=fwloVO1RALTKVs0GKYinGo8AUN6JWi1pxdXyFExdnXlCYe2Q+ag1u8bHcxA9qjw25VgfHZk2NpXY1BnWrii0hSiKpXSdVoKRqKWNAzVwZ8o1m0pp12rH6KswDL5edOxpQltUQuG1CdZdjTTKogJ7ZecsGPma/oRs1aqawuC6Ad4=
Received: from 30.221.65.110(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WISGh2f_1730465599 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 01 Nov 2024 20:53:20 +0800
Message-ID: <cfd351ed-01d5-42e6-a764-2d915bd3adeb@linux.alibaba.com>
Date: Fri, 1 Nov 2024 20:53:18 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: remove entry once instead of null-ptr-dereference
 in ocfs2_xa_remove()
To: Andrew Kanner <andrew.kanner@gmail.com>, mark@fasheh.com,
 jlbec@evilplan.org
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 syzbot+386ce9e60fa1b18aac5b@syzkaller.appspotmail.com
References: <20241029224304.2169092-2-andrew.kanner@gmail.com>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20241029224304.2169092-2-andrew.kanner@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/30/24 6:43 AM, Andrew Kanner wrote:
> Syzkaller is able to provoke null-ptr-dereference in ocfs2_xa_remove():
> 
> [   57.319872] (a.out,1161,7):ocfs2_xa_remove:2028 ERROR: status = -12
> [   57.320420] (a.out,1161,7):ocfs2_xa_cleanup_value_truncate:1999 ERROR: Partial truncate while removing xattr overlay.upper.  Leaking 1 clusters and removing the entry
> [   57.321727] BUG: kernel NULL pointer dereference, address: 0000000000000004
> [...]
> [   57.325727] RIP: 0010:ocfs2_xa_block_wipe_namevalue+0x2a/0xc0
> [...]
> [   57.331328] Call Trace:
> [   57.331477]  <TASK>
> [...]
> [   57.333511]  ? do_user_addr_fault+0x3e5/0x740
> [   57.333778]  ? exc_page_fault+0x70/0x170
> [   57.334016]  ? asm_exc_page_fault+0x2b/0x30
> [   57.334263]  ? __pfx_ocfs2_xa_block_wipe_namevalue+0x10/0x10
> [   57.334596]  ? ocfs2_xa_block_wipe_namevalue+0x2a/0xc0
> [   57.334913]  ocfs2_xa_remove_entry+0x23/0xc0
> [   57.335164]  ocfs2_xa_set+0x704/0xcf0
> [   57.335381]  ? _raw_spin_unlock+0x1a/0x40
> [   57.335620]  ? ocfs2_inode_cache_unlock+0x16/0x20
> [   57.335915]  ? trace_preempt_on+0x1e/0x70
> [   57.336153]  ? start_this_handle+0x16c/0x500
> [   57.336410]  ? preempt_count_sub+0x50/0x80
> [   57.336656]  ? _raw_read_unlock+0x20/0x40
> [   57.336906]  ? start_this_handle+0x16c/0x500
> [   57.337162]  ocfs2_xattr_block_set+0xa6/0x1e0
> [   57.337424]  __ocfs2_xattr_set_handle+0x1fd/0x5d0
> [   57.337706]  ? ocfs2_start_trans+0x13d/0x290
> [   57.337971]  ocfs2_xattr_set+0xb13/0xfb0
> [   57.338207]  ? dput+0x46/0x1c0
> [   57.338393]  ocfs2_xattr_trusted_set+0x28/0x30
> [   57.338665]  ? ocfs2_xattr_trusted_set+0x28/0x30
> [   57.338948]  __vfs_removexattr+0x92/0xc0
> [   57.339182]  __vfs_removexattr_locked+0xd5/0x190
> [   57.339456]  ? preempt_count_sub+0x50/0x80
> [   57.339705]  vfs_removexattr+0x5f/0x100
> [...]
> 
> Reproducer uses faultinject facility to fail ocfs2_xa_remove() ->
> ocfs2_xa_value_truncate() with -ENOMEM.
> 
> In this case the comment mentions that we can return 0 if
> ocfs2_xa_cleanup_value_truncate() is going to wipe the entry
> anyway. But the following 'rc' check is wrong and execution flow do
> 'ocfs2_xa_remove_entry(loc);' twice:
> * 1st: in ocfs2_xa_cleanup_value_truncate();
> * 2nd: returning back to ocfs2_xa_remove() instead of going to 'out'.
> 
> Fix this by skipping the 2nd removal of the same entry and making
> syzkaller repro happy.
> 
> Cc: stable@vger.kernel.org
> Fixes: 399ff3a748cf ("ocfs2: Handle errors while setting external xattr values.")
> Reported-by: syzbot+386ce9e60fa1b18aac5b@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/671e13ab.050a0220.2b8c0f.01d0.GAE@google.com/T/
> Tested-by: syzbot+386ce9e60fa1b18aac5b@syzkaller.appspotmail.com
> Signed-off-by: Andrew Kanner <andrew.kanner@gmail.com>
> ---
>  fs/ocfs2/xattr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index dd0a05365e79..5bc4d660e15a 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -2036,7 +2036,7 @@ static int ocfs2_xa_remove(struct ocfs2_xa_loc *loc,
>  				rc = 0;
>  			ocfs2_xa_cleanup_value_truncate(loc, "removing",
>  							orig_clusters);
> -			if (rc)
> +			if (rc == 0)

Seems in this case, we have to ignore rc and directly goto out?

Thanks,
Joseph

>  				goto out;
>  		}
>  	}

