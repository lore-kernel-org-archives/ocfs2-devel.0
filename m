From: Jeff Liu <jeff.liu@oracle.com>
Date: Tue, 18 Jun 2013 12:20:02 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Free sc->sc_page in
	sc_kref_release()
In-Reply-To: <51BFD6B0.2090106@huawei.com>
References: <51BFD6B0.2090106@huawei.com>
Message-ID: <51BFDFF2.7010208@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 06/18/2013 11:40 AM, Younger Liu wrote:

> There is a memory leak in sc_kref_release().
> When free struct o2net_sock_container (sc), 
> we should release sc->sc_page.
> 
> Signed-off-by: Younger Liu <younger.liu@huawei.com>

Looks fine to me, thanks!

Reviewed-by: Jie Liu <jeff.liu@oracle.com>

> ---
>  fs/ocfs2/cluster/tcp.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
> index aa88bd8..f0272b9 100644
> --- a/fs/ocfs2/cluster/tcp.c
> +++ b/fs/ocfs2/cluster/tcp.c
> @@ -406,6 +406,11 @@ static void sc_kref_release(struct kref *kref)
>  	sc->sc_node = NULL;
>  
>  	o2net_debug_del_sc(sc);
> +
> +	if (sc->sc_page) {
> +		__free_page(sc->sc_page);
> +		sc->sc_page = NULL;
> +	}
>  	kfree(sc);
>  }
>  
> -- 1.7.9.7
