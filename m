From: Mark Fasheh <mfasheh@suse.de>
Date: Fri, 13 Jun 2014 14:34:42 -0700
Subject: [Ocfs2-devel] [patch 7/8] ocfs2: do not
	return	DLM_MIGRATE_RESPONSE_MASTERY_REF to avoid endless,
	loop during umount
In-Reply-To: <20140609200406.E45385A4A39@corp2gmr1-2.hot.corp.google.com>
References: <20140609200406.E45385A4A39@corp2gmr1-2.hot.corp.google.com>
Message-ID: <20140613213442.GN5484@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Jun 09, 2014 at 01:04:06PM -0700, Andrew Morton wrote:
> From: jiangyiwen <jiangyiwen@huawei.com>
> Subject: ocfs2: do not return DLM_MIGRATE_RESPONSE_MASTERY_REF to avoid endless,loop during umount

This looks good, thanks!

> The following case may lead to endless loop during umount.
> 
> node A         node B               node C       node D
> umount volume,
> migrate lockres1
> to B
>                                                  want to lock lockres1,
>                                                  send
>                                                  MASTER_REQUEST_MSG
>                                                  to C
>                                     init block mle
>                send
>                MIGRATE_REQUEST_MSG
>                to C
>                                     find a block
>                                     mle, and then
>                                     return
>                                     DLM_MIGRATE_RESPONSE_MASTERY_REF
>                                     to B
>                set C in refmap
>                                     umount successfully
>                try to umount, endless
>                loop occurs when migrate
>                lockres1 since C is in
>                refmap
> 
> So we can fix this endless loop case by only returning
> DLM_MIGRATE_RESPONSE_MASTERY_REF if it has a mastery mle when receiving
> MIGRATE_REQUEST_MSG.
> 
> [akpm at linux-foundation.org: coding-style fixes]
> Signed-off-by: jiangyiwen <jiangyiwen@huawei.com>
> Cc: Mark Fasheh <mfasheh@suse.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: Xue jiufei <xuejiufei@huawei.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Reviewed-by: Mark Fasheh <mfasheh@suse.de>
	--Mark

--
Mark Fasheh
