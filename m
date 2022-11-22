Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC7C2C433FE
	for <ocfs2-devel@archiver.kernel.org>; Tue, 22 Nov 2022 01:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=MgfuEDvhq6xmSFm09FmGq4fcaAoGsezjdLikPKaKEgY=;
 b=f9WQPofHyu8RuSdADLhBenymhlQDVWQJxJ/e0YzW00YES0IPfhnE8M6qScNU5IzLPh56UhsrWlIN
   v1pabY0unbfJCka34VRqRielmPE1S1o/3piTbZoSh54uA/sbCVCbLklk0rJJpHk0OkH8eIfOVVGX
   L1nPIL5e2gVsz1EHMfhxkdEQwWrsJEyZtItU5KnYDbJHog75HiAwEwcmhAsapJw9A6g3Bnx/O2Zf
   vXJHlOARSCJcpb5fOLjPqdf1vwV2aLilq9HkfFQ/zdmoZvEoP/6gFr+iz1ncMMzkUxcn+zFt5Lqo
   PopYuB2b/zLrifiik6Rd42tU4zMbCjE/bqHJxA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=MgfuEDvhq6xmSFm09FmGq4fcaAoGsezjdLikPKaKEgY=;
 b=FdB2ZOrN+KWK9RfEpCd3bVz0meTjXjsW1OoucWXRKt8Zonoglk43LIR8o8VUDs+4v7ErPLKfhs9R
   HS34oX1mAGWuxxu0Gc8bgB+8U+Wqh8xs1Lp1e33Wy9GtnPdpvao6yawaq9v05X1CTM8HZ51S8H4j
   Gd/vxo6K9wOnn7AHFl6JUx3l1nRAQURShb3mUgHpNjttqoiw3SexMKXIWyGACK4z3NO0kPF89Ddh
   wsQQNCi5x2EXbX4a4jb9YnlPRMklrORG3UYi00FPE9dbleq4Wzi1CPUwdizH+jtF4l+PyzTmjWjf
   vdWUoosl3L1xUC35pH8pHLP8iGUokr/E4bQPMA==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RLQ009Q17WX8QD0@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 22 Nov 2022 01:53:21 +0000 (GMT)
Message-id: <92129377-7b2f-4853-c42f-a0f199a61f0f@linux.alibaba.com>
Date: Tue, 22 Nov 2022 09:52:52 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.2
Content-language: en-US
To: "Alexey Asemov (Alex/AT)" <alex@alex-at.net>, ocfs2-devel@oss.oracle.com
References: <d7a1e5ae-c43f-5a6a-c0c6-619a3e22b092@alex-at.net>
 <911762fa-8fc2-ec01-e767-1ed8ae7e5c38@linux.alibaba.com>
 <53bae0c2-7e20-4b16-9c7c-4fb9e617b9c1@alex-at.net>
In-reply-to: <53bae0c2-7e20-4b16-9c7c-4fb9e617b9c1@alex-at.net>
X-Source-IP: 115.124.30.45
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10538
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 malwarescore=0 clxscore=42 adultscore=0 bulkscore=0 lowpriorityscore=0
 phishscore=0 spamscore=0 impostorscore=0 mlxlogscore=999 priorityscore=60
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211220011 domainage_hfrom=8622
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
From: Joseph Qi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Joseph Qi <joseph.qi@linux.alibaba.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R171e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046051;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=2; SR=0;
 TI=SMTPD_---0VVPpUhn_1669081972;
X-ServerName: out30-45.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: MCFKEhBIR816D7tqVNjSUBnJbQxVRx07
X-Proofpoint-ORIG-GUID: MCFKEhBIR816D7tqVNjSUBnJbQxVRx07
Reporting-Meta:
 AAGIoX+2ApoMJOL8mRBmDI5uuIgCwrW+JGj295QL580ZfrTgXqyjwgoOUcJJnD4A
 lZAq5QwNrd3/eq2WW9df/2pMP7jcsEv+74WCcYLCOvxXE7eJvrHiSIEkG8MgK8Wn
 G16y7Ihc42W7htUIMQfZMoZGm2lwI2q3QQoon5rlCy3+FYXIg1AZTMHAP6O4QnAn
 vJBedOKU8NXAjMgD3fXR4AJru1TVZifntOCHxi+i4RXF8KDWJLQovj+d0cmykPnf
 VCjLsZfcqhoL1xp/H/x+xeS70Q4xzR5v3iutGC25kMCl1u++6CmnKCovZC9Q2fkN
 Hu4WVOqkSC2KikkcVwxh9h0MOxs5prEjvRfBBMeTx5fdl5EPAjLfyxrRPoVFf5nh
 HMKzk74X8SEhfcBTPHLADo3t0+LKe/wpJCeze6792uTxe3hSPPB2azjdNbSgGexK
 XJ2O582RBOfgZumXt4EvOHtLTuDk9uTJx48KkDvbj9V6TVFkrv0tajUMR/oKU7+3
 lM95qv0c/T3Y8PjPa57wwDFNYsNtMbfpC2xjDIk8eEE0XQ==



On 11/22/22 12:15 AM, Alexey Asemov (Alex/AT) via Ocfs2-devel wrote:
> The modification I mentioned surely fixes the thing (well, obviously).
> 
> If to reproduce, trivial as well:
> 
> - mkfs with indexed-dirs option (otherwise low hardlink limit will apply)
> - Create a file
> - Create 65535 hardlinks to it, stat will now show 65536 hardlinks (that comes from local inode cache)
> - Clear inode cache (for me cat 3 > /proc/sys/vm/drop_caches is enough) or reboot
> - stat again and you will see hardlink count = 0 that is the result of actual inconsistency
> 

Will take a deep look into it.

Thanks,
Joseph

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
