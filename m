From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 10 Feb 2009 23:35:15 -0800
Subject: [Ocfs2-devel] [PATCH 4/4] ocfs2/dlm:
	Make	dlm_assert_master_handler() kill itself instead of the asserter
In-Reply-To: <1233693436-29263-4-git-send-email-sunil.mushran@oracle.com>
References: <1233693436-29263-1-git-send-email-sunil.mushran@oracle.com>
	<1233693436-29263-4-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20090211073515.GD9512@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Feb 03, 2009 at 12:37:16PM -0800, Sunil Mushran wrote:
> In dlm_assert_master_handler(), if we get an incorrect assert master from a node
> that, we reply with EINVAL asking the asserter to die. The problem is that an
> assert is sent after so many hoops, it is invariably the node that thinks the
> asserter is wrong, is actually wrong. So instead of killing the asserter, this
> patch kills the assertee.

	You mean that the node asserting mastery is probably correct,
and the node that sees a disconnect between mastery information and the
asserter is confused?

> This patch papers over a race that is still being addressed.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
> ---
>  fs/ocfs2/dlm/dlmmaster.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
> index 54e182a..0a28139 100644
> --- a/fs/ocfs2/dlm/dlmmaster.c
> +++ b/fs/ocfs2/dlm/dlmmaster.c
> @@ -1849,12 +1849,12 @@ int dlm_assert_master_handler(struct o2net_msg *msg, u32 len, void *data,
>  		if (!mle) {
>  			if (res->owner != DLM_LOCK_RES_OWNER_UNKNOWN &&
>  			    res->owner != assert->node_idx) {
> -				mlog(ML_ERROR, "assert_master from "
> -					  "%u, but current owner is "
> -					  "%u! (%.*s)\n",
> -				       assert->node_idx, res->owner,
> -				       namelen, name);
> -				goto kill;
> +				mlog(ML_ERROR, "DIE! Mastery assert from %u, "
> +				     "but current owner is %u! (%.*s)\n",
> +				     assert->node_idx, res->owner, namelen,
> +				     name);
> +				__dlm_print_one_lock_resource(res);
> +				BUG();

	BUG() isn't much of a die.  Are you figuring soft lockup code
will eventually kill this?

Joel

-- 

"And yet I fight,
 And yet I fight this battle all alone.
 No one to cry to;
 No place to call home."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
