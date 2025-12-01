Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598881DB122
	for <ocfs2-devel@lists.linux.dev>; Mon,  1 Dec 2025 05:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764568244; cv=none; b=uvhqFnAKkJPhKM4O83vOOTbXXqAeRAGVcKqQCbxAVIJnzrxqZEEVVPAxPnDmnSHiGTkwrpb65nJpGga3OdLvUFl5RbSf3jFi06M8cDA9gwEhmJ+rrQ17biTXsYSOvFS2FHqNJmp39TAHRaqT4rv8w4Yae108E02H+DMl0QJdRtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764568244; c=relaxed/simple;
	bh=F/ztnYndVtU2pe1Fg5UObZ2BY77hbdFGOdTO0oEiKWQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vi/81nSpVIa1ysTOyNt0CQ9JxK5d+LrvKd6iQk+bn2htLDjMrkVRX1LTiRz5nmlDPGk5IfxMmcU/BtPR96hLLP+1fF92hHZB41w00XT/i+a8Q+UAco8drWRjaVbyk6PBJ6OQnajoZwKCK2HtBZn0yVDqIcgHsa9UdfPpoy0XNw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dXBWojhC; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dXBWojhC"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-298250d7769so27076915ad.0
        for <ocfs2-devel@lists.linux.dev>; Sun, 30 Nov 2025 21:50:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764568242; x=1765173042; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eJREozEjseeIu9xfaigiftxOhLedS8qLXirYP5CG/7w=;
        b=dXBWojhCIcvdqbkkO5F/95ZizRbXZdNCQIKS87/oSHCBuGpRiE950XoUfiGYvA1uiB
         E3omPbvYhBCAZ3FlLxdiNZZ2WkGis8FLS1dEpn6S+bzbLmqbEsdvP4QJQ8KIMfYAbzdh
         BQQwOzHEi1f3/U/7Jcza6rz6GDVpTA4wyvMj2poDEfKxQ9egtmnp3dw5LKgnD9itICuH
         Ze8rNcJl3m8JoGgK/CTA7s3zS2wejqf3iZubppNYdn4JBZg5KT70+eOAwJycwbpK/pCT
         HQfRACRZNtMnb2To9bdxWwb45Sx/3ZZvb2dAUbJ8TPSKMeu2BHnUhSNH3OuNusz/hLgo
         d9DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764568242; x=1765173042;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eJREozEjseeIu9xfaigiftxOhLedS8qLXirYP5CG/7w=;
        b=TJhhQaA80LLvwKjNZusPF40HmnnPejaZTWxLg4mKH9hrHOsRnp9QJdyYgF9GGmKqDq
         vVEPRQDE+g3aukh4AuSljFy6cjOi6z02+GnnzZ/hPRCcU5eFMfDGYZQ3dkOkj+iHDihK
         4Ko+BjDLPFYLFswGw/wtOkW7kEPsQDqpU1/FGfckpfwJsPnciToOrkWXX8h5rFB0N8iH
         2u2TBTtH7yUqWV5yDHijvQTFaNTDkBQdV7lCT/zSxUKz6oV7M/Wz9gxKZiM8Fy84x5Fp
         n+wWfK2jlIV/0D9hT+kfjYWesDxFaPIBsGIO8Ne4gdYWnTBcbBDqqHhuvMqpu38jRUL3
         ZEnw==
X-Forwarded-Encrypted: i=1; AJvYcCXneWP4epmd1CCX9aYGxDjNlKMdSgqhl0ZmrALdjuqOwmH8MbFVf3hHF1qb94gzsOhTLrh3rbFKOkbCew==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx8WkmHxKCMkhAorU/8+AbYljRlQXiNuCDtqaCivbwpMHj8qELm
	CwtIkHQ3Czzlecv9BDGAz/fPPJnhCjqCDDNMhlrjQkgMDPMQhNRNI8Nn
X-Gm-Gg: ASbGncuoWcTfA2fmmIp+hiF71Hj0U5zZYaHeN6uXVfEuRzTLFYYk5qJ3R6fWq2l+grJ
	vRhBNx7BjvGc9s8iJntqK8FZJExc6qrfnYioEm3mq9p9inFIfbKV7u3KaHB1msda8FqnJm9/t+k
	CItT8tP6wKafNp1l7PnuvDoidcAt5zCDDQWmZvLEnQehBznOX5ELHlM6Td366xp4sWJKQkUyROz
	hw9TWQnRjcrnquuR2rgh/o0m2EpU4j4+Dorf8FZWhcm3QWNneDRt0Sei83KpQ1ckjF3sT9rgDJE
	kVBnKlaPN7m8zlgKtPKsrCI4qv8ek3PRYMOXef1RDNNIciGI6m+p1HHmVBavrmuFECKoIFVEzHq
	wJkpas16W++zDI+H4arkU9NzM3V44slZ96JR8JRuU3gpU4xhhOypZkiCHQdCGWVPSgqPkG6IYmN
	kA8TqNCMo5TlTiZ5WPS7vm
X-Google-Smtp-Source: AGHT+IFepUydC64DMkmBda+q1x8TpJ+ZVbr2aragVE01SyztePUbnC5ulz34kBE3htJbBIeaaym06g==
X-Received: by 2002:a17:902:e94d:b0:295:888e:9fff with SMTP id d9443c01a7336-29b6c3e921fmr421343225ad.20.1764568241595;
        Sun, 30 Nov 2025 21:50:41 -0800 (PST)
Received: from inspiron ([114.79.136.226])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29bceb5dc73sm110259815ad.98.2025.11.30.21.50.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Nov 2025 21:50:41 -0800 (PST)
Date: Mon, 1 Dec 2025 11:20:34 +0530
From: Prithvi Tambewagh <activprithvi@gmail.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev,
	skhan@linuxfoundation.org, david.hunter.linux@gmail.com,
	khalid@kernel.org,
	syzbot+96d38c6e1655c1420a72@syzkaller.appspotmail.com
Subject: Re: [PATCH] fs: ocfs2: fix kernel BUG in ocfs2_find_victim_chain
Message-ID: <aS0sqmSpqWTi5T3v@inspiron>
References: <20251130104637.264258-1-activprithvi@gmail.com>
 <6d27a5aa-1e32-4dd3-997c-ddc015be88a3@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <6d27a5aa-1e32-4dd3-997c-ddc015be88a3@linux.alibaba.com>

On Mon, Dec 01, 2025 at 10:51:49AM +0800, Joseph Qi wrote:
>
>
>On 2025/11/30 18:46, Prithvi Tambewagh wrote:
>> syzbot reported a kernel BUG in ocfs2_find_victim_chain() because the
>> `cl_next_free_rec` field of the allocation chain list is 0, triggring the
>> BUG_ON(!cl->cl_next_free_rec) condition and panicking the kernel.
>>
>> To fix this, `cl_next_free_rec` is checked inside the caller of
>> ocfs2_find_victim_chain() i.e. ocfs2_claim_suballoc_bits() and if it is
>> equal to 0, ocfs2_error() is called, to log the corruption and force the
>> filesystem into read-only mode, to prevent further damage.
>>
>> Reported-by: syzbot+96d38c6e1655c1420a72@syzkaller.appspotmail.com
>> Closes: https://syzkaller.appspot.com/bug?extid=96d38c6e1655c1420a72
>> Tested-by: syzbot+96d38c6e1655c1420a72@syzkaller.appspotmail.com
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Prithvi Tambewagh <activprithvi@gmail.com>
>> ---
>>  fs/ocfs2/suballoc.c | 7 +++++++
>>  1 file changed, 7 insertions(+)
>>
>> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
>> index 6ac4dcd54588..84bb2d11c2aa 100644
>> --- a/fs/ocfs2/suballoc.c
>> +++ b/fs/ocfs2/suballoc.c
>> @@ -1993,6 +1993,13 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
>>
>>  	cl = (struct ocfs2_chain_list *) &fe->id2.i_chain;
>>
>
>This blank line can be eliminated.
>
>> +	if (le16_to_cpu(cl->cl_next_free_rec) == 0) {
>
>Better to add the upper limit check as well. e.g.
>
>!le16_to_cpu(cl->cl_next_free_rec) ||
>le16_to_cpu(cl->cl_next_free_rec) > le16_to_cpu(cl->cl_count)
>
>Thanks,
>Joseph
>
>> +		status = ocfs2_error(ac->ac_inode->i_sb,
>> +				     "Chain allocator dinode %llu has 0 chains\n",
>> +				     (unsigned long long)le64_to_cpu(fe->i_blkno));
>> +		goto bail;
>> +	}
>> +
>>  	victim = ocfs2_find_victim_chain(cl);
>>  	ac->ac_chain = victim;
>>
>>
>> base-commit: 939f15e640f193616691d3bcde0089760e75b0d3
>

Hello Joseph,

Thanks for the feedback! I will make the changes in the patch. I wanted 
to confirm that the new patch should be sent as v2 on this same thread, 
along with the change log since v1, right?

Thanks,
Prithvi

