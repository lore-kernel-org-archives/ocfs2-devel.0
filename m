Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13975C433F5
	for <ocfs2-devel@archiver.kernel.org>; Fri, 29 Apr 2022 02:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Z2qP9DCv4lSUTSfBIGw/fjxkMp/5Px0G6WiRS/HAtKA=;
 b=WKMCquKPBa4uHLTAx8IuK+odoyN9CdTQY9dBq/+4++CIS6lLtD7qjydDx5y0IgLfFJBDsrsCeo3X
   bXhVv7z9FBvohKKDuFBtdblJTce+Yopz7aPgzscXAacBHNUYs9zvJYnh3Yfkd7vO0z4pulPZsPDa
   shvsegM13IZ6LuqO8H7bCU6R75EU0y+xBnvRg7oTCA5kuYC3dh/KAN4MjcX4NVekWtOcKKgi1JKZ
   Wiwx9fI1TobfjW8x73FDtVz+UJxeliO0tmOEh1DWxxcaq7OvM8J5OAAWgMCtT7c/3EjHU4X3/zZ3
   yFPKd/UTTUjDmpEr4sk1qxYC+SgBMywkcAvzsg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Z2qP9DCv4lSUTSfBIGw/fjxkMp/5Px0G6WiRS/HAtKA=;
 b=WC0875gbrrmenrMPCq8F70liH/3s1xBPLWz3atVYE5mPoUprDK3CCE6bFWsSvc1mXuniHu4BOrkr
   /BdxeuBiQb0x68IRQPP+2NRRBj0yXzb5d2lzzCLY1X8wbaHSLnHrmaUv2QQWPhQr/VjUHKwDOHvt
   Dsvk+L4gKmZfFFdv3FFnDLO3HxdwgfroC0kTxKbgqxu9y3zHn3DtATR93OdasNlObIUvcc79LVxg
   3ly6jdoFj51I7cuTuSYhxd1CVfJxEFjjIuvmh7PoQdGH1eC2sFL1awEV+tEmWxt2aIsp3o39ZvKQ
   qAOF+4wemcDdWV/EcQWOvG5hO1kGWHKqJY2eeg==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RB200I1TYCT9D30@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 29 Apr 2022 02:46:05 +0000 (GMT)
Message-id: <dbe0ca0c-2b7c-f27b-49b2-8a3a6ce440f8@linux.alibaba.com>
Date: Fri, 29 Apr 2022 10:45:36 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Content-language: en-US
To: "heming.zhao@suse.com" <heming.zhao@suse.com>, ocfs2-devel@oss.oracle.com,
 akpm <akpm@linux-foundation.org>
References: <20220424130952.2436-1-heming.zhao@suse.com>
 <20220424130952.2436-4-heming.zhao@suse.com>
 <df95d0b8-0fa4-e705-9a2b-5db888f53282@linux.alibaba.com>
 <ea9f9636-43bd-1079-f788-18f33c1e3e18@suse.com>
In-reply-to: <ea9f9636-43bd-1079-f788-18f33c1e3e18@suse.com>
X-Source-IP: 115.124.30.43
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10331
 signatures=591664
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 spamscore=0 suspectscore=0 mlxlogscore=751 bulkscore=0
 phishscore=0 clxscore=19 mlxscore=0 adultscore=0 malwarescore=0
 priorityscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2204290012
 domainage_hfrom=8415
Subject: Re: [Ocfs2-devel] [PATCH v3 3/5] ocfs2: ocfs2_initialize_super does
 cleanup job before return error
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R151e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04395;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=3; SR=0;
 TI=SMTPD_---0VBf.tFy_1651200336;
X-ServerName: out30-43.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: 92GG39-40_uzY29QVURyB74sYuKnNcuD
X-Proofpoint-ORIG-GUID: 92GG39-40_uzY29QVURyB74sYuKnNcuD
Reporting-Meta:
 AAFTPWkw37nJ0OZF5X+E8wy6bIyUwYik9si91cEZhHC1MEmZv1nTmK6fJcs42FbX
 5vAnrrk4AZV2wmo/aEUbbY9PANydMqmaQ0vjbk8cjEaLp7wtR2J6PBVarH0g0Cyo
 HFswyhwOyHgQyTVtErseNBsaRa9slqltWXFzRq/g+Fcbh1LU54ud5+9nB+5pLIJP
 hb/WejIrBdpSbgMNFpYHmg5UXqMIm10syiu3lIgY3NUc11ca11gsVtO5NxRkyXBR
 iBbvJz6QKq6lOvhNC6WvVckKDx3mavQoU7IJuk0T1rcz57vmmn2Mt5nZPy5L3CFd
 k9Fm6N+gaOfO/DJ0AaqNX0Z9daPMGRaZ7XOeHClZAXhHB+uTheFbjN8DKdA4iZq9
 3wViVLZfuQvVPoVIu7v2NaNm3t1MdBdsk6VwZ3KmuKjYluQHevXYz+xlvDKrpbv7
 ti6AEfM1foTp2fk6q0dFAHJum7eNO5i0M9xzpyyzbEhrnyyxggLK0kjeDSdNT2qk
 oVvX3hkb3ATBKykga7o7tlve9SZP7IcmFzOcP5uINjA=



On 4/28/22 10:59 PM, heming.zhao@suse.com wrote:
> 
> In the front of ocfs2_initialize_super, the sb->s_fs_info is set to osb.
> So set osb to NULL is not enough, sb->s_fs_info still keep wild pointer.
> The caller (ocfs2_fill_super) will fetch the wild value from OCFS2_SB(sb).
> 
IC, you are right.

> Another question: do I need to resend v3 patch with "Reviewed-by: Joseph Qi ..."

Not needed. And Andrew Morton already has added it into -mm tree.

Thanks,
Joseph

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
