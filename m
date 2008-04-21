From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 21 Apr 2008 03:01:53 -0700
Subject: [Ocfs2-devel] [2.6 patch] make struct ocfs2_control_device
	static
In-Reply-To: <20080421084926.GS26897@cs181133002.pp.htv.fi>
References: <20080421084926.GS26897@cs181133002.pp.htv.fi>
Message-ID: <20080421100153.GA7059@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Adrian Bunk <bunk@kernel.org>
Cc: Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

On Mon, Apr 21, 2008 at 11:49:26AM +0300, Adrian Bunk wrote:
> This patch makes the needlessly global struct ocfs2_control_device 
> static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Joel Becker <joel.becker@oracle.com>

> 
> ---
> d8837f8ed79bc615105e5ca2724c3d22c9f26089 diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
> index 7428663..b503772 100644
> --- a/fs/ocfs2/stack_user.c
> +++ b/fs/ocfs2/stack_user.c
> @@ -635,7 +635,7 @@ static const struct file_operations ocfs2_control_fops = {
>  	.owner   = THIS_MODULE,
>  };
>  
> -struct miscdevice ocfs2_control_device = {
> +static struct miscdevice ocfs2_control_device = {
>  	.minor		= MISC_DYNAMIC_MINOR,
>  	.name		= "ocfs2_control",
>  	.fops		= &ocfs2_control_fops,
> 

-- 

Life's Little Instruction Book #356

	"Be there when people need you."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
