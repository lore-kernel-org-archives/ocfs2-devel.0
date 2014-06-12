From: Mark Fasheh <mfasheh@suse.de>
Date: Thu, 12 Jun 2014 16:17:38 -0700
Subject: [Ocfs2-devel] [patch 3/8] ocfs2: revert "ocfs2: fix NULL
	pointer dereference	when dismount and ocfs2rec simultaneously"
In-Reply-To: <20140609200402.66B1331C76B@corp2gmr1-1.hot.corp.google.com>
References: <20140609200402.66B1331C76B@corp2gmr1-1.hot.corp.google.com>
Message-ID: <20140612231738.GE5484@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Jun 09, 2014 at 01:04:02PM -0700, Andrew Morton wrote:
> From: Xue jiufei <xuejiufei@huawei.com>
> Subject: ocfs2: revert "ocfs2: fix NULL pointer dereference when dismount and ocfs2rec simultaneously"
> 
> 75f82eaa502c ("ocfs2: fix NULL pointer dereference when dismount and
> ocfs2rec simultaneously") may cause umount hang while shutting down
> truncate log.
> 
> The situation is as followes:
> ocfs2_dismout_volume
> -> ocfs2_recovery_exit
>   -> free osb->recovery_map
> -> ocfs2_truncate_shutdown
>   -> lock global bitmap inode
>     -> ocfs2_wait_for_recovery
> 	  -> check whether osb->recovery_map->rm_used is zero
> 	
> Because osb->recovery_map is already freed, rm_used can be any other
> values, so it may yield umount hang.

Good catch, thanks for this.

I'm thinking the original patch was just wrong and we need to make sure
everything related to file system maintenance is shut down completely
(including truncate log flushes) before turning off recovery.


Reviewed-by: Mark Fasheh <mfasheh@suse.de>
	--Mark

--
Mark Fasheh
