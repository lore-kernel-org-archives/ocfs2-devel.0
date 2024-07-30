Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E0F78827
	for <ocfs2-devel@lists.linux.dev>; Tue, 30 Jul 2024 01:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722302551; cv=none; b=KpMbzB83ENfAy07aRLnteKyWYHK5BrnpSJ9STLFiey3lg/yYvYG2faImlkkNK1B/ocLtih1uQNERUPEJxHzZu0ICCvjrcT8Kc/VshRq3ARxtyYT2/lVwwsQCFe9ZHvZUEfCqsv3c/ZnqaXE3f63O038A0cucJUbyWVMZeIm/p10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722302551; c=relaxed/simple;
	bh=TLIgq13zi3GzKQ8SGv3L/T8s5sbFv9BrD8M7ece+SEY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iK2D7LF/sghXdHpGHS7mVCy8SiMQYaCpX4oIGpbRVXC7QUK+njeBB68F0WKNOXyHyQ8pjNd8ETeF1VfZPrMDMv5Fr71gNs8lV8SUH9soPYfZsB9Qo2qisChGXFcSRCAbG/g7i41dZBHQDgy0YY+pJGavkClC93C3dPQUGf2Dc4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=BsMEdpTo; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="BsMEdpTo"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3687f8fcab5so1737037f8f.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 29 Jul 2024 18:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1722302547; x=1722907347; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=atIUIGBb2HZmkEQhyByaolSXjemxdihXBlNNvAfuJPM=;
        b=BsMEdpTol3SkAl1GUl0P7B8xHiz3DU1e7tg5AGSDCxeS037FdpuXx/lJqPjCSaOEGQ
         qv4tWK+9hIfBAtONcrJ1NDUokoku+rlR4mbeETc206Ia4I61LmrmyVzTmssdlO2WW4OW
         oqtEDLvcAmF/Kjj0FbXlmc4znctkjB4Qsz/Y1TbZ26inZo3D2bu0Sy9FO7EHvhpPNOiY
         QI5xTx+l/txy4X6IrCqWtwgdz8163QVLDtd5U3hDUKOl3juofCWwVtURLLLuLDMgsRjv
         /esfCMrm46grO2vuibOFpYCZM1G8cjf2LyfxX++wp/N5e8gGCuLzw1CKj52jMek5yt8u
         2RNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722302547; x=1722907347;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=atIUIGBb2HZmkEQhyByaolSXjemxdihXBlNNvAfuJPM=;
        b=axA+XvqIpPJ/XoZnavnOFnY2jRkTpuvpG7tVbxXDrY5yYNtZZetJX5gxwZyLtdCRat
         ISufMKik/ETRYRraJ6ZhkLohw2UsXkxu0EWmLqYP7ABUaUPc39kIt6SvJZDcYpKQUbxI
         Qr/04TyvfPnD868tYzESp32N+iyRww0JuuCY8nY/V1TcF0QFIQBjeQKfxPOHn5mi6m4J
         tCAlp6xbt0yRaZ5L1Iku277crO9LAmPDtSIZ5GjfIwIOyqqZ7lEHZ+RVRaYy8KT6uKPf
         h5GY9c8xu1pddgLHGRqdKdJEpX/Q8olyr+mxrhkrH30jg3ObDUQnFE1m07nXGRwStb5a
         l2kQ==
X-Gm-Message-State: AOJu0Yx0vWT7ZWM5fGaeDohWpJsremJ7saqvsIIUqRbvMhqa08MN2SfV
	ek6dCVl7C70jQIucR1xTHbGQw6ljMrbuJ0AzrEhaCxVb6ZtUKvCX3N7vZBZiM9o=
X-Google-Smtp-Source: AGHT+IGQudFzCmE3WdEOwPT/5fNBrTwAnv2KDNFlIgxerUQb5guVtB7tSfE+UicktbGSj3A6YLaXHw==
X-Received: by 2002:a5d:5f51:0:b0:35f:1f8a:e69a with SMTP id ffacd0b85a97d-36b5d073f43mr9877715f8f.49.1722302547184;
        Mon, 29 Jul 2024 18:22:27 -0700 (PDT)
Received: from [192.168.2.179] ([2406:4440:0:105::28:b])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fed7ee1482sm90121865ad.155.2024.07.29.18.22.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jul 2024 18:22:26 -0700 (PDT)
Message-ID: <52c4a690-b181-434f-ae9a-0a8a71c4423d@suse.com>
Date: Tue, 30 Jul 2024 09:22:23 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] ocfs2: adjust spinlock_t ip_lock protection scope
To: Heming Zhao <heming.zhao@suse.com>, joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev
References: <20240729080454.12771-1-heming.zhao@suse.com>
 <20240729080454.12771-4-heming.zhao@suse.com>
Content-Language: en-US
From: Su Yue <glass.su@suse.com>
In-Reply-To: <20240729080454.12771-4-heming.zhao@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2024/7/29 16:04, Heming Zhao wrote:
> Some of the spinlock_t ip_lock protection scopes are incorrect and
> should follow the usage in 'struct ocfs2_inode_info'.
> 
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>

LGTM:
Reviewed-by: Su Yue <glass.su@suse.com>

> ---
>   fs/ocfs2/dlmglue.c  | 3 ++-
>   fs/ocfs2/inode.c    | 5 +++--
>   fs/ocfs2/resize.c   | 4 ++--
>   fs/ocfs2/suballoc.c | 2 +-
>   4 files changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index cb40cafbc062..28ab6578f957 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -2232,6 +2232,8 @@ static int ocfs2_refresh_inode_from_lvb(struct inode *inode)
>   	else
>   		inode->i_blocks = ocfs2_inode_sector_count(inode);
>   
> +	spin_unlock(&oi->ip_lock);
> +
>   	i_uid_write(inode, be32_to_cpu(lvb->lvb_iuid));
>   	i_gid_write(inode, be32_to_cpu(lvb->lvb_igid));
>   	inode->i_mode    = be16_to_cpu(lvb->lvb_imode);
> @@ -2242,7 +2244,6 @@ static int ocfs2_refresh_inode_from_lvb(struct inode *inode)
>   	inode_set_mtime_to_ts(inode, ts);
>   	ocfs2_unpack_timespec(&ts, be64_to_cpu(lvb->lvb_ictime_packed));
>   	inode_set_ctime_to_ts(inode, ts);
> -	spin_unlock(&oi->ip_lock);
>   	return 0;
>   }
>   
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index 2cc5c99fe941..4af9a6dfddd2 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -1348,14 +1348,15 @@ void ocfs2_refresh_inode(struct inode *inode,
>   		inode->i_blocks = 0;
>   	else
>   		inode->i_blocks = ocfs2_inode_sector_count(inode);
> +
> +	spin_unlock(&OCFS2_I(inode)->ip_lock);
> +
>   	inode_set_atime(inode, le64_to_cpu(fe->i_atime),
>   			le32_to_cpu(fe->i_atime_nsec));
>   	inode_set_mtime(inode, le64_to_cpu(fe->i_mtime),
>   			le32_to_cpu(fe->i_mtime_nsec));
>   	inode_set_ctime(inode, le64_to_cpu(fe->i_ctime),
>   			le32_to_cpu(fe->i_ctime_nsec));
> -
> -	spin_unlock(&OCFS2_I(inode)->ip_lock);
>   }
>   
>   int ocfs2_validate_inode_block(struct super_block *sb,
> diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
> index c4a4016d3866..b29f71357d63 100644
> --- a/fs/ocfs2/resize.c
> +++ b/fs/ocfs2/resize.c
> @@ -153,8 +153,8 @@ static int ocfs2_update_last_group_and_inode(handle_t *handle,
>   
>   	spin_lock(&OCFS2_I(bm_inode)->ip_lock);
>   	OCFS2_I(bm_inode)->ip_clusters = le32_to_cpu(fe->i_clusters);
> -	le64_add_cpu(&fe->i_size, (u64)new_clusters << osb->s_clustersize_bits);
>   	spin_unlock(&OCFS2_I(bm_inode)->ip_lock);
> +	le64_add_cpu(&fe->i_size, (u64)new_clusters << osb->s_clustersize_bits);
>   	i_size_write(bm_inode, le64_to_cpu(fe->i_size));
>   
>   	ocfs2_journal_dirty(handle, bm_bh);
> @@ -564,8 +564,8 @@ int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input)
>   
>   	spin_lock(&OCFS2_I(main_bm_inode)->ip_lock);
>   	OCFS2_I(main_bm_inode)->ip_clusters = le32_to_cpu(fe->i_clusters);
> -	le64_add_cpu(&fe->i_size, (u64)input->clusters << osb->s_clustersize_bits);
>   	spin_unlock(&OCFS2_I(main_bm_inode)->ip_lock);
> +	le64_add_cpu(&fe->i_size, (u64)input->clusters << osb->s_clustersize_bits);
>   	i_size_write(main_bm_inode, le64_to_cpu(fe->i_size));
>   
>   	ocfs2_update_super_and_backups(main_bm_inode, input->clusters);
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index dc421f55ed8f..e2569b0d6204 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -790,9 +790,9 @@ static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
>   
>   	spin_lock(&OCFS2_I(alloc_inode)->ip_lock);
>   	OCFS2_I(alloc_inode)->ip_clusters = le32_to_cpu(fe->i_clusters);
> +	spin_unlock(&OCFS2_I(alloc_inode)->ip_lock);
>   	fe->i_size = cpu_to_le64(ocfs2_clusters_to_bytes(alloc_inode->i_sb,
>   					     le32_to_cpu(fe->i_clusters)));
> -	spin_unlock(&OCFS2_I(alloc_inode)->ip_lock);
>   	i_size_write(alloc_inode, le64_to_cpu(fe->i_size));
>   	alloc_inode->i_blocks = ocfs2_inode_sector_count(alloc_inode);
>   	ocfs2_update_inode_fsync_trans(handle, alloc_inode, 0);
