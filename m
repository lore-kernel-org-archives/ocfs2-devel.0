From: Randy Dunlap <rdunlap@infradead.org>
Date: Sun, 7 Jun 2020 14:50:13 -0700
Subject: [Ocfs2-devel] [PATCH] fs: ocfs2: fix spelling mistake
In-Reply-To: <20200607212115.99278-1-iamkeyur96@gmail.com>
References: <20200607212115.99278-1-iamkeyur96@gmail.com>
Message-ID: <037d3c9a-2abe-1e4e-eb91-a14f2e84e629@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Keyur Patel <iamkeyur96@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

On 6/7/20 2:21 PM, Keyur Patel wrote:
> ./ocfs2/mmap.c:65: bebongs ==> belongs
> 
> Signed-off-by: Keyur Patel <iamkeyur96@gmail.com>
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
> +	 * There are cases that lead to the page no longer belongs to the

I would say                                      no longer belonging to the

>  	 * mapping.
>  	 * 1) pagecache truncates locally due to memory pressure.
>  	 * 2) pagecache truncates when another is taking EX lock against 
> 

Please fix your To: line:

(no To-header on input) <>

-- 
~Randy
