From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Tue, 21 Sep 2010 14:20:33 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: allocate lvb for
 dlm_lock_resource which needs it -drop2
In-Reply-To: <201009200551.o8K5p2oB017578@acsinet15.oracle.com>
References: <201009200551.o8K5p2oB017578@acsinet15.oracle.com>
Message-ID: <20100921062033.GA4128@laptop.jp.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I am taking back this patch.
I would like to add something about lvb updating to it and send it out soon.

regards,
wengang.
On 10-09-20 13:48, Wengang Wang wrote:
> Changes to drop1:
> 1) adds unsigned reserve_lvb:1 to dlm_lock_resource indicating lvb should be
> reserved or not. This flag doesn't make sense to this patch its self, but it
> helps the coming patch that allocates lvb for dlm_lock which needs it. The 1
> bit flag doesn't take extra memory space, so putting it here is fine.
> 
> 2) adds a new parameter to dlm_new_lockres() indicating if lvb memory should be
> reserved. Determining method by checking name in v1 is discarded.
> 
> 3) adds u8 reserve_lvb:1 to dlm_migratable_lockres indicating if the migration
> target should reserve lvb for the dlm_lock_resouce in case of needing to create
> a new dlm_lock_resouce.
> 
> 4) increment dlm_protocol major version because of 3).
> 
> trivial changes:
> 1) moves the real allocation from dlm_init_lockres() to dlm_new_lockres().
> since we have the new-added parameter, we know if we should do the allocation
> in dlm_new_lockres(). And it's better we do allocations at the same space.
> 
> 2) adds DLM_LKF_VALBLK to dlm_flags in ocfs2_lock_create.
> We are missing the flag. But since it's adding a new lockres(no race), so no
> problem running current codes.
> 
> 3) adds some asserts on res->lvb.
> 
