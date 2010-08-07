From: Joel Becker <Joel.Becker@oracle.com>
Date: Sat, 7 Aug 2010 11:41:14 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2 fix o2dlm dlm run purgelist
 (rev 3)
In-Reply-To: <1279580652-29247-1-git-send-email-srinivas.eeda@oracle.com>
References: <1279580652-29247-1-git-send-email-srinivas.eeda@oracle.com>
Message-ID: <20100807184113.GH3699@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Jul 19, 2010 at 04:04:12PM -0700, Srinivas Eeda wrote:
> This patch fixes two problems in dlm_run_purgelist
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
> Acked-by: Sunil Mushran <sunil.mushran@oracle.com>

This patch is now in the fixes branch of ocfs2.git.

Joel

-- 

"To fall in love is to create a religion that has a fallible god."
        -Jorge Luis Borges

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
