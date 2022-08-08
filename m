Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2C6FC25B06
	for <ocfs2-devel@archiver.kernel.org>; Mon,  8 Aug 2022 09:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=e0ithoDajNnrA6NgDaYzn1Y0wdKuHZqd2XXURYhyT1o=;
 b=mHEipdMPYJzGis02/lmqOxqaVymdWUBWwXZYGZvJ2zrnu7P8GdR4xbU2cdhodD6TFzXzHC+4o/i/
   9g0k0KBiDu8Jz8yX5vs43P/ritGSPNZyDbBmnA7oY0y+Tum4iY0Lt5Li/N28qcON8sphKMvzQMSI
   /ZcXkmnNV3nb/ht+D4xDnIx+AS3txrMn+lWNGUYuCH8nN/ajDMG4XI7SEJuFbLzQpGH50lhNMq9V
   DJhr0u66ZZb9j6L0rm14/jlAZg6bRbnqV2VTk8KI9RA/Dp92VBdpTmTnmMKMp+dMhp9dDX7i/OoL
   F/Kb8yJ6S02eu4AhICC//iO7WHWlQgcukG4gjQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=e0ithoDajNnrA6NgDaYzn1Y0wdKuHZqd2XXURYhyT1o=;
 b=Emk12VMuavgG2a3YWxYMBE5vKqJKkadMH54LXLR5+H1hom+S+3FOK8c4phWoyMBIyn4pqzxgwnjU
   v0K7rb1eYZJPMLcU1NXVtgofRGuWYmysB885V9wTySGjfa4F0O/ZeaAJiKoMSvW2CY1GoUpnJOFq
   817G5rX8yDHhvcg2RqfRQcVvsLbJztglzA0SMjswXy/+T+t3ouh1WkWATpqrFiZ9AqjkE+CnMcE4
   QIUdSf2Im6o6pujij6a8J9O6c1eoMU7rD3TQMcytUvqK11klVyPrF1i8Upf0bQ5heOMZR+KvMWue
   lzKhux17TaJdgE2SvIOjGqpi/dyAiUaO3jr50g==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220729 64bit (built Jul 29
 2022))
 with ESMTPS id <0RGA00AK2IDK82E0@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 08 Aug 2022 09:29:44 +0000 (GMT)
Message-id: <d65afb07-6e4a-a566-de32-f61a7b3582a4@linux.alibaba.com>
Date: Mon, 8 Aug 2022 17:29:22 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Content-language: en-US
To: Heming Zhao <heming.zhao@suse.com>, ocfs2-devel@oss.oracle.com
References: <20220730011411.11214-1-heming.zhao@suse.com>
 <20220730011411.11214-5-heming.zhao@suse.com>
 <e90f3f19-f790-8018-ddb4-0bb405d45ad6@linux.alibaba.com>
 <20220808090714.w7vojxh23zka4cx3@c73>
In-reply-to: <20220808090714.w7vojxh23zka4cx3@c73>
X-Source-IP: 47.90.199.10
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10432
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
 lowpriorityscore=0 phishscore=0 mlxlogscore=999 spamscore=0 clxscore=119
 bulkscore=0 priorityscore=0 mlxscore=0 adultscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208080047 domainage_hfrom=8516
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R201e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046050;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=4; SR=0;
 TI=SMTPD_---0VLh0IAQ_1659950962;
X-ServerName: out199-10.us.a.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: wbgldPqbuIVfhYGKui30L98_hsBu4Lmy
X-Proofpoint-GUID: wbgldPqbuIVfhYGKui30L98_hsBu4Lmy
Reporting-Meta:
 AAEqsoM3OKdr2nUnmvk8GHBfaGpSSw2UW5rPBBAeD4Iol84fUXfaPOmvlfPpgmNR
 62CQrUUPygPfAmUYXNJcrNPz4alUN18YghGKPeHEtkz1zhwQXXje3o5Xuj6rrQ9X
 ipgGt5wl0Lq7L8r/BBq8fKorKvvYPOhqa1BfCUIFl3cym2lUexZynr3bIX+12Puj
 gp7Ljaz2LarW1f+lNIfsGGymXP6ETDL7OuOYUFHFgxzJvPcHWJl0G1DHc8Hmc4yL
 hLYdUt9y2/BkjNNi5W+6z88XT2in5YkFe9w0VC+aKHeeb16/Gl59ks0y3452iSVo
 9PBZSdOdemld3DL7Y/RCP2ZT0bRG+4LN032HqQ416Wpa3Bxis/eB7PtSkYuHH8/o
 TYRZ+ccB9usQ/kzi623+1zEH5Jbl4tzyNotxVMBc018aQ+FPWbv26ZXF+TXAmGo1
 WBRtB8FX3ZbWLeP+shNSKfyD/mSDQdVrlmJuKorWtV5E4fdnqBuE2aaT/JSygQBx
 WzZelDhlWOU1XdB4CB2T/8Z1X5oiktk3fXF7Bh0Q01SLiw==



On 8/8/22 5:07 PM, Heming Zhao wrote:
> On Mon, Aug 08, 2022 at 04:19:22PM +0800, Joseph Qi wrote:
>>
>>
>> On 7/30/22 9:14 AM, Heming Zhao wrote:
>>> MMP (multiple mount protection) gives filesystem ability to prevent
>>> from being mounted multiple times.
>>>
>>> For avoiding data corruption when non-clustered and/or clustered mount
>>> are happening at same time, this commit introduced MMP feature. MMP
>>> idea is from ext4 MMP (fs/ext4/mmp.c) code. For ocfs2 is a clustered
>>> fs and also for compatible with existing slotmap feature, I did some
>>> optimization and modification when porting from ext4 to ocfs2.
>>>
>>> For optimization:
>>> mmp has a kthread kmmpd-<dev>, which is only created in non-clustered
>>> mode.
>>>
>>> We set a rule:
>>> If last mount didn't do unmount, (eg: crash), the next mount MUST be
>>> same mount type.
>>>
>>> At last, this commit also fix commit c80af0c250c8 ("Revert "ocfs2:
>>> mount shared volume without ha stack") mentioned issue.
>>
>> I suggest we re-split this series (especially patch 3 and 4), but not
>> revive a buggy commit first and then another commit fixing it BTW.
>>
> 
> No problem. I remembered this fixing style, and won't make this kind of
> mistake again.
> 
> Do we need to wait for Mark's further comment?
> It looks Mark didn't like non-clustered mount at his first reply, but he
> showed another idea for non-clustered mount on the second reply. And I
> am sure what's his meaning/attitude for non-clustered mount.
> 

Yes, let's take Mark's input first for the next version.

Thanks,
Joseph

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
