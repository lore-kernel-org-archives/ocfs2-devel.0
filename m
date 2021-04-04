Return-Path: <SRS0=Zidv=JB=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27CB0C433B4
	for <ocfs2-devel@archiver.kernel.org>; Sun,  4 Apr 2021 11:26:03 +0000 (UTC)
Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 81DDA61388
	for <ocfs2-devel@archiver.kernel.org>; Sun,  4 Apr 2021 11:26:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 81DDA61388
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
	by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 134BP6qh046446;
	Sun, 4 Apr 2021 11:26:01 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by aserp2130.oracle.com with ESMTP id 37q38mghmp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 04 Apr 2021 11:26:01 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 134BPjY9132471;
	Sun, 4 Apr 2021 11:26:00 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 37qa3g3a9b-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Sun, 04 Apr 2021 11:25:59 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lT0tC-0006xD-3e; Sun, 04 Apr 2021 04:25:58 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <joseph.qi@linux.alibaba.com>) id 1lT0sh-0006wI-Kb
	for ocfs2-devel@oss.oracle.com; Sun, 04 Apr 2021 04:25:27 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	134BOr8g016017
	for <ocfs2-devel@oss.oracle.com>; Sun, 4 Apr 2021 11:25:27 GMT
Received: from userp2030.oracle.com (userp2030.oracle.com [156.151.31.89])
	by userp3020.oracle.com with ESMTP id 37q2prvmfs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Sun, 04 Apr 2021 11:25:27 +0000
Received: from pps.filterd (userp2030.oracle.com [127.0.0.1])
	by userp2030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	134BPD4k022736
	for <ocfs2-devel@oss.oracle.com>; Sun, 4 Apr 2021 11:25:26 GMT
Received: from out30-56.freemail.mail.aliyun.com
	(out30-56.freemail.mail.aliyun.com [115.124.30.56])
	by userp2030.oracle.com with ESMTP id 37q3h1p2es-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Sun, 04 Apr 2021 11:25:26 +0000
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R101e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04395;
	MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=5; SR=0;
	TI=SMTPD_---0UUPEt.z_1617535520; 
Received: from B-D1K7ML85-0059.local(mailfrom:joseph.qi@linux.alibaba.com
	fp:SMTPD_---0UUPEt.z_1617535520) by smtp.aliyun-inc.com(127.0.0.1);
	Sun, 04 Apr 2021 19:25:21 +0800
To: Wengang Wang <wen.gang.wang@oracle.com>, ocfs2-devel@oss.oracle.com
References: <20210402171344.1605-1-wen.gang.wang@oracle.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <994870d6-5b0e-3a22-6180-9beb501a59b0@linux.alibaba.com>
Date: Sun, 4 Apr 2021 19:25:20 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210402171344.1605-1-wen.gang.wang@oracle.com>
Content-Language: en-US
X-PDR: PASS
X-Source-IP: 115.124.30.56
X-ServerName: out30-56.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
	include:spf2.service.alibaba.com
	include:spf1.ocm.aliyun.com  include:spf2.ocm.aliyun.com
	include:spf1.staff.mail.aliyun.com include:a.hichina.mail.aliyun.com
	include:b.hichina.mail.aliyun.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=208
	phishscore=0
	suspectscore=0 mlxscore=0 spamscore=0 priorityscore=0 impostorscore=0
	adultscore=0 bulkscore=0 lowpriorityscore=0 mlxlogscore=999
	malwarescore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104030000 definitions=main-2104040076
X-Spam: Clean
Cc: GHe@suse.com
Subject: Re: [Ocfs2-devel] [PATCH V2] ocfs2: fix deadlock between setattr
 and dio_end_io_write
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.9
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxscore=0 spamscore=0 phishscore=0 adultscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104030000 definitions=main-2104040077
X-Proofpoint-GUID: MFX2CsDw8F0hJB47P4uSDWcb94tXIEB9
X-Proofpoint-ORIG-GUID: MFX2CsDw8F0hJB47P4uSDWcb94tXIEB9
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1034 suspectscore=0
 impostorscore=0 malwarescore=0 priorityscore=1501 spamscore=0 mlxscore=0
 bulkscore=0 lowpriorityscore=0 adultscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104030000
 definitions=main-2104040076



On 4/3/21 1:13 AM, Wengang Wang wrote:
> The following deadlock is detected:
> 
> truncate -> setattr path is waiting for pending direct IO to be done (
> inode->i_dio_count become zero) with inode->i_rwsem held (down_write).
> 
> PID: 14827  TASK: ffff881686a9af80  CPU: 20  COMMAND: "ora_p005_hrltd9"
> #0 [ffffc9000bcf3c08] __schedule at ffffffff818667cc
> #1 [ffffc9000bcf3ca0] schedule at ffffffff81866de6
> #2 [ffffc9000bcf3cb8] inode_dio_wait at ffffffff812a2d04
> #3 [ffffc9000bcf3d28] ocfs2_setattr at ffffffffc05f322e [ocfs2]
> #4 [ffffc9000bcf3e18] notify_change at ffffffff812a5a09
> #5 [ffffc9000bcf3e60] do_truncate at ffffffff812808f5
> #6 [ffffc9000bcf3ed8] do_sys_ftruncate.constprop.18 at ffffffff81280cf2
> #7 [ffffc9000bcf3f18] sys_ftruncate at ffffffff81280d8e
> #8 [ffffc9000bcf3f28] do_syscall_64 at ffffffff81003949
> #9 [ffffc9000bcf3f50] entry_SYSCALL_64_after_hwframe at ffffffff81a001ad
> 
> dio completion path is going to complete one direct IO (decrement
> inode->i_dio_count), but before that it hang at locking inode->i_rwsem.
> 
>  #0 [ffffc90009b47b40] __schedule+700 at ffffffff818667cc
>  #1 [ffffc90009b47bd8] schedule+54 at ffffffff81866de6
>  #2 [ffffc90009b47bf0] rwsem_down_write_failed+536 at ffffffff8186aa28
>  #3 [ffffc90009b47c88] call_rwsem_down_write_failed+23 at ffffffff8185a1b7
>  #4 [ffffc90009b47cd0] down_write+45 at ffffffff81869c9d
>  #5 [ffffc90009b47ce8] ocfs2_dio_end_io_write+180 at ffffffffc05d5444 [ocfs2]
>  #6 [ffffc90009b47dd8] ocfs2_dio_end_io+85 at ffffffffc05d5a85 [ocfs2]
>  #7 [ffffc90009b47e18] dio_complete+140 at ffffffff812c873c
>  #8 [ffffc90009b47e50] dio_aio_complete_work+25 at ffffffff812c89f9
>  #9 [ffffc90009b47e60] process_one_work+361 at ffffffff810b1889
> #10 [ffffc90009b47ea8] worker_thread+77 at ffffffff810b233d
> #11 [ffffc90009b47f08] kthread+261 at ffffffff810b7fd5
> #12 [ffffc90009b47f50] ret_from_fork+62 at ffffffff81a0035e
> 
> Thus above forms ABBA deadlock. The same deadlock was mentioned in
> upstream commit 28f5a8a7c033cbf3e32277f4cc9c6afd74f05300. well, it seems
> that that commit just removed cluster lock (the victim of above dead
> lock) from the ABBA deadlock party.
> 
> End-user visible effects:
> Process hang in truncate -> ocfs2_setattr path and other processes hang at
> ocfs2_dio_end_io_write path.
> 
> This is to fix the deadlock its self. It removes inode_lock() call from dio
> completion path to remove the deadlock and add ip_alloc_sem lock in setattr
> path to synchronize the inode modifications.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> ---
> v1 -> v2: remove the "had_alloc_lock" as suggested.
> ---
>  fs/ocfs2/aops.c | 11 +----------
>  fs/ocfs2/file.c |  8 ++++++--
>  2 files changed, 7 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index 3bfb4147895a..ad20403b383f 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -2295,7 +2295,7 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
>  	struct ocfs2_alloc_context *meta_ac = NULL;
>  	handle_t *handle = NULL;
>  	loff_t end = offset + bytes;
> -	int ret = 0, credits = 0, locked = 0;
> +	int ret = 0, credits = 0;
>  
>  	ocfs2_init_dealloc_ctxt(&dealloc);
>  
> @@ -2306,13 +2306,6 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
>  	    !dwc->dw_orphaned)
>  		goto out;
>  
> -	/* ocfs2_file_write_iter will get i_mutex, so we need not lock if we
> -	 * are in that context. */
> -	if (dwc->dw_writer_pid != task_pid_nr(current)) {
> -		inode_lock(inode);
> -		locked = 1;
> -	}
> -
>  	ret = ocfs2_inode_lock(inode, &di_bh, 1);
>  	if (ret < 0) {
>  		mlog_errno(ret);
> @@ -2393,8 +2386,6 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
>  	if (meta_ac)
>  		ocfs2_free_alloc_context(meta_ac);
>  	ocfs2_run_deallocs(osb, &dealloc);
> -	if (locked)
> -		inode_unlock(inode);
>  	ocfs2_dio_free_write_ctx(inode, dwc);
>  
>  	return ret;
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 85979e2214b3..8880071ee4ee 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -1244,22 +1244,24 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
>  				goto bail_unlock;
>  			}
>  		}
> +		down_write(&OCFS2_I(inode)->ip_alloc_sem);
>  		handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS +
>  					   2 * ocfs2_quota_trans_credits(sb));
>  		if (IS_ERR(handle)) {
>  			status = PTR_ERR(handle);
>  			mlog_errno(status);
> -			goto bail_unlock;
> +			goto bail_unlock_alloc;
>  		}
>  		status = __dquot_transfer(inode, transfer_to);
>  		if (status < 0)
>  			goto bail_commit;
>  	} else {
> +		down_write(&OCFS2_I(inode)->ip_alloc_sem);

Why not do down_write() just before if clause?
Anyway, it also looks fine to me. So with or without that change,

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
