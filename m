Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BBF3C433EF
	for <ocfs2-devel@archiver.kernel.org>; Tue,  5 Apr 2022 10:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=kidtmsufMdR6CIdGKQf/TLWRcD9ffoLLQq1a462nuiU=;
 b=RSCGSqD8Zes/27MtOI+frBKnxd8jJT76ddkaWCTNG8Ip79ef4bXKzUoaPNt+wMcvPiVY9g1+KtIB
   Z4awKDKKVprZlTiEuBiszM5hT3aD/KbuuyFuEHLCrq+WTi9gwLqOwizSd9Td/LFsMfs2WJ8FkLQG
   ZVdOe1Nqmo8Xml07p+DdcmCaClMWJLQRCKDEmUfI9FkVq6R+5/wXDQhUxZM0TaAimRNmt1ufSmif
   JOSKkpvmxKJR1yoptLjmpA9ehQBhu1fktMoHtmnXH25mcSLeVN3N1ugw9AGxQ51FOXfX+uBAWYFH
   nPu3p0GSqLIc4lTXF79P28P1nXeROOJeg7in/w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=kidtmsufMdR6CIdGKQf/TLWRcD9ffoLLQq1a462nuiU=;
 b=S3N0V48zGuFx6h0paXQRRvKPu2DnLJL58Jg422h8jxzwagdDi0KVjcZCtTF1peYq2Me3/UXAftXZ
   /6BaVD7qrGpuoUvixvZTlLlg6jQVHcg7bYRarvGiXkZJwUrrEmiu7aAFejWUK83tqWlOViVeEp8+
   4bSyuJ/iPPh3IbaK5xNbYzZnhce/kxPquj1gcBL9lYh7ERotjk0mmtCpW/ZD5Hql7ANDk9wV5RLT
   4/LnbAtFd/LEKcAuoBoMfp8par1rymW/CTJspY36ttWdkOyM26sQIANXPiXz6gdN6GkAavhy/Kok
   cFRm1gGeFBrF0BGSZ5c9HuLxfR6uRj3btttRTw==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0R9V00MHX3PO2KC0@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 05 Apr 2022 10:27:24 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com;
 s=mimecast20200619; t=1649154427;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=A8NbmZDMsDquCF5lkxQQA4rFL5yFLN578mCqv86NmP0=;
 b=Jc2jMjmRU6qHXWkS/E3d/xRwepYKzzM8/4e8wdb/9KyN8K8iSoslFuy2YiN5PZfsBzhoBs
 ++lUPsavn46Kffy2qVXYjxeY+PFO/5Obj/sLMxaEhPUqN9WtN2x+o5bTeUUAGjB4IxSiMZ
 2qqpijl7J8oM9UqBeLXOdX3VN4eefS0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ovnic24IakKjbvvE/L7lIKXZNLNvwzJuZ7nPxxJ3/+i0VNhFEE6vaiHVum/x/T1WlrODnSLWngnxrt/8KepZrV/fiDLolaH0E8sY+TBJrg4LxE94MIYGG5wHuI25eyj1O2Yll7FoCg24JTBUlfHVseUkskMHe+umDlZiF6knaIN8FTRwD9RqDkTEgFSSe+dxvQAYU+V7MZJOWU4QfFcCngEkHgcINUROjlwZdnRWWO3SIHhJkNdAQRD0lfwXcjnDuwVbo18cEMZ+NxXSaq7Ry7nF9bzy7I8DnVldt8E8k1/jpsNWhks2+oktZ6Zc2JpyEvMfPNScmbFT7zZaKI6jYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A8NbmZDMsDquCF5lkxQQA4rFL5yFLN578mCqv86NmP0=;
 b=aXtwRneIN11hmyz+4XFuTqNnQU5cdC7/kNlDMxqTmCDt+EPJw6GlXpLZ9s6p8UN7Ti0ySmbsb/d3kWloydZJgz9t3EUxBfXtVBUnTAqouoFzBCM+bWEXdvnqb4hJuy57bX2DZoRD4N7Y1uTPx/qyJRdc5AGh+WZR70eA7CNccFX1m1XKbT3LrXHgetPJkX7J87zggy8n2FCPVz+gDsvwj5U//F0npmp0PF3aGn718wV48YshLDu4p4P5cA2h8Jo2XoF4pyceWbbDSQ13fYjzDvK+m1EFXmum2m8MA4qWhVFf75B4f3w6XzEG+bpgfGmY/qo+KWPbPigTAGpOXz53ig==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
Message-id: <b53e1d19-9295-6bdd-9404-b759b7dd8271@suse.com>
Date: Tue, 5 Apr 2022 18:26:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-language: en-US
To: ocfs2-devel@oss.oracle.com, joseph.qi@linux.alibaba.com
References: <20220404164055.1434-1-heming.zhao@suse.com>
In-reply-to: <20220404164055.1434-1-heming.zhao@suse.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(2906002)(8936002)(31686004)(31696002)(36756003)(86362001)(5660300002)(6666004)(316002)(83380400001)(8676002)(2616005)(53546011)(6506007)(6512007)(66946007)(508600001)(26005)(6486002)(186003)(38100700002)(66556008)(66476007)(45980500001)(43740500002);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2022 10:27:03.5708 (UTC)
X-Source-IP: 194.104.111.102
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10307
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 mlxlogscore=999 bulkscore=0 clxscore=205 malwarescore=0 spamscore=0
 suspectscore=0 adultscore=0 impostorscore=0 priorityscore=118 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204050061
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: fix error handling during mounting
	stage
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
From: "heming.zhao--- via Ocfs2-devel" <ocfs2-devel@oss.oracle.com>
Reply-to: "heming.zhao@suse.com" <heming.zhao@suse.com>
Content-transfer-encoding: 7bit
Content-type: text/plain; charset="us-ascii"; Format="flowed"
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-MC-Unique: jT2m737KMuqXiC80vhdJOw-2
X-ClientProxiedBy: TYAPR01CA0207.jpnprd01.prod.outlook.com
 (2603:1096:404:29::27) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b773cf9e-ef29-4c0e-ed28-08da16eed367
X-MS-TrafficTypeDiagnostic: VI1PR04MB5518:EE_
X-Microsoft-Antispam-PRVS:
 <VI1PR04MB55180A43B67F788CE0722AB297E49@VI1PR04MB5518.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 TsKEqCFLhbjbUV5MJtp+FxMKuU3Cpu0Z5rw42nVno04rFpibmLONjt3kj2yC2Xd4N7Y/q1wpW1dbtYNFMnC0Mo1vcCDyc3Qn3sfzmV6Ig5VDuaNUtEBk8LuzRXhX0VBusVDL0bYf2GWGOM8cPT6hW46CnqDHMxt1cQwZahe4yh0ZYOYORfG3KKD8pLBzjmn11D5Jef4+gTdGhl1TjErhD/5SI1PtUl033NmwZVBWBK3pvmaUdGBAdRk8X7T/k+DOJyy1G4N7SIEmjyjPgCSa17UgAjizh7Y7HPYP1tnavgBCBz1y2aiiSwoOolU4Xhy+wcuwyJVZ4PsS0AIZoBULYx1k+Fb50ywmwqZXJZ9AWubJOVTy7+JmmfjEjjDAd7JHnd/K+J0rlpPI7G0VtSZe63WMtZ1RGdiZXwrpXYI84k4ciDE0knQ016uft1CUUK0H68TmTLFSpZ/h6VxmRj33cOwtag2cJ/RK+Q04k5+1z7Jy6b2lBhT1Exo0FIx/OqKE6EExQ3MxYgVXgip6mLY5OD5GIpuXIU5u+ePjImf1Vz2hBwdaO9spM9rNFNRmpIHWA15BZlvkL2JYbdruIzhqYjCCe6dL+WZ7eipUS/HiOqmA7+YP+/oH9ZHQgcGiatyQhhX320o553H2hgh2EIkt0CdCo1p2pwYNWmVLc5lwrtrQKPfCohGeuEtjuyoFjGjvkig08Ce8Ylvqd31sbWTH/421EbZRLCFFDKgdE8TGS3I=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?R2dBWS9rK2N2RFFWM0ZkQ1h6Q3VIZFk4NWJ2cWIxVWZDTkZmemNNODlWVkFj?=
 =?utf-8?B?cVE1WFRmK25FR0lNN3ErVmNMcERubkJlWkNDM2xFVnlPdUdsY1RlLzY3RFhq?=
 =?utf-8?B?TStsOU03dXVBcWdsU3BPMlAvRW1ZWjVrNHJvMUdRUW43U0hiYUNXenBzeEpz?=
 =?utf-8?B?a2hyQm1NUk02SEh3Rkl1cFZrTng5aThoMTBlb21BcWlZNHYwU0NOenQxYlFa?=
 =?utf-8?B?RTdrR0xpL3dTZENLQVNteXhuMUxVczdadWRIOVZXemVCK1o1WVVBbGp3c0xj?=
 =?utf-8?B?dmN6a2dBcVdOWDFVaVZjWDJzRkxYQ1piWVB3VUxOS3phNlhpRTRjcVd1Q0tH?=
 =?utf-8?B?KzRhVmJBN3VQSWszekJjOXB3TWcwVWJVM3BRRCs5N0NQMXpBdTBPQ05kd2oy?=
 =?utf-8?B?MUwrSzRMQzV6LzN1Qm1FSE5qNE5aUFJ2eXNZZXBEU2kxenRzV2dFNzZtaTI1?=
 =?utf-8?B?Z1EyaG1URmQ0aW00UTlwM1l3bmRQTCtsOFpGWkxsRnBKU1BHbDFJOW8vaVhG?=
 =?utf-8?B?dkl5bko2dkJmQzY2ZmZQWjJ6QlE0RDdzM2dKUFlEYlEzcVQxZFZOeFRacHZN?=
 =?utf-8?B?Sytucmdkd0VCMzJPbkFrS28vRGk2NTZCZm9XNzlMeWRUSjVUNEFsNWRIUmFK?=
 =?utf-8?B?clNDZjV0YTYwd0wyRXYwTlhyUU5ydmJtRGhwdmFyRGtJTXJxRzU3QWhvcXd5?=
 =?utf-8?B?Q2JMaU1xakRaRWlBcURkTlpFd3VwcGJMbjRpb0RJOGxWTlVLemdEdHcxNWJt?=
 =?utf-8?B?bEFtdVBZZEpsNlk5ZG8zNDZYenM0SEhUakR4YVdLQUR3Mk44R3Q4REwrMklC?=
 =?utf-8?B?dWdCajFuUDdSTk5xQnBhRDlIanNjbVg5THNuc3NDQTU0c1pYU2pZTzJ1NWIx?=
 =?utf-8?B?WUpiVDViaDlYZmRyUlEyU05EM2VUNllpSGRyT01id2Y5T0lZT2Q1YTlpSjNw?=
 =?utf-8?B?RHRSWGUydnFTUmVmZ0I2ektBWXFPZUU4ajlJRE5KN3NkdG5paG8rK1FFRHdG?=
 =?utf-8?B?U1pTMUdTcng4cG5objJqb0xYTSt4Q1F4RnNPMlhWTFV6akNQYkd2OXk2cStV?=
 =?utf-8?B?cUYyd1FUbmZsZW5CRDFndTMyRi9lMUJzM25JazRPcFh2dDJmTnNKN1RBK3JI?=
 =?utf-8?B?WlZtY1k3cDhoT2dKTUFRNGhvVWRvMXpOVEJyc1NkNGU1SGlqOVpWQXBaWXg4?=
 =?utf-8?B?LzA0aWpYdmhEKzVRZUphSUxhbXhsWGNqZVJscVFJYjFLMk53bjh4YUFCTFRm?=
 =?utf-8?B?NjR5UDVGVWljcFRKV2MvWVpXdWtubXVMYkhhOXphZTNHYmRoV004blgrdG13?=
 =?utf-8?B?Zy9yVUhUME1wNk5ZN01CRGRmYWQ3R2dvZXhxSnRkZmhwT2VuRHhYUUZIbXdT?=
 =?utf-8?B?T3czTENvWFVXMmdjcWdxN2hNOFBoYWVXTGE2MnZOci9aeEtlV0FZR05MMENV?=
 =?utf-8?B?a0cwRE1CVXpGeFlyeXh3SktmaXVEVGUvb2Z1SHJpbFd1dEdURmdPMUJDZG9w?=
 =?utf-8?B?VmJvUVZkR1lYVjFNVnlrd2ptT09yNnN1SVRyZmdkbHZEYjNSdUsvQVQ3bXNY?=
 =?utf-8?B?d2dLaVZITjFySDAyd2J4K3JLUWpZTG5SaXA0TllsRXloam5LZ0RNRUhXNlVz?=
 =?utf-8?B?cVpXaVR2SFFibnhPK2RUbkVKWTN5VHdlbEtwUmoyS2xnVEpVRDA2clRrdlJi?=
 =?utf-8?B?QXZseEQ0VUxoajk4UDg3ZFpoS1pOYmtQV2piN21qeUJIQ0xhU05NV0wyUlN1?=
 =?utf-8?B?bnAvbE82a3UwY0l1aVIzenBBblNaaGVkYWNDYlgxZEtxbmhjbXlZOE5TOTRN?=
 =?utf-8?B?aDcvRUJkcVZYdTkzdmIySVFWRXluZkYxcDl6NENadGFQakxLTnRETVZhVmNh?=
 =?utf-8?B?RHcvcWVhNWJiTWpIcGZmUjE0Vit0VzJ6RXlnVVBrR1M0NUdoMXVPRkxDME1w?=
 =?utf-8?B?bkg0cWN4b3lCZjlyZzZmTklnN0kwZ3lEV0JtQSt4cVFpTUdDcHNoQlNHd1RQ?=
 =?utf-8?B?enRxSk1ydVljOGR1eUtWY2paK2ZvdXJCOVYyRmNPcDJpSXpWTzVLU3RyRnp2?=
 =?utf-8?B?T3ErTlNGSEJQMnVIOFZJZERYL3grcWQwaGhUQ0FuU1RHWnZ3Z00yOUpWakx2?=
 =?utf-8?B?cGI4aERCY1lUUmpiMGowd2lqdlZ6dm5ZSW9NM3ppOW94b0RjbnlaUnQxM3pL?=
 =?utf-8?B?c20xTVl4T0hrVVpTVityZVltaVNMS2YvSDkyUlNkSU4zazgxQ0xUWFFZSGtD?=
 =?utf-8?B?UDN3dEFVM1RiS254NnF3VHhUZVY0OGF1SXdrOHA2azBOcjZIZzV4RkdPNTVs?=
 =?utf-8?B?UmhNcG1zaG1LbDhqVWVNeDFOczhrRTZsZGxIdTZvRHRMN1ZlSG9CUT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 b773cf9e-ef29-4c0e-ed28-08da16eed367
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 ORu/0PD9tze/oZjUZWMptNG+d2E6Nr/BAWT43AVL8YFLcjQqPiMZ+zz+b6iNFfo/GwHBAgjUNrxIUQjNAhLaYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5518
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
 include:de._netblocks.mimecast.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: G8ZDoXx6tnlQ8UR_44SdyA-S1YRhn47j
X-Proofpoint-GUID: G8ZDoXx6tnlQ8UR_44SdyA-S1YRhn47j
Reporting-Meta:
 AAFnUheIjBauwq+2SK6rP25FvUHeJK2d1fhZNorGeIJBjP6YIaUcxv7zIXSCdddl
 EdcJXmKB5OXguEG2MLlY0PA20kwe05G/A4aQaI3TZxmBkimMMXB0MKG3Xdo6s5R6
 xavet5rKhAqr8fzUjzqv0HyHhnHeleLsDP5+wHYWbWOJhVXrVZPaT80bZ8NModyp
 I6gIh4etmbCe7b2twty1tnGvumhCETDuakQsGWHiB1janTsCjBdsajpKMgGaRvgU
 JZx9OInY3X7ByXX67fwf0ELKqgHYsV06/uD/+cXClkQPHLC6nkb1tMX6YpyGdXLf
 HP0BOUwP8YHPpODxP9hv/SKMtnQIKy9iPLaLPXLPP0Sfl+J7jFhi0Bp1jAaU/cvC
 eS91pBqM98+Bc8WPVryAb2sjb5tgmFYckG/gztW9XxyC77hFDX78DWp8F9PYz3Mq
 Evj/HcllthdcUC36cmgl1O8Z73pyk1Ft0/kpGalNC3Gt8o100aeyTU/V9Y+AO6Ht
 AQYb4gJJh9M4e/3ax4na/93vHYpxnLN3yd96PZbiVHs=

On 4/5/22 00:40, Heming Zhao wrote:
> This is draft version, It only passed compiling & mount/umount test.
> I want to know if my idea is acceptable for maintainers.
> 
> There left one issue: mounting crash when no dlm connection. I still
> can't find out a better solution without directly free inode memory.
> So I marked the related function (ocfs2_release_system_inodes) with
> comment: "/* FIXME crash when no journal */"
> 
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> ---
>   fs/ocfs2/reservations.c |   4 +-
>   fs/ocfs2/reservations.h |   2 +-
>   fs/ocfs2/super.c        | 156 +++++++++++++++++++++++++---------------
>   3 files changed, 99 insertions(+), 63 deletions(-)
> 

For the issue: free inode trigger kernel crash when journal un-init.



There are three solutions:



1> Revert commit da5e7c87827e8

    For avoiding kernel crash, this make sense for us. I only concerned whether there

    has any non-system inode access before dlm init. And my answer is NO.
  all journal
    replay/recovery handling happen after dlm & journal init done.
  So this method is
    not graceful but workable.


2> My v1 & v2 patch, keep da5e7c87827e8, and do some checks (osb->journal) in

    ocfs2_clear_inode.

    tThe fix code is special for mounting phase, but it will continue working after

    mounting phase. In another word, this method adds useless code in normal inode

    free flow.



3> My v3 patch, directly free inode in mounting phase, but maintainer didn't like.





If maintainer didn't like solutions <1> & <3>, Do we choose solution <1>?



At last, all above three solutons had been test (without crash) based on my latest
patch.

Thanks,
Heming


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
