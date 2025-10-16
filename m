Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34061F418D
	for <ocfs2-devel@lists.linux.dev>; Thu, 16 Oct 2025 22:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760653298; cv=none; b=K5sgzu2Y4R7v/tsBPskQ3750hetyv1WmVrIB3nBPauYJk25+EFfOPrpRQRJSLxnsrq0tKkbEif/QlQF8YDWxFuRrp+02DnsyxBdSyKsdGttgP98OUHpK3hNvCNkk/DzxXGN7e0mbYyclVyneYhVX8oKW/qXcF57F1hY+ODnyF/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760653298; c=relaxed/simple;
	bh=fn0QIOjAfmgRPDMjiYhI3qaqXZfEOxvDEvLbYSwWdPw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dH6b9Ax+0dXD7QZh2sXS/EWZaF2bp6WYww2cnf6zmft6hRNezJNRLKE5uYovcUJGPQFWkwTQUAHHDwD3ITkjyLmdIOtH7CSR9n1QK157V0RxAbDSAtKbIiQaMCb61S5W+9gFqxXY2+bvY+mbXWba8Iewv4+JQEZN58zeUqGAz7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gFuEe4ls; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gFuEe4ls"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-46e38c21fafso2414035e9.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 16 Oct 2025 15:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1760653294; x=1761258094; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Oh3Ls6Reupo8w6Ru+NE56MRhyUuoVaX3SQZwJbXOQ/Y=;
        b=gFuEe4lsI+Y9JDAdHtxFvgKHutOidvmmDUDwAyYe6jloPisMO6LNJsMwVKFN5wZTAB
         Asr32i+BBTpvv9+5xUkwcusUgsaj9rtxEw2o/s+C2MPHVoFl1Z8njYuUQQ4mKZHC1rS9
         e9EwXM93bugCpCzagRhR43nUSTSg63iUDnZWQpvonPWltIIH6RxUzXt2VTedeFenIFV4
         G6ZV8U7eDwd5PunvGUUoFqz2iCGGJP7gPTVbzQHELOeRWc/lZ7bKAd+3E3WRxCCRtuca
         Wbt0hS+LDgxQewDU4LbtdXc3NHew0W2fAJpwDA0jm5B08kAZVf8LgHTbXq/7iGOUDOaA
         EGvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760653294; x=1761258094;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Oh3Ls6Reupo8w6Ru+NE56MRhyUuoVaX3SQZwJbXOQ/Y=;
        b=R2P2d09s2XApIoMC3pMOFlGTR8E/2zTQmf5NDgljmI0WObWxfBhyl4zpM52st7rYj/
         w5nxwk+JU0mSr+WT1eitGNfdPv/7TQjEmdCFZEONTrys63L/RXMIxFrqByH3E61iPack
         YvUJcFhyrzkE3YPY+FTdo/+bmj1Z913ojy+GxhTyhY8pY2RnbEY2lAq3XVZnQTkwhKUi
         FE4DzwvxecxTcRxS9QN6msFWW4yKrLtqrnReiQYQpZMnxUQ+Qr1R4X80Ks6Dt9WDhiWL
         USfSeFVN+yuS40X/dEU9dIEXT5+LfoguQfDKP7rTyix0LusauFVojuGLqQnNE/yBpycY
         Ia3Q==
X-Gm-Message-State: AOJu0Yx8PSdDZQ/jst0oMKSwbflvwM3khwR7T/6vQNAwmU8Gt8HIa+ca
	bHgyGz2ETnRUjofNDdOGlWMexttYrMev6Kvub9dWMPVbXxhcc84faMBCesUbQ8WJLEw=
X-Gm-Gg: ASbGncvQIuMVOE5QoguE88Qoh235RddUaxsJ/77O8/fnWERrkHz3tMlK04Jf2DK+qQ+
	Iu74c/3d/1792XdKOctmGwRvh0W24WCui2de4WrgN/dpfz2nkpCXRvNHYvZzJ60JTr2zC1F/Lrw
	wEsIbPT3l8KBePvnzzfAPd5wuBDMMT7KXIUrSbCXxIBEctGqS2dm+0NGPOjUuYheRa5SyWVK+33
	Z1DB9oXc9BAFI6ggdohRvfYyV8xBHwJE/Yu6IuWJ1dDrD6+7CVg/dsEBgzICEnxRtFMkGEIzplC
	KABx7LBq4WS3SU0dpHvaUFBUCbuJO3tyOeHvAFEFkckF5TmuOHaqELUAAvgLU1r3mJkD1ya6Jy+
	FSJRf1l6FuquZJPGiR94CZPvvGkNmnrdW4JhIa7LjObh2lV0GZnlQDEnnxvwtvpe9QBGRa8hfjS
	VW6LwJATEFFt1rH3qbpn0FdUFp6qXf
X-Google-Smtp-Source: AGHT+IHlts03je2m39rP9irQ7jl1isIcFSU1pDNVXBlAvTIK9PgZCCSDIRMU5M2VyOdKCFPvXq9whg==
X-Received: by 2002:a5d:5848:0:b0:3f4:52d3:7a6a with SMTP id ffacd0b85a97d-42704dd390emr622215f8f.10.1760653294017;
        Thu, 16 Oct 2025 15:21:34 -0700 (PDT)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a20e5f9eb8sm5767498b3a.41.2025.10.16.15.21.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Oct 2025 15:21:33 -0700 (PDT)
Message-ID: <2f30e51e-46e7-41f0-90d2-8076cf87dbbb@suse.com>
Date: Fri, 17 Oct 2025 06:21:29 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: add directory size check to
 ocfs2_find_dir_space_id()
To: Dmitry Antipov <dmantipov@yandex.ru>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, lvc-project@linuxtesting.org,
 syzbot+ded9116588a7b73c34bc@syzkaller.appspotmail.com
References: <20251013103709.146001-1-dmantipov@yandex.ru>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <20251013103709.146001-1-dmantipov@yandex.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/13/25 18:37, Dmitry Antipov wrote:
> In 'ocfs2_find_dir_space_id()', add extra check whether the directory
> data block is large enough to hold at least one directory entry, and
> raise 'ocfs2_error()' if the former is unexpectedly small.
> 
> Reported-by: syzbot+ded9116588a7b73c34bc@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=ded9116588a7b73c34bc
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>

Reviewed-by: Heming Zhao <heming.zhao@suse.com>> ---
>   fs/ocfs2/dir.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
> 
> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> index b9bf1428a3d9..3c2dacba9b0a 100644
> --- a/fs/ocfs2/dir.c
> +++ b/fs/ocfs2/dir.c
> @@ -3444,6 +3444,14 @@ static int ocfs2_find_dir_space_id(struct inode *dir, struct buffer_head *di_bh,
>   		offset += le16_to_cpu(de->rec_len);
>   	}
>   
> +	if (!last_de) {
> +		ret = ocfs2_error(sb, "Directory entry (#%llu: size=%lld) "
> +				  "is unexpectedly short",
> +				  (unsigned long long)OCFS2_I(dir)->ip_blkno,
> +				  i_size_read(dir));
> +		goto out;
> +	}
> +
>   	/*
>   	 * We're going to require expansion of the directory - figure
>   	 * out how many blocks we'll need so that a place for the

