Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C05FC7EE23
	for <ocfs2-devel@archiver.kernel.org>; Mon, 22 May 2023 06:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=j9HZhs9xiOVbV41UIOPzL6umsw2sgF8yxvtIaDvXAYs=;
 b=CsZjsv3+ng+GUeldsA1TK0NKAnyxEHAQRzlKAd0HvEal9HA9jDRl5KDvmeVejXKH7r65u+w+KRk8
   YMDTJwZ9zlR9YbPuawYqZaN1vaqWNyWnsmrWxTxyzo8tTdKWcT9QpDEetEuTMUALzj/DnrJ4Kf3m
   dfTotS/P7WuuZfBss27AA/xCZWCL3lDf/8iWN+6EmWWZACm7BTFqHNLYyf0M5rytEYiLhlLWDxAB
   Nw6gGZdIe9gSgHx08DG7eSRyuPh2c2utZNDMEcOaYqyt0aTVRUig11WxTSUbFwkPJW/oYvCWqjch
   Fo5H/ThJMxi+NFZkVv8s/uSYzUp1o8akQtPiNw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=j9HZhs9xiOVbV41UIOPzL6umsw2sgF8yxvtIaDvXAYs=;
 b=bqTu7Fw81XcYDG8fuPrS32zNe/oL6mbeJb1hbUsb/+nNw6g4pmvPw9ITdXEK4VYy18xewveg4Eao
   vTPjO1jtQ3WkHDW3YIOLkg+XXILtA4MIZvv1mIkwsq91hEN+1wejXqZAIhaVj1uDyRZZsA1/nQB+
   MjNQfHp6ittHbeF6iR3XQDNkmKsxq4kIJ7YOxd/WMbak+pJDH/hrLH+pFOymDASlLfXKwox6NuAf
   NPujt+0BPV10tTSRORTadjrlhHMb2x8GmKQrChGRO6Q406P4eTz7sVwAbYVuL0oQ697Qq/kPpMBT
   UFdgaautc0i6oRzwSffwO4miw4/kKH64t7tC+g==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230420 64bit (built Apr 20
 2023))
 with ESMTPS id <0RV100N21RNGPP30@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 22 May 2023 06:35:40 +0000 (GMT)
Message-id: <e3ee56fc-515a-eb92-b923-360e4a758c12@linux.alibaba.com>
Date: Mon, 22 May 2023 14:34:44 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
Content-language: en-US
To: David Howells <dhowells@redhat.com>
References: <376ab23b-52d0-d7fd-2dd9-414cbb474e01@linux.alibaba.com>
 <20230520000049.2226926-1-dhowells@redhat.com>
 <20230520000049.2226926-23-dhowells@redhat.com>
 <2362051.1684736916@warthog.procyon.org.uk>
In-reply-to: <2362051.1684736916@warthog.procyon.org.uk>
X-Source-IP: 115.124.30.98
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10717
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 phishscore=0 clxscore=129 lowpriorityscore=0 spamscore=0 priorityscore=100
 impostorscore=0 suspectscore=0 mlxlogscore=621 bulkscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305220056 domainage_hfrom=8803
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 Hillf Danton <hdanton@sina.com>, Jan Kara <jack@suse.cz>,
 David Hildenbrand <david@redhat.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Jeff Layton <jlayton@kernel.org>, Christian Brauner <brauner@kernel.org>,
 linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
 linux-mm@kvack.org, Al Viro <viro@zeniv.linux.org.uk>,
 Jason Gunthorpe <jgg@nvidia.com>, linux-fsdevel@vger.kernel.org,
 Logan Gunthorpe <logang@deltatee.com>, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v21 22/30] ocfs2: Provide a splice-read	stub
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R161e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046050;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=21; SR=0;
 TI=SMTPD_---0Vj9B4yc_1684737284;
X-ServerName: out30-98.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: YycNdmt2ed8TfEoHtnzk8ynfBdWN9pPl
X-Proofpoint-GUID: YycNdmt2ed8TfEoHtnzk8ynfBdWN9pPl
Reporting-Meta:
 AAEGzKb5vchwWwRw6l8kUfGm21PNkkhRsC0856KZ68cCFshV1bC7Y5RlDua/KLMd
 /YIfy2vI9w14zwPv2b7vBrXj49EIZM65vAnF9hbm9AB+KPOVjOJrzNmskHYddC4b
 /mMTcqxALEwdYHdN7so9NbxtC9HA5jiKMXnfUErgHI9rD5iQC5T7uqshZ6bv5Zmc
 JoeD/IdBBmiVwC4dSdBf8XkCzxF5AU8kDu/LWkb4OLznda+s0P8+kkUTXVwr2Bty
 MnwP2tgoQyvsZfF7GVWS57XPL7VFUxc/K4YXluK8XHohjeywTsYCQAXEHKOHIdvT
 gAhuSis8h1qcUce2k+q4R+tzWiZySsOk0GPtCPMo0HvOdhadLLrb2mpusJ80872F
 dknybdj7j4PY1KOwELkj/kNEk2VsMbiLxN12OwB929cdyBN+VU0crICvylv2pdVZ
 zVW/0bDV74we03jQ+pz1cLSqM+vIRmj9HqHVwOUYEpyMSXW6pCDH+X+muNpYELFb
 WDO5AaK46AMcklaWhb3AUda3tCvGt7EQ0lfaD+6BCuU=



On 5/22/23 2:28 PM, David Howells wrote:
> Joseph Qi <joseph.qi@linux.alibaba.com> wrote:
> 
>> Don't see direct IO logic now. Am I missing something?
> 
> See that patch description ;-)
> 
>     Provide a splice_read stub for ocfs2.  This emits trace lines and does an
>     atime lock/update before calling filemap_splice_read().  Splicing from
>     direct I/O is handled by the caller.
> 

Oops, missed the patch 7 of the series since I've only received this
one:(
Have checked it on maillist, it's fine for me now.

Thanks,
Joseph

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
