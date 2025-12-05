Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DAD43043CF
	for <ocfs2-devel@lists.linux.dev>; Fri,  5 Dec 2025 07:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764918351; cv=none; b=vBnrqe4djnW31ZLjBURhksFUTgBzMS7UvVs8p3QJi7hKuTNM/F1shRSOD5T/LZaVl+BZ3Smr+xfp9Nm7IuzcKWyGpFZMwB7m/U4RMRMcRoU4XWYcATpnHvS5QBJdOp1DfP/9pnmdqti/F+FaLvEWaPf/SLGR55zIsHTYax6THic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764918351; c=relaxed/simple;
	bh=rjneLgNgTY5hHjnkwvKRObQ7JGdEAoSOrayFY2xWwdk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aXfCPn6Rz08wTUmR1YLOYPbuZaLHR28/T6FuJFYCDo/Zz/UelFMAnfBM4lwH3zjIQZkAd/dmhzJoJ3+DwdDcwU+7ejbF73/n5ag6Kj62tEOPrkG7XpV4Rk5E18sIY6gO+9jxGMbuMfjzvWw5qmSwrih5eni8gDf6ihVsCof4/C4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Vxo7Qlsw; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Vxo7Qlsw"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4779b49d724so3567865e9.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 04 Dec 2025 23:05:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1764918347; x=1765523147; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JTsoFxduBBAYBUsBF3sxxGemXJ3qYb49zqODh54bQjM=;
        b=Vxo7QlswAoNoc2AqfrTHPHeYCxo/VbT8igpk9z0S1dEWA0pI+Hn/CJye+BU9T2jgbB
         u0kkIc/Mn/7loI4/wB6egEBlh2ynf0ttIxzfkueLhV0FM7Po+jHkfdI6hYyiDa9J0hvN
         /vpCdhGMP81eOK84o88W45k0DAnUuRzzMf9oN3s73Mo15iOQK63ODM0IT3fFnl8uzzFO
         qm1akpA/2IIKs5lfUVLbT5EOWeunsCgL62FTnp/Kbtyep+sHdVaZ4FaC5/w30A/02PRD
         rRjVf7NAULf1+oP5pBgSAMg49rqgnmhEdWIxj86AFHNWDNF8xOEh6Goz+a92AZ5Cyz0Q
         eTPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764918347; x=1765523147;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JTsoFxduBBAYBUsBF3sxxGemXJ3qYb49zqODh54bQjM=;
        b=fqPjgM8vRA5Lr447VwdwHiQLOcOSo1LgOgN728dV7P+LVm6ykEWbp9MLyjPY2GGgyG
         9Hpl6f3yYyiZmUr+P5esB5T/z+zJCGweNwGOxsbIosXxMe7XQhmVVCY+Jh/WsIbZ0x1P
         o5k8Wor+fFMwfYNEMVPbrMCxcASDcW6pIKCWbwOXimrvshWWK1QqFzsa0f1/aQA/guuA
         0qPr+4Z7l3xFp8R1p4Uq/YaDUQ38lgdwO9KT6oJSYZzTPBEpudpoU5vg3fNfiO/6YEyr
         WV20Z9kEBFfOG3ijJmaNVzNB7jtq/aJ9D6Sh5OgT4/5sn5xEF1Xk4f27OTgqGNbEzwL6
         o8/w==
X-Forwarded-Encrypted: i=1; AJvYcCVf1a/cskh7pojggwXXYeQpL15JFUYf2zeYye6TRX6HGueRLViOl1tZLJsp0o4mpUtdATsvhKrwDNDL2Q==@lists.linux.dev
X-Gm-Message-State: AOJu0YysZ39EZ6XXP3xQEu5uMOlHSsD6+00tWasplKoeHeeKi22MNBwU
	iUjBdtYK+sZWsyjG2r+u2+2uQPvLY0k1YS7XMwi+ZuOxB6YGZ23L3EQHJJUaUjDqGBA=
X-Gm-Gg: ASbGncv6eKwgaa3fZMx8rkszbptH33HQo4UMLdpozpAZdxQgwVUaOj3Wp3GwNqOlIgu
	acopeFfoItFkNTbvkKFViu34Vb+aB94OtQW8EKo2H/LbTOIF1T1OmMJ7u4xRqyuSkBQ5Q9qC4LF
	f3Ad07zHXfAU6Ma/FoNRaVfy4n9ZL2XAo7O9VLSqUy6pLON3a+MHzYb6x3degYuIKdnUZOpKgKs
	UpruWHrejyBr9SMcwGxtF0L3ET87gFgZZS2DKwXuJqq6Oe2B6dLLWqtvJFtyH8ZeS82yENay2WY
	WVJ6APAyoJfsuJzCQQcC6gWrhX/nHmzKeM1khbjmsVmqYJQOejRP+Vji8y5uLAuTkJB/H79hdEr
	pYfOKPEPiEVP6uwzjW+uV1oPnJ1SBxM6fuaIQeDF67rbjFtSHaG3UMqG0BSIpgU/Kv5P/aIIYSd
	M9dve8BMDZchjlMeWtSgIk
X-Google-Smtp-Source: AGHT+IHWPxN42pBIKentauoPsmJt2DFI86al+wBh/AErPENg0WEGzc/DbernadUmCu51llkA0NfkRQ==
X-Received: by 2002:a05:600c:1388:b0:477:a450:7aa2 with SMTP id 5b1f17b1804b1-4792c8ac705mr49842145e9.1.1764918347406;
        Thu, 04 Dec 2025 23:05:47 -0800 (PST)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7e29f2edec6sm4200238b3a.9.2025.12.04.23.05.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 23:05:46 -0800 (PST)
Date: Fri, 5 Dec 2025 15:05:44 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@lists.linux.dev, lvc-project@linuxtesting.org, 
	syzbot+cfc7cab3bb6eaa7c4de2@syzkaller.appspotmail.com
Subject: Re: [PATCH] ocfs2: fix memory leak in ocfs2_merge_rec_left()
Message-ID: <2u6dw5pw225v72iiezztbokptt5vv6kbgv2zijmkpewurcrupl@gar3iu3eukbw>
References: <20251205065159.392749-1-dmantipov@yandex.ru>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251205065159.392749-1-dmantipov@yandex.ru>

On Fri, Dec 05, 2025 at 09:51:59AM +0300, Dmitry Antipov wrote:
> In 'ocfs2_merge_rec_left()', do not reset 'left_path' to NULL after
> move, thus allowing 'ocfs2_free_path()' to free it before return.
> 
> Reported-by: syzbot+cfc7cab3bb6eaa7c4de2@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=cfc7cab3bb6eaa7c4de2
> Fixes: 677b975282e4 ("ocfs2: Add support for cross extent block")
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>

LGTM.
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
> ---
>  fs/ocfs2/alloc.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index b267ec580da9..0ab9b06643f4 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -3654,7 +3654,6 @@ static int ocfs2_merge_rec_left(struct ocfs2_path *right_path,
>  			 * So we use the new rightmost path.
>  			 */
>  			ocfs2_mv_path(right_path, left_path);
> -			left_path = NULL;
>  		} else
>  			ocfs2_complete_edge_insert(handle, left_path,
>  						   right_path, subtree_index);
> -- 
> 2.52.0
> 
> 
