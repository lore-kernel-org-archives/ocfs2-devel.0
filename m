Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8ED963B9
	for <ocfs2-devel@lists.linux.dev>; Sat, 23 Sep 2023 08:24:28 +0000 (UTC)
Received: from eig-obgw-6001a.ext.cloudfilter.net ([10.0.30.140])
	by cmsmtp with ESMTP
	id jkvnqYgJdDKaKjxwBqHYI4; Sat, 23 Sep 2023 08:24:27 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
	by cmsmtp with ESMTPS
	id jxwAqOENEuMYjjxwAq0oDX; Sat, 23 Sep 2023 08:24:27 +0000
X-Authority-Analysis: v=2.4 cv=RtrWkQqK c=1 sm=1 tr=0 ts=650ea0bb
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=P7XfKmiOJ4/qXqHZrN7ymg==:17
 a=OWjo9vPv0XrRhIrVQ50Ab3nP57M=:19 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19
 a=IkcTkHD0fZMA:10 a=zNV7Rl7Rt7sA:10 a=wYkD_t78qR0A:10 a=NEAV23lmAAAA:8
 a=x_RLF880AAAA:8 a=IXr_WNlcAAAA:8 a=SRrdq9N9AAAA:8 a=VwQbUJbxAAAA:8
 a=1XWaLZrsAAAA:8 a=20KFwNOVAAAA:8 a=cm27Pg_UAAAA:8 a=gQTog8Qx81Ab3WLl5k0A:9
 a=QEXdDO2ut3YA:10 a=jCPSC2jcP07J4OBJNHyf:22 a=K24ECnMRWNUKRqF_MnsZ:22
 a=AjGcO6oz07-iQ99wixmX:22 a=xmb-EsYY8bH0VWELuYED:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=KYMAErdkolcSoZbgUhBMI2wZn//SGSGFc89+vETw29c=; b=NPMGblqr6awDP5CreG5PI0zYu3
	dZq0M4yi5TmtWJS47EPpFYdUfHESrES1fT7eShNXCHIex3GK+j78ZeX6tZzJK1+O4Y3iBBhgKJhV5
	Zn8gFp/M0RYQ5iMRXgxDk7BTRwh82+miQcHHOi0cwCNZNvKg26zE6sGWiI8ZBYvxjMsoAZR8FhOBm
	q8okV+aRuyedi3IrkVhylkXkI3//9W4oOquC5ZliZSeD+Hv/h3T6tj3BV7aoLeEY0PWOnnJaQncPK
	IwqQ5LdNVJa5hLZs5tAn6vyma1XK5Qv1J1MRW8ry6freLNoJ5jUiKRpi1CGkRTitrCDMzhVPJrZnL
	94UfsgsA==;
Received: from [94.239.20.48] (port=46684 helo=[192.168.1.98])
	by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96)
	(envelope-from <gustavo@embeddedor.com>)
	id 1qjxw9-003TvN-2J;
	Sat, 23 Sep 2023 03:24:25 -0500
Message-ID: <2b9b1259-bff8-c82e-bd87-af3d2bfc4a54@embeddedor.com>
Date: Sat, 23 Sep 2023 10:25:25 -0600
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] ocfs2: Annotate struct ocfs2_replay_map with __counted_by
To: Kees Cook <keescook@chromium.org>, Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>, Joseph Qi
 <joseph.qi@linux.alibaba.com>, Nathan Chancellor <nathan@kernel.org>,
 Nick Desaulniers <ndesaulniers@google.com>, Tom Rix <trix@redhat.com>,
 ocfs2-devel@lists.linux.dev, llvm@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20230922174925.work.293-kees@kernel.org>
Content-Language: en-US
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <20230922174925.work.293-kees@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 94.239.20.48
X-Source-L: No
X-Exim-ID: 1qjxw9-003TvN-2J
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: ([192.168.1.98]) [94.239.20.48]:46684
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 4
X-Org: HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfAehYpmwKA8rYFOi3MvxauJWIUiPVtqnR1ydU4pbQC8Sx7bF5DXsedkwLsmeHsEpNxGa98TLzgRDMH/kLG7Zp8C4+84CY1m6Th5BDwr8x5k4bZXKe73W
 7atbGaS/Xea4djrGkoDFnLQYlgacdvoU014/FY8+Gs5+QgPulhDd+vK9zpkaYqhHaztbRBXZAGp0Htylh21ARekR0fJZxxyFKADbe/PVau2JHzQthlEw7EGL



On 9/22/23 11:49, Kees Cook wrote:
> Prepare for the coming implementation by GCC and Clang of the __counted_by
> attribute. Flexible array members annotated with __counted_by can have
> their accesses bounds-checked at run-time checking via CONFIG_UBSAN_BOUNDS
> (for array indexing) and CONFIG_FORTIFY_SOURCE (for strcpy/memcpy-family
> functions).
> 
> As found with Coccinelle[1], add __counted_by for struct ocfs2_replay_map.
> 
> [1] https://github.com/kees/kernel-tools/blob/trunk/coccinelle/examples/counted_by.cocci
> 
> Cc: Mark Fasheh <mark@fasheh.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
> Cc: Nathan Chancellor <nathan@kernel.org>
> Cc: Nick Desaulniers <ndesaulniers@google.com>
> Cc: Tom Rix <trix@redhat.com>
> Cc: ocfs2-devel@lists.linux.dev
> Cc: llvm@lists.linux.dev
> Signed-off-by: Kees Cook <keescook@chromium.org>

Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Thanks
-- 
Gustavo

> ---
>   fs/ocfs2/journal.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> index ce215565d061..604fea3a26ff 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -90,7 +90,7 @@ enum ocfs2_replay_state {
>   struct ocfs2_replay_map {
>   	unsigned int rm_slots;
>   	enum ocfs2_replay_state rm_state;
> -	unsigned char rm_replay_slots[];
> +	unsigned char rm_replay_slots[] __counted_by(rm_slots);
>   };
>   
>   static void ocfs2_replay_map_set_state(struct ocfs2_super *osb, int state)
