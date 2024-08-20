Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC4613211F
	for <ocfs2-devel@lists.linux.dev>; Tue, 20 Aug 2024 04:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724126692; cv=none; b=hOuRkfOh+MyEDl1h8jENIpChQE5mPK1XRcRagQ/JeKzH+PVFSXbo4JKIJYp8di7mE11NJiUBLPEpiQSmupz+F1g+WGiV+DhhoKHQZpXTDtqtp7bSXRDEml9hDRX4WFSryKr5KtW8ArrmlzOSc55IwCQkjgobjl1LJ0DlZh8KZ8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724126692; c=relaxed/simple;
	bh=H23msXZo8TFfWGNB+BXXZdr7WwBND5joU7wNlrIf8gU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aPj4dR0wyDdrx8Ex9FJFu/vDuUpJhBQ65+VgSmJZ9yhDm8K6I6p/RojDVha6Pmbw3pKMOgqkmkRYePBcoVfEVEoGQpY5ZR3QIvhbltxPOdOuFZ3UfSxyj71dfQTZFVe87sYFY08s9QCB2N0nIXmgcHZ0o/g1vcYKCXGGPcvTggs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bMsxpavU; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bMsxpavU"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3718706cf8aso3158037f8f.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 19 Aug 2024 21:04:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1724126687; x=1724731487; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=B40v24EN9IZ3cBGvmjDIed+yCQZBs6o5/vWWPhgdADU=;
        b=bMsxpavUD1VRULMcQ2ckpDnXTl3OXypQAPW+NNsbf4G42ZQaQOODoicQqXZ9wW17Gs
         RsDHt+22u206EJK6ZUj2LQ42DdrHJy+NMHsMyNEdKviikBTZfNm2JM0Ebz+U4a4k1gJy
         EoB65n7PY7YT2kFOJXBxuNpxShPCi3oB5vtItL2RRbI2a7b9NYiS/qxnkN/M/8k9VdHX
         shmRK/orvyyLcxAs7Vbk2vb0MU9BtTyboXy/OYFZTzGddQ8B8UBaPTOrB4kahkYBYteT
         +MbmDRJhsNcvTImjdIHps43hOnmko8LtRqrWQ8uOwy2APfhXJ5ikkhsGaQQLFt9mP2AC
         qhcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724126687; x=1724731487;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B40v24EN9IZ3cBGvmjDIed+yCQZBs6o5/vWWPhgdADU=;
        b=Fkets8YICY4/LWplCABPT4g9gHLmseiLteqecLxGZcW8ggVrfZgK/sGhlionrjWvZC
         nrDRc343A0oCY3Tlg1hGJAWNla2EFN4BceY6jlk7HII+4VDBaoV4XytLQgzlbzJN2hiR
         NGzMLptQDXMavIWhNncQSYuFp7Fw2f8r6aVTKDuNyIf5WzAbFKkQYtI+BIZg+Llz1PZ8
         MkKLAJU7aeIbptOQ22rtQFk7FjyMqoJ/sbWsVTdf9mZ12MQsGZNdCwTDlbIHMbW05xkr
         idN3iJEVPe9FVUee7ALQ0bgVqzejo2CFcZ4EGG7Bq5gk7kTImixIw+WP3sAbxvJayq/I
         Gnbw==
X-Forwarded-Encrypted: i=1; AJvYcCVX6uNinkVbG/W8ujgzVH6qVBKPxmmhNUzFWB6MP6KD1aMOPrUjuD9n9N4yOy8O1oX4MpY3G4qh3zy3LQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YwO6ocQIlRXJIhsLSguutGaZASnKGUY2LLttBGlstfUmZXdemdY
	D9JihdptbAyHlLK92+eIl0YCroMo8aH8Jn6xFDZRaDfJ0V6aMyU7Jb04qGq8/Yc=
X-Google-Smtp-Source: AGHT+IH/CHvuB1V57d0Rh6z699rg/2J9/DbidbURKDXYfGHFDmatIeVh24mQLf0Gdjp61bK1MgorRg==
X-Received: by 2002:adf:a45a:0:b0:371:879f:5cc0 with SMTP id ffacd0b85a97d-371946a4289mr7661975f8f.42.1724126686926;
        Mon, 19 Aug 2024 21:04:46 -0700 (PDT)
Received: from ?IPV6:2408:8409:2423:4cad:2dff:7072:d755:c454? ([2408:8409:2423:4cad:2dff:7072:d755:c454])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d42bd74981sm4116429a91.42.2024.08.19.21.04.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Aug 2024 21:04:46 -0700 (PDT)
Message-ID: <2e662cb6-47d9-4bbd-855d-1f6d5edb8633@suse.com>
Date: Tue, 20 Aug 2024 12:04:39 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: remove unreasonable unlock
To: Lizhi Xu <lizhi.xu@windriver.com>, joseph.qi@linux.alibaba.com,
 syzbot+ab134185af9ef88dfed5@syzkaller.appspotmail.com
Cc: jlbec@evilplan.org, linux-kernel@vger.kernel.org, mark@fasheh.com,
 ocfs2-devel@lists.linux.dev, syzkaller-bugs@googlegroups.com
References: <0000000000007541d9061ff83615@google.com>
 <20240819025112.2505463-1-lizhi.xu@windriver.com>
Content-Language: en-US
From: "heming.zhao@suse.com" <heming.zhao@suse.com>
In-Reply-To: <20240819025112.2505463-1-lizhi.xu@windriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/19/24 10:51, Lizhi Xu wrote:
> There was a lock release before exiting, so remove the unreasonable unlock.
> 
> Reported-and-tested-by: syzbot+ab134185af9ef88dfed5@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=ab134185af9ef88dfed5
> Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
> ---
>   fs/ocfs2/buffer_head_io.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
> index cdb9b9bdea1f..e62c7e1de4eb 100644
> --- a/fs/ocfs2/buffer_head_io.c
> +++ b/fs/ocfs2/buffer_head_io.c
> @@ -235,7 +235,6 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
>   		if (bhs[i] == NULL) {
>   			bhs[i] = sb_getblk(sb, block++);
>   			if (bhs[i] == NULL) {
> -				ocfs2_metadata_cache_io_unlock(ci);
>   				status = -ENOMEM;
>   				mlog_errno(status);
>   				/* Don't forget to put previous bh! */

The fix looks good to me. However, I found another issue in this function.

In the for-loop after the 'read_failure' label, the condition
'(bh == NULL) && flags includes OCFS2_BH_READAHEAD' is missing.
When this contidion is true, this for-loop will call ocfs2_set_buffer_uptodate(ci, bh),
which then triggers a NULL pointer access error.

If you agree with my analysis, please add the new fix and send a v2 patch.

Thanks,
Heming
