From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu Feb 28 14:41:50 2008
Subject: [Ocfs2-devel] [PATCH 04/18] ocfs2_dlm: Add missing
	dlm_lockres_put()s in migration path
In-Reply-To: <1203970862-8790-5-git-send-email-sunil.mushran@oracle.com>
References: <1203970862-8790-1-git-send-email-sunil.mushran@oracle.com>
	<1203970862-8790-5-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080228224052.GG23975@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Feb 25, 2008 at 12:20:48PM -0800, Sunil Mushran wrote:
> The inline comments explain the missing puts in the lockres
> migration paths.

	The comments are readable in a patch email, but not in a 'git
log'.  Can you expound on the problem in the patch header too, please?

> @@ -1919,6 +1946,8 @@ void dlm_move_lockres_to_recovery_list(struct dlm_ctxt *dlm,
>  		     "Recovering res %s:%.*s, is already on recovery list!\n",
>  		     dlm->name, res->lockname.len, res->lockname.name);
>  		list_del_init(&res->recovering);
> +		/* Duh... */
> +		dlm_lockres_put(res);

	Why is this "Duh..."?  People looking later won't have the
benefit of your memory :-)

Joel

-- 

"Practice random acts of kindness and senseless acts of beauty."

 Oh, and don't forget where your towel is.

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
