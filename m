Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947CB3203AA
	for <ocfs2-devel@lists.linux.dev>; Mon, 20 Oct 2025 14:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760969209; cv=none; b=T2sdUNXFGoegtSwov6jDv4nwnggm7dk2m+KAPCivjHPweDm/ED6JeATWEI5Cjws8+XpXdv77s0PfitJaEkXzvo4isvEvPL35ufzuSYD9BOVegu5eyIQKWpwmkzqndVAKYgu76nU4iY9/TAd541QCDSfprFNMuB+/xPykr5u3wlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760969209; c=relaxed/simple;
	bh=Eh8X6InyDp64MAueXNNr6YXF5k1VK4khgRJ01Ij0gdk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Oytmc0NMIANPfABgBq434xc13pz6vPbhhEgnEW/poOU26ra+tI8UmnQ70yyw6pVW2Lw/ZQZVpmQiEenK7nES1r85K0aKAe/IHLCo17TJUk9RNmVwuuXyhRnUXp1C1krmJgE6+cH2QWN7D/+ijFGpWnHTE2jbZ5KUeMP0rroHXqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=akW8TR7L; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="akW8TR7L"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-426ff579fbeso530684f8f.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 20 Oct 2025 07:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1760969205; x=1761574005; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Im+u+Gvkto1cPhyJVM9r3qGYC/v7bSfOLga5VGMQtEc=;
        b=akW8TR7LwFO98MVdbzj4lyzkZHY/h7Mb8Q17GmvlYtCaPrGUpllGdndEAIAnjoiI1x
         287JZpUEgUwRUY8ZOP+zj500TJiV82EETKbBCp8udcHXLkdRFFzqpapvS4cPlZ4Hults
         7K2y5nk5l5TeqyaPpzJvDDqXPWBwU+RtoyVvr00ISlcUuMGqZgjDT45yQeGIED30Dwl3
         KfNqmoBnTiE2mhs7sA0TwA/++AIvdQLWW1l2GgxxaD/8df8IKHagmlTvD6IEXxECqQzp
         Mi5J4Y8fN6Ra4tO5lkXD1bd3027Sel3u/HdAgHNkU/O0OOdF6jZm331OkYdbJ9KGOh5t
         OuLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760969205; x=1761574005;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Im+u+Gvkto1cPhyJVM9r3qGYC/v7bSfOLga5VGMQtEc=;
        b=KZlAJ+Umxn9xNBHd9H3VIatrPz23SMobVxVdbCdEgoe02Wx1Qnepj0Sw+yHEjksTiG
         yBFyR2LsXO7gkZpNs5GumX+/Hz/KarVliD0A0/IA6qyWO1Xzj6+ZbW2xVYFhcrf6xd2M
         DPUOJeuLEaEHxqXh6b2EjX4as2+8z/N+KnFkaMjRElTbFRcEgXEYmVtJKBkBmM0K92d0
         4BS8yT42b+QuMCyFVSf1pdbDeEZY/EYmonUmEOWnb2vIhme+FLZp/zmly/KPJz4HQ34d
         KzvQFfiU9cuz1rytEJElD33pqd5rhuBAOyzm+DIMiiSLyq9ihmNIPDS83nV8MgQyrH3U
         hUHw==
X-Gm-Message-State: AOJu0YyuQV2B6Us0DumN2t2LqcN39HmuohqQUq5AgFudMDerBQGKJA/c
	FxHJnV4C98DniWrpTKvYsMIND43Agu2VqgRNW9pm/ODvmp4h5YEGrCdCPN6QK9JddFg7urYADaX
	fLjmV
X-Gm-Gg: ASbGncs/+6U6AsLhJHW0PhUleWQ6V3qkn+/P1yVCI5iL3ra3zbfrj4IQMhe3feJZHr1
	4z9xHkGnO1RcdHf5/7EHnbb1l+NMiwAiuzZGZY/2o9XhGAwjqGJVDF/cG8BMDWZmKaUjYAI+HGe
	1zjoU596cdnNGaCsa/BQFyyS7ZnEN7ip1XqRvhA4N5D8DPWSwP4VQUcRsipCQXPvXelqZiec1IU
	GASKVRaMoRIzuMH/NhNWBHLdos1FNrP6/ByymsnYesAPGuxzpdo6v+OsU4O3t5rWLyfpP2nPCKo
	GHSfFsor4ubpWk9Si1arrf3JfHshLfZEWGmhZMZ+u75hDE2L9K+PTrdgUARZdcIYhFIN9Y9UbXS
	pRvINf6FS5AG8SMj5tLP7fdjnE0kwbcXwCMZJsIWuHjcy8Uyt+AKehWic13p4vBH8sGWppiKAUm
	s8e+ZAQfk=
X-Google-Smtp-Source: AGHT+IEQN2+kD7GeeA8UPEDsT5sW3cFhaUqaoh2xnyVRS//Ibpl3naJ6rWupKd/Dkq9wGR5b+tNp6A==
X-Received: by 2002:a05:6000:2383:b0:425:6794:f19b with SMTP id ffacd0b85a97d-42704d14627mr5267307f8f.2.1760969204549;
        Mon, 20 Oct 2025 07:06:44 -0700 (PDT)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33d5ddf1f7asm8049223a91.1.2025.10.20.07.06.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 07:06:43 -0700 (PDT)
Message-ID: <18c4bf1b-5860-46ff-9e55-71e715fafdf2@suse.com>
Date: Mon, 20 Oct 2025 22:06:39 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: add extra consistency check to
 ocfs2_replay_truncate_records()
To: Dmitry Antipov <dmantipov@yandex.ru>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, lvc-project@linuxtesting.org,
 syzbot+4d55dad3a9e8e9f7d2b5@syzkaller.appspotmail.com
References: <20251020102455.96229-1-dmantipov@yandex.ru>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <20251020102455.96229-1-dmantipov@yandex.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Dmitry,

the code logic is correct but the commit log needs revising.

On 10/20/25 18:24, Dmitry Antipov wrote:
> In 'ocfs2_replay_truncate_records()', check whether truncate long

'truncate log' not 'truncate long'

> length matches the one configured via the superblock parameters
> established at mount and current record index is within the valid

the length is established at mkfs time, not at mount time.

Thanks
Heming

> range, thus preventing an out-of-bounds accesses while iterating
> over the log records below.
> 
> Reported-by: syzbot+4d55dad3a9e8e9f7d2b5@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=4d55dad3a9e8e9f7d2b5
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
> ---
>   fs/ocfs2/alloc.c | 10 ++++++++++
>   1 file changed, 10 insertions(+)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index 162711cc5b20..143ce8ba6071 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -5941,6 +5941,16 @@ static int ocfs2_replay_truncate_records(struct ocfs2_super *osb,
>   
>   	di = (struct ocfs2_dinode *) tl_bh->b_data;
>   	tl = &di->id2.i_dealloc;
> +	if (le16_to_cpu(tl->tl_count) != ocfs2_truncate_recs_per_inode(osb->sb)) {
> +		status = -EINVAL;
> +		mlog_errno(status);
> +		goto bail;
> +	}
> +	if (le16_to_cpu(tl->tl_used) >= le16_to_cpu(tl->tl_count)) {
> +		status = -EINVAL;
> +		mlog_errno(status);
> +		goto bail;
> +	}
>   	i = le16_to_cpu(tl->tl_used) - 1;
>   	while (i >= 0) {
>   		handle = ocfs2_start_trans(osb, OCFS2_TRUNCATE_LOG_FLUSH_ONE_REC);

