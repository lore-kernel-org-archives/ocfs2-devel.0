From: Joel Becker <jlbec@evilplan.org>
Date: Mon, 13 Jan 2014 07:37:11 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] o2dlm: fix NULL pointer dereference
 in o2dlm_blocking_ast_wrapper
In-Reply-To: <1389403153-4220-1-git-send-email-srinivas.eeda@oracle.com>
References: <1389403153-4220-1-git-send-email-srinivas.eeda@oracle.com>
Message-ID: <20140113153711.GB18208@localhost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jan 10, 2014 at 05:19:13PM -0800, Srinivas Eeda wrote:
> From: Srinivas Eeda <seeda@srini.(none)>
> 
> A tiny race between BAST and unlock message causes the NULL dereference.
> 
> A node sends an unlock request to master and receives a response. Before
> processing the response it receives a BAST from the master. Since both requests
> are processed by different threads it creates a race. While the BAST is being
> processed, lock can get freed by unlock code.
> 
> This patch makes bast to return immediately if lock is found but unlock is
> pending. The code should handle this race. We also have to fix master node to
> skip sending BAST after receiving unlock message.

Did the master send the BAST after the unlock, or does that race too?
Does the master know the unlock has succeeded, or does it just think so?

> @@ -385,8 +385,13 @@ int dlm_proxy_ast_handler(struct o2net_msg *msg, u32 len, void *data,
>  		head = &res->granted;
>  
>  	list_for_each_entry(lock, head, list) {
> -		if (lock->ml.cookie == cookie)
> -			goto do_ast;
> +		/* if lock is found but unlock is pending ignore the bast */
> +		if (lock->ml.cookie == cookie) {
> +			if (lock->unlock_pending)
> +				break;
> +			else
> +				goto do_ast;
> +		}

This breaks out for asts as well as basts.  Can't that cause problems
with the unlock ast expected by the caller?

Joel


-- 

"Not being known doesn't stop the truth from being true."
        - Richard Bach

			http://www.jlbec.org/
			jlbec at evilplan.org
