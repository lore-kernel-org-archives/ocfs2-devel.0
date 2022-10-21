Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4DBDFA3742
	for <ocfs2-devel@archiver.kernel.org>; Fri, 21 Oct 2022 17:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=hpWGsksWB0ojc+YUBLmYMPIXKtSXQ/PJ5Igb38UXSqs=;
 b=SOlZs5DEPUYxysR7uJRjBJ+sr1wDp4iC3baGbU9q46MzBf4r3kA/6CCDuuTHf8pjLax9rveNLmkx
   dytQ1r8uRCZP6CFAVjKHjqbps1Xv4kYXlI9oJy+Rvhrbs0XJj4F/5LGCr/o7kWRKzEFD2yz5A6f2
   7rsG5OwfL/OKekPjMPMBi3Rg3XmRzKPSaZJhKNm9GV8B8evgFkP6mcLk+nvNIwqo17q3PxntG5NX
   v3NrbpPmKiZAt5bpT1IUtmjHni3FfGCM3FlmKa+69bRyfmUZFumSvUh8WaIcWlx3saDd8HXOkF+I
   ddS8nYjiLvBrtz9B/oR1OPRBgm3jEejtLYLafQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=hpWGsksWB0ojc+YUBLmYMPIXKtSXQ/PJ5Igb38UXSqs=;
 b=eQQ9907uQO0fH/LoCEz+au6/tcEt3dtyhLbLCaqHgFLDovQXEU6igu9v97IcjErLo5YWcGnMasTL
   kFGzq+uV/kDXZ0kWuWoqzbiM6uStpwQqLCvWZdrC7+B4CffCBmECWgaS6Yq14jwH6GBhpPvk+gK/
   GRqFHNWG2rvkh/t4kVIo9Xm9KcZAEWlTcJATRaObrWADAp1u8dGdD2T+GKrvD1KwxtxgPgbzfBSg
   yXufj5IfLmfcG7E6MohxYv81U32fDUhKbGjoHivwbo9dHNAFoPPgAu0lpUPj1JvHz8OiXOp7EOlG
   msJ8IYsuCk13gFaapXMfs+tfEup7IDdVVp+DDw==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220914 64bit (built Sep 14
 2022))
 with ESMTPS id <0RK400KDR539QED0@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 21 Oct 2022 17:11:33 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cvqp3P3B8BLfAmpNZxHvh7i9DBRLxrF0L/Puf+VClskgfrGn6tLUXXdLD+sHtspD2l57WBbG2sjZXzUG6eiPg0fU4jRvyKPxdOw6GkssGXnsjsRrL9aZ4M6qGsrWDrN1J4VAE6nd64uj3ZIumGRMhdXMHTT8uIvxSkcOO6Hac8nLvgmtOx/DEf2WEwHPE4xZEhCUfM3uvaVO0tPrVnmu3szQEJAv0N6hVRs38BgnAA30Xd1hhOrzqwbj2MD4CZ06cYwpIMSiJRVJouM1O2UVPuLKefpkM8lBbJMVqnzgbK2k+ke7+RkXiWWZD0mY1Y291mXuICqnfv9gfQIbujqbeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c1p/x8XJ+Q362Wu9z4oBoXAVVel641qCZMxeygRMU98=;
 b=mbQtjLOiAVIvijp3wfz9SNisohTWlTmCr+CaK2KbmRjNdggP7RN6VTe5KnTkk3Q9Na6J5WGrNntWGz4iFlAdTMFNvzSqkcdP9ZPwkWnjTj1xTOFM6DZFwrmpDiciNvlWtEe5G2CrwXG/CXWKYfQvvbSCnquY2VQwKNElLbwaxWx7z9QCaZJ9u2TgxZjwmijEoVfBoHs/zURaraT/erHU4XTzMVCZmpGB99rKRz46qwgCjnPjBcOX6xJ9yjY/Lqy1aa1bKS/Lw55thpRJ+fwE7RCFoyPVRWpJ/+S9+ijFYIAGBptPbVSpVkEzPGOqPBmpdfrPU7CX0x/BOhpPyfKppQ==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c1p/x8XJ+Q362Wu9z4oBoXAVVel641qCZMxeygRMU98=;
 b=5qc34ng+gRAm2isjW+n5AB+xpET61TNj1PNivsUyi2YfAKrHCEgoG+RV8GyZQoU/FRd7wl6/rY4hsKNJwqHP57KHUYGubRVhZ3HsoLDhdS3PP4UUDKAa95v5p7TK7lt3Qn4bWxlRHnbuzAVjoiqoky2DIOvPde++XR2UCUef75o=
Message-id: <d559793a-0ce4-3384-e74e-19855aa31f31@amd.com>
Date: Fri, 21 Oct 2022 01:29:31 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Content-language: en-CA
To: Yang Yingliang <yangyingliang@huawei.com>, linux-kernel@vger.kernel.org,
 qemu-devel@nongnu.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-erofs@lists.ozlabs.org, ocfs2-devel@oss.oracle.com,
 linux-mtd@lists.infradead.org, amd-gfx@lists.freedesktop.org
References: <20221021022102.2231464-1-yangyingliang@huawei.com>
In-reply-to: <20221021022102.2231464-1-yangyingliang@huawei.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM6PR12MB3370.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(4636009)(136003)(376002)(346002)(396003)(39860400002)(366004)(451199015)(36756003)(31686004)(31696002)(86362001)(5660300002)(7416002)(38100700002)(4001150100001)(44832011)(26005)(41300700001)(2906002)(2616005)(83380400001)(186003)(316002)(6512007)(4326008)(6506007)(53546011)(478600001)(6666004)(66556008)(66946007)(66476007)(8936002)(966005)(8676002)(6486002)(45980500001)(43740500002); DIR:OUT;
 SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2022 05:29:34.7082 (UTC)
X-Source-IP: 40.107.220.75
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10506
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 priorityscore=233 phishscore=0 mlxlogscore=886 lowpriorityscore=0 spamscore=0
 malwarescore=0 adultscore=0 suspectscore=0 clxscore=264 impostorscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210210031 domainage_hfrom=13122
Cc: alexander.deucher@amd.com, richard@nod.at, mst@redhat.com,
 gregkh@linuxfoundation.org, somlo@cmu.edu, chao@kernel.org,
 huangjianan@oppo.com, liushixin2@huawei.com, hsiangkao@linux.alibaba.com,
 rafael@kernel.org, jaegeuk@kernel.org
Subject: Re: [Ocfs2-devel] [PATCH 00/11] fix memory leak while	kset_register()
 fails
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
From: Luben Tuikov via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Luben Tuikov <luben.tuikov@amd.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ClientProxiedBy: YT3PR01CA0006.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:86::11) To DM6PR12MB3370.namprd12.prod.outlook.com
 (2603:10b6:5:38::25)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3370:EE_|DM4PR12MB5796:EE_
X-MS-Office365-Filtering-Correlation-Id: c28566e1-cfbf-4438-67ea-08dab3253d04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 mjWTlJ3Cv2/NULzy2Tc/vPlmV1pquOu9JJpHuBRHadPSWO9WG7mI5LRewAMLLM8Fwbt1IwxsJ7d63QBVd5/QMJ3xzdznICvg0MENoiuIBR3+FzawRsnpGezkk4+BDlVtwb6DSxRHE/QpV50QTyd2hHXLtU1Csld2td4wd+GPY1okb4Xj9sPSOc2hcU8WfdSxMG0blhkkjv4xMMnQZhT3pd04DroIdsH6NEQ51ibKfXcoDQbTQPfB6D/y7ZcI2oAiCjM5RIWLL2F1O8ouOBUvcHO5tb1FmYOx9osZXajXC9YtuVC3l/t9RJR9q/KhdXhMtzovyBRvvENKYIakR/j4pbZ2RdCZ9HWAmX8M/AS7VT1kVK2RAjVgOuhkQvbSWj8Qk69i0yXXZCTtTvgllUCwsVDK9+nSjtH9QUCeCuOf6aBMInSjslizYFzHulVZTBkQ0sE3uYM6utUh7+n0aNFpJs2STvSt2DCzBuxmr8ZzWCUzrK6UKK6hs3x1umkdWfFWf1EZXe2o7/jqKD7QbfZAqiTPPnqjC7Iq/HihwxIIl7UNTDXa+5ABMBvvYF6bW2pHRJG9xh48T02IyyZxcDZhlHhQA9J8/yuyNMauyQujmbyy8wgkeZP45quE09aJFQ05NkRWHDCsGkCuj+/2h0ZZEClofr5LSPMAtmWB9Zmyvm9e4uLF89Rr/Y8++k+fZ6AAxKJZBu/oL5AxjrG5kwMwU+3hiI2dAkPx2iwpnjrFEF71UrWU6F9cyzMY82azhObAQR8/BVRhj3wuICFWEWTQRhmGT7zJh/Iu0btVUHwtzyBzklJg9/atoyu9ZsWBhTfiHBZAC/IQVEtqF5f5NfajGw==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?Wmw5T0xrR2xpTTQ4ZjNDOWYzeWgrNkovb3dEdlNNNXFOeXhLejVqc3duRkdU?=
 =?utf-8?B?blFLY1VEa21IMEhlOHdTNGFJeHo1bzZQT3cvYW8waHJyUmFBS21NVGVNT0F4?=
 =?utf-8?B?WVZRUjU3UXBUaTZ1MUlJQ3pSekhkTVVhR1hRUTJqQmJkM2VYWVVQWGYwMzhS?=
 =?utf-8?B?VEc4SVJxcTg4aWZ3UGdrN2J3T3YwWUdacThiUW1kbjlXd3hEZEh4T3ZqU1Js?=
 =?utf-8?B?a21QOWNkZXNFVk9JQklVRXJ1TDhPVGJ3NzE1UUhXaGE1MnlBYVpubERPUDdh?=
 =?utf-8?B?K3J2eUl1WWNjc2NyK1RvdWI0NDRCM3M0eVVkWHhLODFnMFE5NUh6SUI5Tzl4?=
 =?utf-8?B?cG5tVXZHbmpqQnU0dVp3L2RMRWpWL0NHOHcrRHV5Q21HWmFsQkFzYlExaGJp?=
 =?utf-8?B?dlowS1Z2ZktlOUMyMzEwdGR5bDJ6ak9IR1JQRTQ4M0F1em95a25lRHZSUGwy?=
 =?utf-8?B?Z3MzcHIzbFd2WUlqcm00WGFVOURDYUNjQWFlVGxUd2x4ZDNjdE9LSUpTVGtX?=
 =?utf-8?B?VDFNK1hCYlQydGd0c2grYVUzVHFiWHBxdmpEQ2xSKzE5YjI5aHd2aE90ZjNF?=
 =?utf-8?B?cnVxcGFLb21weGY0MmtyRVBWZmJYM05JaERTektIaHE0MmVqbklpbDVjdk04?=
 =?utf-8?B?Zkw1bXJWeWdTdEgzMVJRNU5NKzlpMlBsTlZURkQxME5lcVUvRkUxYS9MVDZ1?=
 =?utf-8?B?ZDBYNDBYQ1VuV0NuOThOZ0hzL0Y1dFltUG1PYitXbkZ2Q0hqM09ydktpd1lm?=
 =?utf-8?B?cG00SzVTeDJTWWk5MVZnUTVoaC80cCtUMFQxUjJWWFdwRjdsdHhlVlFCT2JH?=
 =?utf-8?B?YzBYTXJzSXozNitJck1IQkZqeFdWQjBvajNLYUFjditESDcya3hwd2MzUkE3?=
 =?utf-8?B?WGVmLzkxNnNZNFFPVkRYS2RZYmxEN0NKcC82ZmhUdGNSVnc1TDFtQnJvZ1RI?=
 =?utf-8?B?OEJ0M3Q1bTNlenBxSm1NRHhKQmdKNjFkYXp2eU5GeVI3VDJIYVB0SGZOODYv?=
 =?utf-8?B?aTlnSURSVmp4YW9pRkh6RlkxZG9Fb2FKM254NkJjK1F3SnNHaU9Ibi9HTTYx?=
 =?utf-8?B?TDlKY1Zvb1dESnJ6ZXliR1hLSTQ5NHo1RUNZOGFpZk9OQitWNFF1K2JhcHhv?=
 =?utf-8?B?MVBwNE9lRmdsMHB6VlJ2b0xaR3VQK0owZzF4WWJkQ05zaEF2L1V0ZVpKSWN6?=
 =?utf-8?B?bzFQOXh2MUFQZDBGNHBKVXRyZm42WnR5a3RaVHZCL1pabzVIb2I0OFhBTlVs?=
 =?utf-8?B?UmY3RmdDcjN5SnFyU3BwRmJhcFUrNFppbDduL01RZFZRVDZFV2JPRXdic1Bl?=
 =?utf-8?B?aU54c0huUDJrMWxkRmhUdVcwT1h3V0ZaMGJQS0pyb2FyWlBFMXZlVWc4SWNN?=
 =?utf-8?B?ek9TYmJjZ0srZUZvOTF5MUdzeGk3eEZCaWp1aXBIaGJPMzJMcmU5K2Qrb2I5?=
 =?utf-8?B?RThpNjdEZCtHQ2pDTUxQOGgvSGZOamMxWU1LNFJrQVo2TzZ2cWJqQlhmUnRj?=
 =?utf-8?B?Si9vVTkwdzU0dnFzUld5RHdLS25yMEJ4ZWN3T2wzeVQ1Y1MrRWVER1BrOWJM?=
 =?utf-8?B?cjdGdHBVcGpVdzlLZmptQUZSZ05WS3FwdERVckNVQWxHRDZudjYrK0NwcHRp?=
 =?utf-8?B?c0ZpTVM4eTIyOHUzbmV4M1g1Zlo1QjFvb1ZPVjZCNmNqaXhSdVJzMVhZMTJ2?=
 =?utf-8?B?b0xRdXpKOGVBcGlJelA5Y3UzQ3hNcWJ5SnkyRUUxa3RPUlZQQ0hkb0c4M05T?=
 =?utf-8?B?NHJiQVF6bnhBbmpKSkZDaUZSSFhCdk5XR3orVFphVlhVZHdNZ2F3Q1dZNDBo?=
 =?utf-8?B?c3pFMEVtaldJbGZmakFLSGUxWHFmV01XWUpBSklPWC9XUklVUVpGcXI5ZzBT?=
 =?utf-8?B?VE1tdzlzLyttQllkRVB0aFBIbWFOMnZ4QkJaaVltajdMdW56Z1o0MDhBQjNh?=
 =?utf-8?B?ZWFQWXdmL3RrVkpYeThFYzgxb2FBQmJqbFRUbXRoQlAyN3pqNmxUMUcvcTFZ?=
 =?utf-8?B?YTZvQkQ1alFaUnRBOEJJWmh0VTlWRndCVVM5eDIrUXc5aHhRbjdrVWhDUlhB?=
 =?utf-8?B?Tjh5NWJ3M3krOXRIWGhmM24ybzZWZjFLdGt4RkxsK3VsSHFOMXlHZUZqZktp?=
 =?utf-8?Q?3UzzgtirfBpiDA4Ptxkl45avu?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 c28566e1-cfbf-4438-67ea-08dab3253d04
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 Hbu/u6glgoW0HucQLPGQd6k/0y2eEgO7DiDM7flyTq6Wd4We8kaohSkQXEa+eJKK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5796
X-ServerName: mail-co1nam11on2075.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:amd.com._nspf.vali.email
 include:%{i}._ip.%{h}._ehlo.%{d}._spf.vali.email include:oktamail.amd.com
 include:_spf.salesforce.com include:mktomail.com ~all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: ofugeKP4IZgasOr97w4PTHqmMe12g_aL
X-Proofpoint-GUID: ofugeKP4IZgasOr97w4PTHqmMe12g_aL
X-Mailman-Approved-At: Fri, 21 Oct 2022 17:11:31 +0000
Reporting-Meta:
 AAFHorNevimhJsbtue9YNdptmprKDl/hymWXJCbQvv1/Y9eG7AE8JQl8WuWF+TYz
 JpmwiUbRRqqB1v38U0A+jpYhfZ4tOwoW7VYvcfXJ2X0KATzVOH0Cl3rzIlZZWu8u
 zqx9f4P305jFiFqEz7sMjSfEJJZ2J974nGcOYEXvVX368zwPsISF57NQF8v9McRZ
 T42DjczwSteuJDO6Z+Y5hE97I2/CDsJfVEJljT3sH9aOpUUvjLqs3b6nSVJ0IQyS
 oECJVxIf0SfGwXxKkFiirLFcKENwAoNAkzZmsEEnerjQZagVu7fbPQxmSKxrmAY1
 7ZMEE+ssn8UIQwVb4nfNfek/uX6LIVwfMGqn1STabwe5DTmkOOfQDMVgKgig72+I
 KoIpv+j+9kLKO1qwM/m58e/JgjIuFmZZ017fY1+qor+jj1Q+uhAVibzw5tMHwbMj
 tLHlJZnTK4PXawEdLG2wewZ6sAgB+pjEcC5hb54Cc2LD3/NYnLYvS0GryO/79ifP
 L8yPvmJ2zAMRO/llP3nxDK613ElVy81Wod7J84HcqrA=

On 2022-10-20 22:20, Yang Yingliang wrote:
> The previous discussion link:
> https://lore.kernel.org/lkml/0db486eb-6927-927e-3629-958f8f211194@huawei.com/T/

The very first discussion on this was here:

https://www.spinics.net/lists/dri-devel/msg368077.html

Please use this link, and not the that one up there you which quoted above,
and whose commit description is taken verbatim from the this link.

> 
> kset_register() is currently used in some places without calling
> kset_put() in error path, because the callers think it should be
> kset internal thing to do, but the driver core can not know what
> caller doing with that memory at times. The memory could be freed
> both in kset_put() and error path of caller, if it is called in
> kset_register().

As I explained in the link above, the reason there's
a memory leak is that one cannot call kset_register() without
the kset->kobj.name being set--kobj_add_internal() returns -EINVAL,
in this case, i.e. kset_register() fails with -EINVAL.

Thus, the most common usage is something like this:

	kobj_set_name(&kset->kobj, format, ...);
	kset->kobj.kset = parent_kset;
	kset->kobj.ktype = ktype;
	res = kset_register(kset);

So, what is being leaked, is the memory allocated in kobj_set_name(),
by the common idiom shown above. This needs to be mentioned in
the documentation, at least, in case, in the future this is absolved
in kset_register() redesign, etc.

Regards,
Luben

> 
> So make the function documentation more explicit about calling
> kset_put() in the error path of caller first, so that people
> have a chance to know what to do here, then fixes this leaks
> by calling kset_put() from callers.
> 
> Liu Shixin (1):
>   ubifs: Fix memory leak in ubifs_sysfs_init()
> 
> Yang Yingliang (10):
>   kset: fix documentation for kset_register()
>   kset: add null pointer check in kset_put()
>   bus: fix possible memory leak in bus_register()
>   kobject: fix possible memory leak in kset_create_and_add()
>   class: fix possible memory leak in __class_register()
>   firmware: qemu_fw_cfg: fix possible memory leak in
>     fw_cfg_build_symlink()
>   f2fs: fix possible memory leak in f2fs_init_sysfs()
>   erofs: fix possible memory leak in erofs_init_sysfs()
>   ocfs2: possible memory leak in mlog_sys_init()
>   drm/amdgpu/discovery: fix possible memory leak
> 
>  drivers/base/bus.c                            | 4 +++-
>  drivers/base/class.c                          | 6 ++++++
>  drivers/firmware/qemu_fw_cfg.c                | 2 +-
>  drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c | 5 +++--
>  fs/erofs/sysfs.c                              | 4 +++-
>  fs/f2fs/sysfs.c                               | 4 +++-
>  fs/ocfs2/cluster/masklog.c                    | 7 ++++++-
>  fs/ubifs/sysfs.c                              | 2 ++
>  include/linux/kobject.h                       | 3 ++-
>  lib/kobject.c                                 | 5 ++++-
>  10 files changed, 33 insertions(+), 9 deletions(-)
> 

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
