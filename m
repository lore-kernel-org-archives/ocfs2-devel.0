From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Fri, 5 Jul 2019 10:06:12 +0800
Subject: [Ocfs2-devel] [PATCH] fs: ocfs2: dlmglue: Unneeded variable:
	"status"
In-Reply-To: <20190702183237.GA13975@hari-Inspiron-1545>
References: <20190702183237.GA13975@hari-Inspiron-1545>
Message-ID: <6a6ae279-9d35-0c00-d3db-72e11cda3838@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hariprasad Kelam <hariprasad.kelam@gmail.com>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>



On 19/7/3 02:32, Hariprasad Kelam wrote:
> fix below issue reported by coccicheck
> fs/ocfs2/dlmglue.c:4410:5-11: Unneeded variable: "status". Return "0" on
> line 4428
> 
> We can not change return type of ocfs2_downconvert_thread as its
> registered as callback of kthread_create.
> 
> Signed-off-by: Hariprasad Kelam <hariprasad.kelam@gmail.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/dlmglue.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index dc987f5..1420723 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -4407,7 +4407,6 @@ static int ocfs2_downconvert_thread_should_wake(struct ocfs2_super *osb)
>  
>  static int ocfs2_downconvert_thread(void *arg)
>  {
> -	int status = 0;
>  	struct ocfs2_super *osb = arg;
>  
>  	/* only quit once we've been asked to stop and there is no more
> @@ -4425,7 +4424,7 @@ static int ocfs2_downconvert_thread(void *arg)
>  	}
>  
>  	osb->dc_task = NULL;
> -	return status;
> +	return 0;
>  }
>  
>  void ocfs2_wake_downconvert_thread(struct ocfs2_super *osb)
> 
