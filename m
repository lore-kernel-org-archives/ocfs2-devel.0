Return-Path: <SRS0=itZy=NC=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	HTML_MESSAGE,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 380B2C4338F
	for <ocfs2-devel@archiver.kernel.org>; Wed, 11 Aug 2021 05:02:48 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D1D0960F13
	for <ocfs2-devel@archiver.kernel.org>; Wed, 11 Aug 2021 05:02:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D1D0960F13
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17B4tidg024742;
	Wed, 11 Aug 2021 05:02:47 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3abwqgs2h7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Aug 2021 05:02:46 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17B4uBRm167585;
	Wed, 11 Aug 2021 05:02:45 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3abjw5ncnj-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Wed, 11 Aug 2021 05:02:45 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mDgO2-0006aN-Tm; Tue, 10 Aug 2021 22:02:42 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <islituo@gmail.com>) id 1mA6go-0004lG-Mk
	for ocfs2-devel@oss.oracle.com; Sun, 01 Aug 2021 01:19:18 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1718FkLU165890
	for <ocfs2-devel@oss.oracle.com>; Sun, 1 Aug 2021 08:19:18 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by aserp3020.oracle.com with ESMTP id 3a4xb382aq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Sun, 01 Aug 2021 08:19:18 +0000
Received: from pps.filterd (m0246574.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	1718JHnm030740
	for <ocfs2-devel@oss.oracle.com>; Sun, 1 Aug 2021 08:19:17 GMT
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com
	[209.85.216.50])
	by mx0b-00069f01.pphosted.com with ESMTP id 3a4x3596ac-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Sun, 01 Aug 2021 08:19:17 +0000
Received: by mail-pj1-f50.google.com with SMTP id
	k4-20020a17090a5144b02901731c776526so27140177pjm.4
	for <ocfs2-devel@oss.oracle.com>; Sun, 01 Aug 2021 01:19:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language;
	bh=jHVr5WNtK9UraF8nr137mQmwTb+BQ7wOgLReODSESQU=;
	b=uXkBzeOu5XzK8TSW90zvqaWmxkxs2VJZ9zYTONol+vgVSJiAp0ev3U8oNQWz8OkTq9
	rxjtoQ2HWz6d+xZA+SbUhpqjgMQmhHqrge3RHXRjvsBrHuhF7WJBNXkn70yvdxg0Yfr5
	mIT6+zipLPy/reE3DwzGJHA5He7qWlP7+jtiewNbx1OIgytZE3r93mrj2JNMvhNQDSED
	cQrf3BRwtPn2a2uql/4BOkb8HQ8Ro/AidjftfxvUrDEbeeyJvq9r34Z9UKi/LOHLQACo
	IrvYH7RASMrLlK4uwvIYFG1BiTixfaBDGChLIq+1IiTHkIbfW7TPmtj3G7Stg2JxYRvO
	9hEg==
X-Gm-Message-State: AOAM531YT0tP7Dz0N5Q5CdBLs2Mt9C4jmPY5m82oBhBJ8zqtU5t23In6
	mq9TRapKP1xue0E6Sn1uwTw=
X-Google-Smtp-Source: ABdhPJw/1PKiOlropSVp4vDFEaUZM8evShUeMnWMdkRPnR8BH2yecuHNF6XNT7RrH/9dhr1iPI3iCA==
X-Received: by 2002:a17:90b:1c8e:: with SMTP id
	oo14mr11884892pjb.108.1627805956262; 
	Sun, 01 Aug 2021 01:19:16 -0700 (PDT)
Received: from [10.106.0.30] ([45.135.186.29])
	by smtp.gmail.com with ESMTPSA id y5sm7782074pfn.87.2021.08.01.01.19.13
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Sun, 01 Aug 2021 01:19:15 -0700 (PDT)
To: Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210731075659.73505-1-islituo@gmail.com>
	<607936a1-a21d-7d2f-7a89-2abeb4c5b1d4@linux.alibaba.com>
From: Li Tuo <islituo@gmail.com>
Message-ID: <8ebbfdde-25b8-064e-9307-75ac368b0815@gmail.com>
Date: Sun, 1 Aug 2021 16:19:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
	Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <607936a1-a21d-7d2f-7a89-2abeb4c5b1d4@linux.alibaba.com>
Content-Language: en-US
X-Source-IP: 209.85.216.50
X-ServerName: mail-pj1-f50.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 redirect=_spf.google.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10062
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxlogscore=999
	spamscore=0
	suspectscore=0 bulkscore=0 lowpriorityscore=0 malwarescore=0
	priorityscore=316 phishscore=0 clxscore=361 adultscore=0 mlxscore=0
	impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108010061
	domainage_hfrom=9485
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10062
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
	phishscore=0 malwarescore=0
	bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108010061
X-Mailman-Approved-At: Tue, 10 Aug 2021 22:02:40 -0700
Cc: linux-kernel@vger.kernel.org, baijiaju1990@gmail.com,
        TOTE Robot <oslab@tsinghua.edu.cn>, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: quota_local: fix possible
 uninitialized-variable access in ocfs2_local_read_info()
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
Content-Type: multipart/mixed; boundary="===============9152585781082824776=="
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10072 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 bulkscore=0 suspectscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108110030
X-Proofpoint-ORIG-GUID: B22kL4iiMEM_I06ILhZp9Q9WclYpXSzh
X-Proofpoint-GUID: B22kL4iiMEM_I06ILhZp9Q9WclYpXSzh

This is a multi-part message in MIME format.
--===============9152585781082824776==
Content-Type: multipart/alternative;
	boundary="------------31EE5300D36FD931FAD7A018"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------31EE5300D36FD931FAD7A018
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Thanks for your feedback. We will prepare a V2 patch according to your advice.

Best wishes,
Tuo Li

On 2021/7/31 21:57, Joseph Qi wrote:
> Thanks for the efforts.
> For the issue you mentioned, I'd like just initialized
> oinfo->dqi_gqinode as NULL before calling ocfs2_global_read_info().
> But it seems still have other issues here such as dqi_gqlock.
> We need take care all those initialized in ocfs2_global_read_info()
> carefully.
>
> Thanks,
> Joseph
>
> On 7/31/21 3:56 PM, Tuo Li wrote:
>> A memory block is allocated through kmalloc(), and its return value is
>> assigned to the pointer oinfo. If the return value of
>> ocfs2_global_read_info() at line 709 is less than zero,
>> oinfo->dqi_gqinode may be not initialized. However, it is accessed at
>> line 775:
>>    iput(oinfo->dqi_gqinode);
>>
>> To fix this possible uninitialized-variable access, replace kmalloc()
>> with kzalloc() when allocating memory for oinfo.
>>
>> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
>> Signed-off-by: Tuo Li <islituo@gmail.com>
>> ---
>>   fs/ocfs2/quota_local.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
>> index b1a8b046f4c2..4c1219e08b49 100644
>> --- a/fs/ocfs2/quota_local.c
>> +++ b/fs/ocfs2/quota_local.c
>> @@ -693,7 +693,7 @@ static int ocfs2_local_read_info(struct super_block *sb, int type)
>>   
>>   	info->dqi_max_spc_limit = 0x7fffffffffffffffLL;
>>   	info->dqi_max_ino_limit = 0x7fffffffffffffffLL;
>> -	oinfo = kmalloc(sizeof(struct ocfs2_mem_dqinfo), GFP_NOFS);
>> +	oinfo = kzalloc(sizeof(struct ocfs2_mem_dqinfo), GFP_NOFS);
>>   	if (!oinfo) {
>>   		mlog(ML_ERROR, "failed to allocate memory for ocfs2 quota"
>>   			       " info.");
>>


--------------31EE5300D36FD931FAD7A018
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: 7bit

<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <pre>Thanks for your feedback. We will prepare a V2 patch according to your advice.

Best wishes,
Tuo Li 

</pre>
    <div class="moz-cite-prefix">On 2021/7/31 21:57, Joseph Qi wrote:<br>
    </div>
    <blockquote type="cite"
      cite="mid:607936a1-a21d-7d2f-7a89-2abeb4c5b1d4@linux.alibaba.com">
      <pre class="moz-quote-pre" wrap="">Thanks for the efforts.
For the issue you mentioned, I'd like just initialized
oinfo-&gt;dqi_gqinode as NULL before calling ocfs2_global_read_info().
But it seems still have other issues here such as dqi_gqlock.
We need take care all those initialized in ocfs2_global_read_info()
carefully.

Thanks,
Joseph

On 7/31/21 3:56 PM, Tuo Li wrote:
</pre>
      <blockquote type="cite">
        <pre class="moz-quote-pre" wrap="">A memory block is allocated through kmalloc(), and its return value is
assigned to the pointer oinfo. If the return value of
ocfs2_global_read_info() at line 709 is less than zero,
oinfo-&gt;dqi_gqinode may be not initialized. However, it is accessed at
line 775:
  iput(oinfo-&gt;dqi_gqinode);

To fix this possible uninitialized-variable access, replace kmalloc()
with kzalloc() when allocating memory for oinfo.

Reported-by: TOTE Robot <a class="moz-txt-link-rfc2396E" href="mailto:oslab@tsinghua.edu.cn">&lt;oslab@tsinghua.edu.cn&gt;</a>
Signed-off-by: Tuo Li <a class="moz-txt-link-rfc2396E" href="mailto:islituo@gmail.com">&lt;islituo@gmail.com&gt;</a>
---
 fs/ocfs2/quota_local.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index b1a8b046f4c2..4c1219e08b49 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -693,7 +693,7 @@ static int ocfs2_local_read_info(struct super_block *sb, int type)
 
 	info-&gt;dqi_max_spc_limit = 0x7fffffffffffffffLL;
 	info-&gt;dqi_max_ino_limit = 0x7fffffffffffffffLL;
-	oinfo = kmalloc(sizeof(struct ocfs2_mem_dqinfo), GFP_NOFS);
+	oinfo = kzalloc(sizeof(struct ocfs2_mem_dqinfo), GFP_NOFS);
 	if (!oinfo) {
 		mlog(ML_ERROR, "failed to allocate memory for ocfs2 quota"
 			       " info.");

</pre>
      </blockquote>
    </blockquote>
    <br>
  </body>
</html>

--------------31EE5300D36FD931FAD7A018--


--===============9152585781082824776==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
--===============9152585781082824776==--

