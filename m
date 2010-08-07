From: Joel Becker <Joel.Becker@oracle.com>
Date: Sat, 7 Aug 2010 11:40:28 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: remove potential deadlock -V3
In-Reply-To: <201007301519.o6UFJ5ch018098@acsinet15.oracle.com>
References: <04A823D0-EA74-4893-ABD0-816DA589CE16@oracle.com>
	<201007301519.o6UFJ5ch018098@acsinet15.oracle.com>
Message-ID: <20100807184028.GF3699@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jul 30, 2010 at 11:18:00PM +0800, Wengang Wang wrote:
> When we need to take both dlm_domain_lock and dlm->spinlock, we should take
> them in order of: dlm_domain_lock then dlm->spinlock.
> 
> There is pathes disobey this order. That is calling dlm_lockres_put() with
> dlm->spinlock held in dlm_run_purge_list. dlm_lockres_put() calls dlm_put() at
> the ref and dlm_put() locks on dlm_domain_lock.
> 
> Fix:
> Don't grab/put the dlm when the initialising/releasing lockres.
> That grab is not required because we don't call dlm_unregister_domain()
> based on refcount.
> 
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>

This patch is now in the fixes branch of ocfs2.git.

Joel
-- 

"If the human brain were so simple we could understand it, we would
 be so simple that we could not."
	- W. A. Clouston

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
