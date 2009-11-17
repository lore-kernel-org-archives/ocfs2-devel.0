From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 17 Nov 2009 13:43:28 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2/cluster: Make fence method
 configurable
In-Reply-To: <1258492078-32200-1-git-send-email-sunil.mushran@oracle.com>
References: <1258492078-32200-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20091117214328.GC18683@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Nov 17, 2009 at 01:07:58PM -0800, Sunil Mushran wrote:
> By default, o2cb fences the box by calling emergency_restart(). While this
> scheme works well in production, it comes in the way during testing as it
> does not let the tester take stack/core dumps for analysis.
> 
> This patch allows user to dynamically change the fence method to panic() by:
> # echo "panic" > /sys/kernel/config/cluster/<clustername>/fence_method
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
> ---
>  fs/ocfs2/cluster/nodemanager.c |   50 ++++++++++++++++++++++++++++++++++++++++
>  fs/ocfs2/cluster/nodemanager.h |    7 +++++
>  fs/ocfs2/cluster/quorum.c      |   14 +++++++++-
>  3 files changed, 69 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/cluster/nodemanager.c b/fs/ocfs2/cluster/nodemanager.c
> index 7ee6188..77cdc09 100644
> --- a/fs/ocfs2/cluster/nodemanager.c
> +++ b/fs/ocfs2/cluster/nodemanager.c
> @@ -35,6 +35,11 @@
>   * cluster references throughout where nodes are looked up */
>  struct o2nm_cluster *o2nm_single_cluster = NULL;
>  
> +char *o2nm_fence_method_desc[O2NM_FENCE_METHODS + 1] = {
> +		"reset",	/* O2NM_FENCE_RESET */
> +		"panic",	/* O2NM_FENCE_PANIC */
> +		"unknown",
> +};

	Why do you have "unknown"?  There's no point to it; we 
default to "reset" and you never allow anything about O2NM_FENCE_METHODS
to be set.

> +static ssize_t o2nm_cluster_attr_fence_method_read(
> +	struct o2nm_cluster *cluster, char *page)
> +{
> +	unsigned int i = O2NM_FENCE_METHODS;
> +
> +	if (cluster && cluster->cl_fence_method < O2NM_FENCE_METHODS)
> +		i = cluster->cl_fence_method;

	cl_fence_method should always be below O2NM_FENCE_METHODS.  You
only need to check if(cluster).  If cl_fence_method is off, we'll crash,
which is fine.

> +	switch (o2nm_single_cluster->cl_fence_method) {
> +	case O2NM_FENCE_PANIC:
> +		panic("*** ocfs2 is very sorry to be fencing this system by "
> +		      "panicing ***\n");
> +		break;
> +	case O2NM_FENCE_RESET:
> +	default:

	Why not:

+	default:
+		WARN_ON(o2nm_single_cluster->cl_fence_method >=
+			O2NM_FENCE_METHODS);
+	case O2NM_FENCE_RESET:

so that netconsole will catch a wacky cl_fence_method.

> +		printk("*** ocfs2 is very sorry to be fencing this system by "
> +		       "restarting ***\n");

	And here, print KERN_ERR so noone filters it out with low klogd
levels.

Joel

-- 

"For every complex problem there exists a solution that is brief,
     concise, and totally wrong."
                                        -Unknown

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
