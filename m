Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71AA718C324
	for <ocfs2-devel@lists.linux.dev>; Mon, 23 Sep 2024 08:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727079368; cv=none; b=QxoQAB3wYIizmXDAIBVhtFEaDqiN0QAT4fISRk6LPHsmClR5d2vzVvS9OnWO2ZMn4Jg5f6dhqBgpv70Gc8/PiO3tNFEjahhhcIoF7RZYh/yAXfkI1X6NA6nhQSBdaswQeltMCy+3/stcYPTeIPle5313lCjDVWZlCPzUX7XRKvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727079368; c=relaxed/simple;
	bh=nhyA89QWnnx2FmkbVTxycOy83Nv1/mW01Jb+W8K38Ds=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=aZ7+RIbDVxohxuEFqbqoXNSC9G6wXiJHCzT66Ix99nz4rjykPsNAYIVQzF/pDSXGYFcguXcnvPqfvPuvkyNQHYayzQjFWAQas+AVJxS452K4jwBDjRQAtrq30DreZHcGWr85SFRbw6vPyUEmFSglU0RBE3O0Rx6+4u3trMs4d98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Iu847/FS; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Iu847/FS"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-42cdefe9ae8so5960905e9.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 23 Sep 2024 01:16:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1727079362; x=1727684162; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:cc:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nWOcTPwwf7Z/BAt3ngEueyugAgcowiKUH3melF7Cxsg=;
        b=Iu847/FSxUlmzbig8ibuphLJOxpy1TmXeZIzNZabGvT463rrUV3GZ23SeEac+j4UA0
         89yKs2nfoDFD/ATFtACXo28d/uT619pmeeu4QtICEDRCCRAjhW6UtS7XT+85B5MjRfoP
         TGZWJPtcpxp8101kM0uSnAu2eKIVfotIgqkum4EGZd9ehJ+GUjlKtbJJi/DvCkIDZ6Ym
         enfHc4hmYMHf3bmxDhhz9hAV7l4ejYCeoF0vUXmxKNIyMRg5L7UrsWiTyx2jlX6Fotd+
         8OxlYHEXdJ3SMA2eEoQ90ar4AmhIcA98mNVJzCosKdKZNew8KlmOvSOwJLDMH5AkJbdl
         ZAtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727079362; x=1727684162;
        h=content-transfer-encoding:in-reply-to:from:cc:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nWOcTPwwf7Z/BAt3ngEueyugAgcowiKUH3melF7Cxsg=;
        b=djIqPoX1tlBVncrwq85DA4ovK/7xDCHH1PysjqW2szMSBgy1h8vzLz3M84vYv0tFOV
         Kvh5XaTgXoMEvJgdCn7a4xBWRdRC8XWdP7rPEujNnCuS9mfG5bB9qcEcqyH547P1LqT/
         zmbYyXpF9FahKmJT4LVXmGrBwD3lakh/5RifASoJDxdYbzj6O9rgU5CtURgTi4goxs4a
         JS15TbwlrbVya+IsXTrf8nnvrGicCeM5NRwCL0MGD3WTi13qm9KawR2zh9/erLDFKMOj
         TwqdytgPR+vLnZFIGszBBF6b95bVc37buTrShL6iLSdFfcQq1uC9THffKOkgSJlU+fdR
         AWhA==
X-Forwarded-Encrypted: i=1; AJvYcCW2W9AwS3WpkDRA1BKLCRoUg5pfzaQVL9e+qYKw9A8j4c8v0k9S13EgWtgPIbre/BGS9Xh5DmT0QJlACg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yyf7iZAmdUkwe8XTy7pXslRD84m48BVw1XIQ8HOXsIUXWyI+mYv
	OufH1+Re/rjTuMDdHvOJe77rVmjHmNKWbQ30G8bw3Fee4VQfMBUUAuTy5EsWz/A=
X-Google-Smtp-Source: AGHT+IHbdxRSD1sPI5JLKyTtMB4Ok5vqE859Zp3ofCigxPO4cBfVIBrjsI0N/b0/rh4D4OfFwNx4dg==
X-Received: by 2002:adf:ab12:0:b0:37b:8b7c:107a with SMTP id ffacd0b85a97d-37b8b7c120bmr17728f8f.8.1727079361625;
        Mon, 23 Sep 2024 01:16:01 -0700 (PDT)
Received: from ?IPV6:2408:8409:2440:c1a:5215:bb45:d9a6:6f23? ([2408:8409:2440:c1a:5215:bb45:d9a6:6f23])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2079473e8a2sm129039435ad.251.2024.09.23.01.15.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Sep 2024 01:16:01 -0700 (PDT)
Message-ID: <0a4b798a-db82-40da-9167-141b684f43fa@suse.com>
Date: Mon, 23 Sep 2024 16:15:53 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [ocfs2?] kernel BUG in ocfs2_write_cluster_by_desc
Content-Language: en-US
To: syzbot <syzbot+18a87160c7d64ba2e2f6@syzkaller.appspotmail.com>
References: <0000000000005ef449062240d69c@google.com>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>, linux-kernel@vger.kernel.org,
 ocfs2-devel@lists.linux.dev, Mohammed Anees <pvmohammedanees2003@gmail.com>,
 syzkaller-bugs@googlegroups.com
From: "heming.zhao@suse.com" <heming.zhao@suse.com>
In-Reply-To: <0000000000005ef449062240d69c@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Regarding the mail thread: [PATCH 2/2] osfs2: Fix kernel BUG in ocfs2_write_cluster

Both ocfs2_search_chain and ocfs2_search_one_group call ocfs2_cluster_group_search to search for an extent cluster block. It seems that the ocfs2_cluster_group_search() sets wrong res->sr_bit_offset.

Just from the code logic, in ocfs2_block_group_find_clear_bits(), the ocfs2_find_next_zero_bit() returns ZERO which can trigger this bug. But in the real world, this function never return 0, because the 0-bit is always set to 1 for the cluster-group itself.

let's verify my thoughts.

#syz test

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index f7b483f0de2a..d4e563281c9e 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -1346,13 +1346,17 @@ static int ocfs2_block_group_find_clear_bits(struct ocfs2_super *osb,
  
  	/* best_size will be allocated, we save prev_best_size */
  	res->sr_max_contig_bits = prev_best_size;
-	if (best_size) {
-		res->sr_bit_offset = best_offset;
-		res->sr_bits = best_size;
-	} else {
+	if (!best_size) {
  		status = -ENOSPC;
-		/* No error log here -- see the comment above
-		 * ocfs2_test_bg_bit_allocatable */
+	} else {
+		if (best_size) {
+			res->sr_bit_offset = best_offset;
+			res->sr_bits = best_size;
+		} else {
+			status = -ENOSPC;
+			/* No error log here -- see the comment above
+			 * ocfs2_test_bg_bit_allocatable */
+		}
  	}
  
  	return status;
