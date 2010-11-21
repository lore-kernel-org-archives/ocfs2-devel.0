From: Joel Becker <Joel.Becker@oracle.com>
Date: Sun, 21 Nov 2010 11:57:14 -0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2/dlm: Migrate lockres with no
 locks if it has a reference
In-Reply-To: <1290208010-2603-2-git-send-email-sunil.mushran@oracle.com>
References: <1290208010-2603-1-git-send-email-sunil.mushran@oracle.com>
	<1290208010-2603-2-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20101121195713.GC14333@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Nov 19, 2010 at 03:06:50PM -0800, Sunil Mushran wrote:
> o2dlm was not migrating resources with zero locks because it assumed that that
> resource would get purged by dlm_thread. However, some usage patterns involve
> creating and dropping locks at a high rate leading to the migrate thread seeing
> zero locks but the purge thread seeing an active reference. When this happens,
> the dlm_thread cannot purge the resource and the migrate thread sees no reason
> to migrate that resource. The spell is broken when the migrate thread catches
> the resource with a lock.
> 
> The fix is to make the migrate thread also consider the reference map.

	The idea is good, but I have a question about the
implementation.

>  static int dlm_is_lockres_migrateable(struct dlm_ctxt *dlm,
>  				      struct dlm_lock_resource *res,
> -				      int *numlocks)
> +				      int *numlocks,
> +				      int *hasrefs)

	There's no point in returning hasrefs.  No caller cares about
*why* it isn't migratable, just that it isn't.  In fact, no caller cares
about the number of locks, either.  They only care about the boolean
is/is-not migratable.
	I say you remove the numlocks and hasref arguments, and merely
return 0 when there are locks or refs, 1 otherwise.  -errno for errors,
of course.

Joel

-- 

Life's Little Instruction Book #407

	"Every once in a while, take the scenic route."

Joel Becker
Senior Development Manager
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
