From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 21 Jun 2010 20:34:31 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2 fix o2dlm dlm run purgelist
In-Reply-To: <1276977371-13911-1-git-send-email-srinivas.eeda@oracle.com>
References: <1276977371-13911-1-git-send-email-srinivas.eeda@oracle.com>
Message-ID: <20100622033430.GA15659@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sat, Jun 19, 2010 at 12:56:11PM -0700, Srinivas Eeda wrote:
> There are two problems in dlm_run_purgelist
> 
> 1. If a lockres is found to be in use, dlm_run_purgelist keeps trying to purge
> the same lockres instead of trying the next lockres.
> 
> 2. When a lockres is found unused, dlm_run_purgelist releases lockres spinlock
> before setting DLM_LOCK_RES_DROPPING_REF and calls dlm_purge_lockres.
> spinlock is reacquired but in this window lockres can get reused. This leads
> to BUG.
> 
> This patch modifies dlm_run_purgelist to skip lockres if it's in use and purge
>  next lockres. It also sets DLM_LOCK_RES_DROPPING_REF before releasing the
> lockres spinlock protecting it from getting reused.
> 
> Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>

	I agree with everything Sunil said.  More below.

> +		/* Status of the lockres *might* change so double
> +		 * check. If the lockres is unused, holding the dlm
> +		 * spinlock will prevent people from getting and more
> +		 * refs on it -- there's no need to keep the lockres
> +		 * spinlock. */
> +		unused = __dlm_lockres_unused(lockres);

	There's no point in commenting about "no need to keep the
lockres spinlock" when you are now holding it through the operation.
You can drop everything after the '--'.

Joel

-- 

"Here's a nickle -- get yourself a better X server."
	- Keith Packard

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
