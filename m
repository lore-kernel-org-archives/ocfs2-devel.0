Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2833323771E
	for <ocfs2-devel@lists.linux.dev>; Mon, 13 Oct 2025 07:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760342206; cv=none; b=SGd1DZHogU1qyrv0OII7ZJB8F3wMnidWk06YJlpdYB7utowEHjzyXkOXLPD5xOPez/ukp6eoEsUAquKDINupYjoUdzBdjHjbkc3CDcgs6+EefoHxVk7YOdDr1z1GMI5NfAsLP8p3jXzo4H8O846nw+6kXmo0p2q7FRLitr9YfKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760342206; c=relaxed/simple;
	bh=mzYDimvZfhYkcrezHs6y91wRagKRDYC9y8xOj2g5Te8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XBqyUrBwhIk/8w3lgH4qq53k/Si67G8VPQ0fzijjz9oNuUHnT1iyrNc/3SkNlGzTd0gZofZJKKbiDmMNUvttm9B5rkeOvB4NAvBFib0qIFJeBVY7q9CK+zGFPeFnPHHZcPsRWU9zLUIAdBgOXGnOpoG0Cb2cESRlf0Ln75t/jeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=g19Xcia/; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="g19Xcia/"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3ecdd162cd1so292452f8f.2
        for <ocfs2-devel@lists.linux.dev>; Mon, 13 Oct 2025 00:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1760342202; x=1760947002; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3GuJvs8IwTKt1ewnJX1dAUs7OwdAMzrg4H2b4rWBHhE=;
        b=g19Xcia/ccWn4sBWp8QuNkndIM8QcLbwq6HJfV1r7923gjQAr90ycVF8KKX7PMeoN4
         tIO8X40JD4/Vh+eTAAuPJcAhsrKSh4e7pv+DK2CfyIMZrjJxIW6G22vXfPHTilaqNbe3
         2drIKEjziOszpZ8nfuVM41tRDaknjfFDf5Pk9D33hZgXGx6xTbKZsF+9vVV04rNwLtuO
         Lk3WucwZyM4E2lNaBT9YGb+SkNBD5nvcQo/noIUD+mADe5a1fqUkwmgxgJqDI6YrvcVz
         nFM/7K7ker5B02v/+1DF/skwG29BxALtD4s0VaESQN3ej1nnWw11Q7M1tvuyEfKXxMbB
         sr0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760342202; x=1760947002;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3GuJvs8IwTKt1ewnJX1dAUs7OwdAMzrg4H2b4rWBHhE=;
        b=UAY0GaRnime1hn7PdmYSsdxRMppD5q2xSe7LtlJeG+KDp4SsGefRIh1gdUqrUOLinh
         j5SN3nNVCLV0XQ/GJWaMij2OcLYj/+9OQys/bej8fVJ6hEfyY1Br4EC624jO0o9f3HLx
         BsmAs6XzBE+2UAmjb95P6dqVSXxEYuRHUfgUFKFouJwChQQ+f0tpuQ2u+nJwhR8xl9n7
         V1JS11LIQ94eih/qUcu9xwDCeQPN6WIZvyy4LIW/S7DNtzpH8sH4D8PLLjW5mjFGzHzt
         SSA6Fq8Z0XnlxMNgvDEs87WFsJCmmFlXETBrHdfOm49K6L/PauORf7pd0ZJaYE1n7s/2
         Iv9Q==
X-Gm-Message-State: AOJu0Yx4ogWz1HfdXZc55/d2gvw+9CG7ZMU3PBBorWKqxQkY7AZrzfmH
	p9qzmbMrztfkR+cn7Tc6PH7VD+jmsiqqwGTNNrya+NuXc0RmZxdXekc+29gx39Of4us=
X-Gm-Gg: ASbGncvWrwqFD7NSWgIp05gfE4SgJT7h+AVxWT7OiecXTyJ1GpUPypZjfgQdvFdZeTj
	r1fiwmF6ZxQ+ICoGEsayIQzOM0HRyPp9ZiiXo0OAd1F2FXCDnZ8842kT+QKkNOmubnYZYBcQP9A
	ghWSKKrYcGddzdWVlTKT1rY9IoO3C0iQ5ziBIJC/o942+BXwgf//0TSDohz3MsW1CP9kgzmYjoq
	l8XNKiAncQP+QUFgnVisFIsgEwjoCjPOd3+5eYG6VfqDX7X24+tX/EGS8fh/mXWzVpCb3CboZZM
	jrLWW1yspzqsyMAm6yn5oTKhQjqedacDnkrpbobuv3zWe4AveE0sYoqc30XmcDLcUgXXSX64XsQ
	gEdxHWCqrL7v+fIa4iaDAT57CGH15LZU7lbhZrwVrJpkp62PDPu3zWY5aDL4=
X-Google-Smtp-Source: AGHT+IFShbotpGDUxTLcvjFU2gWzZbVe42UqshtTF3ceWOFyf+Dw0Y9SwTuW+nJX1ws4R1oZcbdHsQ==
X-Received: by 2002:a05:6000:18a4:b0:3e9:559c:13f6 with SMTP id ffacd0b85a97d-42666aca3b5mr7112358f8f.2.1760342202140;
        Mon, 13 Oct 2025 00:56:42 -0700 (PDT)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034f08d1bsm124734725ad.68.2025.10.13.00.56.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Oct 2025 00:56:41 -0700 (PDT)
Message-ID: <4b43da6e-a3fb-4368-8f89-9c5c0fb86eb3@suse.com>
Date: Mon, 13 Oct 2025 15:56:37 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: add boundary check to ocfs2_check_dir_entry()
To: Dmitry Antipov <dmantipov@yandex.ru>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, lvc-project@linuxtesting.org,
 syzbot+b20bbf680bb0f2ecedae@syzkaller.appspotmail.com
References: <f5c8060f-fff2-4c16-afec-ac750550cc30@suse.com>
 <20251013062826.122586-1-dmantipov@yandex.ru>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <20251013062826.122586-1-dmantipov@yandex.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/13/25 14:28, Dmitry Antipov wrote:
> In 'ocfs2_check_dir_entry()', add extra check whether at least the
> smallest possible dirent may be located at the specified offset
> within bh's data, thus preventing an out-of-bounds accesses below.
> 
> Reported-by: syzbot+b20bbf680bb0f2ecedae@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=b20bbf680bb0f2ecedae
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>

Looks good to me.
Reviewed-by: Heming Zhao <heming.zhao@suse.com>> ---
> v2: adjust error message (Heming Zhao)
> ---
>   fs/ocfs2/dir.c | 17 +++++++++++++++--
>   1 file changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> index ece0462a5d26..b9bf1428a3d9 100644
> --- a/fs/ocfs2/dir.c
> +++ b/fs/ocfs2/dir.c
> @@ -302,8 +302,21 @@ static int ocfs2_check_dir_entry(struct inode *dir,
>   				 unsigned long offset)
>   {
>   	const char *error_msg = NULL;
> -	const int rlen = le16_to_cpu(de->rec_len);
> -	const unsigned long next_offset = ((char *) de - buf) + rlen;
> +	unsigned long next_offset;
> +	int rlen;
> +
> +	if (offset > size - OCFS2_DIR_REC_LEN(1)) {
> +		/* Dirent is (maybe partially) beyond the buffer
> +		 * boundaries so touching 'de' members is unsafe.
> +		 */
> +		mlog(ML_ERROR, "directory entry (#%llu: offset=%lu) "
> +		     "too close to end or out-of-bounds",
> +		     (unsigned long long)OCFS2_I(dir)->ip_blkno, offset);
> +		return 0;
> +	}
> +
> +	rlen = le16_to_cpu(de->rec_len);
> +	next_offset = ((char *) de - buf) + rlen;
>   
>   	if (unlikely(rlen < OCFS2_DIR_REC_LEN(1)))
>   		error_msg = "rec_len is smaller than minimal";

