Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8ED3FC4321E
	for <ocfs2-devel@archiver.kernel.org>; Mon, 28 Nov 2022 14:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=PLjNjrlxbeQvx+bO6aJHAbdf68frJuXmtv9PmEcwp38=;
 b=MF566r6HZT4LUDCOQSWi+lt0hocwTMtNV9gCguJ24qIHIFb0S3dqQkQ4AALAVgRE10r6eR2xfVxJ
   3dR/3QCpWLiyo98cCwfTwtx1e8VYsoGDb0SIewt39dgEi6YPHuqXZ92wc+wxiTc6OkoBRkVHRxHQ
   neNhvucwf3L/epe6OTyQWXol5PWcB2dTs06ej+PCpJGOrbSKWW/8tKvEoj+SiN8nEpQt4HnKX4NS
   HpegqlleaDXY4YZD0V/gi921kfHL4lJF0f8A3odzBDqFXHDHVL59uMotOj8GjfU2PFj91rMbnVWt
   yH9viZCYiYNtLQec5aAox8rCZmXqET503X4iKg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=PLjNjrlxbeQvx+bO6aJHAbdf68frJuXmtv9PmEcwp38=;
 b=kvsImIreiTwojGu8qfj5/B2yRYAydjG7tEofQAu2KNgd58Z+pFFoWDD2rlG9Bs0afQHTj7oj41W6
   jeL7oMLzR64HJ+TV23FGeCZHn+fChAwg7EkZ+spAxMz9ceWXXmpxcFJjR6wpDAxPVEx4S4KkAwaa
   PiHg89HnBJ1gsU6xToNh+J7xnTLzzTKyWId8rIf9I7mC+9l0WO4F/6TuV1IsV5+j+8F0eym+2jPM
   KjzfOwhHI1Fd0wHp5DmCE/fG13WJIEYzXCzJ+c6M04sWv38h1je5jD+/3A37bu3LAZHtCbbzwrUE
   CKnePxm4jVlnj6dQoG03jUrXKz4HbMAgnfNpJA==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RM200E6BAF99I00@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 28 Nov 2022 14:18:45 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=alex-at.net; s=default;
 t=1669536027; bh=ifqpxnijmBXn+nVUcZGDdk5tNOx+iigdZzegFzLArVk=;
 h=Date:Subject:To:References:From:In-Reply-To;
 b=1sUDfpUxQ97CIjjSo9foBQCtMiy4lx/zMnOFdUTVbdSVnAVkxyMYGPu/znIovCQcL
 JyLkoYVqCqpAPwg/kVspx7aRApDPuyD2KE/PeTzJF5evi9A0SO+5WYPnMRIt9AnpEA
 HHJxuWrSob0UPDZXMxp1cYHLbjUAFdupdA+I2ceM=
Message-id: <3d3a6129-29a7-ff7e-36a1-9163d7a88228@alex-at.net>
Date: Sun, 27 Nov 2022 11:00:26 +0300
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Content-language: en-US
To: Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@oss.oracle.com
References: <d7a1e5ae-c43f-5a6a-c0c6-619a3e22b092@alex-at.net>
 <911762fa-8fc2-ec01-e767-1ed8ae7e5c38@linux.alibaba.com>
 <53bae0c2-7e20-4b16-9c7c-4fb9e617b9c1@alex-at.net>
 <92129377-7b2f-4853-c42f-a0f199a61f0f@linux.alibaba.com>
 <a32840a6-8894-7898-c6c9-41feb869aad1@linux.alibaba.com>
In-reply-to: <a32840a6-8894-7898-c6c9-41feb869aad1@linux.alibaba.com>
X-Source-IP: 51.195.137.138
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10543
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=1501 bulkscore=0 phishscore=0 lowpriorityscore=0 mlxscore=0
 impostorscore=0 malwarescore=0 suspectscore=0 unknownsenderscore=20
 spamscore=0 clxscore=-77 mlxlogscore=999 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2210170000 definitions=main-2211270067
Subject: Re: [Ocfs2-devel] dinode link count inconsistency in
 ocfs2_read_links_count() logic
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
From: "Alexey Asemov \(Alex/AT\) via Ocfs2-devel" <ocfs2-devel@oss.oracle.com>
Reply-to: "Alexey Asemov \(Alex/AT\)" <alex@alex-at.net>
Content-transfer-encoding: 7bit
Content-type: text/plain; charset="us-ascii"; Format="flowed"
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: mail.alex-at.net
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 a mx a:home.alex-at.net a:sphynx.alex-at.net
 a:mail.alex-at.net a:mx.alex-at.net a:home.alex-at.net a:sphynx.alex-at.net
 a:mail.alex-at.net a:mx.alex-at.net ~all
X-Spam: Clean
X-Proofpoint-GUID: rCkBCXi5hbxn7_DIW3C7Tcs0506LYrgn
X-Proofpoint-ORIG-GUID: rCkBCXi5hbxn7_DIW3C7Tcs0506LYrgn
X-Mailman-Approved-At: Mon, 28 Nov 2022 14:18:44 +0000
Reporting-Meta:
 AAGJjEcu5aNoE7u7ip0lcs0/gAymKnj2pjEVPTog/tptzfq1uhR5YSy2mYPmLUg4
 v56EsAG45Z8CPCcqVOVsrTa/hkb9nbbPj41WIbst3+fIOU+Zxpl6xdnH+88KPyJw
 NdtIqsew2uCbIilGIFgkNTEOAhmzJJsQ5252i0denKaS42bMwwHD8iKoPDbtQdiS
 gIRkN3Zrd+vl7w3vEuNTq3iEtxROE3dE+NDFtnh03h64pq1GZptWmzHLpTy/3Dzk
 dQmh4vPLWmD7eVxDmvroDcvJpvDyUi/cCEahhdpdvpydhIcH8DPquZVJt7sJz8pU
 Q8js6XfiC6qK6B8vEImG9gfz7kFP2zhQLaaQ4s8DROwSoQY6r3pFYXuzjNxH/8hI
 /IpE1UunTj4AsuXNdqEwF0u/KfDJWYPP5KZEpSqq2fnoH7F6W8oLVNaTTg/otBs3
 1yWw95JacHDgk8roxAjIH1gSBwP/dcQjLyfMM86Ne6q8eopFaJOWlEuqAEQwgzDe
 KIIOzebSe9EKgcgGZLpTS//30C7zZSt1GNx6Nd7GjxE=

I've sent a formal patch, it is awaiting moderation according to the reply.

For how it happens: yes, ocfs2_link_max() returns OCFS2_DX_LINK_MAX 
indeed. And so large number of links is allowed.
But ocfs2_read_links_count() checks for dynamic di->i_dyn_features flag 
OCFS2_INDEXED_DIR_FL which is only valid and set for directories, not files.
So when reading file dinode, it drops the high part, and that is 
obviously wrong. Anyways, dropping high part seems terribly wrong to me.

KR,
Alex

On 25.11.2022 14:25, Joseph Qi wrote:
> Hi,
>
> Checked the code again, since feature indexed dirs is now default on, so
> the ocfs2_link_max() check will return OCFS2_DX_LINK_MAX, which can use
> high 16 bits of links count.
>
> Could you please send a formal patch?
>
> Thanks,
> Joseph
>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
