Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A06118C2A
	for <ocfs2-devel@lists.linux.dev>; Fri, 15 Sep 2023 20:50:46 +0000 (UTC)
Received: from eig-obgw-6009a.ext.cloudfilter.net ([10.0.30.184])
	by cmsmtp with ESMTP
	id hAJeqXcLoyYOwhFm2q0wNl; Fri, 15 Sep 2023 20:50:46 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
	by cmsmtp with ESMTPS
	id hFm1q2DHzOCehhFm1qYHU2; Fri, 15 Sep 2023 20:50:45 +0000
X-Authority-Analysis: v=2.4 cv=feK+dmcF c=1 sm=1 tr=0 ts=6504c3a5
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=WzbPXH4gqzPVN0x6HrNMNA==:17
 a=OWjo9vPv0XrRhIrVQ50Ab3nP57M=:19 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19
 a=IkcTkHD0fZMA:10 a=zNV7Rl7Rt7sA:10 a=wYkD_t78qR0A:10 a=NEAV23lmAAAA:8
 a=x_RLF880AAAA:8 a=IXr_WNlcAAAA:8 a=SRrdq9N9AAAA:8 a=cm27Pg_UAAAA:8
 a=VwQbUJbxAAAA:8 a=G5nsRgLVucSo8_3d1RoA:9 a=QEXdDO2ut3YA:10
 a=jCPSC2jcP07J4OBJNHyf:22 a=K24ECnMRWNUKRqF_MnsZ:22 a=xmb-EsYY8bH0VWELuYED:22
 a=AjGcO6oz07-iQ99wixmX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=nxvRp4DGgI/6MixR2WlqcSPhzQJquVqoPBvbY8UncWM=; b=nXds5WHz6Ptbe2/HB9I9kDCSE9
	Lq4v3BlLXWKNpglWH8WUCFTaLFxUEvQTDIZ3Eu2EGfcCwxqhOh1rIKXB2uGfM96xUhyDGSTrWacb1
	g27LYfvYcH/4en27z4xPrxykTLgF4Oqg+Yqy6Vqkr0ULxChC9vn7I9zzj4kbSDAN1Hlq3Z+O6Ws7i
	C43pWD3m5jpbWgcLIQHLdjnDNkhMQHWxGJmdvd6t7fcUhqIbkxYch72CIMi9ovmzD53wlA6jKMHY5
	dJpyYCIBHkPyVzJtyAHHhfrbsmsFqJ0le+cK81Jx/TUktXiZekpMflwTbs71bACupN1FMo7MBQKDB
	P4bScZ+w==;
Received: from 187-162-21-192.static.axtel.net ([187.162.21.192]:35644 helo=[192.168.15.8])
	by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96)
	(envelope-from <gustavo@embeddedor.com>)
	id 1qhFm0-002g5A-0y;
	Fri, 15 Sep 2023 15:50:44 -0500
Message-ID: <ae45f6a6-8870-d2c8-8c98-a9e7d9d1ba2f@embeddedor.com>
Date: Fri, 15 Sep 2023 14:51:40 -0600
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] ocfs2: Annotate struct ocfs2_slot_info with __counted_by
Content-Language: en-US
To: Kees Cook <keescook@chromium.org>, Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>, Joseph Qi
 <joseph.qi@linux.alibaba.com>, ocfs2-devel@lists.linux.dev,
 Nathan Chancellor <nathan@kernel.org>,
 Nick Desaulniers <ndesaulniers@google.com>, Tom Rix <trix@redhat.com>,
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
 linux-hardening@vger.kernel.org
References: <20230915201522.never.979-kees@kernel.org>
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <20230915201522.never.979-kees@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.21.192
X-Source-L: No
X-Exim-ID: 1qhFm0-002g5A-0y
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-21-192.static.axtel.net ([192.168.15.8]) [187.162.21.192]:35644
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 497
X-Org: HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfMinmvxJtkXRJWovD9t/P30618ab2oCC8VFPRXl1KX/ckkAt+cv+D3hyzf6t7cOh5buZkR9YF74X+4ehboVUdrArabGwXaTYfgYbQkqdQZGsSwIeW5au
 ID9+LBFvwv11IVkZx3LG+HmkYunTRw1tWcXTzselxzd/AbMwRJ0F0Apqc4gwrp87qLqLNW6lujpFk0Os3BR99NV+9dkIcEx3jxcxHbQqffN2ZsfAhs4JnSrH



On 9/15/23 14:15, Kees Cook wrote:
> Prepare for the coming implementation by GCC and Clang of the __counted_by
> attribute. Flexible array members annotated with __counted_by can have
> their accesses bounds-checked at run-time checking via CONFIG_UBSAN_BOUNDS
> (for array indexing) and CONFIG_FORTIFY_SOURCE (for strcpy/memcpy-family
> functions).
> 
> As found with Coccinelle[1], add __counted_by for struct ocfs2_slot_info.
> 
> [1] https://github.com/kees/kernel-tools/blob/trunk/coccinelle/examples/counted_by.cocci
> 
> Cc: Mark Fasheh <mark@fasheh.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
> Cc: ocfs2-devel@lists.linux.dev
> Signed-off-by: Kees Cook <keescook@chromium.org>

Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Thanks
-- 
Gustavo

> ---
>   fs/ocfs2/slot_map.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/slot_map.c b/fs/ocfs2/slot_map.c
> index da7718cef735..e544c704b583 100644
> --- a/fs/ocfs2/slot_map.c
> +++ b/fs/ocfs2/slot_map.c
> @@ -37,7 +37,7 @@ struct ocfs2_slot_info {
>   	unsigned int si_blocks;
>   	struct buffer_head **si_bh;
>   	unsigned int si_num_slots;
> -	struct ocfs2_slot si_slots[];
> +	struct ocfs2_slot si_slots[] __counted_by(si_num_slots);
>   };
>   
>   
