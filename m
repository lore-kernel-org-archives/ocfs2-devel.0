Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95AFC10A12
	for <ocfs2-devel@lists.linux.dev>; Wed,  4 Sep 2024 02:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725418587; cv=none; b=tK3hszFd7SXPA/DLtsBihH7OUbQSEHojb0e57r/WQNrKPcCZh1AvA94RMwFcsdGkHaVlT/CASaeHkE4E1SldUbas7/QPoeVYWMK5YbwMvpyM7AoeWZDO2ZQnSsxGvwd1PwHxsU2UvmFtGC3YU2zEZaWglKn6M+fUavdEb2kheuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725418587; c=relaxed/simple;
	bh=14rH4WdkWdWibctUOK+kPWCfmXRDXsOefGe6wfN/PaM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PK0r8f1V59Uhwd60Hn82DUjiksDUgMS2Vr3xs/2Yv+kYD9Xxl+1duLjvN7Ixq5ioHlSXon06dCzs9RepWQDHFTwMZOtQNW1qMgvabp3mGopui1EpqjxifUNSlM7G4jpGs/lbAqRg2rfwKRVR9dmnbvubyH945eMPxxbGXFNx9JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=DimGEDZI; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="DimGEDZI"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-42bbbe94b88so6868535e9.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 03 Sep 2024 19:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1725418583; x=1726023383; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ubn5GPjsridgsmOU05JKYbFNp+11/YV274NOu1eTxQM=;
        b=DimGEDZIv5OqMKJlV/0u9RB6GUlukogTwBvb3DQeertTVHqHHWQG1EZg40E9utij/Z
         oUhR/yu9Obg75UPD9B3Q1nZd6TboeRIQRQbbfBu48dXBG8z9UMcDb/EvkMwCQU5S2oGx
         wvuMPLqi7ZVpW9n8cQ86zuWjwYF0CXhD/w6ysWh1Nnn4VrSVfqMi6g6oSvVDBXvncBc5
         v4K7bzTtLUKIxdayFY9qWdNbmj5e8UsSdMH4oYYrobBxCZK1z95YhqfEpMw9rCPKeR2X
         EMx1b8Dk5uC1hGBXEJanSlGom3ZjE5JH/uBhw3rFio1xJ6d0Zjeea6ckWUNfsyqAs9/d
         4jow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725418583; x=1726023383;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ubn5GPjsridgsmOU05JKYbFNp+11/YV274NOu1eTxQM=;
        b=MqOuON+s3sLKZNQQlxdTDkETmXzYHd4KrO/F3v/flpYg9MTAmTUzKIiu/3JRxVnP+Y
         h5Tp7PbJ6JvZQak8tBmHJjFS+O5nFKlihLZMabg/yjnGSjiKhORxDeXOcjlk5AVPexou
         6yLNoyRZiyxcWQ+cq4CTrNfrwPRDNxMbRjlaqbfHosgkkc65XTS5TkQkVZMOwoxTPjxY
         N4Cl2HVa8njhwPPfbqmHhj3OvceRzZcy8KD8C/lzMsd2BvRng8RSAXMXhi6U6Ri5Igbt
         1dWAAoB7ADTh4U+y81keUkURYBIZ4jYtaRUUvt0LYprdDjb25CnGLRKB6cxBDfD1kyuB
         IHwQ==
X-Gm-Message-State: AOJu0Yzjmse1LDtbDYGhdgOfcyEKH0f3fB9u8ihFxHeJLc52Oax4vSFB
	pENzfygxP3XMCBE4jiODaFxZRVQ+A8e0m8kNEZqbRRFe9/qAEP8Ydz6vOIvznUc=
X-Google-Smtp-Source: AGHT+IEJXBKc6njWxBLSEnW5c7t5V760KTvEErAuOB8Hq4eRJ+IEicwbGrEqupTSPBpcNn2ALmi9tw==
X-Received: by 2002:a5d:588e:0:b0:374:d088:476f with SMTP id ffacd0b85a97d-374d0884b17mr2791420f8f.5.1725418582334;
        Tue, 03 Sep 2024 19:56:22 -0700 (PDT)
Received: from [10.202.32.28] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71778533261sm566410b3a.71.2024.09.03.19.56.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Sep 2024 19:56:21 -0700 (PDT)
Message-ID: <0d6730e8-9a58-45ba-9e57-c22039f03253@suse.com>
Date: Wed, 4 Sep 2024 10:56:18 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: cancel dqi_sync_work before freeing oinfo
Content-Language: en-US
To: Joseph Qi <joseph.qi@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 syzbot+f7af59df5d6b25f0febd@syzkaller.appspotmail.com
References: <20240904020949.1685198-1-joseph.qi@linux.alibaba.com>
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <20240904020949.1685198-1-joseph.qi@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/4/24 10:09, Joseph Qi wrote:
> ocfs2_global_read_info() will schedule dqi_sync_work. So any error
> occurs after it, we have to cancel this delayed work first before
> freeing oinfo, otherwise it will trigger the following warning with
> CONFIG_DEBUG_OBJECTS_* enabled:
> 
> ODEBUG: free active (active state 0) object: 00000000d8b0ce28 object type: timer_list hint: qsync_work_fn+0x0/0x16c
> 
> Link: https://syzkaller.appspot.com/bug?extid=f7af59df5d6b25f0febd
> Reported-by: syzbot+f7af59df5d6b25f0febd@syzkaller.appspotmail.com
> Tested-by: syzbot+f7af59df5d6b25f0febd@syzkaller.appspotmail.com
> Fixes: 171bf93ce11f ("ocfs2: Periodic quota syncing")
> Cc: stable@vger.kernel.org
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>   fs/ocfs2/quota_local.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
> index 8ce462c64c51..ebe0dbc8db4a 100644
> --- a/fs/ocfs2/quota_local.c
> +++ b/fs/ocfs2/quota_local.c
> @@ -782,6 +782,7 @@ static int ocfs2_local_read_info(struct super_block *sb, int type)
>   		if (locked)
>   			ocfs2_inode_unlock(lqinode, 1);
>   		ocfs2_release_local_quota_bitmaps(&oinfo->dqi_chunk);
> +		cancel_delayed_work_sync(&oinfo->dqi_sync_work);
>   		kfree(oinfo);
>   	}
>   	brelse(bh);

In my view, there is one problem:
If ocfs2_global_read_info() returns error before ->dqi_sync_work is
initialized, above code will trigger wild pointer error.

-Heming
