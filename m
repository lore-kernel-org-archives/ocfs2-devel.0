Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0733C19F2D
	for <ocfs2-devel@archiver.kernel.org>; Sat,  6 Aug 2022 15:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=qrkDLvpYvV2OPSbAkUDOX9L01ANZRVFntVHIHka9Z4E=;
 b=vKTJxva2wSIYYt7hGy7Rn7vwvIV5IR4sYbwMzBJ1/zmUaz3mEnrpwN24hDeUCfY0JLb3927mJwHT
   yQqcinOIkCqGXSTOKnC1Eiw2vzFeGl+lPcLoL1jrDUKRsQI7zTsr0Z6lI91EmOVESoP09caVeCIf
   9OLntwDkRPUvkRg2VyI4ccs/1VOzuWR7iXRfhuckZYLZLOG7EeuxH8PeySTCbOjsUcP68cgYYB7X
   H8dtPlkGrG45Ogdv5tHBgPttTVtNjGmoNtuHeAnhUxTOqPQ9gka9jy1iEb7Esr9WRiQSvVVbMZXz
   kd/TsoQmkk9Rw5ggfPKZdREdM0BPto8QC3o9ew==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=qrkDLvpYvV2OPSbAkUDOX9L01ANZRVFntVHIHka9Z4E=;
 b=Be/KzHRq4a5iar2Hv5cHrBf9TLU/btaV5aiAU5WKvsKfseyvVAN8893Z9x5866XA1aFJ6UrDo/Wy
   JaGn0uF8EFpTv5lvYDq7wIcSU7x8K7xfRXnj30oxK10pCuI7bx+q5NpIxHmGc2JUsw40aqmBl32P
   BjLIpNEh8jGQDjmyyEnd6wO41lXOovhfOyP22MIbDliTarnwn6IZokvEzTVCbCPGqHNSy0zlhPL7
   qHdgWgLTFZPnHenmITsRAMMXPoWwBnG7ZakGWWFV/Byj6ItnEtQ1YkDw32lfYMOYIY4llo7k76uj
   0yh55QmqoJCkLJnowELsAXteSB+5sb+/forfig==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220729 64bit (built Jul 29
 2022))
 with ESMTPS id <0RG700453AU08GD0@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 06 Aug 2022 15:54:00 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nX0jXYRM3LWN9pQ9R5tzPmDi/UcUEFVzeYWuS6lb4isZhIKWMnR7/4y/bpD/wBGVMJXPDSjluTbBDn+b2F3+9tvQWB2xrtLLjqN7RKSbxg6qV9H8Syje+E7kfssGbsyMW35SmGCM7NQgwTHHYXfu+MJ2oyShQPmaA6NmWPz9z9/sE+TuXtbgISFoeyQbedDmiGD063hHMB8Jp5jFMHj40eLhQk6b1yzr/4VgRn4R/4gk5zLocAdinn4Uflyy2h8iZGL49/PBjRoqQY0WcwJ4vPJf6mxxPAeIN+pmtRoehcd2dAEc1mryhYDOEcfdt9smXuTBlf12TgHtc4oYVfI6sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QcfqvAqBtb7U1HrKsDoUMmZI91FjMnlLIOywBOm4LJs=;
 b=A5pVJDyKFnKAFizJUxc9kAN91eJAltgpCkPMW5xyOOEzp19o3CWE8tr9bi1qANAmUzy7fpszMgdcYDU5+QeOUZDOaohh9Gj0qXXedDXjZ2VSKwERlK7m5GXjO2OTwszlSkwR0xdoSEOohXjd7GF2cMo+Xi9rNiBVsvyo5VmhWlPCca456eVcTWv1b/sXukJ68pNIEW5uGwDJuzY7S1Mcg8TyP78JargzpNy7bPDBrPjXinB2w1L+jW6a6t+ZlPamHiDPl1MotxrmTcnRTD+5zCpTrobu4caxsL5uitB+QBEUts0ydTAQIIfO1tpdzvLOf8y6rBsIuT2UCV136EfYCQ==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QcfqvAqBtb7U1HrKsDoUMmZI91FjMnlLIOywBOm4LJs=;
 b=E377EJi0mKWZKMtiNZUygIfBSnXBtlQdpiKnIL1nyIJdj/pKaPDf5E8gZf5xvihGacI7MDnBco4YD+K+bQBxKp7ISMTZ/0+9mygLqmfLlSXap5kiFhcxgNbIyLXjzMz5cmGCDHxbtHcI+y3qKzjUnxOrDZvu/kxzbSk8MbhMx+p7Iz54+qqP+fpk2/jkJOeMYHaGmHYIL99z2qIFVi3HkNDj9trNsjs7nvPgYlsQSIbrACI8sqYqjx4PcW5M9GOn/TgkJ/gFuWGqZJQXSCTYIPkCqFO5v0uTQWuTEADm2buMgTdezj2QJRClQvl2QNgcDnzlExsL0hhxWuJ6aW8sfA==
Message-id: <23fff663-32d9-0038-d8f2-05d9a90aef2c@suse.com>
Date: Sat, 6 Aug 2022 23:53:28 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-language: en-US
To: Mark Fasheh <mark@fasheh.com>
References: <20220730011411.11214-1-heming.zhao@suse.com>
 <20220730011411.11214-4-heming.zhao@suse.com>
 <CAGe7X7kLfsUfb1+yYgD4PffnJYvJVeqrLtub8qC=ujC2gxEzTA@mail.gmail.com>
 <0b33b0c2-71dc-3961-88ee-fb29dedcc7c1@suse.com>
 <CAGe7X7n7J52w3Jn5Sz5=f2AQohLMK5xK2Pjsd9oPAMSn52+SrQ@mail.gmail.com>
 <CAGe7X7=F16yaowhTrLgSGcS4gsGUbtjBgEamfur5n1C0hgRA=Q@mail.gmail.com>
In-reply-to:
 <CAGe7X7=F16yaowhTrLgSGcS4gsGUbtjBgEamfur5n1C0hgRA=Q@mail.gmail.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:VI1PR04MB4671.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(136003)(346002)(39860400002)(396003)(376002)(366004)(66556008)(83380400001)(66946007)(66476007)(4326008)(8676002)(38100700002)(316002)(86362001)(6916009)(31696002)(5660300002)(8936002)(31686004)(36756003)(6486002)(2616005)(186003)(478600001)(6512007)(41300700001)(6506007)(26005)(53546011)(6666004)(2906002)(45980500001)(43740500002); DIR:OUT;
 SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2022 15:53:36.0380 (UTC)
X-Source-IP: 40.107.2.88
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10431
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0 lowpriorityscore=0
 mlxlogscore=999 spamscore=0 impostorscore=0 mlxscore=0 clxscore=206
 priorityscore=158 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208060085
Cc: ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 3/4] re-enable
 "ocfs2: mount shared volume without ha stack"
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
X-ClientProxiedBy: SG2PR01CA0174.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::30) To VI1PR04MB4671.eurprd04.prod.outlook.com
 (2603:10a6:803:71::11)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eee28161-c933-4be5-4431-08da77c3d254
X-MS-TrafficTypeDiagnostic: AS1PR04MB9429:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 dhaMr6fNZKsAxz1cgSpNWadU8Ywptb6OChPRbNGHuPGM7t7H3NRDyXC/Rh33KGXd+0o1oUypOiyln/E5RUpp3NRhVc1izpan1fhTYw6+bizOIgrskuusRK5SQxAjTeJCXCdrYp3FhBbTncUFrcITmAZ6w9YtOjueHtPhTLKTrXZY3msKOsQe0fXFmZW6le8ghh3ZCOuLrjstYzGlIBrdC1qwgDqhoN/paGRjSDls6W1/DMuXNgvownF53iMpfvyWJObE9Z/erIYRHUgW+01EDO1UTTfuZHrvmT3yIoUbtyu4odrrlyCZ2b2+tU3EQATjU+dOAwlvFN2grYrqv4KWn9b3THCrbowHtPLc5/6sWRxN7+Sio2zUc/Gc500QPecrSkD0BUxB0w8ZVebCFE6LUl1tMLa/unm4wSAiRheEzB6oNU3DXqws+EOqZiaDOmaFRFVGGMxzH/kYSalwtmXUE7JyyqCjuOwyP4YMqLtAzMSXtUPE5T7vKGA6ezIQX3a4NJuldJAjorkn11QzWsyLdAOeGit2DL66IxpEsnh0CuXX2yH5IErlbtwaMxrW82ckKMGzimGOXULkkMsTIeqnyTN+DSgycKhT/KS5B6gDvz2ig0CNfUHXHlDN9GfGmG9GPFNhePfW5Z/RJ8qo30sTePyJBUHHsvH6q1cdW+VNfHzCKmMnEap9+G956DMChPBrEJMRcKUxdxIJnUmO/S6ozrQDFCwszXeOWq4SXv34Y9IZHMfOcaq4rFsOg4lMcI4WVfon4NwfwDYrVt0OijfgAOLejS2KBo+zQc2w04UXeTj+lHGpVJQYoXc07lnlnmXu7pZhp1ACfA9K+TPzMD2PYA==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?WDRXWUNMYVMvTDZ2eG5XNHZrU3F3NTNlaGp1WURMbk8rNlV6Zjl3dThjNk4v?=
 =?utf-8?B?WWNvVGRWTkFyb0lwWWR3MUtKR0IzS0w5R0hnN1cyeHRTTVJnUXRMT3ZTZk55?=
 =?utf-8?B?SEQ5eFVkaklRNFgzb1pGZ1dlcWI0dnlEVThsOFlIaUY0ODNYQTRYWWh0TlJu?=
 =?utf-8?B?ZC8zSXJQMnl6enBlQWMwVVZad014QVg3U2ZUKzcyVTh0djRWSDFQcTkxV21T?=
 =?utf-8?B?ZWhpVysva00wcU91Uis2a1NDRVVNbC9qQnZLTEF6cnlLRVF4SGV4N1FwdUlr?=
 =?utf-8?B?cXdaL0dKSGFWSXF3aVZ4RmxUYSt2Ym5LRWo3a3FEREprOUFZZkFQb3lTVzdE?=
 =?utf-8?B?NmF5NkNiUHAvWkoxRmpteWxXSTFLb1llOEZMNVd2OFlEeE5uZmpScXRhSzRu?=
 =?utf-8?B?VVZpcVhoZENXeWN2VXFoU3M0alNkZ2N4bzJ1aHQxSHJpa0FYOEhPejVUVzE1?=
 =?utf-8?B?dTVBSEdvbEIzcitiTmRFWkd6SFIrM2Ftbng2OElJSHgxNDIreFJkMU9uKzUx?=
 =?utf-8?B?UmpjVVFkYlJwdTJWTTdaRngyTjMweVhycy9wUmwzZU0zenAwZHpobXVYeWlI?=
 =?utf-8?B?aGVFenJreHZLYzNYR1g0TUJpNllmODl4Nk45QVVkdjJrOVJoNmMyTlpncjZT?=
 =?utf-8?B?VGdHSnZBcVNyeERxMVNCaW5EV2VHWmRVUTNoaUVXMndRNitHYlBuNTJGR3Bk?=
 =?utf-8?B?dW1Xb2FlamlvN1FWN1lRWms3amJhaTJ6WE9aSGNzc2hWS3c0TTh0MnNkb0h0?=
 =?utf-8?B?NGtXMTIzdWR4Q3VDUXVJbWhDRm45TVQraEhYajFDL0ptcko3U0JieExxK253?=
 =?utf-8?B?cmp1cVZiQ1RJMVJBS2hMMm9tN0tXZVhXV3BuVHlOYktTWm9wVUs1Sm4xd3RD?=
 =?utf-8?B?WFVsV1dndWt1clZTVi96QkhnN3VhOEdvSFVPRTU1UStFbTdyL0pId0N5MUkw?=
 =?utf-8?B?aUI1ZndqVjIyRVVwUksvL3BCUUtJeXI5KzI4M1ZaYmE1SlRkdUNpRlh1QXc5?=
 =?utf-8?B?VG5FMkJ3aUlGK2lQVnhYZDFkQmxPVHJYZFRVQzZxVXlmOS93bHZublNNOEQ4?=
 =?utf-8?B?ajg2ay9NM0h2ME5JaFRVd1V3ZUhKZEc2SXIyVFJhNXlTaTdpcmQ0RXBXWW5S?=
 =?utf-8?B?dy9sQ0wxMHRxcldJUGxqMlNjRk1rK1BEUlZxN2FHZHN5b2o0N04rV285dWNl?=
 =?utf-8?B?cDNIWkJyN1M0N0ZJdDVYM2huNGMzdlU5SGtacU9kb2NmdElRcVQ0UWhPNTgy?=
 =?utf-8?B?djNwOERnNzRSdFhsbTBJRU80Zi9SU2dIWU5xQUlhNWZxdkh6aXM3aHBmT2I4?=
 =?utf-8?B?K0hDdUdwYmNvcVR3aGxyT3orUUcrMFRkL1VGZFM5Q0dSSkZXZE5uUWxBWTlN?=
 =?utf-8?B?b1FtZTV2VnRqMHB3TmVaa2NRV1NsRXBoL1RCZXFrRE1qTkJDYTJNL3A2VkFk?=
 =?utf-8?B?cEJTR2MrZmY0NmRQWXZjZUs4aG9DTDF0bXlvSnRaT0h4cmVWNlVtdTBuQmRV?=
 =?utf-8?B?RlIyY2dNTWkwc1hVOWI3bnQyYUlTMFduOW9CM0xXNHB6WG1uanJVNWhDM3Nw?=
 =?utf-8?B?YkxoOTNrZFJiaTlLNjhXRnNGSkRFM2h5dllXUUFnSnlUaTlidXZTQVpKcjZ3?=
 =?utf-8?B?VUNqcEt2N0NlS0NWRmxmZ1hvTFhqb21DQW5vQWkvZjc5aEJIN1N0dEJrOTNv?=
 =?utf-8?B?eXJCOWROekp4VDNPTG9EanRDcGtDNzhrZldwSytxenpnMy9qL0YwamJMaTZx?=
 =?utf-8?B?TU9zVFRUaURLQlNYSFM2MlBUdUY5ZDVJSTNtU1RwWGt2dWMvcUVobTZ0a0hu?=
 =?utf-8?B?R3ZsZXZYeVB4dllzUXhiUHBOYWNVU3l5WGFQNTBtSGJnRVhMTzVKNTJnazFO?=
 =?utf-8?B?K1pFcmNwaGVwSEpxa3Z1K0RmNkpnZnl1Q2VkaFROTXllRnN6Q0VnSVF6Mnho?=
 =?utf-8?B?YTk4anc4MWZ3VWhZVDF5NkhTeWZCaWl6dk9iT0M1OWdrTitKblZNVjVQb0tr?=
 =?utf-8?B?MjRMd2YwSmNHcStWSW53cXA3MHdrbVJ6TkhoNTFKRmlKVVY3V1gwVHRTdWRF?=
 =?utf-8?B?V0V0R1Z4cEEvbjRralBvbHduTGZhbEFHRWNHNXNPK2FwWGNqY1FDT3ZZMEl6?=
 =?utf-8?Q?mS0JAArXSRG3h+dXSat7Oyg+8?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 eee28161-c933-4be5-4431-08da77c3d254
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4671.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 myw9TTsqioJNr8LKYmT6pLopf1SpErlytsyveDsQNc1Jli8zcJKgIC2XgTTB8ATgi0pi26ph9GgwaaTeiybznA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR04MB9429
X-ServerName: mail-eopbgr20088.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: uJagYej9dMOC4WiKJ9v2F0-aRmiEfE2T
X-Proofpoint-GUID: uJagYej9dMOC4WiKJ9v2F0-aRmiEfE2T
Reporting-Meta:
 AAFk848EKk9LwArCTQEQCQrV7KZ3oBCr2PGLVaJ6Tmu0utWze2u96Q1qk3Owwk46
 tLdZ10zwChKaA2Hj8souF4GfmzEtO062RU5ZC+tW3QNs4BJlHtxpaabyv8E9fwyh
 13U6niA9LDh0BRZ4PZXRqamyuVJunEcxI68Lf2lfh+CUzeBYLGVTDM6tyV4NJ6mz
 XO8OBHYez5XQ4pexR1EFQZn6VKV3vRvDYJbtF10ZNmQQKQeL9rz8hTn+15uDgvj4
 lSkXP33YKpujlykB9IdA3bT3rb3JXW1xYEFEoHp3czwC/4Aoc3qW4CGIkbatQyCN
 0J1eg1xcR06AZgmlyi/ORZ8pCdHZiPuWCg/oRqVryvDfqmakPo2A+joiMKck+O6d
 2OK6qJdFaAyUggFUGIhc3b/bfb9lryTL9eka3zHCZTZDId12iNwiIpQ4lMzS0crr
 xmjgm3UcI/BBOjZAAq8n8KoJrcyEDXykHG7oZiHbz3GL0CZGlla0+Mf1kBpQKrU6
 ms1ecteshekzEV67m0fFCrgzSNHQle8xu6V5uWqE7JpRbg==

Hi Mark,

On 8/5/22 12:11, Mark Fasheh wrote:
> On Thu, Aug 4, 2022 at 4:53 PM Mark Fasheh <mark@fasheh.com> wrote:
>> 2) Should we allow the user to bypass our cluster checks?
>>
>> On this question I'm still a 'no'. I simply haven't seen enough
>> evidence to warrant such a drastic change in policy. Allowing it via
>> mount option too just feels extremely error-prone. I think we need to
>> explore alternative avenues to help
>> ing the user out here. As you noted in your followup, a single node
>> config is entirely possible in pacemaker (I've run that config
>> myself). Why not provide an easy way for the user to drop down to that
>> sort of a config? I know that's kind
>> of pushing responsibility for this to the cluster stack, but that's
>> where it belongs in the first place.
>>
>> Another option might be an 'observer mode' mount, where the node
>> participates in the cluster (and the file system locking) but purely
>> in a read-only fashion.
> 
> Thinking about this some more... The only way that this works without
> potential corruptions is if we always write a periodic mmp sequence,
> even in clustered mode (which might mean each node writes to its own
> sector). That way tunefs can always check the disk for a mounted node,
> even without a cluster stack up. If tunefs sees anyone writing
> sequences to the disk, it can safely fail the operation. Tunefs also
> would have to be writing an mmp sequence once it has determined that
> the disk is not mounted. It could also write some flag alongisde the
> sequence that says 'tunefs is working on this disk'. If a cluster
> mount comes up and sees a live sequence with that flag, it will know
> to fail the mount request as the disk is being modified. Local mounts
> can also use this to ensure that they are the only mounted node.
> 

Above tunefs check & write seq steps are mmp feature work flow.



Your mentioned tunefs work flow matches my patch[4/4] idea, and this

patch does all the works in kernel ocfs2_find_slot().



Because sequences should be saved in SB, update it should grab ->osb_lock,

which influence the performance.

And for saving seqs, for saving space, we won't alloc different disk block for
different node.
  If multi-nodes share the same disk block (eg, keep using slot_map
for saving seqs),
  the updating job will make IO performance issue.



For fixing performance issue, in my view, we should disable mmp sequences

updating when mounting mode is clustered. So I make a rule:

** If last mount didn't do unmount, (eg: crash), the next mount MUST be same mount type. **



above rule another meaning:

new coming node mounting type should same with exist mounting type.



and there is a basic knowledge:

current ocfs2 code under cluster stack already have the ability to prevent
multiple mount when mounting type is clustered.


(from patch 4/4) there are mount labels:

+#define OCFS2_MMP_SEQ_CLEAN 0xFF4D4D50U /* mmp_seq value for clean unmount */

+#define OCFS2_MMP_SEQ_FSCK  0xE24D4D50U /* mmp_seq value when being fscked */

+#define OCFS2_MMP_SEQ_MAX   0xE24D4D4FU /* maximum valid mmp_seq value */

+#define OCFS2_MMP_SEQ_INIT  0x0         /* mmp_seq init value */

+#define OCFS2_VALID_CLUSTER   0xE24D4D55U /* value for clustered mount

+                                              under MMP disabled */

+#define OCFS2_VALID_NOCLUSTER 0xE24D4D5AU /* value for noclustered mount

+                                              under MMP disabled */



whenever mount successfully, there should be three types living labels

in slotmap area:

- OCFS2_MMP_SEQ_CLEAN, OCFS2_VALID_NOCLUSTER - for local/non-clustered mount

- OCFS2_VALID_CLUSTER - for clustered mount


new coming node will check if any slot contains living labels.

whenever unmount successfully, there should be two types left labels in slotmap
  area:
-
  OCFS2_MMP_SEQ_CLEAN or 0 (zero)



when a node does unmount, according to the mount type, it will clean (zeroed)

or write OCFS2_MMP_SEQ_CLEAN in the slot.

> As it turns out, we already do pretty much all of the sequence writing
> already for the o2cb cluster stack - check out cluseter/heartbeat.c.
> If memory serves, tunefs.ocfs2 has code to write to this heartbeat
> area as well. For o2cb, we use the disk heartbeat to detect node
> liveness, and to kill our local node if we see disk timeouts. For
> pcmk, we shouldn't take any of these actions as it is none of our
> responsibility. Under pcmk, the heartbeating would be purely for mount
> protection checks.
> 

 From my thinking, under cluster stack, there is enough protecting logic.
For local/non-clustered mount, mmp will give the ability for detecting node liveness.

So I only enable kmmpd-<dev> kthread for local/non-clustered mount.

> The downside to this is that all nodes would be heartbeating to the
> disk on a regular interval, not just one. To be fair, this is exactly
> how o2cb works and with the correct timeout choices, we were able to
> avoid a measurable performance impact, though in any case this might
> have to be a small price the user pays for cluster aware mount
> protection.

I already considered this performance issue in patch [4/4].

> 
> Let me know what you think.
> 
> Thanks,
>    --Mark

Thanks,
Heming

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
