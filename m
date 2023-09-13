Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D49AEB8
	for <ocfs2-devel@lists.linux.dev>; Wed, 13 Sep 2023 03:53:00 +0000 (UTC)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R831e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0Vrz42ty_1694576860;
Received: from 30.221.128.188(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0Vrz42ty_1694576860)
          by smtp.aliyun-inc.com;
          Wed, 13 Sep 2023 11:47:41 +0800
Message-ID: <923f3dd1-c264-9d5f-3f17-1212493a7daa@linux.alibaba.com>
Date: Wed, 13 Sep 2023 11:47:39 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH v2] fs: ocfs2: Replace strlcpy with sysfs_emit
Content-Language: en-US
To: Azeem Shaikh <azeemshaikh38@gmail.com>, akpm <akpm@linux-foundation.org>
Cc: linux-hardening@vger.kernel.org, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, Christian Brauner <brauner@kernel.org>,
 Dave Chinner <dchinner@redhat.com>, Jan Kara <jack@suse.cz>,
 Jeff Layton <jlayton@kernel.org>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Kees Cook <keescook@chromium.org>
References: <20230831193827.1528867-1-azeemshaikh38@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20230831193827.1528867-1-azeemshaikh38@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/1/23 3:38 AM, Azeem Shaikh wrote:
> strlcpy() reads the entire source buffer first.
> This read may exceed the destination size limit.
> This is both inefficient and can lead to linear read
> overflows if a source string is not NUL-terminated [1].
> In an effort to remove strlcpy() completely [2], replace
> strlcpy() here with sysfs_emit().
> 
> Direct replacement is safe here since its ok for `kernel_param_ops.get()`
> to return -errno [3].
> 
> [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy
> [2] https://github.com/KSPP/linux/issues/89
> [3] https://elixir.bootlin.com/linux/v6.5/source/include/linux/moduleparam.h#L52
> 
> Signed-off-by: Azeem Shaikh <azeemshaikh38@gmail.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
> v2:
>  * Removes patch [1/2] which replaced module_param_call with module_param_cb.
>  * Use sysfs_emit instead of strscpy.
> 
> v1:
>  * https://lore.kernel.org/all/20230830215426.4181755-1-azeemshaikh38@gmail.com/
> 
>  fs/ocfs2/dlmfs/dlmfs.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
> index 81265123ce6c..b38776ba3306 100644
> --- a/fs/ocfs2/dlmfs/dlmfs.c
> +++ b/fs/ocfs2/dlmfs/dlmfs.c
> @@ -80,8 +80,7 @@ static int param_set_dlmfs_capabilities(const char *val,
>  static int param_get_dlmfs_capabilities(char *buffer,
>  					const struct kernel_param *kp)
>  {
> -	return strlcpy(buffer, DLMFS_CAPABILITIES,
> -		       strlen(DLMFS_CAPABILITIES) + 1);
> +	return sysfs_emit(buffer, DLMFS_CAPABILITIES);
>  }
>  module_param_call(capabilities, param_set_dlmfs_capabilities,
>  		  param_get_dlmfs_capabilities, NULL, 0444);
> --
> 2.42.0.283.g2d96d420d3-goog
> 
