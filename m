Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62241C00140
	for <ocfs2-devel@archiver.kernel.org>; Wed, 10 Aug 2022 23:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=WfpASaJF0UyOjZQBWGaXFKQj/W86MbKPsh2+pdbQtR0=;
 b=zYKdaHnWZijNxKpk7pLFXqiVaRH71umemWqtlBYdqwgcgEannQniA7jxdR8+8F/4C3slwBagopIi
   +p+TIVdJX481Fui0fhhDTmA2EDkRfxVw9aeTQHdrd1AtdwtZnu3qs9ZQ2HctjG1glqPQ77o89yyu
   u5QHnXvEbMuimJiWNMcN2vdcugbfekYK3emlHVYwvfNN8zMxL77dq4o49ub2ke3C2coGrJP1GT9b
   OaUw2uAJf5ZjOAcgf/S9N+nWX6/pNP/KyfqLPV2JA5p2CuloDVLZ2Aj1aFDDrB2mvy+d9pgtmqI2
   q466tf0egyoqrzNbmdXlPYwwdnhfKqapPjCMvg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=WfpASaJF0UyOjZQBWGaXFKQj/W86MbKPsh2+pdbQtR0=;
 b=cN7g10pJJXln+gE3Vkxh/2ID2tIyIKb/Lhzokmkvn6PsAGogiyaI3T6Ldsmdnd/PwWF4O+p1e4i8
   LA2LOKF2rQOANZNGW/71gXroXyiL9TmOBijgKMCvBW/30/fYk9BqdtGytPiZN3l58S1XmzA/9IKU
   q8hSG+3905GegZJ9z0UCZvmCzwUK62iOa7vv9lkwMmKkXqnGz8RLMzchv3xsnjfc7GfBAv3cw/LC
   QVrqGzTIei8Q9VyC8Ck837aKvrYto2g4t9tuznEA/ndvYrIB+cdJ57lEbe8rlNU7C5LAfrdWsQdF
   tL6uA27Sh3SltvaMZFIaSdGAj5vk4mAu/58cwQ==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220729 64bit (built Jul 29
 2022))
 with ESMTPS id <0RGF00E19BP80BE0@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 10 Aug 2022 23:53:32 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TD6PGy5s/y32Ip6SO3JLAx6bISf9jIq8RfcFLYLljOXKroWUB/w5gFYAZgrOBTbpJJpNSW7UCJ/el3xuEZAak2WyJmc8DlIbQ9YNFq0gxFSJw2ZbVtw3atiuxLbG0Fu3q+2rJ2Dti5tFfXlDzk2MTuF4zrQ9GstcXF2qTqDIhB2XCat0XeSr8rNZRPtc4qGnK0rHjb+LLBtRmDqxs3T8elgEBnGp1754XrxktakQVztyoEVbqIjKhPpEuHP1zQbfu12WUQxpoxLcGf1ZHsNqJd02SPTr1yndzybXHfu5l/rMzvJC4gf9Nr4mom+HGmc4yrbnhJjBqTu65dbJXOPMzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HVgyk499wXt+GRMfgt+x8xs616MSiv2xRAsz/Gf6rFI=;
 b=ct9cUtVXvbsaRNfiHSnmcXExn7QKiDg6EJOkdfAamzWsG3/EWjQPTw3em6qIG2om0ebRHeykMv0FqNBvEi4SoKGxeFnB77JEq0ElLF25CpGVbH/Er+I4G1eG/DPH0HvpwVWUf9B2j8iRlN1ii/D+Nw/jaDsiz7L4avqOMJBQBIDEd4qGzvckA9yFbtirRxZVrierPNfHxdGTm3ZUv8n/Qhd8G2+FPwA/aAaFfPRYuLZRezFp3MqZE1yNfvxj7LNnUAZsLpd12+URRNj7kGmn5+6qggVx7gNL/OOf/bRiQsRVFia4o6yhrBMbWocH6oik+0nl2M6n7bQIbaefUFMwxA==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HVgyk499wXt+GRMfgt+x8xs616MSiv2xRAsz/Gf6rFI=;
 b=5XGtyLuPbRhKz2Yx27zvnN8LCG9+8McSv08AGpTSErHdKLVuPGc0L9HRmuZ2QKnZEVJqSZmgCJchIEdAY5hEQMDoD3yzhYUOkAe/sPhLrAb+CJXuII70+RjIPGuoAAxtWcJipV0nZPECUqtezOOmPg4DKokOEzksca+NF2k+cpfWebCq+OIO2V22oJTur0psqieisV3OUe6NIRytd8nAFXnLW8eeyoXn6tSQCZAF7Rzl21FEa4wcYSOL3VtSBwNeHEupOIeJz8GMgsSqoyHKP9w7gHHhj4y2hHnfCx6YbNXn1WWx09V7OovBex3CeoXhirx49EyzboXeppMlgLsOOA==
Message-id: <20678917-26f2-b67f-220c-48aa06f38f79@suse.com>
Date: Thu, 11 Aug 2022 07:52:59 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-language: en-US
To: Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20220730011411.11214-1-heming.zhao@suse.com>
 <20220730011411.11214-2-heming.zhao@suse.com>
 <2dd9c00b-bd33-7368-def9-9572dd7e6820@linux.alibaba.com>
 <20220808120852.6tuj3f3ivsuup2pd@c73>
 <d6f09279-38bd-e9ed-51a6-badf9fb7d366@linux.alibaba.com>
In-reply-to: <d6f09279-38bd-e9ed-51a6-badf9fb7d366@linux.alibaba.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:VI1PR04MB4671.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(39860400002)(346002)(396003)(376002)(136003)(366004)(6916009)(316002)(31696002)(36756003)(8936002)(6486002)(478600001)(86362001)(5660300002)(2906002)(6666004)(2616005)(83380400001)(38100700002)(41300700001)(6506007)(53546011)(8676002)(66476007)(4326008)(66946007)(31686004)(66556008)(186003)(26005)(6512007)(21314003)(45980500001)(43740500002); DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 23:53:10.7513 (UTC)
X-Source-IP: 40.107.6.49
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10435
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
 clxscore=206 mlxlogscore=999 mlxscore=0 bulkscore=0 priorityscore=30
 impostorscore=0 lowpriorityscore=0 phishscore=0 suspectscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208100071
Cc: ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 1/4] ocfs2: Fix freeing uninitialized
 resource on ocfs2_dlm_shutdown
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
X-ClientProxiedBy: SG2PR06CA0222.apcprd06.prod.outlook.com (2603:1096:4:68::30)
 To VI1PR04MB4671.eurprd04.prod.outlook.com (2603:10a6:803:71::11)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6157ec5e-c19b-461a-ccb6-08da7b2b7a81
X-MS-TrafficTypeDiagnostic: AM0PR04MB6212:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 OBhghWAXDmT3f0FRnEfrJNw7FaOZJ4wgn/NkFFWuIS1b5iwabHF/o1lD1BB1gJ9gocA9r0QcqF9d/q720cxgEwjFrUGZkJ/XbP8UYhzmc+HQf70gYsyOpdX0Wmp+DRuDEWseeBu6+93pUbrnVpQe7psQOJUSyQNOUFqzL7RT5XcdnSkEvTHeXgYyZ2fL+xeTZa7jUnAPTOrETnucaL9H/8Oc8rSQcmSID4S4j5FRSp3pfMPYj2SPPrRxy2Uprx5uVGgWuFLn5uH/0jmg04uS2HSwMu/DhHpp+qgNTTo/8p3ed3klOcDv+cywJIbyzeZFi8MxnzhgGOjj/2L6tMhiPDRMqXHtDWsceFvdqG0zhnFEOomqwDW7p7TGMoZuBFhnt0gjnV3Aozm/e6Yeo2g9XNrpj5jzte8zt0L3CzcduAVP10JlwlUX8P1fDyIfk0y88RjGFlh+F0pSKj0VV5yrfniQbVQ/xmqf2lj9e88Av9habfvVpGvQ0rLDDj97jdRNXMkOymXUF18df9821c8me+9yX7NnI1p8TjjjQgy6Jho8Egfjl9IYDfhuzTzpAEpHT8pfcCIWCdhlDkrmnOjcK9FTh9Hh9hb8sDozjSomeAAbb3ansYfmJQbXvnPYQXkstbggGpcEHbKEJP3c7pjvMLU+dR/Q42c0J+x8h2KyanyodnFNmM+1QhfCsv7naJ33UH6HlrRieCnKugs/7417irBsGxv+4wkaaDIRgmua4hmcVaj6mBmEfXraTQA8axeE7Jnyd6Ci4vaDvQBtyhrm0ldme2XgTLaA8809AlbKqNkmNJvD6lw0d3T5nx4Sy5EQrGgUUahWGFdwJh3TcivvdR8q73cB5eM2i27fYTKskGc=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?ZXZqbEFTZFR2eTJXOWtwa0VrQm5ITHNwL1VNYVJ5MHhWUi8yVExFK3dDVEts?=
 =?utf-8?B?SVpzRzhiZVpUeHdXeUFudlVaZDZjNW5xT24xSEplUUI4NXpROVo4R0pXclc2?=
 =?utf-8?B?Sm9VL1llVFN1RjdpbWZXblVJdGVsN09NelpqS0RNK2V4S3ArOWZtb0Q5dVVh?=
 =?utf-8?B?NWxyMXp4dHNuVkdld3BrU24xNVY3WkIyNGlyM2RySU1ZeHhTK0I0SlRBZzJq?=
 =?utf-8?B?UzdPdWsrT0lPZHRSenVObnRwbnBtZ3BQbXNGeGhmaDlFMXIxTDJNTmxqZFh6?=
 =?utf-8?B?b2RhTWgyQzhUTDV3Rjl6djhyM0xST3Q0QThiS1k3RWUxdmVWOGhhZVZKWnpn?=
 =?utf-8?B?aHJaUGV6L0dsczNkYWJSdjFFVXZQQVhYcnFYaWovSUVVOGlsaUtDNUUvSnkr?=
 =?utf-8?B?VE8zNWh4VFdHZWFLSUQvL2tnaGtYRDlvcGxxaEFEUllMZUxISFhhOWNXRW9E?=
 =?utf-8?B?OU5KZW0xVDF6M0J3Y3oxc2ExQVVyRDZFaDJvdWZlTEgxakt4M2xBSitCR3JH?=
 =?utf-8?B?YkVpS3RZNDE3c01VdmZZZGNVTi9WOWFVRWVuVGhwQTIycGxUeDFhMTBkVkpl?=
 =?utf-8?B?LzlmTnVzWGE1UFk3L2FPMFFoUUEzQ3Vpd2FMUFBSMEdDTXpJR01QeklOcHZt?=
 =?utf-8?B?cjZ1bXBoTWtpWWg0SExlK1U2VXErNzZzZTY5Y3ZEM0dtOWJ5dnpmdVp1WXNN?=
 =?utf-8?B?ZXplREFqdEtaUHZCSkM4bkM2TjZhUGR1dENHN1NkZ2FOTlNuY0w2T2JTd1pJ?=
 =?utf-8?B?ZkhFS3gzem0zVjNpL2lkWnFIZldiTSsyTk1qUVNhOWVqY3U5RkduWGRCU1I3?=
 =?utf-8?B?WTZsTXJCdWpENVVpSmRXN0V4K25SemhXZFZLYlYydWlKSWNJa21sSzJGWm1O?=
 =?utf-8?B?OHpDMVUxcEJyemtWKzhNSms5YTZvak9SeGJtd3RTN3FUVVN6TU4wRUVkSUVF?=
 =?utf-8?B?NGdxOVZKL0xBNkRUbUNtYmxyZGpSSFBLalByRU5KL1RJOXhUaEhyTXVybllC?=
 =?utf-8?B?R09ha3JEcTlUNEl2VWpWZkxtNzVudytyektVSTdaWkhqYlpkNlk0SnE0ZURV?=
 =?utf-8?B?V2tsY2lsTW5DM3Y0WmpsVG1yazNPTWkyaEtyWXBSUlVqa3ZmbDNSU3dMakxP?=
 =?utf-8?B?Um5OdTA3Z0c0UnRraTNVbGVkbnMxOHRkVHlkbHowTnhzS2psUTNwdi80Ulp4?=
 =?utf-8?B?L0lwaXlnYTA3WmZtelpIZlp1Ylg4Q3VGS1ZGRU5VU1FuRFh5RFhncUdyS0pV?=
 =?utf-8?B?YmY2M0ljY09BaG8vN1pHMWgwejV4VkdFeVRmM2d6NjVsbUppSjkyWEEwcTNL?=
 =?utf-8?B?QmVKTW5YUFU3cUFKK3dPMGhtbXdVR1QvUTc2eHZnenZOOFQ3LzFJZnJQR0Fx?=
 =?utf-8?B?dVVVMkJWZi9NQmRHS0EyN2lKUFhRamhKQlY4OUJ1TzdnWUpLRUpaTnpUaTAr?=
 =?utf-8?B?Mmx0ZWQwMHgrbDZoenN2a1BPN0h3b1FYcEtNdG84ZzBmQjRpR1BLakFJNlR4?=
 =?utf-8?B?TmNpbjZFSDF6WTJxbUZ6TDdaQlhiejhSVGVYYisrSVdQTE1id2FVc3R3VU1R?=
 =?utf-8?B?b1FPS21SNUdKL1dubEkwZFBZajYzbit1OWJjT3FzbS9JYm5tOXVVbTNIaUF5?=
 =?utf-8?B?Z2JLenZEc1VGMTU2QndaYzJ6WmliTG91a1p3emIrTUFQTkpTbnIvQXdkK3lX?=
 =?utf-8?B?aXd1cHIvMEVzWFpwTFM3UmdIZFF6dnkrQmZ4WG41QnZxbHJlSFAwZnFTbWFz?=
 =?utf-8?B?WkpNczg4T3FSYi9uTnl3aVdWaTNKRDh5Z2NSR3hxWjVXZmxlcFZwUjQxbUpq?=
 =?utf-8?B?ZjRXRmFNbHNPQmRvbnpPYmROS1dlekxadUl6RDBsQVV0OHpya25uZEYzdmZQ?=
 =?utf-8?B?a0hkTVpleFV5UUtMbVc3akcyMnBiZFF5SllxcDluV2Yxd3dzMkp6ZzRJVGd3?=
 =?utf-8?B?MUM4WTVXNmw1bWJJTWNCU0xSNEprYmpOTGZ0ODNhOUtEWitEVkRseVY3elpD?=
 =?utf-8?B?M09NUS9oOXZLQnBLOWRUZTVRcjA2d0Ywb3FCbmREMWd4YktWZmdQTzUrV0Nv?=
 =?utf-8?B?L0hPTi9nRWtsemFwUEgyc2hNNU9sSGQwdmNiSzgwNWhKWDM5M0xsNFVwUVVW?=
 =?utf-8?Q?DrKcbp3hJbrxRvKXtWcjXfKnn?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 6157ec5e-c19b-461a-ccb6-08da7b2b7a81
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4671.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 nJjWn1LGPL3Bv/w9c0oeQtW0drXWIiOX/viM+1YTYZuzlBIFwJzacZnPkJs9XED1KYM4Xkm6ppUOrVmkcDZ4tA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6212
X-ServerName: mail-eopbgr60049.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: Efni8Dv0Bt1vBMqKpxGQw2JJs-7xSzPP
X-Proofpoint-ORIG-GUID: Efni8Dv0Bt1vBMqKpxGQw2JJs-7xSzPP
Reporting-Meta:
 AAE0DVmpuZBIPvB6Aaq4xw4WnbopInKfSF6fGmgsqiVlA/geykI+MVtKSP3Ndw16
 f4J1L1UMY2CNyKi755g06FObeCSZob0Z7GnXMwWT6cYpkrS9j5FqdtYpV8D67ORj
 4RDNYaIuinVoY3H2VHcATNJqjIut0Ca3ehfGRhboqkUR+g2sVGMGjxCPeVSEzu0E
 vBl1TIKAP5BzV7zWq08xiNd2fiT1WhYhn71OWb9ehMJkyMM1uCmIJxavPmB4CRiZ
 2WFVe4CzwYy8YOovEZ/SfmKz9OPccDehupAf8Avs9YptoeAKNyXgyqwQUWNsERBn
 cUmCr3oX5LgD9QedDetYobrbHz16Wo9HxbeW/eojIcF35DktKxTiEJC1e/jGrUOU
 SbM/mWTVrc8PHpH4x7PPs5wcwJiEMtB/3zkeeRxTKX4jblG++slu8IQsn2z0+2Du
 Wq1w55n7XR+amoXaW0FHERlG5j06zu13r1GOQ4nDXg2d8vtpZSxrU9fqjacc7sUm
 mMWkmllO9xo68HYfo3BuoXPd77TeTUFcvBesMG+QKtY=

On 8/10/22 09:31, Joseph Qi wrote:
> 
> 
> On 8/8/22 8:09 PM, Heming Zhao wrote:
>> On Mon, Aug 08, 2022 at 02:51:12PM +0800, Joseph Qi wrote:
>>>
>>>
>>> On 7/30/22 9:14 AM, Heming Zhao wrote:
>>>> On local mount mode, there is no dlm resource initalized. If
>>>> ocfs2_mount_volume() fails in ocfs2_find_slot(), error handling
>>>> flow will call ocfs2_dlm_shutdown(), then does dlm resource
>>>> cleanup job, which will trigger kernel crash.
>>>>
>>>> Fixes: 0737e01de9c4 ("ocfs2: ocfs2_mount_volume does cleanup job before
>>>> return error")
>>>
>>> Should be put at the same line.
>> OK
>>
>>>
>>>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
>>>> ---
>>>>   fs/ocfs2/dlmglue.c | 3 +++
>>>>   1 file changed, 3 insertions(+)
>>>>
>>>> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
>>>> index 801e60bab955..1438ac14940b 100644
>>>> --- a/fs/ocfs2/dlmglue.c
>>>> +++ b/fs/ocfs2/dlmglue.c
>>>> @@ -3385,6 +3385,9 @@ int ocfs2_dlm_init(struct ocfs2_super *osb)
>>>>   void ocfs2_dlm_shutdown(struct ocfs2_super *osb,
>>>>   			int hangup_pending)
>>>>   {
>>>> +	if (ocfs2_mount_local(osb))
>>>> +		return;
>>>> +
>>>
>>> IMO, we have to do part of ocfs2_dlm_shutdown() jobs such as
>>> ocfs2_lock_res_free(), which will remove lockres from d_lockres_tracking
>>> added by ocfs2_xxx_lock_res_init().
>>>
>>
>> ocfs2_dlm_shutdown does the cleanup job for ocfs2_dlm_init.
>> This patch fixed crash in local mount error flow.
>> In local mount mode, ocfs2_dlm_init does nothing, which should make
>> ocfs2_dlm_shutdown do nothing.
>>
> Not exactly, even in local mount we have to initialize lockres like
> super lock.

Thank you for your patient explaination, I understood your meaning, will change it in
next version.
I am very busy these days, it makes my brain stop working.

> 
> 
>> And I checked all calling ocfs2_dlm_shutdown cases:
>> 1. mount flow:
>>
>>     ocfs2_fill_super
>>      + xxx =fails=> label:out_super (checked, work fine)
>>      |
>>      + ocfs2_mount_volume =fails=> label:out_debugfs (checked, work fine)
>>      |  |
>>      |  + xxx =fails=> cleanup everything before returning
>>      |
>>      + xxx =fails=> label:out_dismout
>>           At this time, dlm has been init successfully, we can call all lines
>>           of ocfs2_dlm_shutdown.
>>      
>>     
>> 2. ocfs2_dismount_volume => 'osb->cconn' is true.
>>     this MUST be dlm successfully init case. everything looks fine.
>>
>> In previous mail/patch: [PATCH] test error handling during mount stage, I may
>> forget to test local mount mode. So this crash didn't be triggered.
>>
>>> Before commit 0737e01de9c4, it seems this issue also exists since
>>> osb->cconn is already set under local mount mode.
>>
>> Yes. The bug exists since local mount feature was introduced, commit number:
>> c271c5c22b0a7ca45fda15f1f4d258bca36a5b94.  I will change 'Fixes' on next version.
>>
> This patch can be a separate fix and we don't have to bind with
> nocluster mount feature, even though you've triggered it by related
> local mount.

OK.

> 
> Thanks,
> Joseph
> 
>> (Hope 'CC' list takes effect for this mail. -_-# )
>>
>> Thanks,
>> Heming

Thanks,
Heming

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
