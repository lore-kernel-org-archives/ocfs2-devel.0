Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 244B4C4332F
	for <ocfs2-devel@archiver.kernel.org>; Tue, 18 Oct 2022 09:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ek/ctiZ9Htj+Sa9dZbLaejpsn8yWvfiOi0XbG0cUWbw=;
 b=kjiqk39cHgbsGRsWjXcawUS4WDm6FpqdD+YYxT9sxOks+5VDg5SNvC5sRtjoeX3W04PSERbQeQIR
   J6lrO5xh0/mWfkfqn6sI7sbq430f32U05vA4SbEWsCu3JYIzrBdW0056enAv0rLZl7lsZiW3RmoF
   49kXWGqKjQHfS0/GkwsunRd/EZrRETFMZsUlErrTJc4u8SFvPHxs9bsKFFfbqYa+ly3cflwncvn8
   IYDuHDViwY6+YQShxpeTCOHVIGgNTtOPozy9RNuEmaeiAkmU5FMU1g9JFxn89of3WEBdbOqOO653
   ZdZWpSfuCtwfCEeii9rxHnYJqrsvPJlzrnupZw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ek/ctiZ9Htj+Sa9dZbLaejpsn8yWvfiOi0XbG0cUWbw=;
 b=selDjKTZLcy45csJvpbN+Nszoh7j6N/dzZSfE7eHulLXoQIV3nFzpf3fQJrBzvcrXKLqrsPXVUVN
   nZyuaUULFgLHYDVwkfX1o2OvpHsWpcrFMU5tHKIXSNDh76i683Eui+K7PX19i+hHmqoYpD9I2IUu
   wv9BkWDL//ZY6R697p5nXvyULVZyk7DSNfa1VWM8PLToGG+59wQSutYDZnmwHYpY8tTGIoodFlz6
   YiMEddvPNZEo1x22zEXAs4NFKMBhn1G8pTYxjdo+jQ0d9+UNabzUdXqbg2wCUkMPWPBEk0gljNS+
   pyp+wZPcKaO11iK7N+Q2aD9q/kbuJDKY2L3bHQ==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220914 64bit (built Sep 14
 2022))
 with ESMTPS id <0RJX00AF6YGXXZ60@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 18 Oct 2022 09:02:57 +0000 (GMT)
Message-id: <bf27f347-5ced-98e5-f188-659cc2a9736f@linux.alibaba.com>
Date: Tue, 18 Oct 2022 17:02:28 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.3
To: Yang Yingliang <yangyingliang@huawei.com>, linux-kernel@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
References: <20221018075213.736562-1-yangyingliang@huawei.com>
Content-language: en-US
In-reply-to: <20221018075213.736562-1-yangyingliang@huawei.com>
X-Source-IP: 115.124.30.133
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10503
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
 lowpriorityscore=0 clxscore=-23 impostorscore=0 priorityscore=1501
 phishscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210180051 domainage_hfrom=8587
Cc: gregkh@linuxfoundation.org
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: possible memory leak in
	mlog_sys_init()
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R481e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018045176;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=7; SR=0;
 TI=SMTPD_---0VSUDmyd_1666083748;
X-ServerName: out30-133.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: WB-a3XWm7YKnPPJS7lQyNs0ZhnqDmEA_
X-Proofpoint-ORIG-GUID: WB-a3XWm7YKnPPJS7lQyNs0ZhnqDmEA_
Reporting-Meta:
 AAHyTdQRWQqH/fJ3Mwq5Yd/8ofOlAPxfncBVS7hUOPxlkRZ+q+TRo6wtG9U/+OYW
 kcpH2kEQOM7ENxpeuBcgexiHNlMCMg7ctGTknxzREWbVpPWADDvx9cj1ZZm3/kc5
 7QpLwXRqhWSEIKb8RLPTQM/yMzfmme1EKEQQS3DwhrKMonxUSNALGTUnfAqTV274
 Olw4KN9DcFzjM5QmlfHPoUJ6kOrcK+6kBhuzNijfCODdizbbri9un+3feQiHyCk1
 7tWp6SlY3mMX68Fs0yIdaIPSTnZd4D5A2o8VhepQL209Wic1ksomY1oDVPRd4B7s
 pjxG+e2MnrvlUpb61PvVnZZTyxFjg7Gv19odqpILnWp0tvOz/tltVUWh+2S6kCW9
 5teQSJKh//8kRPN3QoZgKySkdERVN/NO2h3gX4vvFSvEPPRfHM2W3eDHVanElnnN
 ZuUSTecdPjFwDOTS5HG0oDcacJWYMGH3t4KdIk4rPjAfSXu+OTTg5xNCoh5WpLNO
 cs0kCVJaUxW+9N6eabSwp8t94knI5SuEClBkI8uwKCjK

Hi,

On 10/18/22 3:52 PM, Yang Yingliang wrote:
> Inject fault while probing module, kset_register() may fail,
> if it fails, but the refcount of kobject is not decreased to
> 0, the name allocated in kobject_set_name() is leaked. Fix
> this by calling kset_put(), so that name can be freed in
> callback function kobject_cleanup().
> 
> unreferenced object 0xffff888100da9348 (size 8):
>   comm "modprobe", pid 257, jiffies 4294701096 (age 33.334s)
>   hex dump (first 8 bytes):
>     6c 6f 67 6d 61 73 6b 00                          logmask.
>   backtrace:
>     [<00000000306e441c>] __kmalloc_node_track_caller+0x44/0x1b0
>     [<000000007c491a9e>] kstrdup+0x3a/0x70
>     [<0000000015719a3b>] kstrdup_const+0x63/0x80
>     [<0000000084e458ea>] kvasprintf_const+0x149/0x180
>     [<0000000091302b42>] kobject_set_name_vargs+0x56/0x150
>     [<000000005f48eeac>] kobject_set_name+0xab/0xe0
> 
> Fixes: 34980ca8faeb ("Drivers: clean up direct setting of the name of a kset")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  fs/ocfs2/cluster/masklog.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/cluster/masklog.c b/fs/ocfs2/cluster/masklog.c
> index 563881ddbf00..7f9ba816d955 100644
> --- a/fs/ocfs2/cluster/masklog.c
> +++ b/fs/ocfs2/cluster/masklog.c
> @@ -156,6 +156,7 @@ static struct kset mlog_kset = {
>  int mlog_sys_init(struct kset *o2cb_kset)
>  {
>  	int i = 0;
> +	int ret;
>  
>  	while (mlog_attrs[i].attr.mode) {
>  		mlog_default_attrs[i] = &mlog_attrs[i].attr;
> @@ -165,7 +166,11 @@ int mlog_sys_init(struct kset *o2cb_kset)
>  
>  	kobject_set_name(&mlog_kset.kobj, "logmask");
>  	mlog_kset.kobj.kset = o2cb_kset;
> -	return kset_register(&mlog_kset);
> +	ret = kset_register(&mlog_kset);

If register fails, it will call unregister in o2cb_sys_init(), which
will put kobject.

Thanks,
Joseph

> +	if (ret)
> +		kset_put(&mlog_kset);
> +
> +	return ret;
>  }
>  
>  void mlog_sys_shutdown(void)

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
