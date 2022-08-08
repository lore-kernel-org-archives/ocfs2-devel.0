Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83081C25B0C
	for <ocfs2-devel@archiver.kernel.org>; Mon,  8 Aug 2022 08:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=qAPaDBl/fx0CXEjzWBIMsURsJpu8Nm964zZmUvbZAHs=;
 b=gszJrdCseznGmlOujM7Ji2QXcNTqpbOaRQnaAlHJkHsP9ZvQYLf0BX5CwTwgPNCs7QjKQy/+hRD9
   RuAokITpRrsg/4XDrOoBJ1jmJ8U6iDj/X2Nm9oqjw+aAooURSfhQ8zNAhVLzrI78hFJL77cFxvS9
   iSDid6EdcIwLIehC7UucGP5a3LbwzaH2DT5F0lutLmzIv42iZja3KlmicVsItJ9O1azoGA+mp2TR
   cpWZOzhSLgfo00fxYJgPrOUE1TS7qXM8dBSuli4YICoVZpGNOO//zyH1IoTpRpruSO1b6AVDCa3W
   Igc8DLEsDrgAQafIOMWx2i4HijBGr4jTBhJj1g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=qAPaDBl/fx0CXEjzWBIMsURsJpu8Nm964zZmUvbZAHs=;
 b=fzXO9QpjtMZk+924l8WN1vvjladRZcfP4+TIDV31AryjApb/HHe+s8hxd8TLql/vMB1YaeASW+JW
   /NzdpqYsPWrOCH+tV1knDHiEJqREiFkNzp+slQx6M9f/0K0TaJNSm2EMIP4w7HCiK/zdiK0kzsvS
   89/QqgZDM3urjzX0XhzewZaZgMuU7LPfZCE+/ZWDkypVZTOh2mj2Bb0TRuyhC4X6id2RIZ657UtE
   1IYN0KqYNJlYgcsTKmRczKEkZd1k8dEKulfoNCegAg3hOHi+kAT9CPGbrUzkQzfMVf6qGn/oSv66
   jmz/izTqMgMx6Gk7+Qgr/5uxyEhnQWKxivWWSA==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220729 64bit (built Jul 29
 2022))
 with ESMTPS id <0RGA00M7QF4QOE80@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 08 Aug 2022 08:19:38 +0000 (GMT)
Message-id: <e90f3f19-f790-8018-ddb4-0bb405d45ad6@linux.alibaba.com>
Date: Mon, 8 Aug 2022 16:19:22 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Content-language: en-US
To: Heming Zhao <heming.zhao@suse.com>, ocfs2-devel@oss.oracle.com
References: <20220730011411.11214-1-heming.zhao@suse.com>
 <20220730011411.11214-5-heming.zhao@suse.com>
In-reply-to: <20220730011411.11214-5-heming.zhao@suse.com>
X-Source-IP: 115.124.30.56
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10432
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 spamscore=0 impostorscore=0 malwarescore=0 mlxscore=0 priorityscore=0
 bulkscore=0 lowpriorityscore=0 adultscore=0 mlxlogscore=999 clxscore=103
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208080042 domainage_hfrom=8516
Subject: Re: [Ocfs2-devel] [PATCH 4/4] ocfs2: introduce ext4 MMP feature
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R561e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018045176;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=3; SR=0;
 TI=SMTPD_---0VLflmgc_1659946762;
X-ServerName: out30-56.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: M6CO23rroU0GOOT0x8vaQPaXJ5S3pjnV
X-Proofpoint-GUID: M6CO23rroU0GOOT0x8vaQPaXJ5S3pjnV
Reporting-Meta:
 AAGhyTdKxml+eLxVKWxB1CnetNVYg6+SLUrJt8YGylJhkdXOf6lPRJCDBbuQ8QIs
 htkxkMxTRnUJW5ZeoLf3aNvfjWuwKE260QHOxa0iCBbhrDBg2qoH8Opo/E5dn22n
 t9F4wHW1xdk83uddUvJB//a3An7FmyoDx0LzHxrzg/MvBECIsd6MZa8rs5r3/3Dq
 Cyw/mX0rbzDFOjsBnMeJCUwYsjGoSidDiyTChgUjsZ4vLjKFps6RX4MM6c/BjbdR
 b16czI0G0WbnbfzD8EANpWfmkPpp04m2R571bVBvYr5KsjmFi9FLRtyxHpHHVGtP
 B9/Z5vlHMIzr+40RcrxUK85Y2cBPhwPm2RHmWeXjXlNi9WtBEGj9Q9XmQgo93ZGY
 a0ECGNTr/UF0137m2yjdMEeJ9dm63lVL8Fhhu9f6tG2UaDUqyrWQU8QoLJ5q5wwl
 XrIzvchtESUQv0bIrU+DTOxG8YJ7N7gnXWJtCfSIh54rYZDrR4SvyGvR0/7RuDuU
 ZQ4ZmnvN1QqJaRIFTci3ZKKR6sm4UPC9jlImL6ESD95Z



On 7/30/22 9:14 AM, Heming Zhao wrote:
> MMP (multiple mount protection) gives filesystem ability to prevent
> from being mounted multiple times.
> 
> For avoiding data corruption when non-clustered and/or clustered mount
> are happening at same time, this commit introduced MMP feature. MMP
> idea is from ext4 MMP (fs/ext4/mmp.c) code. For ocfs2 is a clustered
> fs and also for compatible with existing slotmap feature, I did some
> optimization and modification when porting from ext4 to ocfs2.
> 
> For optimization:
> mmp has a kthread kmmpd-<dev>, which is only created in non-clustered
> mode.
> 
> We set a rule:
> If last mount didn't do unmount, (eg: crash), the next mount MUST be
> same mount type.
> 
> At last, this commit also fix commit c80af0c250c8 ("Revert "ocfs2:
> mount shared volume without ha stack") mentioned issue.

I suggest we re-split this series (especially patch 3 and 4), but not
revive a buggy commit first and then another commit fixing it BTW.

Thanks,
Joseph

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
