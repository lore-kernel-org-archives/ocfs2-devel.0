From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 12 Jul 2010 15:39:03 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2 fix o2dlm dlm run purgelist(bug
 9094491) - rev3
In-Reply-To: <1278972988-17992-1-git-send-email-srinivas.eeda@oracle.com>
References: <1278972988-17992-1-git-send-email-srinivas.eeda@oracle.com>
Message-ID: <20100712223903.GI12179@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Jul 12, 2010 at 03:16:28PM -0700, Srinivas Eeda wrote:
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
> Signed-off-by: Sunil Mushran<sunil.mushran@oracle.com>

	Has this been tested with a testcase that would fail before the
change?
	Also, don't add SoB lines for kernel patches.  You can add
Acked-by for Sunil, but SoB only works for the chain that goes upstream.

Joel

-- 

"War doesn't determine who's right; war determines who's left."

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
