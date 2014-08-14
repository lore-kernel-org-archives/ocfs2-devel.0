From: Mark Fasheh <mfasheh@suse.de>
Date: Wed, 13 Aug 2014 23:16:00 -0700
Subject: [Ocfs2-devel] [patch 03/10] ocfs2: o2net: don't shutdown
	connection when	idle timeout
In-Reply-To: <53EC5055.3000209@oracle.com>
References: <53e290c4.mdvolEdkIB2F3m6N%akpm@linux-foundation.org>
	<20140813185922.GW2203@wotan.suse.de> <53EC5055.3000209@oracle.com>
Message-ID: <20140814061600.GZ2203@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Aug 14, 2014 at 01:59:49PM +0800, Junxiao Bi wrote:
> >>  static void o2net_sc_postpone_idle(struct o2net_sock_container *sc)
> >>  {
> >> +	struct o2net_node *nn = o2net_nn_from_num(sc->sc_node->nd_num);
> >> +
> >> +	/* clear fence decision since the connection recover from timeout*/
> >> +	if (atomic_read(&nn->nn_timeout)) {
> >> +		o2quo_conn_up(o2net_num_from_nn(nn));
> >> +		cancel_delayed_work(&nn->nn_still_up);
> > This might sound silly (since there's a chance the node is killed) but what
> > about the return value of cancel_delayed_work() here? There's a chance the
> > delayed work couldn't be canceled, does that impact the patch in any
> > negative manner?
> The return value don't need to be taken care.
> Two cases:
> 1) If the work is still pending, then the function will cancel it and
> return true.
>     no problem.
> 2) If the work is running, the function will return false. If cluster is
> in split-brain,
> then the work will do nothing, else this node will be fenced, this means
> the net
> revert too late. So this case also can't affect the following patch manner.

Ok, that makes sense - thanks.

Reviewed-by: Mark Fasheh <mfasheh@suse.de>
	--Mark

--
Mark Fasheh
