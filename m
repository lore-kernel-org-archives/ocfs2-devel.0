From: piaojun <piaojun@huawei.com>
Date: Sat, 13 Jan 2018 14:54:04 +0800
Subject: [Ocfs2-devel] Ocfs2-devel Digest, Vol 167, Issue 20
In-Reply-To: <71604351584F6A4EBAE558C676F37CA401071A4B80@H3CMLB12-EX.srv.huawei-3com.com>
References: <71604351584F6A4EBAE558C676F37CA401071A4B80@H3CMLB12-EX.srv.huawei-3com.com>
Message-ID: <5A59AD0C.4010509@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Guozhonghua,

It seems that deadlock could be reproduced easily, right? Sharing the
lock with VFS-layer probably is risky, and introducing a new lock for
"quota_recovery" sounds good. Could you post a patch to fix this
problem?

thanks,
Jun

On 2018/1/13 11:04, Guozhonghua wrote:
> 
>> Message: 1
>> Date: Fri, 12 Jan 2018 06:15:01 +0000
>> From: Shichangkuo <shi.changkuo@h3c.com>
>> Subject: Re: [Ocfs2-devel] [Ocfs2-dev] BUG: deadlock with umount and
>> 	ocfs2 workqueue triggered by ocfs2rec thread
>> To: Joseph Qi <jiangqi903@gmail.com>, "zren at suse.com" <zren@suse.com>,
>> 	"jack at suse.cz" <jack@suse.cz>
>> Cc: "ocfs2-devel at oss.oracle.com" <ocfs2-devel@oss.oracle.com>
>> Message-ID:
>> 	<D1E4D02760513D4B90DC3B40FF32AF35E22EC513@H3CMLB14-EX.srv.huawe
>> i-3com.com>
>>
>> Content-Type: text/plain; charset="gb2312"
>>
>> Hi Joseph
>>     Thanks for replying.
>>     Umount will flush the ocfs2 workqueue in function
>> ocfs2_truncate_log_shutdown and journal recovery is one work of ocfs2 wq.
>>
>> Thanks
>> Changkuo
>>
> 
> Umount 
>   mngput
>    cleanup_mnt 
>  	 deactivate_super:   down_write the rw_semaphore:  down_write(&s->s_umount)
> 	    deactivate_locked_super
>  		  kill_sb: kill_block_super
> 			generic_shutdown_super
> 				put_super : ocfs2_put_supe
> 					ocfs2_dismount_volume
> 						ocfs2_truncate_log_shutdown 
> 							flush_workqueue(osb->ocfs2_wq);
> 								ocfs2_finish_quota_recovery
> 									down_read(&sb->s_umount); 
> 									 Here retry down_read rw_semaphore; down read while holding write?  Try rw_semaphore twice, dead lock ?
> 	                                 The flush work queue of ocfs2_wq will be blocked, so as the umount ops.  
> 
> Thanks. 
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
