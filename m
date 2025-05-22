Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 509762222AA
	for <ocfs2-devel@lists.linux.dev>; Thu, 22 May 2025 09:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747905090; cv=none; b=QmiEkbeaHmlFSoPqrNybqBf5UMEC991Cncfct4+SgcLICBHHvqJ3CwhQ4biE/3ND8f5a7L3SWoZpRIymUPtiStG8h5RhUa6V52RAoJhNlck4X0NicPcaxAydbbhf+k+kQUMf9/m/J6WzM52ycDrwVlPyGBh87YyTxeal5wFk+jU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747905090; c=relaxed/simple;
	bh=ZDC9x4MYunxqEojxt2QMnAUa/sa1GbM7hsgeW5aenQ0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rPAV9jQLPqapWP+NUW87FFAG81MeEsPL6DLexQkGqJ/EbjY5SCvsy7eOUT4bgiq2B7XWiil8FNTA1Hw9pL0owlkORk6jon9G2NNeVGcBvyxEqdTaodpDtSxgsUK4jIHqonwcvPSIaM5AmWV7NtINhzEydp2zgv/rDQasZYiHmdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d0RkTwnL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d0RkTwnL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747905088;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Efw/xOoBR5JtsAGWTbkGb39F5QrJRSJy0Aiy1rPkylA=;
	b=d0RkTwnLqSfj3Fchi08koiFF1bUS0ZYlIgM/GNhR1Y13qYukU1EOmapWj7fQLJqamI8sRj
	RvbS366oTj1FIHYXBTkgj+d8E0MEoHGXeUTAyIQoaDilumkmo5HNl0lnXIOCWkCHOkbeJD
	z8fNqrXBRtlmXpR+IU57searNgtoRvU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-358-zgYyRHeuPpS5cQ885qz_AQ-1; Thu, 22 May 2025 05:11:25 -0400
X-MC-Unique: zgYyRHeuPpS5cQ885qz_AQ-1
X-Mimecast-MFC-AGG-ID: zgYyRHeuPpS5cQ885qz_AQ_1747905084
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43ea256f039so60909985e9.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 22 May 2025 02:11:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747905084; x=1748509884;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Efw/xOoBR5JtsAGWTbkGb39F5QrJRSJy0Aiy1rPkylA=;
        b=ZHFYFtAzJpRD25T3j6u4hyex/uS6aDMTwf2eQmhbWGfLoAr6AxAQgNfdksvRZ66YxX
         IDljXOCjAMIZE9NFMsfeOFOzaFC4qds/0PiXRCRtBkbqpoojS3fg58bQ4EYTZ/pztqCo
         QHPsIFB4SV/9utbMMcoNbNOJKNmA5cutNfINLWTBBNkF25/7W7DB91P40gi36DvlcU5X
         Ad613mvFqB6ja8BedSIpKvW2whuevbqcfXosU1vaGiky487MALNrYSsd/P9NapHnQ1oO
         Sa5oyrHFNxfQt42ZCsf3ndJj0d9zBbUklA0bbxQr+nb17kSHoU16kdFyEk0kBD6xDwXF
         lzbw==
X-Forwarded-Encrypted: i=1; AJvYcCW5WCKDEk/n0sBySl+1aT2bdtGWfOfeogBo4/2wGdNQYB7uiemfpQg8a2mEP0NcQGiiVYTer6XYaLxl2g==@lists.linux.dev
X-Gm-Message-State: AOJu0YxYTeRxbiXY+tsj0d7/t8YX5LOQiM+vrMujjRnrhy/eWRlCBG8i
	FKtGQ+MMZu+AF4zS8MMkI8FaBVoPZECsglvaBp5GGsp5N5N700uoJDyK/plSSzamKhnDKIGVT9p
	hUctQq/psQa4foUHv5SO1hhbc7np6laa2/lUU7zAf0jZuX4xabrKi5D8OzZUFEzMO
X-Gm-Gg: ASbGncvbZ5Y4aJDMjPCxZTtad0FeWW4F0OpI6FnB6RafKfp/D8vStG6vQuCLTkjjxgd
	EHSebuaF0ILGhdzGmHzcjTS0GcqKvxLBzTJsqh7SvgwcqAq++xICHDSZxlIz7vBPAiRvH3USRgd
	C2RKi12E25kWlt6+GS9kYB1TMvlENZo6ZpXtClC7hUQ9mWx76EHip72ZEwYNFVKXaWlXtM5GrWg
	V3dXqSgFXQ/vSOiybijbCDI7ZrxPq0p1ooHEAeDV54zp0tu2CpJzMm4PfJla6HA/wgcfAEpN+3M
	IrU0ot578UDN6/YN9pc=
X-Received: by 2002:a05:600c:a016:b0:441:d2d8:bd8b with SMTP id 5b1f17b1804b1-442fd622c81mr247895255e9.8.1747905083659;
        Thu, 22 May 2025 02:11:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEciTJ/zcRf4AXElu0pqBhYj5jKqeehae3NT83Gy64LvlkBARBipL5idMvjE3WFf06oe/P65g==
X-Received: by 2002:a05:600c:a016:b0:441:d2d8:bd8b with SMTP id 5b1f17b1804b1-442fd622c81mr247894945e9.8.1747905083275;
        Thu, 22 May 2025 02:11:23 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:247a:1010::f39? ([2a0d:3344:247a:1010::f39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-447f6f05581sm97329145e9.13.2025.05.22.02.11.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 May 2025 02:11:22 -0700 (PDT)
Message-ID: <f8640da1-c442-4704-8f0a-8d498e1b7e16@redhat.com>
Date: Thu, 22 May 2025 11:11:20 +0200
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 net-next 5/6] socket: Replace most sock_create() calls
 with sock_create_kern().
To: Kuniyuki Iwashima <kuniyu@amazon.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Willem de Bruijn <willemb@google.com>
Cc: Simon Horman <horms@kernel.org>, Kuniyuki Iwashima <kuni1840@gmail.com>,
 netdev@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
 Juergen Gross <jgross@suse.com>, Stefano Stabellini
 <sstabellini@kernel.org>, xen-devel@lists.xenproject.org,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 ocfs2-devel@lists.linux.dev
References: <20250517035120.55560-1-kuniyu@amazon.com>
 <20250517035120.55560-6-kuniyu@amazon.com>
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20250517035120.55560-6-kuniyu@amazon.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: SeRBPHCXb8VzQf4QwhO0ojcjRZBfPMCayqDcxq_mOZs_1747905084
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/17/25 5:50 AM, Kuniyuki Iwashima wrote:
> Except for only one user, sctp_do_peeloff(), all sockets created
> by drivers and fs are not tied to userspace processes nor exposed
> via file descriptors.
> 
> Let's use sock_create_kern() for such in-kernel use cases as CIFS
> client and NFS.
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>

The change makes sense to me, but it has a semantic change, let's add
more CCs.

Link to the full series:

https://lore.kernel.org/all/20250517035120.55560-1-kuniyu@amazon.com/

/P

