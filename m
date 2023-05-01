Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1E90C77B60
	for <ocfs2-devel@archiver.kernel.org>; Mon,  1 May 2023 02:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=NbZ5ijraOiRKw33wNrXzLW7D4tsyi80RCh8igsFuWeA=;
 b=C8TpfXuyO8vaI1sNrT/qw+/lyLPEHukay0PIJuwnMNmHdIbMPxghJkeoMYMCgNWgqpkY9yaXrGZ7
   DOyM4AkrQUtD6vsY6HpHg8Jk6h/52W4dd4elMnGloJXtsbU6iLxCH+SRVcopeT04lqJXsoygscTA
   c7uENJEfu/CZSGVUQv7qiudlJi27Uss6i/FiHYpR+AJeQh/EGyWdnUXgsqej4CasjfVfcZlix5Mj
   P5BcYnFIHCZ322BEzY+ThZ1cfvRMDFjG0FDxkF97Xjc8PBrsifqUo8WqN+DfMNRdLs/Onc3ceQkt
   +IbGlNjMqoybCncLrJoSLLLBYdXLGu/lVQW9Lg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=NbZ5ijraOiRKw33wNrXzLW7D4tsyi80RCh8igsFuWeA=;
 b=D1yjCVW/ckp4GJdDAGnVouhkAStjYS2Q5umtlNJUfedICeZgfOKEjsCxerCUBviIRvvgjfsoFmJX
   5JA402elzwgc1zLsQiFK18CULaZ50rkBejrMUNTNz52dOWo+TnqZ7OJ1f6qzypKu7navYgswfwUy
   BjtA8ntXBaPGasE1+NlaXQHl5D1zk9JqkfUs2dmuhUyCMEQr0X1PuaCluDQbQNvqa1LMuz+/ux5u
   XikR00UT+4Rj5HDUFmR4qIUbd45aZ1BjWz96oHPWO2IkvlWS8//NpfTQQ9yRjG7LQPCIOXIGP7EH
   duAUr4xYrkKtQEgLKHq5dtg9YB0X+jc80FI7sw==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230420 64bit (built Apr 20
 2023))
 with ESMTPS id <0RTY00E0JJ959040@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 01 May 2023 02:07:53 +0000 (GMT)
Message-id: <b2942f09-9797-220f-db72-3b49b0859277@linux.alibaba.com>
Date: Mon, 1 May 2023 10:07:34 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
To: Heming Zhao <heming.zhao@suse.com>
References: <20230430031302.15597-1-heming.zhao@suse.com>
Content-language: en-US
In-reply-to: <20230430031302.15597-1-heming.zhao@suse.com>
X-Source-IP: 115.124.30.97
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10696
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 spamscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999
 phishscore=0 clxscore=62 impostorscore=0 bulkscore=0 priorityscore=0
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305010015 domainage_hfrom=8782
Cc: ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 1/2] ocfs2: fix missing reset j_num_trans	for
 sync
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.15
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/options/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel/>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
From: Joseph Qi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Joseph Qi <joseph.qi@linux.alibaba.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R351e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046059;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=2; SR=0;
 TI=SMTPD_---0VhJ0oz._1682906854;
X-ServerName: out30-97.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: 5KMaK8sqnbxvvxSP3Qz9R9fgBQoyFTzQ
X-Proofpoint-ORIG-GUID: 5KMaK8sqnbxvvxSP3Qz9R9fgBQoyFTzQ
Reporting-Meta:
 AAHtxFCqx2DP3sBkOse7NRIpNtDtbqKvunTbY3VBvywzlKICH0zUTD9hzbR00zNc
 59bQJZFDL81VZQHWXlRZm8vB2gHiLba+fVZ4ILM0szfq5Tx2qKWD22bg8L9h96F7
 Zy9OXajWYMPP/2flg6P0+eMykhfXGZobxU6eK8OdV8EGbDd/sFO3WlZZl9cHU9mg
 HaHZiCTkc1UWcRrq46KXCbYPzRbI25VKvG8xMcdL8Ux6Dko0aLjs4oM2gyqlOCj4
 E5eG8rbGBquIxiogSfK2rEJfzGLfNFZ8pY9voKhjWxcdTkyV8EMShRjOjvALnwgc
 e1qD692e7cyQ/YR6iX9U8dJZyvitYsDWRzU1/zaoNPeMPbykJ3v5vgb17c3fYJdY
 NE8g2Zqc3RUf1K0d9q/sw8Dv0yVIkUSiOdZqyZGlBW9ONwdLyZkwwlCxKqwN72p3
 ZUI7a+iSBXPyNy3HIQhgPzROdv62XIETptQSQ0Ai4Mw3HzdD0byUfzynXxkx2zGX
 IBdMlX/IE3RScg2n3jATlBoMStWS5SthIu1jPZcAT3ws

Hi,

What's the journal status in this case?
I wonder why commit thread is not working, which should flush journal
and reset j_num_trans during commit cache.

Thanks,
Joseph

On 4/30/23 11:13 AM, Heming Zhao wrote:
> fstest generic cases 266 272 281 trigger hanging issue when umount.
> 
> I use 266 to describe the root cause.
> 
> ```
>  49 _dmerror_unmount
>  50 _dmerror_mount
>  51
>  52 echo "Compare files"
>  53 md5sum $testdir/file1 | _filter_scratch
>  54 md5sum $testdir/file2 | _filter_scratch
>  55
>  56 echo "CoW and unmount"
>  57 sync
>  58 _dmerror_load_error_table
>  59 urk=$($XFS_IO_PROG -f -c "pwrite -S 0x63 -b $bufsize 0 $filesize" \
>  60     -c "fdatasync" $testdir/file2 2>&1)
>  61 echo $urk >> $seqres.full
>  62 echo "$urk" | grep -q "error" || _fail "pwrite did not fail"
>  63
>  64 echo "Clean up the mess"
>  65 _dmerror_unmount
> ```
> 
> After line 49 50 umount & mount ocfs2 dev, this case run md5sum to
> verify target file. Line 57 run 'sync' before line 58 changes the dm
> target from dm-linear to dm-error. This case is hanging at line 65.
> 
> The md5sum calls jbd2 trans pair: ocfs2_[start|commit]_trans to
> do journal job. But there is only ->j_num_trans+1 in ocfs2_start_trans,
> the ocfs2_commit_trans doesn't do reduction operation, 'sync' neither.
> finally no function reset ->j_num_trans until umount is triggered.
> 
> call flow:
> ```
> [md5sum] //line 53 54
>  vfs_read
>   ocfs2_file_read_iter
>    ocfs2_inode_lock_atime
>     ocfs2_update_inode_atime
>      + ocfs2_start_trans //atomic_inc j_num_trans
>      + ...
>      + ocfs2_commit_trans//no modify j_num_trans
> 
> sync //line 57. no modify j_num_trans
> 
> _dmerror_load_error_table //all write will return error after this line
> 
> _dmerror_unmount //found j_num_trans is not zero, run commit thread
>                //but the underlying dev is dm-error, journaling IO
>                //failed all the time and keep going to retry.
> ```
> 
> *** How to fix ***
> 
> kick commit thread in sync path, which can reset j_num_trans to 0.
> 
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> ---
>  fs/ocfs2/super.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index 0b0e6a132101..bb3fa21e9b47 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -412,6 +412,9 @@ static int ocfs2_sync_fs(struct super_block *sb, int wait)
>  			jbd2_log_wait_commit(osb->journal->j_journal,
>  					     target);
>  	}
> +	/* kick commit thread to reset journal->j_num_trans */
> +	if (atomic_read(&(osb->journal->j_num_trans)))
> +		wake_up(&osb->checkpoint_event);
>  	return 0;
>  }
>  

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
