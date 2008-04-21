From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 21 Apr 2008 03:02:06 -0700
Subject: [Ocfs2-devel] [2.6 patch] make struct o2cb_stack_ops static
In-Reply-To: <20080421084931.GT26897@cs181133002.pp.htv.fi>
References: <20080421084931.GT26897@cs181133002.pp.htv.fi>
Message-ID: <20080421100206.GB7059@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Adrian Bunk <bunk@kernel.org>
Cc: Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

On Mon, Apr 21, 2008 at 11:49:31AM +0300, Adrian Bunk wrote:
> This patch makes the needlessly global struct o2cb_stack_ops static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Joel Becker <joel.becker@oracle.com>

> 
> ---
> eb3ca85e31f3ddec51aaab0fd2243962d7ce1bc6 diff --git a/fs/ocfs2/stack_o2cb.c b/fs/ocfs2/stack_o2cb.c
> index ac1d74c..bbd1667 100644
> --- a/fs/ocfs2/stack_o2cb.c
> +++ b/fs/ocfs2/stack_o2cb.c
> @@ -385,7 +385,7 @@ static int o2cb_cluster_this_node(unsigned int *node)
>  	return 0;
>  }
>  
> -struct ocfs2_stack_operations o2cb_stack_ops = {
> +static struct ocfs2_stack_operations o2cb_stack_ops = {
>  	.connect	= o2cb_cluster_connect,
>  	.disconnect	= o2cb_cluster_disconnect,
>  	.hangup		= o2cb_cluster_hangup,
> 

-- 

"What does it say about a society's priorities when the time you
 spend in meetings on Monday is greater than the total number of
 hours you spent sleeping over the weekend?"
	- Nat Friedman

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
