Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95C52C77B61
	for <ocfs2-devel@archiver.kernel.org>; Wed, 22 Mar 2023 17:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=CWME7o6IP0CCO240NCafFAeQFpXYDwSdqVGTrF7FhyA=;
 b=gdstAlmiNAs19WqbwaPLC574H7agiWd1MnjbktuJleTJtpxcxOVNC1+sucp7YVIQWHxfcnqH38ZC
   8PBjQlF+jg5Aojw2dY9kDW9MUV8r0o27H9SqZokQLrqdFK+w1e7Rmx0X8oRnRuMSYrkX/GgtUAny
   i/7mRwWIRl6HaOVx6L9S6IpQWwZQse9yclHIMrtsXDS7XvzDGDpoxk3VA8M9GYF7wiazjfMVngqo
   OtBBfhUc7ojSc2WwgTvVKuqMrwxx8+88FYusTYEd4jY2zgzdWypaoGOdMHFP8U/fCuFN/+O3TX8s
   n55/dJkvDlaOeWPuUVNJhzEOzJDCr4mribWr9Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=CWME7o6IP0CCO240NCafFAeQFpXYDwSdqVGTrF7FhyA=;
 b=utWFawaLcAieYxhw4Dyo8DqQ5VNR3ekzfGM8xqGq4duvmJQdrsOTtClYNbrdHcLKxYzOovYAIw0G
   Qmsyebl4ZwQKgAwDoGIzh5u/MGCJ5RSkG1XG4giMq92owY1Hm/GeL0Nn8Vckmb+PftyC0MDOYgoW
   O5jj0R3cy0cKY6GMZDoO/HPbVcZumaEnIq52LpVpvQGfJfBSf1gIXQb/pgjUlQNVtJD75emZ5wQ2
   +9MkeVYQ7iHpkn0NsyoNdan0zU/pI+ICi6lVulfLTj0gV5cHlBXeyeeiucxOmJq/x9l9lPEOXP2M
   1FZW+DHVe3UOMHtgY8tGjlmAixj+HH5S6V19vA==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRX007AUM1D6C50@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 22 Mar 2023 17:03:13 +0000 (GMT)
Message-id: <bbd8c221-d4d2-8bbf-944f-2f33ed80f02f@linux.alibaba.com>
Date: Fri, 10 Mar 2023 14:20:53 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
To: Yangtao Li <frank.li@vivo.com>, xiang@kernel.org, chao@kernel.org,
 huyue2@coolpad.com, jefflexu@linux.alibaba.com, tytso@mit.edu,
 adilger.kernel@dilger.ca, rpeterso@redhat.com, agruenba@redhat.com,
 mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 viro@zeniv.linux.org.uk, brauner@kernel.org
References: <e8054874-88d8-e539-8fd4-6123821aa3a8@linux.alibaba.com>
 <20230310061549.11254-1-frank.li@vivo.com>
In-reply-to: <20230310061549.11254-1-frank.li@vivo.com>
X-Source-IP: 115.124.30.113
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10644
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 mlxscore=0 clxscore=67 mlxlogscore=677 suspectscore=0 spamscore=0
 malwarescore=0 adultscore=0 impostorscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=48 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303100049 domainage_hfrom=8730
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v4 2/5] erofs: convert to use i_blockmask()
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
From: Gao Xiang via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Gao Xiang <hsiangkao@linux.alibaba.com>
Content-transfer-encoding: 7bit
Content-type: text/plain; charset="us-ascii"; Format="flowed"
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R691e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018045192;
 MF=hsiangkao@linux.alibaba.com; NM=1; PH=DS; RN=20; SR=0;
 TI=SMTPD_---0VdWCdER_1678429253;
X-ServerName: out30-113.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: MTdAt9EdDzgT16CYGN424ALuvBwYd5Pp
X-Proofpoint-GUID: MTdAt9EdDzgT16CYGN424ALuvBwYd5Pp
X-Mailman-Approved-At: Wed, 22 Mar 2023 17:03:04 +0000
Reporting-Meta:
 AAEjyIuM3P9ITye4kkUPtf5wNbwXGYRAWGIwGs97GuqHNK7Dm0p9J953nv46W1Cm
 vt+fgQO2kgqXatRd8zOKGLOSZicjPy9B5CehF2MKA7v+mqFNRoZNfHEB9GYAt+W7
 u6P6vq4m5mURN8fixjz6zD8OF4Ba6tTNuf14BFPYRY8f61Zy3Ig1elvPrXbptzma
 kSeNJEh+K7fA9/fIWxhwTN6Rq5XbbxR+Afu6vhDeaGlgook0YJZqEvECCcKNSCQO
 s9F1zjeFkK0UCwc/E0/6P7z9ztq453GilT7s//E+VQWU894hN4CdhMa9mbJvXYQj
 ZRKqCfRohfv3pXEw1WQYCVUxvWlRw6j1q7oK6q/dj7pJhuAGUojuy6Q6guNChNqH
 ainKvJPAEXXeXq57V2FFka9bRK+Wo0dIrp/A/fRJa9WbzGthV2xEdB9yGCRAsUlB
 sVrG0GnLNXGjwldGt4W/4H/y0wxhfzzFAQfiSH+DJIL4xaHFNNEAKVu4xWA/5MqE
 667ygUzKpuSDk2exI80OJzhOsSlNXEXSSps+6Ew5faqL



On 2023/3/10 14:15, Yangtao Li wrote:
> Hi Gao Xiang,
> 
>> Please help drop this one since we'd like to use it until i_blockmask() lands to upstream.
> 
> I'm OK. Not sure if I need to resend v5?

Thanks, your patch looks fine to me.  The main reasons are that
  1) active cross tree development on cleanup stuffs;
  2) we'd like to add subpage block support for the next cycle,
     and they seem somewhat convolved...

So I will apply your patch when i_blockmask() is landed upstream
then.

Thanks,
Gao Xiang

> 
> Thx,
> Yangtao

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
