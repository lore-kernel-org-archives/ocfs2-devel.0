Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03945FA373D
	for <ocfs2-devel@archiver.kernel.org>; Tue,  1 Nov 2022 11:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=L4CrWfb6q+e2lCB6KO9KU1dd5rXsPI9UO1I06lAwm64=;
 b=m5be/z5p4Raq1/38Rql5kewCve118tObtZelnkDnUlWJYhWPH8p0kSCPQSqgYuU/LvhirSzZ2UV2
   OYlGd/MPI+c2Ln0pl9nUEt8/SYMzq5YXn39mb5qot/B6rvqDD2ZnL2Jugn+b2Kp4VPqnsBw10vSK
   /jPPd5TiIwZYL35/9pDp+TQhygAwBL566DyOBB8XZgtGbQDresT5lt3LKDmJ2jhH0bukXvbXc/nf
   E5UvC0kVoWV8etYxnjsUTUDlNjf4MBL8o1KTJCKate+sXJCKnvKNCx/U3XBal+uVuD1x0qp7wjhv
   rUdUj2muaobH9kAhZVUzahRy4dvS/wO9TMTF8w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=L4CrWfb6q+e2lCB6KO9KU1dd5rXsPI9UO1I06lAwm64=;
 b=rC/q3X2+TF6mrpWOImWXf/dDz5BNhLfwtkQ216vU811Bo9ddVvUoNm1TXji8xfpLyBKLHkrI2gCi
   pPLeLPnuzlsQUeCAZgdva+bcZEZgZl5EtxlGnKaGsbeoHvaYcDqpkHwZO0tNcV4vJiNIiCy4tl83
   BdhFtNZyHZ6+yB5Z7ZsZktSyFGuMYy0N9vV1HYvndf3Hpnj3eQvvUEwMgsby/w8SqksAkK3CYum5
   GgsVuzGGDqWuF7HvuXxpyWp7DaxxxFFwDJYf5V4f4Wrjt3/VJ8okZ6LqP0tuKL4RSFsrTjuAkC0l
   cg6OTWNl1eLFGl6jzJJHi+l1d02l/WiZ1JMs6Q==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221026 64bit (built Oct 26
 2022))
 with ESMTPS id <0RKO00PA11YJ8EC0@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 01 Nov 2022 11:15:55 +0000 (GMT)
Message-id: <41651ca1-432a-db34-eb97-d35744559de1@linux.alibaba.com>
Date: Tue, 1 Nov 2022 19:15:33 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.0
Content-language: en-US
To: Shang XiaoJing <shangxiaojing@huawei.com>, akpm <akpm@linux-foundation.org>
References: <20221101064745.23738-1-shangxiaojing@huawei.com>
In-reply-to: <20221101064745.23738-1-shangxiaojing@huawei.com>
X-Source-IP: 115.124.30.42
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10517
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 impostorscore=0 bulkscore=0 spamscore=0 adultscore=0 suspectscore=0
 mlxlogscore=999 priorityscore=120 lowpriorityscore=0 clxscore=55 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211010086 domainage_hfrom=8601
Cc: ocfs2-devel <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: Fix memory leak in
	ocfs2_stack_glue_init()
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R201e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046060;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=5; SR=0;
 TI=SMTPD_---0VThZubP_1667301333;
X-ServerName: out30-42.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: cHapgQvwAtoXjQE9BP-UQJFSHpn36Lk6
X-Proofpoint-GUID: cHapgQvwAtoXjQE9BP-UQJFSHpn36Lk6
Reporting-Meta:
 AAHw5o2P2pTbb0UJ6gAhMUbZH0kgp3oRLv8DsGt9Wa5HzYk/ckdEy8JAvK8QrSok
 8LoCKhFcFoM7l+dlLmKJA1XUg5XOlpwWWriu7pkOKZwoMzKtRaVjhJK+WZmISkrJ
 NSp6AUxWRiqqqEhW/RgsEGxr0VBfnsUB3GnkJ/CDVKqpbDIc37WzCO1zGZnLv1bu
 wl5XvRSQRVk0i5EwpJXysbxmLqFI7mRXIlNGJm/E+rtCsicS5npKwzCYgv7WubPm
 KTW6jGxnKVpCrS7zkg1/vyW9eBKVxY8ifSE1ABXlciqoridLvcmt0wx2tI60oiEE
 Cb+6sa7J305EvkZyZyTKSkUIXcbSR3vXj+4XxlUVau7L5xBt6cCMN8pVGBjwWlEM
 HRZ7sA35SqEpCKeYnKEGBCgDWOxjg0d1XhxYZ6FxvQLuKlcmcuAdcS0i2/mgPdLf
 zf2KbtQHQAhK729i/IJkG1CzPfiXrK3o2QlCj3aGYs0Xo2ucvEvgq7T2G3xcDTvD
 FhMBLAnpSH+tOv2mrssH/1+TvSE7L1CdX9qmBiIzwl4=



On 11/1/22 2:47 PM, Shang XiaoJing wrote:
> ocfs2_table_header should be free in ocfs2_stack_glue_init() if
> ocfs2_sysfs_init() failed, otherwise kmemleak will report memleak.
> 
> BUG: memory leak
> unreferenced object 0xffff88810eeb5800 (size 128):
>   comm "modprobe", pid 4507, jiffies 4296182506 (age 55.888s)
>   hex dump (first 32 bytes):
>     c0 40 14 a0 ff ff ff ff 00 00 00 00 01 00 00 00  .@..............
>     01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<000000001e59e1cd>] __register_sysctl_table+0xca/0xef0
>     [<00000000c04f70f7>] 0xffffffffa0050037
>     [<000000001bd12912>] do_one_initcall+0xdb/0x480
>     [<0000000064f766c9>] do_init_module+0x1cf/0x680
>     [<000000002ba52db0>] load_module+0x6441/0x6f20
>     [<000000009772580d>] __do_sys_finit_module+0x12f/0x1c0
>     [<00000000380c1f22>] do_syscall_64+0x3f/0x90
>     [<000000004cf473bc>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> Fixes: 3878f110f71a ("ocfs2: Move the hb_ctl_path sysctl into the stack glue.")
> Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>

Looks good.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/stackglue.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
> index 317126261523..a8d5ca98fa57 100644
> --- a/fs/ocfs2/stackglue.c
> +++ b/fs/ocfs2/stackglue.c
> @@ -669,6 +669,8 @@ static struct ctl_table_header *ocfs2_table_header;
>  
>  static int __init ocfs2_stack_glue_init(void)
>  {
> +	int ret;
> +
>  	strcpy(cluster_stack_name, OCFS2_STACK_PLUGIN_O2CB);
>  
>  	ocfs2_table_header = register_sysctl("fs/ocfs2/nm", ocfs2_nm_table);
> @@ -678,7 +680,11 @@ static int __init ocfs2_stack_glue_init(void)
>  		return -ENOMEM; /* or something. */
>  	}
>  
> -	return ocfs2_sysfs_init();
> +	ret = ocfs2_sysfs_init();
> +	if (ret)
> +		unregister_sysctl_table(ocfs2_table_header);
> +
> +	return ret;
>  }
>  
>  static void __exit ocfs2_stack_glue_exit(void)

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
