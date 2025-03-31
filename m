Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4308D1876
	for <ocfs2-devel@lists.linux.dev>; Mon, 31 Mar 2025 03:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743392873; cv=none; b=K8kzvAYS7TZMeT/dZOADQasmJatV+WCjDh7oEOZYrB2E8/wzdHf50OXl4GKYXEVtfM9Dle3fPjh/AFP7eYFsYd8zFZbG4egXDKYbieYzItL2RKdlockk2TwNuOY4k8q8DSRMuC+h4/wevIUCrkPHIJlbqhlBUTGnCMpKMNS03qA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743392873; c=relaxed/simple;
	bh=FMfOvDnt30Fad/t5QfefmzJEN9WgnTdM+M+qb4cCDM0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O79P9VfHOxb/yEXvi2V1lD+wZ/NXVJ8E3mQlhT+ihUIH1ODGuMnkUXQOJtd49i45tYj+ivzcvibndXBnObmEN4PuO3plIuG7lluE7vBj8D9IE75F9He2xY7KQVnSgLSQi/9coul5miK2mstjhlK76DaI79fHidJ9AJT/Xy8ll+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=AUzLyeAP; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="AUzLyeAP"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-43935d1321aso3800955e9.1
        for <ocfs2-devel@lists.linux.dev>; Sun, 30 Mar 2025 20:47:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1743392868; x=1743997668; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ox8RCPAc/PLiGZZEUysehX7JfG73ej3P9CWPn0N4YmE=;
        b=AUzLyeAPMZDTCqK4wqpHGT3mn4SbTu7sFqQl8p9um5fYKWoGiJ14TDe/Vh004VBhV2
         yf8nhZkA9JCAojfFOMOuMaWoskAP1QSf/YxaEMhCRgXE39Y3p3KHzFp/5Vhq8f0YKib/
         6CgGP6uKDKyM4IrpP5g5eDrdmy7ydqV+77Z2X0B7s3vpzg+3fP1zvKRaVHPpLuNNM6Rw
         SU3hyQtbX/7LXw9I8Q+UtAMvOCA67Cm5+MAnKU5Z8IQAJiGJO3OhrG72jLDvyLIiAgO6
         Aaf3Ep0dhmBW6GKUA/CO6Ao1xKDzW4wCopvz7+veyUxl9KCyhhvaZLuJAtzVGbfSh6Y2
         9n8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743392868; x=1743997668;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ox8RCPAc/PLiGZZEUysehX7JfG73ej3P9CWPn0N4YmE=;
        b=xKC1KqECTGBa663AjZbL2fwPDNs2qGZQ6X1IQG6Pw5BXPuvOeVMW3xmevLC2Sxfz1b
         xLyp0ag4fVhgHiM2YTFwKWlemAj3dguilmC6/J1huSaH0snOtJn9UklEhC67vEQg3kLP
         aNC/x+XTVk7Gfy0l3/xM4OvKfi7sVSZPtO/XTl1a9rnYgOXR6Ckv11FZ4xOyOKxyL+GN
         SgVnV9iC5u+kd5lXuLNGGy56zHWb/wsBkUwt15lCQsN4j5b+iEcc0uJyOAYdqD6L3WI8
         gsgW5yMmFhVTxYisX+T/Qq4CTIS9V0VwANljLVmUZOTdqPWiDqh+nm1UnGrxKWDxgoJv
         YIPw==
X-Gm-Message-State: AOJu0YyiXiQ0xSnXnBbUDNT4BKZKXON9k8zEeP5N9mbG/QHFrSJ1a++a
	3GRv4tlInB2su+I4cLJFTvU8iKCDj0qJe3eJ1XQVoZBKtDjjgIX5kZ5vc7mKez9WsX3tz5HS0NI
	s
X-Gm-Gg: ASbGncvCF1rgKKdCMX4JcWVTZOoPX+GGatHSpBDkOdVLX7kML+xKDXtpptGSzdZcyJ3
	MXzgDhxhgOxYAZzApzleHbVA1yZaWhp/XW/ph0tv684NObcenULWDX06IVA5W356zTPrR6gr+eL
	97Bgxt1tptDxCglnzIPQHsELs6YeBWMJUfj6q8gPEXuID1gqSmECfGQZQfURujp4nLeyE7M1tlf
	jNqLhTmkxb57f6m3ZQcwnZSkFPBHQz65AauD5+6pHdawAPLShEOkSbtEMkFCxwTXJkL95ONCJpo
	upHt6QqHC6Cb+Px1RkBa4+CgvaZdt5XxkTiqaEd/yuZu+s5QNCW1K/yUHKi73Q==
X-Google-Smtp-Source: AGHT+IEBdAYoQt/GGX/pCYZQo0++T7o+xAWHc1C/mbNvwv2Jivr8uhePRe+gs/gnSqzXM4Nti1FIiw==
X-Received: by 2002:a05:600c:4e87:b0:43b:c962:ad29 with SMTP id 5b1f17b1804b1-43db61d8dc0mr18015015e9.1.1743392868489;
        Sun, 30 Mar 2025 20:47:48 -0700 (PDT)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73970e22449sm6033684b3a.49.2025.03.30.20.47.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 30 Mar 2025 20:47:47 -0700 (PDT)
Message-ID: <9390ba6d-8fc9-4cc0-b000-9d5ef0ec3393@suse.com>
Date: Mon, 31 Mar 2025 11:47:44 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND] ocfs2: Validate chain list bits per cluster to
 prevent div-by-zero
To: Qasim Ijaz <qasdev00@gmail.com>, mark@fasheh.com, jlbec@evilplan.org,
 joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 syzbot <syzbot+e41e83af7a07a4df8051@syzkaller.appspotmail.com>,
 stable@vger.kernel.org
References: <20250329111654.5764-1-qasdev00@gmail.com>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <20250329111654.5764-1-qasdev00@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 3/29/25 19:16, Qasim Ijaz wrote:
> The call trace shows that the div error occurs on the following line where the code sets
> the e_cpos member of the extent record while dividing bg_bits by the bits per
> cluster value from the chain list:
> 
> 		rec->e_cpos = cpu_to_le32(le16_to_cpu(bg->bg_bits) /
> 				  le16_to_cpu(cl->cl_bpc));
> 				
> Looking at the code disassembly we see the problem occurred during the divw instruction
> which performs a 16-bit unsigned divide operation. The main ways a divide error can occur is
> if:
> 
> 1) the divisor is 0
> 2) if the quotient is too large for the designated register (overflow).
> 
> Normally the divisor being 0 is the most common cause for a division error to occur.
> 
> Focusing on the bits per cluster cl->cl_bpc (since it is the divisor) we see that cl is created in
> ocfs2_block_group_alloc(), cl is derived from ocfs2_dinode->id2.i_chain. To fix this issue we should

The cl (chain list) is created by ocfs2-tools during the execution of mkfs.ocfs2.
ocfs2_block_group_alloc(), as its name, which creates block groups, not chain lists.

> verify the cl_bpc member in the chain list to ensure it is valid and non-zero.
> 
> Looking through the rest of the OCFS2 code it seems like there are other places which could benefit
> from improved checks of the cl_bpc members of chain lists like the following:

Syzbot performs fuzz testing, in real-world it's very difficult to clear
the cl_bpc value. For this issue, checking only the divisor value is sufficient.

> 
> In ocfs2_group_extend():
> 
> 	cl_bpc = le16_to_cpu(fe->id2.i_chain.cl_bpc);
> 	if (le16_to_cpu(group->bg_bits) / cl_bpc + new_clusters >
> 		le16_to_cpu(fe->id2.i_chain.cl_cpg)) {
> 		ret = -EINVAL;
> 		goto out_unlock;
> 	}
> 
> Reported-by: syzbot <syzbot+e41e83af7a07a4df8051@syzkaller.appspotmail.com>
> Closes: https://syzkaller.appspot.com/bug?extid=e41e83af7a07a4df8051
> Cc: stable@vger.kernel.org
> Signed-off-by: Qasim Ijaz <qasdev00@gmail.com>
> ---
>   fs/ocfs2/resize.c   | 4 ++--
>   fs/ocfs2/suballoc.c | 5 +++++
>   2 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
> index b0733c08ed13..22352c027ecd 100644
> --- a/fs/ocfs2/resize.c
> +++ b/fs/ocfs2/resize.c
> @@ -329,8 +329,8 @@ int ocfs2_group_extend(struct inode * inode, int new_clusters)
>   	group = (struct ocfs2_group_desc *)group_bh->b_data;
>   
>   	cl_bpc = le16_to_cpu(fe->id2.i_chain.cl_bpc);
> -	if (le16_to_cpu(group->bg_bits) / cl_bpc + new_clusters >
> -		le16_to_cpu(fe->id2.i_chain.cl_cpg)) {
> +	if (!cl_bpc || le16_to_cpu(group->bg_bits) / cl_bpc + new_clusters >
> +		       le16_to_cpu(fe->id2.i_chain.cl_cpg)) {

checking cl_bpc makes sense.

>   		ret = -EINVAL;
>   		goto out_unlock;
>   	}
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index f7b483f0de2a..844cb36bd7ab 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -671,6 +671,11 @@ static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
>   	BUG_ON(ocfs2_is_cluster_bitmap(alloc_inode));
>   
>   	cl = &fe->id2.i_chain;
> +	if (!le16_to_cpu(cl->cl_bpc)) {
> +		status = -EINVAL;
> +		goto bail;
> +	}
> +

See my previous comment, this part code is useless, please remove it.

Thanks,
Heming

>   	status = ocfs2_reserve_clusters_with_limit(osb,
>   						   le16_to_cpu(cl->cl_cpg),
>   						   max_block, flags, &ac);

