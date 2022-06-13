Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34317C43334
	for <ocfs2-devel@archiver.kernel.org>; Mon, 13 Jun 2022 08:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=E9s+/YXRb+hDykn3KvUf82+m1pxua8vSBSoxj64/yrI=;
 b=Scov7zTLM2FvFlk6G8YiWAdm5Bn6B7SlCiJ31h55RuNG4RDJps4wPjOJpnLalvEfaJbbcVhRva/L
   9nI0BtZeppsFrUYAKj2C+W1dQHYdXa51QVcknHAGm52FZcQzuwPQfsoJk+mQr9a87CFLU64LeMh/
   Fc2a1C2MpIHAsMNLVKtml0rbGvHNK3Fd+JFmykr39T3+FWQPEV1OhrIz3IJ/UTxdUTr+auy2K+un
   6vl2Drsqog8uLRhFTkOn3UyoBwTiAWpdq1hRV5fQMjLs0Q4itGHvUhkrR1x5i8tzHBPrMyy2dOIv
   Iq62Mg5p3WB6V2vBS8orjIS/1r3Ka8fgo/MErg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=E9s+/YXRb+hDykn3KvUf82+m1pxua8vSBSoxj64/yrI=;
 b=JVMWLpS/bktnm4Km3014W6xow6UIO7Uy/VKgRmAgD6LpbldDtGwzDdP9FWSqo6oYQ6v8JNeH6D/3
   /8nchvB08aPa0qVI14QZsW5nIJnTAGXe3l3GhQLzNm6Cr5sR2IZJBGfO7CAezyB6c6qSc+E/n1+7
   I0EPzmvO11l5BD1HsG77uwuztDBxKoth94qUJT4z6oyh4eNITD48iggCrDY7Ym5L1f9pBUNVXgF6
   hO+XXVqZzD63nxDiRmH3tzGsce9HXurUhZXngdBj7z2kK9LCfgj8+v9DoobndZUyUiJ/xVK+8+yS
   XdbF8Dz0yq97qILY2P3btXGGtJd6CtfOw6Ap/Q==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220531 64bit (built May 31
 2022))
 with ESMTPS id <0RDE00FLER4XY2B0@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 13 Jun 2022 08:48:33 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AOeZEgLDiXxAoltSEQCZf/s4v6MMBSk8hW4d1GQJuUeyctKzgWUr+yaZiL+5Y6FbY96MxS59Ij52enPpB/RUHqEaCyI8gup77PbZW6/JYDatjBNmdyEsxf7hKTfe+P0bFPrKDfygdYKxvS81UEZLMh7k0h5uQOiDA/76MaY6TG5sKaeHwF3DcFjFEuG2unNbknu9NIQDeU8tnuBE5KpHYIhC9KzSr8qz5CYyv8VrRwmAy8pBwnFQR760cTuotAD8agPA4hiP7XJnbsCkQ6mX5Rn/dDFn8x4QbHgeO01zE9iIW/paD2Y0bWGQKpthh9PiCU6G1YaKhtYbCqle7uf0lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=av+idlxb2isBU5eUbAEAbNKEcxWn+eLgF8qk8gfgo20=;
 b=UTuIuPPPo9sn+RNSKprZoWOBwU8S1k9fZMLUt4ij+64F6PbIti9UwEli9HzSNIAIn/7UL8aFTG5oYMrwRyNWfDDapY884MkDoK/eRL6idWjmlENEdZCiBBBc/g0GfPnQNDg0ZIGr4d31Kow/NhnOZi2kzKqlm/GtvueZR7uHi0jVKHAZxqw2AviOrDUXjwUk3t4QCxDNtdBhzuB19CbLfjL3OKlx4RBlIFmmx68Qv8H3zMeKLjV2SZZuJ5LXXqcE5sIo8OEcFOpaBGmcnZnpdAg1k67/LfFXqwgX1vKPQb9ARO4L/BLpqSODI2q9TaUgNfKOZhlswLxSPndO2RX9LQ==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=av+idlxb2isBU5eUbAEAbNKEcxWn+eLgF8qk8gfgo20=;
 b=Y32uMTzGv1f4AeVvFtMfAt36ovK48kFW0WatQFxQhLQDLXk3c6vy5EZTVkPvdax9Ui4tMaUIbVaGwC+tpTFO+foYua38dO+TJm1pDNGoWt6rBjAmO04jDCDe0G3Tw1um/ew/eerU3kzKjb4zNexHDxxSYWhtoCtQYqWYGiU6dfWnEV48q/xV9cNILGP/PisAe5DCHzG0NYPmezexh12bPTLq6L4osSo7DjvGnkIEJ2rzHUaFQPGh3vo/9LsRP2FcPDelJ1AablsEtoyTxmOm45i/k345JkIzTKV+UE45Y5zgDbUEKrWYLqimXfs8RveBpbwaxkMsfGkwQsYnIzXUlw==
Message-id: <28b5b33b-1942-b128-d3f0-5e3592338dad@suse.com>
Date: Mon, 13 Jun 2022 16:48:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-language: en-US
To: Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@oss.oracle.com
References: <20220608104808.18130-1-heming.zhao@suse.com>
 <20220608104808.18130-2-heming.zhao@suse.com>
 <09b33ef3-b93a-5b50-d87d-8667ed993e5d@linux.alibaba.com>
 <faee689f-7a04-2042-636c-80fb48bc30ed@suse.com>
 <8dd30c4e-d572-bfd0-f261-b9cfcd8b5b4d@linux.alibaba.com>
In-reply-to: <8dd30c4e-d572-bfd0-f261-b9cfcd8b5b4d@linux.alibaba.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(366004)(6666004)(31696002)(2906002)(2616005)(6486002)(86362001)(6512007)(26005)(5660300002)(8936002)(186003)(6506007)(53546011)(508600001)(38100700002)(36756003)(66556008)(66476007)(31686004)(66946007)(8676002)(4326008)(316002)(43740500002)(45980500001); DIR:OUT;
 SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2022 08:48:17.6247 (UTC)
X-Source-IP: 40.107.22.63
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10376
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 priorityscore=60
 malwarescore=0 impostorscore=0 clxscore=214 mlxscore=0 spamscore=0
 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=888 lowpriorityscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206130039
Subject: Re: [Ocfs2-devel] [PATCH 1/1] ocfs2: fix ocfs2_find_slot repeats alloc
 same slot issue
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
X-ClientProxiedBy: SG2PR06CA0248.apcprd06.prod.outlook.com (2603:1096:4:ac::32)
 To DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 817355fb-d836-4939-e782-08da4d1975dc
X-MS-TrafficTypeDiagnostic: DB7PR04MB5545:EE_
X-Microsoft-Antispam-PRVS:
 <DB7PR04MB5545A4BFDFE8E99CAA753FC397AB9@DB7PR04MB5545.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 /rI6l8c/bXRdVB3RYkvXbUSb1poH1I/dX2lv8XYOcm3F+vNpJwMp5d9UnKgPh+D/g9y6vp1bOBWbZDKFqCWBNGdcD6/xulXEyV2bG2NPseM/6Ud9Au4nV8odfQsGmH9MzSfq18QFsfmke37OUKGd9hZMJXD2mOLPw7kCsIKb5pKUagumI0GGyqqbv3YJz97b68Jnn8vgCgZn6cPROERlGGBy9j8TgeAJgJAY0/7ocLK1JPnj+UAEG0bVhd1IS6mqGWBnCeRq2RNk9fJkgQDaZZxJsK3Rzfsq3SRjHmwOFksBRWndEos4fruf0bQDc7lyZKMWcAs1OmHtOk0k0npvq0qPkuXUnGi8BgD+PxMFmw+wu/9WWNnqG8mr3tof1Lqr0d/eRo119RQhsSeTBJTyCO1jKY4EM4JZ1yBEzgZTsy38cRMmjRWAxpXaBmi/Hr8xcAPX47wHYY3qwO2h3esRPgaEzVreB0Syl0xVUgWrMrWh0gyTUYYIhIYjblmXzbuzOxkjzP2yOXfoMsb/yezGnlGD7x88h5EpsaIOD2CObGJcMI+ctRoVzD3XgIzZ8+0yKFL0e8mFMoAxgjD2XoTYKu4KypgF/2mP/q1wDvt5Y7F1Ds/VTuZVRnJ4GGcpMZ/6aBQxevb6tSUZowbMpxmuwoTdPp7Fh8NFA6UEAsERZkxc3jTW+kmnks/pWw518J8d0GKxzjhORkERp7COSxrGM/4cvc67c7inumOx/IKoxco=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?SE1qckRjc3BVMHQxeHBGVFA4ZUJPK2lIeEtPZFE1Wk5haHZCRHVnODJ3eEE3?=
 =?utf-8?B?Q0d6OFFqOGxLWmdyWWloY0tJZWptZm05M0p6b2JzVWlHRjhaQ1B6Tkxyd2pX?=
 =?utf-8?B?bEU0dG1QS2txUXp3VUp0M2oxc1dDQWVtcTYwNXlNaTN5Nk9aYkgzKzdEb05I?=
 =?utf-8?B?T0dMN24xMzR6VGlLclVkbW9jOVRhWmlrY3JNaU1mVjF4U3IxMzBTRUo2SEVv?=
 =?utf-8?B?akxMSU5uMmVmYjNWbzZ1eUhYMWtvN3NjajB4czR0b1ZJZkQrd1VERWhjRDN4?=
 =?utf-8?B?ZUYzaG1lRG5Cdm1VUWZYSDFqOEZWZGlkdkFuMy90K3U5dE11Y28rTW9NM0Rq?=
 =?utf-8?B?ZTVuZUFGUWRIRWpkYVZua3J2OGl1YzJhdU9qZXVQRGJpNENuY3RpcnR3c2hw?=
 =?utf-8?B?SmMwcGpjbWlwK3JBUXkvcEdqY2I2ajUzRXVqSjN4Nm5NRFdYNGhlTVlFalBs?=
 =?utf-8?B?WDJuTTdLMWgvNjBUSnVxbkZKOHNxNWhuTFVQVkp3WTVINXhTNlFZSm9aK3BG?=
 =?utf-8?B?QWs0RTltcXhnM0wxRDJWMVo4UmRidlB1WDBWazcydmlld3dHbUZLcTZOYnYr?=
 =?utf-8?B?TEJ3ZVZNVExMM0M3dllIZDNUQkJMWkk5OXByN3dzYW1SbmZ3bXUxc0FjT01F?=
 =?utf-8?B?OEZ6NlFCalpaSG5WNFp4dEhhT21oT1FhK3lWRUlMTTE3dlkzNGdWeDR2NG1a?=
 =?utf-8?B?cGRkV2xCTG01RDByNmh6RVcwZFBjSDlyeXBVRkFXQ2hxQmZPV09VVmFRMEN1?=
 =?utf-8?B?SVptUy93SnJrakt6U21ZYy9Od2VWTnpWOG43em41OU1VME53YS96TW1NZVVl?=
 =?utf-8?B?R2JxaWtidmVRbGZ4bFVzcU9IY3JQVGVtamxxaFhXeVJhVS9GZW5RTWsxVkht?=
 =?utf-8?B?Mm0zTVVVbnA4WmxPNWtpZ3FLK2k0WXd3bXVBcWhnaEIwZ3RUWUhnMWM3MnND?=
 =?utf-8?B?MnM0ekJjclBPVnNXTm4ybGZYM2dMRVozM1dVbXBKY3p5bU52b2xqK0dQNTNM?=
 =?utf-8?B?RFBsWHdhRDZqbVFKM3ZTU1FhdFhqY3J1bXNxNDh6WjRpSGpJaU0vb3NQN3JS?=
 =?utf-8?B?eE05bms4cnpGZmk1TEhxUy90MlJBVC9BM2NGSG9Rd2pWOWVENWdhNGxoTXQy?=
 =?utf-8?B?VlBvY1VacjdpY0dHZWtiQVdzYWp4akVUOVhCb3p2Z1dBRkpHc21rTFU2VVBJ?=
 =?utf-8?B?b2NpeVJucnBXa00yUk4vbTRHWlo4enBxZmlzSXd6S0hEaWxXWnRUSFJvM1RV?=
 =?utf-8?B?S0Y2MVUraHlFTTFMN09URmdJalBPMW9HNFUzTXZHVjZXSWREaFBEdGtXaVh2?=
 =?utf-8?B?VVJLR0I3a1NhOTBOS0NqVUJyUjlCVzdMNUJaZWJHQnBiZjk2L0IwRlBJWk5u?=
 =?utf-8?B?WnlWY3JNb28vSDVrSWRuMUU2R2doWXRuMytSQnZRVitxV3daZlFDNDlyaDAy?=
 =?utf-8?B?aWFodXdXR3FLMFEvdGRDUFUxeDViNlh6OWhJYUg5aXBURkhsNU5pY2NzYlow?=
 =?utf-8?B?ZG1nQ0ZiekJWK0lVTHdSWndsb0ZmYWN0VFEwdjRVTW1EQlNERzQvWUtLQzdZ?=
 =?utf-8?B?bUZ4V3NIQlFwanJVV2w0TTArNWtWVmZvYWhEMFRIbmJXdkdiempGUGZCbmNC?=
 =?utf-8?B?NlpBTVNIQlhpQldyZFJjTTNlN3MrZ0NxYmNLenFtY3BnUDFrU1Y3TmNJa2N0?=
 =?utf-8?B?WXRIRWdIdTFraUpKUy9CdExkRFVuUHhHd1Y0Ui9hSXhHTzdHZlNJYThHclV1?=
 =?utf-8?B?ajJJZUdYRDhwQnUwa01rWUVnbjlTRDVpZXFuc1hodjlsaVFrMFpkekMzR2o4?=
 =?utf-8?B?SXp3ajNTUFE5OTVBZDZLQ1dZZmtjSVQ0eEZLcjFweS9UUUFqUVVYN3lsMGZF?=
 =?utf-8?B?TXIzaGFrY1VNaVJFRjBrTUhRTmlaclV5OUE4a1lYWHE3WjhYOStNSUczSGJx?=
 =?utf-8?B?MDgwbkdIVWFTczA1YVBtTGdJUHFMbVZHcmp3SEVPay9QME9yNkVhamkzNHFD?=
 =?utf-8?B?TnY5SHd2azZXcHV0Zkp3bzg1WUxpckVmSHc5Zjg5MGtObmVoanNBUlhzdWpC?=
 =?utf-8?B?V09td3B6UVpHcEdMMGJtRnIyOXpoMHhNczZhS013dHFyTW96MTNNejFENVl2?=
 =?utf-8?B?YUJJZUtlYk42REF4MWtSWkhPaUxRbHBtWXhIQzBQdTNPeCt5K0RVSkJrSWZX?=
 =?utf-8?B?VHdKZThtNzZwR2hrdXd5ZG5QU3VOY2RJOVRLM0RsSXozQTFLVVBaaHZKN0Q5?=
 =?utf-8?B?QXFzaW56MjA3Tm9KTTJjVW12YUc5WE92clE1YnZwSU1BbDI2eE15dDc0amJU?=
 =?utf-8?B?dmRWV2ZDSVVOQ09UaHBENGdaRkxNci8yS1JFZ3BtdFBuVFVkdkVZQT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 817355fb-d836-4939-e782-08da4d1975dc
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 WcGbw2TcLO96W7W5+VULqA86GOsdT/GUD488ARSe4Bv/MmVPVhpTpK5SGTatnBkXrPeZsQmOJoGIN6lX0W7bzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5545
X-ServerName: mail-am6eur05on2063.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: 4j_GXpON0sfJbmz-_jorEQ-cTdIWR_Rg
X-Proofpoint-ORIG-GUID: 4j_GXpON0sfJbmz-_jorEQ-cTdIWR_Rg
Reporting-Meta:
 AAHKXp2Fn1UcrXJlUY05MY5CINzhtm/XpH82tRa/sB6skEeWfEzmTaHLhvgciQ3B
 jnCxAr5rQK54vCss4pai+hhzTDh5eFI4eIxSvGbg2ySN/h1cuIgNU1jziMjIH1VA
 YjOnGY/nS61LFydEuoo4oCfku2AvAyvMnAdO5FMTqnVXTsElR0pWdSl3Urt7xY8R
 5awHSPTkhbpscRuDOoIR3usKl8kH4nanZwk1XPOBmaQ65aRgHUKqI/r3dRH1ZEZS
 zpbiAxljZB8rJ/UWQJwmFrr/DrmRAkKSZP56GkL2KxuVbZv6D5NPpXRZeeLyx2vd
 fishgLRqcHsnDYo1owu79L0PieyIBW7cO8+w2OZgE9dEW+EINBiWUO5g3/4dPyvR
 QlI9O8v2Dx4uUn3LShqFrHpwR2DTMaAKAR9iPKP+bmM+hizORpBs+D5mzZ62tg/i
 AgM1XzN78B6G+nH7AlCl3Z0G9CmPzBuIw9pB/1pvkrlwtiMrZFudC0PjZhk9dsQR
 Wn7LoYRitTW1JMTFlDJaBBb4+o5I0zntI/l3nE+HSXw=

On 6/13/22 16:21, Joseph Qi wrote:
> 
> 
> On 6/13/22 3:59 PM, heming.zhao@suse.com wrote:
>> On 6/12/22 22:16, Joseph Qi wrote:
>>> Hi,
>>>
>>> Why can't use local mount? I don't remember if we discuss about this.
>>>
>> Sorry, I can't follow your question.
>> Do you mean why revert commit 912f655d78c5?
>>
>> or you are interest with the feature local mount?
>> the local mount is created by mkfs.ocfs2, which can't be converted to clustered.
>> see mkfs.ocfs2(8) '-M' option.
>>
> What Junxiao's main concern is data corruption, so I'm afraid we have to
> introduce an ondisk feature bit to prevent mixed nocluster and cluster
> mount, similar to local mount.

this patch defined two new variants/flags:
#define OCFS2_SLOTMAP_CLUSTER   1
#define OCFS2_SLOTMAP_NOCLUSTER 2

(I expect) Under OCFS2_SLOTMAP_CLUSTER, for clustered mount mode and for compatibility,
anything doesn't need to be changed.

OCFS2_SLOTMAP_NOCLUSTER will introduce a new value for slotmap area.
this new value only take effect after a successfully nocluster mount.
(pls fix me), existed kernel/user space code don't do any special handle for
noclustered mount mode in slotmap area. So the new value is also compatibility.

And the patch can also prevent mixed mount, the related code is in ocfs2_find_slot().
code logic:
- noclustered mount condition: slotmap is empty or already mounted with noclustered
- clustered mount condition: slotmap is empty or already mounted with clustered.
- all other conditions will be denied.

> Another scenario is journal replay after crash.
> 

this patch set a rule:
If last mount didn't do umount, (eg: crash happened), the next mount MUST be same mount type.
(please also check above lines of 'code logic'.)

In my view, this rule is enough to handle crash scenario.
So my patch should be polished in somewhere, but it is workable.

Thanks,
Heming

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
