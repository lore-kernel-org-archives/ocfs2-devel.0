From: Joseph Qi <joseph.qi@huawei.com>
Date: Fri, 25 Dec 2015 13:54:17 +0800
Subject: [Ocfs2-devel] Different idea about slot overwritten
In-Reply-To: <71604351584F6A4EBAE558C676F37CA48291BE8C@H3CMLB14-EX.srv.huawei-3com.com>
References: <71604351584F6A4EBAE558C676F37CA48291BE8C@H3CMLB14-EX.srv.huawei-3com.com>
Message-ID: <567CDA09.5000004@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Guozhonghua,
The case you described can not happen.
slot is protected by super lock, which has already refreshed slot info.

Thanks,
Joseph

On 2015/12/25 11:14, Guozhonghua wrote:
> Hi Jiang,
> 
>  
> 
> I think there is another scenario about slot overwritten issue.
> 
> There are three nodes in the ocfs2 cluster. Node 3 had mounted with slot 1.
> 
> Node 1 and node 2 execute mounting volume operation at the same time.
> 
>  
> 
>         N1                               N2
> 
>         mount ocfs2 volume               mount ocfs2 volume
> 
>         ocfs2_fill_super()                 ocfs2_fill_super()
> 
>           ocfs2_initialize_super            ocfs2_initialize_super
> 
>             ... ...                          ... ...
> 
>             ocfs2_init_slot_info(osb);       ocfs2_init_slot_info(osb);
> 
>       ocfs2_mount_volume               ocfs2_mount_volume
> 
>         ocfs2_super_lock                 ocfs2_super_lock
> 
>          Gotten the super lock             Waiting for the super lock
> 
>          Find slot 0 unused
> 
>          from memory
> 
>                 update the slot 0 with 1
> 
>                 ... ...
> 
>                  locked journal 0
> 
>         mount finished.
> 
>                                               Gotten super lock and
> 
>                                                                                   Also find slot 0 unused
> 
>                                                                                   from memory,
> 
>                                                                                   update the slot 0 with node num 2
> 
>                                                                                   But Journal 0 is locked by N1
> 
>                                                                                   Mounted hang up.
> 
>           ... ...                             ... ...
> 
>     umount volume                         ... ...
> 
>          cleare the slot 0                ... ...
> 
>                                           Gotten joural 0 lock
> 
>                                      mount finished.
> 
>                                                                          But here, the slot 0 is cleare by N1
> 
>                                                                        
> 
>         IF N1 mount again
> 
>         Same condition with N2
> 
>         and will hang up.
> 
>        
> 
> In the function of ocfs2_mount_volume, I think the slot info should be refreshed after ocfs2_super_lock called.
> 
> static int ocfs2_mount_volume(struct super_block *sb)
> 
> {
> 
>         status = ocfs2_super_lock(osb, 1);
> 
>         ......
> 
>        
> 
> +      status = ocfs2_refresh_slot_info(osb);
> 
> +      if (status < 0) {
> 
> +              mlog_errno(status);
> 
> +              goto leave;
> 
> +      }
> 
>         ... ...
> 
> }
> 
>  
> 
> Another way is to move ocfs2_init_slot_info() function from ocfs2_initialize_super to replace ocfs2_refresh_slot_info as above.
> 
>  
> 
>  
> 
> Message: 5
> 
> Date: Wed, 23 Dec 2015 18:23:36 +0800
> 
> From: jiangyiwen <jiangyiwen at huawei.com <mailto:jiangyiwen@huawei.com>>
> 
> Subject: [Ocfs2-devel] [PATCH] ocfs2: fix slot overwritten if storage
> 
>         link  down during mount
> 
> To: Andrew Morton <akpm at linux-foundation.org <mailto:akpm@linux-foundation.org>>
> 
> Cc: Mark Fasheh <mfasheh at suse.de <mailto:mfasheh@suse.de>>, ocfs2-devel at oss.oracle.com <mailto:ocfs2-devel@oss.oracle.com>
> 
> Message-ID: <567A7628.5040503 at huawei.com <mailto:567A7628.5040503@huawei.com>>
> 
> Content-Type: text/plain; charset="utf-8"
> 
>  
> 
> The following case will lead to slot overwritten.
> 
>  
> 
> N1                               N2
> 
> mount ocfs2 volume, find and
> 
> allocate slot 0, then set
> 
> osb->slot_num to 0, begin to
> 
> write slot info to disk
> 
>                                  mount ocfs2 volume, wait for super lock
> 
> write block fail because of
> 
> storage link down, unlock
> 
> super lock
> 
>                                  got super lock and also allocate slot 0
> 
>                                  then unlock super lock
> 
>  
> 
> mount fail and then dismount,
> 
> since osb->slot_num is 0, try to
> 
> put invalid slot to disk. And it
> 
> will succeed if storage link
> 
> restores.
> 
>                                  N2 slot info is now overwritten
> 
>  
> 
> -------------------------------------------------------------------------------------------------------------------------------------
> ????????????????????????????????????????
> ????????????????????????????????????????
> ????????????????????????????????????????
> ???
> This e-mail and its attachments contain confidential information from H3C, which is
> intended only for the person or entity whose address is listed above. Any use of the
> information contained herein in any way (including, but not limited to, total or partial
> disclosure, reproduction, or dissemination) by persons other than the intended
> recipient(s) is prohibited. If you receive this e-mail in error, please notify the sender
> by phone or email immediately and delete it!
