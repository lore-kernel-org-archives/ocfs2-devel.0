From: Joel Becker <jlbec@evilplan.org>
Date: Mon, 1 Jul 2013 16:04:21 -0700
Subject: [Ocfs2-devel] [RESENT PATCH 4/4] ocfs2: adjust switch_case
 syntax at o2net_state_change()
In-Reply-To: <51CE5C0F.8030701@oracle.com>
References: <51CE5C0F.8030701@oracle.com>
Message-ID: <20130701230421.GE965@localhost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sat, Jun 29, 2013 at 12:01:19PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> Adjust switch..case syntax at o2net_state_change to meet
> the kernel coding standard.
> 
> s/printk/pr_info/.
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>

	Switching to pr_info() hasn't been discussed as part of the
project.  Let's have that conversation elsewhere.

Joel

> ---
>  fs/ocfs2/cluster/tcp.c |   26 +++++++++++++-------------
>  1 file changed, 13 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
> index aa88bd8..db4c465 100644
> --- a/fs/ocfs2/cluster/tcp.c
> +++ b/fs/ocfs2/cluster/tcp.c
> @@ -630,19 +630,19 @@ static void o2net_state_change(struct sock *sk)
>  	state_change = sc->sc_state_change;
>  
>  	switch(sk->sk_state) {
> -		/* ignore connecting sockets as they make progress */
> -		case TCP_SYN_SENT:
> -		case TCP_SYN_RECV:
> -			break;
> -		case TCP_ESTABLISHED:
> -			o2net_sc_queue_work(sc, &sc->sc_connect_work);
> -			break;
> -		default:
> -			printk(KERN_INFO "o2net: Connection to " SC_NODEF_FMT
> -			      " shutdown, state %d\n",
> -			      SC_NODEF_ARGS(sc), sk->sk_state);
> -			o2net_sc_queue_work(sc, &sc->sc_shutdown_work);
> -			break;
> +	/* ignore connecting sockets as they make progress */
> +	case TCP_SYN_SENT:
> +	case TCP_SYN_RECV:
> +		break;
> +	case TCP_ESTABLISHED:
> +		o2net_sc_queue_work(sc, &sc->sc_connect_work);
> +		break;
> +	default:
> +		pr_info(KERN_INFO "o2net: Connection to " SC_NODEF_FMT
> +			" shutdown, state %d\n",
> +			SC_NODEF_ARGS(sc), sk->sk_state);
> +		o2net_sc_queue_work(sc, &sc->sc_shutdown_work);
> +		break;
>  	}
>  out:
>  	read_unlock(&sk->sk_callback_lock);
> -- 
> 1.7.9.5
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel

-- 

Life's Little Instruction Book #3

	"Watch a sunrise at least once a year."

			http://www.jlbec.org/
			jlbec at evilplan.org
