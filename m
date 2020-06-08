From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Mon, 8 Jun 2020 09:53:49 +0800
Subject: [Ocfs2-devel] [PATCH v3] fs: ocfs2: fix spelling mistake and
	grammar
In-Reply-To: <20200608014818.102358-1-iamkeyur96@gmail.com>
References: <20200607212115.99278-1-iamkeyur96@gmail.com>
	<20200608014818.102358-1-iamkeyur96@gmail.com>
Message-ID: <84cbc852-740b-7f8f-051e-b8c532ab70a4@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Keyur Patel <iamkeyur96@gmail.com>, mark@fasheh.com, jlbec@evilplan.org, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>



On 2020/6/8 09:48, Keyur Patel wrote:
> ./ocfs2/mmap.c:65: bebongs ==> belonging
> 
> Signed-off-by: Keyur Patel <iamkeyur96@gmail.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/mmap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
> index 3a44e461828a..39a77e903fdf 100644
> --- a/fs/ocfs2/mmap.c
> +++ b/fs/ocfs2/mmap.c
> @@ -62,7 +62,7 @@ static vm_fault_t __ocfs2_page_mkwrite(struct file *file,
>  	last_index = (size - 1) >> PAGE_SHIFT;
>  
>  	/*
> -	 * There are cases that lead to the page no longer bebongs to the
> +	 * There are cases that lead to the page no longer belonging to the
>  	 * mapping.
>  	 * 1) pagecache truncates locally due to memory pressure.
>  	 * 2) pagecache truncates when another is taking EX lock against 
> 
