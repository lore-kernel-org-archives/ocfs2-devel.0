From: Joseph Qi <joseph.qi@huawei.com>
Date: Tue, 15 Mar 2016 10:32:19 +0800
Subject: [Ocfs2-devel] Could the master return DLM_NORMAL when unlock
 nonexistent locks from other node?
In-Reply-To: <D1E4D02760513D4B90DC3B40FF32AF355EE2304D@H3CMLB14-EX.srv.huawei-3com.com>
References: <D1E4D02760513D4B90DC3B40FF32AF355EE2304D@H3CMLB14-EX.srv.huawei-3com.com>
Message-ID: <56E77433.6000007@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Changkuo,
I don't agree with you.
The case you described is a real bug. From the description, I think it's
a race that leads Node B has already purged the lockres, while Node A
still thinks it is already there. So IMO, we have to figure out why can
it happen, but not treat it as normal.

Thanks,
Joseph

On 2016/3/15 9:55, Shichangkuo wrote:
> Hi all,
>     When NodeA want to unlock lock-res1, and it send message to NodeB, but in NodeB any lock queues (granted, converting, blocked) could not find this lock for some unknown reason, then NodeB reply DLM_IVLOCKID.
>     In this situation, NodeA bug. The detail is described as follows.
> 
>         NODEA                                              NODEB
> ocfs2_drop_lock
>     ocfs2_dlm_unlock
>         o2cb_dlm_unlock
>             dlmunlock
>                 dlmunlock_remote        ---->   send message to master
>                                                   dlm_unlock_lock_handler
>                                                       return DLM_IVLOCKID
>     BUG()
> 
> I think it's no nessary to let NodeA bug, it just like we removed an nonexistent file.
> Could NodeB return DLM_NORMAL?
> 
> Thanks
> Changkuo
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
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
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
