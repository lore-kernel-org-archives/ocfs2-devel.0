Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E22224FA
	for <ocfs2-devel@lists.linux.dev>; Fri, 14 Feb 2025 01:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739496892; cv=none; b=N0iBUWap/MJrGZoXhQxKbFmkd78mZSL940jc3tCg7dbvVOY0gYq7pjNG98N9/ZqEWtqZNbkOlUIXMnDUVMslVKuWfltwETsSiUq4nwHAvcIZ+eq9pmBgTwshV3Eq1oQAKorQqCKZkl6XqklXHfrD2SwmeTIUI4baHVmF1mzJ22Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739496892; c=relaxed/simple;
	bh=+OSE5Cjqom6njhQUpHIo1JEL5EvmRopP+8UJJR9zXLI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fIFygT2B5S1aE26LvpXLlHd3t6r3decZy/Knp6XIWU70AIx2JKDI3cRcXgsd3eUooqk5GsA7Ihv057J/RpMW9ZZt+8LeHK5a2SHew+MLUH6/dsoCqGTaLvkiwAtRcP8I/Cwr7+luOb5+CXzU5X/ZChRK6SGkzXQQzdnJVOgBsM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=eoqYeFJf; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="eoqYeFJf"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1739496887; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=KZ0sLc/cuClVDixrTTIBGuyAyZDWpQQ+Idy51MsphVQ=;
	b=eoqYeFJftEg1VzNP+Xk6vviVD2HL2XNUjhp7E6E/ZJTrTuVywTyiFAvsrVwf49/PsFHACfKj7l3ZKn5+Cg9sPTuGM2ZxH01hL48xRdpci5VKWDs8571ne2yhu7l1RscSaDjcQsJmdfKcE9mKZ1Fv0GrwnC58DZatc95F2/j9TUU=
Received: from 30.221.128.236(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WPP0Muz_1739496886 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 14 Feb 2025 09:34:47 +0800
Message-ID: <072e3c64-5571-4828-862a-7b431e6e56ce@linux.alibaba.com>
Date: Fri, 14 Feb 2025 09:34:46 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] ocfs2: Remove reference to bh->b_page
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 akpm <akpm@linux-foundation.org>
Cc: Mark Tinguely <mark.tinguely@oracle.com>, ocfs2-devel@lists.linux.dev,
 linux-fsdevel@vger.kernel.org
References: <20250213214533.2242224-1-willy@infradead.org>
 <20250213214533.2242224-2-willy@infradead.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20250213214533.2242224-2-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/2/14 05:45, Matthew Wilcox (Oracle) wrote:
> Buffer heads are attached to folios, not to pages.  Also
> flush_dcache_page() is now deprecated in favour of flush_dcache_folio().
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/quota_global.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
> index 15d9acd456ec..e85b1ccf81be 100644
> --- a/fs/ocfs2/quota_global.c
> +++ b/fs/ocfs2/quota_global.c
> @@ -273,7 +273,7 @@ ssize_t ocfs2_quota_write(struct super_block *sb, int type,
>  	if (new)
>  		memset(bh->b_data, 0, sb->s_blocksize);
>  	memcpy(bh->b_data + offset, data, len);
> -	flush_dcache_page(bh->b_page);
> +	flush_dcache_folio(bh->b_folio);
>  	set_buffer_uptodate(bh);
>  	unlock_buffer(bh);
>  	ocfs2_set_buffer_uptodate(INODE_CACHE(gqinode), bh);

