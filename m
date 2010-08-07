From: Joel Becker <Joel.Becker@oracle.com>
Date: Sat, 7 Aug 2010 11:39:13 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: fix a dead lock
In-Reply-To: <201007161515.o6GFF20K015585@acsinet15.oracle.com>
References: <201007161515.o6GFF20K015585@acsinet15.oracle.com>
Message-ID: <20100807183912.GB3699@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jul 16, 2010 at 11:13:33PM +0800, Wengang Wang wrote:
> When we have to take both dlm->master_lock and lockres->spinlock,
> take them in order
> 
> lockres->spinlock and then dlm->master_lock.
> 
> The patch fixes a violation of the rule.
> We can simply move taking dlm->master_lock to where we have dropped res->spinlock
> since when we access res->state and free mle memory we don't need master_lock's
> protection.
> 
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>

This patch is now in the fixes branch of ocfs2.git.

Joel
-- 

"Three o'clock is always too late or too early for anything you
 want to do."
        - Jean-Paul Sartre

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
