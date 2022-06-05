Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12860C433EF
	for <ocfs2-devel@archiver.kernel.org>; Sun,  5 Jun 2022 13:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=WT0zZWF9Dj65sPBYEzoR62hwJqxDpwuf0n8wUNtABaU=;
 b=eYZnXGy/LlRlHteViCHPQIihSC7Jwmzh3rlMF97naJv+qA26otbI+/twQxA6bW2zcSTnEW0NXU1i
   waKWn1bVrDLHl4390HUhzjV0Y+HxdtsycqtzceIGNl0Rb/n8c65pjeVnkIS6RWvglsvEVeZ2x8m0
   9rArX8uoHTVgBvHCbsviL0owaBE9I8jJEF/EDYpnsj+Huo1D/voS2KTgxfbUw76FtLAz6GvnIf/k
   KsE7UanpN6xjgfGTNKjuS7ajbquT8brBdgkXjL9ZFR+JouI+GAXf+rPus6EroXlcF/Hpx+D7JEFv
   OrF6vpv3yEwX6pY181+ZEmg1dJALe1IhuyTXJg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=WT0zZWF9Dj65sPBYEzoR62hwJqxDpwuf0n8wUNtABaU=;
 b=Y8Vqnj+93ALme+/xJN+FGmGYW9vRUaC6FCvxGs7CIMyRG6iORs9SgkTanm45XnRViAObZ3SuFOZK
   gr8NsizRWa0scWBroEBqpGPwJ3JIJy4apn05Ba8ralk1iWr+wq4VZP1KfhRd5oR08k0P50PYZV7R
   k++/PINAarHau/hDvyrIpNOaCKfhUg7G7VVDjypygs7nw5P3TDF1J1HqZ0Zmdeh06DasjiJ0/jTE
   3jjbAt5A59YvDrsLRqD8ph2su+Ev3N6pyG0YRWxynmzx9VH7lAZTLo5D5WCSYbr4Fyw1K2TDX9cr
   YfsAsKuOGBmtUIzo4qrWx1EjuA6LstDsqINq3Q==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD000DN1BLLTU10@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 05 Jun 2022 13:46:33 +0000 (GMT)
Message-id: <ba010e81-5ac8-79f5-61c0-5aac46068388@linux.alibaba.com>
Date: Sun, 5 Jun 2022 21:46:12 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Content-language: en-US
To: Junxiao Bi <junxiao.bi@oracle.com>, ocfs2-devel@oss.oracle.com
References: <20220603223122.43174-1-junxiao.bi@oracle.com>
In-reply-to: <20220603223122.43174-1-junxiao.bi@oracle.com>
X-Source-IP: 115.124.30.54
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10369
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 clxscore=176 malwarescore=0 mlxlogscore=999 priorityscore=48 suspectscore=0
 lowpriorityscore=0 bulkscore=0 impostorscore=0 spamscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206050063 domainage_hfrom=8452
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: kill EBUSY from dlmfs_evict_inode
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R111e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046060;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=2; SR=0;
 TI=SMTPD_---0VFNAVRV_1654436772;
X-ServerName: out30-54.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: D9LSF0DUYA018wr7q8zH0wTN09iaCan3
X-Proofpoint-GUID: D9LSF0DUYA018wr7q8zH0wTN09iaCan3
Reporting-Meta:
 AAE1DpkkvDZ1rtqr8YmQDzQr3CJJ1Ti/D7E893UbjcJVUulCsE2yaOE7cR8K8K3o
 VRWZUv9zfFuuWvV2y7Fv9G1BlQD3c7v8SdI/dG2X415w7ukmi/yNmiUY3VBtMZAk
 1qcisfORqU+z9GjHkuNJ2rg2vnHFIB8lsRS5RUZJ7FRbqKf+VnUEyGh1a+xrCJQh
 gOW4XIespDvfGxWucQq1sOOdwm7u7GiJYqHmmw2I0OoNBG1BEZpsKzskG1h7T1Qd
 hzuNZWqv2mdJUIUPoaW7opkc+ibA0t0BdPczDQAjN8kSkC2G0jpHglNYcocl5fY4
 OI5dr70Y/htWylZXtAES1k1sKpxmFmHkiyL5TGrwc4MBClFb7aeQsisv8Z1dsTH4
 y40Xu1sB0ocXc23IWpuSu8G0jDiNJ1hLxLLM12qyyCQLaHnmm8Ei29K5ONyBu9bV
 PhZpeggvy6GTkGOSErQ+kYy6SDrsdBOkEwJjIW98Su7P7fMByRJUSCqKnVjmn6mS
 EgnIWeJqpTA//nlrAmz4FH1WjgRGpnpG92MxShg23m0=



On 6/4/22 6:31 AM, Junxiao Bi wrote:
> When unlink a dlmfs, first it will invoke dlmfs_unlink(), and then invoke
> dlmfs_evict_inode(), user_dlm_destroy_lock() is invoked in both places,
> the second one from dlmfs_evict_inode() will get EBUSY error because
> USER_LOCK_IN_TEARDOWN is already set in lockres. This doesn't affect
> any function, just the error log is anonying.

s/anonying/annoying
> 
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> ---
>  fs/ocfs2/dlmfs/dlmfs.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
> index e360543ad7e7..a120610dff7e 100644
> --- a/fs/ocfs2/dlmfs/dlmfs.c
> +++ b/fs/ocfs2/dlmfs/dlmfs.c
> @@ -296,17 +296,25 @@ static void dlmfs_evict_inode(struct inode *inode)
>  {
>  	int status;
>  	struct dlmfs_inode_private *ip;
> +	struct user_lock_res *lockres;
> +	int destroyed;
>  
>  	clear_inode(inode);
>  
>  	mlog(0, "inode %lu\n", inode->i_ino);
>  
>  	ip = DLMFS_I(inode);
> +	lockres = &ip->ip_lockres;
>  
>  	if (S_ISREG(inode->i_mode)) {
> -		status = user_dlm_destroy_lock(&ip->ip_lockres);
> -		if (status < 0)
> -			mlog_errno(status);
> +		spin_lock(&lockres->l_lock);
> +		destroyed = !!(lockres->l_flags & USER_LOCK_IN_TEARDOWN);
> +		spin_unlock(&lockres->l_lock);
> +		if (!destroyed) {
> +			status = user_dlm_destroy_lock(lockres);
> +			if (status < 0)
> +				mlog_errno(status);
> +		}
>  		iput(ip->ip_parent);
>  		goto clear_fields;
>  	}

As you describes, it firstly invokes unlink and then evict, but strictly
speaking, flag USER_LOCK_IN_TEARDOWN doesn't mean 'destroyed', it could
be destroying, destroyed, or even unattached.

So how about just checking the flag like other places?
Something like:

	/* Don't destroy lockres twice */
	spin_lock(&lockres->l_lock);
	(lockres->l_flags & USER_LOCK_IN_TEARDOWN) {
		spin_unlock(&lockres->l_lock);
		goto skip;
	}
	spin_unlock(&lockres->l_lock);
	status = user_dlm_destroy_lock(lockres);
	...
skip:
	iput(ip->ip_parent);
	...

Thanks,
Joseph

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
