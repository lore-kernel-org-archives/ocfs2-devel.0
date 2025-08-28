Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE8C13FEE
	for <ocfs2-devel@lists.linux.dev>; Thu, 28 Aug 2025 01:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756343467; cv=none; b=qjiW3G9cCw4VuZPfZka9stAoHOsdeQfMZDk/l6254eWenRUiYdMN1/lkwoWZnAQs9S68K1VoBTEXxqGR0LQoKx5jSXY28O3XWSOJd5UIDCDcsRZ01LDLqPoZq/jL768tpaxm+G/RBVeDhXyErZtV9ce1Vxska/4QsIncGVdC6x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756343467; c=relaxed/simple;
	bh=T54sChdFCQYgAIe63tS9H5O7JGsgrowHeQQI8195BAY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tduaHlQJOKgyktnS/3Oog3/q7NNDkvNSYK/nElDdYFH9f2E0HAvkbf5/8+AteLCg8GPUXkfUNCGC0I8+uT3MUiHx0DFbm+MQT0YGqQy2FOkbImkFqmSnqjsKj6nuFc2uZWesY1Am7/KrRkLJxBR1qomYmrWw+SPSow7DOx2uyg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=RsyobB3G; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="RsyobB3G"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1756343459; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=8f3eyUP4EDg8Z+h3Vm1+LYpznbLQKSbkGehfEGu1b9k=;
	b=RsyobB3GTSyyyTEnpNOAI0XTNF0ZxyW7MVHxgmOxW9iqknQQ7duzFYEElRGFoiL6hk5Isp4SumFT7ENNBZNrRM9BelfySGABYSPo4T/3dXKc/QoiyZ/tXQzEJ9Wxz/m+1jt+VFgRyfH4xhm+cnOYt6BQgMHuvnUupYeDPpkzW+Y=
Received: from 30.221.144.151(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WmkrGUA_1756343458 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 28 Aug 2025 09:10:59 +0800
Message-ID: <e0af0cee-9477-4179-ade5-7df879e22f02@linux.alibaba.com>
Date: Thu, 28 Aug 2025 09:10:58 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Documentation: ocfs2: Properly reindent filecheck
 operations list
To: Bagas Sanjaya <bagasdotme@gmail.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linux Documentation <linux-doc@vger.kernel.org>,
 Linux ocfs2 <ocfs2-devel@lists.linux.dev>
Cc: Jonathan Corbet <corbet@lwn.net>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>
References: <20250826024756.16073-1-bagasdotme@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20250826024756.16073-1-bagasdotme@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/8/26 10:47, Bagas Sanjaya wrote:
> Some of texts in filecheck operations list are indented out of the list.
> In particular, the third operation is shown not as the third list
> item but rather as a separate paragraph.
> 
> Reindent the list so that gets properly rendered as such.
> 
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>

Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  .../filesystems/ocfs2-online-filecheck.rst    | 20 +++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/Documentation/filesystems/ocfs2-online-filecheck.rst b/Documentation/filesystems/ocfs2-online-filecheck.rst
> index 2257bb53edc1b1..9e8449416e0bee 100644
> --- a/Documentation/filesystems/ocfs2-online-filecheck.rst
> +++ b/Documentation/filesystems/ocfs2-online-filecheck.rst
> @@ -58,33 +58,33 @@ inode, fixing inode and setting the size of result record history.
>      # echo "<inode>" > /sys/fs/ocfs2/<devname>/filecheck/check
>      # cat /sys/fs/ocfs2/<devname>/filecheck/check
>  
> -The output is like this::
> +   The output is like this::
>  
>      INO		DONE	ERROR
>      39502		1	GENERATION
>  
> -    <INO> lists the inode numbers.
> -    <DONE> indicates whether the operation has been finished.
> -    <ERROR> says what kind of errors was found. For the detailed error numbers,
> -    please refer to the file linux/fs/ocfs2/filecheck.h.
> +   <INO> lists the inode numbers.
> +   <DONE> indicates whether the operation has been finished.
> +   <ERROR> says what kind of errors was found. For the detailed error numbers,
> +   please refer to the file linux/fs/ocfs2/filecheck.h.
>  
>  2. If you determine to fix this inode, do::
>  
>      # echo "<inode>" > /sys/fs/ocfs2/<devname>/filecheck/fix
>      # cat /sys/fs/ocfs2/<devname>/filecheck/fix
>  
> -The output is like this:::
> +   The output is like this::
>  
>      INO		DONE	ERROR
>      39502		1	SUCCESS
>  
> -This time, the <ERROR> column indicates whether this fix is successful or not.
> +   This time, the <ERROR> column indicates whether this fix is successful or not.
>  
>  3. The record cache is used to store the history of check/fix results. It's
> -default size is 10, and can be adjust between the range of 10 ~ 100. You can
> -adjust the size like this::
> +   default size is 10, and can be adjust between the range of 10 ~ 100. You can
> +   adjust the size like this::
>  
> -  # echo "<size>" > /sys/fs/ocfs2/<devname>/filecheck/set
> +    # echo "<size>" > /sys/fs/ocfs2/<devname>/filecheck/set
>  
>  Fixing stuff
>  ============
> 
> base-commit: ee9a6691935490dc39605882b41b9452844d5e4e

