Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDA29C433EF
	for <ocfs2-devel@archiver.kernel.org>; Sun, 10 Apr 2022 21:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=VAESHmoGGJhurSCsyJyQIzSubLBHcU+XRu/CL5RUsRQ=;
 b=kAzXrENynTKKuYHBlhDU2l+ce9Oz5fjmQp3xRiJqYUSLJ0FFP25KMZa3gO+4rWvhNg287quMh0h+
   9xzleo4Knojs7FPfg6fCJq1iPYXdMIJAdhFUZadIPw+9YVZvLR47yd+eApRs+d/mOpud005lqAoP
   OKQUJBbwExCQBxi45JM4d7JJyaA7qqgRaV3YCuMfqDRwuYbK03WxsJPcMsNycmkDfRpVNcYZl1AJ
   GGwwxMKbl6OZA3XIQda+E6tS3fnPktYrP0s+HaiunAC+rHjaGjO9YdWwBIcwFiMuLp8C7t9N21vR
   OGUBRCnh/g7DHN38wG9LaSIBKvJE4I81HaDMdg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=VAESHmoGGJhurSCsyJyQIzSubLBHcU+XRu/CL5RUsRQ=;
 b=oBaL3/jntOb23eRDOPNbZ/VCigkISoNQiQw6XK73EAsEFkbvUEaxqhHy87Uo6a8nrNNiwtkz2z7n
   TxXk16JX4kcm9Lr8pAHbL0n+e0cZ/E6bYgNC11r+lCuJFufXZQ8Y+IjnURd1kDhzKVxVfdMrNw2O
   iXpxTCLefCKQdnjZdOZtXSYhNilFisWner/DIuL/xrCplpG2PH3MiTfXfo1SJRZQcOrVBZap2jZO
   QohGWfS1jcRvNkggG+jSDX1mA7Frrs171HEVXX/qdnBa6YHTkFJzoJnLMVJ0JrsuhA0elqexBx/X
   I+/88j+2IquJkqkaAh8ZaeuJCUmbbqOSxaBm3A==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RA500IBU82U0V30@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 10 Apr 2022 21:37:42 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com;
 s=mimecast20200619; t=1649563142;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=VmFFD7WqdEy/brlglFqLSUakqfeZraqbEUlH+/b6tCY=;
 b=liLlximhOHtMmti+4oN2t8T2rBxuIq6OXSEYmg3Si1TFi6UnX0LROy4V9p5RbJ98mFYbFz
 b5BeapAK8ia8lTQx8d1y8TbKn5FdVSfkeoT6uhZ1Va1zFIwbjrhC95gbbhq3vFGI946Z5D
 tBbHtarCzaNSOoHdjSb9eIyWUVjhaXM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UCJj03rsIqanOIfozDlunVB8XIctNs8+53LQlng0UiI8jGhjzaZ3c42LUwtyJHILrC6t60AoW3oSXx+DH100ubUcow/1/Gr/C5m54RSecN9EEs+6w3K/WnfsbNEKk3OlnDvTPZU+4OntSNDbeSzPGYnCkdfAckNg72wNeThj5eWIDFlJR1ijKvv9iXCi8Mqn5jy4gYwqgjm5h6vxGswt09EfQt6fu6CCIzlr9uHT3ptoxCz4SDfzApcJB8MNG4bTSkWMsNA36ar8RpaDh77/zIH0dX887SY01KYDh/PkDw3fExYbc0brF7cGvHD3reaPWn/rn87fUQha4IPw5Rxl4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VmFFD7WqdEy/brlglFqLSUakqfeZraqbEUlH+/b6tCY=;
 b=Od1s8NKpq13xQPBJdzWlHrY0G4BeKpXYR3w9f1iut7VMmfoLkEC0nLPXMml7Kc7bvf9VLtHETkBJH+2AwFRZACP+nZW4eDzPd84QS/9bSnpiygkaC1g4CKtrBv40uNmuHeWyFs5nSZP3eygkpamMlM5WQyMOXHextg+/TfEx/eAhVFvUVDzzYVUAjnDZx+lzce17amMgLwgNnkSacX9wvACNg2e3N/czXG2B/zQ4qR2eUTEt8L2xfXZay4OMpq+01e89zrLpw+oylErpk8pCB8TvJJznuP/pBplKr5CZ/QqUFVfHNDbREvtZCqcsF1RyMYDAAR6kHNWVC1TZ4AW1lA==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
Message-id: <559954bf-dd6d-9eb9-a803-399ca442af53@suse.com>
Date: Sun, 10 Apr 2022 11:58:46 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-language: en-US
To: Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@oss.oracle.com
References: <20220408103012.1419-1-heming.zhao@suse.com>
 <20220408103012.1419-5-heming.zhao@suse.com>
 <5bd3a683-b0bd-b6b9-32c0-b57026f109aa@linux.alibaba.com>
In-reply-to: <5bd3a683-b0bd-b6b9-32c0-b57026f109aa@linux.alibaba.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(38100700002)(31696002)(86362001)(66476007)(66946007)(508600001)(2616005)(186003)(26005)(66556008)(8676002)(6486002)(6512007)(8936002)(36756003)(83380400001)(2906002)(5660300002)(6506007)(6666004)(31686004)(53546011)(316002)(43740500002)(45980500001);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2022 03:58:58.6924 (UTC)
X-Source-IP: 194.104.111.102
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10312
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=169
 priorityscore=172 adultscore=0 lowpriorityscore=0 mlxlogscore=999 bulkscore=0
 spamscore=0 impostorscore=0 suspectscore=0 mlxscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204100025
Subject: Re: [Ocfs2-devel] [PATCH v1 4/5] ocfs2: ocfs2_mount_volume does
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
From: "heming.zhao--- via Ocfs2-devel" <ocfs2-devel@oss.oracle.com>
Reply-to: "heming.zhao@suse.com" <heming.zhao@suse.com>
Content-transfer-encoding: 7bit
Content-type: text/plain; charset="us-ascii"; Format="flowed"
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-MC-Unique: eGtFEDnuNM6yI0w1RW9wng-2
X-ClientProxiedBy: TY2PR02CA0051.apcprd02.prod.outlook.com
 (2603:1096:404:e2::15) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1377bbc5-f72f-4afa-e3f5-08da1aa6708b
X-MS-TrafficTypeDiagnostic: AM0PR04MB6307:EE_
X-Microsoft-Antispam-PRVS:
 <AM0PR04MB630744FB1C4EEB5C9A5183D997EB9@AM0PR04MB6307.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 aKcvlO3A1SbRGFNBPPSZdcU6Aut+WgAa57BFh+zG9JEJHbscSEHqfJL2+XWK6cYkE4WEbzRzHPmDC9M8CgGTzK/u4PNcZv20nechkmA/DNfHis60lEslsEfn135fWTTNJuoTwiXkPbXgbvnvmtticMcfZ/7QWtpp2K7w8bD/fjnKJB+qqHy69RJAj7ld8DiieO23o5wZinysElSkmg8tnmRkh/Q4/4vu4npQJpWBDR549gupJjnkxLWNCn0D5ZxTulgysRBgJHixx286aq6NbxYwFT5DyPJ9xUlRQeVEa03QODHGvRmOvmpczYEwpf6aI9kbihpk5DZnYSaEp8bZbwxcwg5gkqEVcxN/AXDO1y14TvCcGPNNK/DTEQSImTqGxLSQBX/UgQQbMScJY5VBVMTENa04SGTu7+55AG5Ze6tZxx6JZzB4goqrpEC+GC3neQeb4j7dyN1qnf4d1hifj1pTK0SLIuZIw0FO3xeAOGkthGcddIjuG318aPvDa732LGS44hv5xcIEKt8+Ntc5/GsmqKk6/VbHnx4pxB5W7eXhyPYri8q8WNPNBzBFkW8GW6KvHdFTFsGMKMxn8rw3FvNjZMd2/3LbQPb2dhmMh0eqJPsMKdpzv6PhCCU27ke8O1qM18SubAdMXC22S2YZUGrNzcOPFLuqbVs5xHqXdKPKSpWSEV0jm86FWyhVXkjE8ZU5pS0nfGecpWYV9D6tVcfezbckD1BMpkMcwbhccFo=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?WFpUZk9uNHlmNmFJOE0wZU41VzFpZ1VKNDdDZFZIR2VpTlZGTWV3R2RTcVl2?=
 =?utf-8?B?cXEyTDRBcFFQb0JXaEZSaEhvc3JPdzUxdWJhWS9SaVp5TlgxaUw5WUJ1MXJE?=
 =?utf-8?B?Y1pIUXZLYXViZEgyMFQ1TTRXRitDaG5sUy9QdDhJT0JjQzdKY0RXdlArZm1m?=
 =?utf-8?B?QVQveWUwWmR6TG53c1lOSlpNb00vYTNmWWl6REZRRkxrcTdCU2NkVWpXTWor?=
 =?utf-8?B?dFJHd09qcUIxb0kraVNMME9Lbk9zWFFwM3llUXNvNmJFNndzWjQwdGIxcGps?=
 =?utf-8?B?bVJMa1kxeEJMM2ZYWFRTQThUeDd4TSswN1JTVnk3anYwdWdXc1hOR3lEY3B1?=
 =?utf-8?B?RFZFWkw5a001RHlqMGp1WXRjRVJYVVFzeDN6cVh3KzRWbDNKeXVEVmRSODR5?=
 =?utf-8?B?YUxmVytCWFNOb2tGaVZ0L0VGSDU4WVdyTURZR2dIYnRvNTZ6VjRzMXg4eUZq?=
 =?utf-8?B?dlprWFV5ajNxanBDbFZtZ1Q2dmxObkVOU3pyMmxRVVhTZUFkWko0bWFreWs4?=
 =?utf-8?B?SjQ2S1gyWW0rQ3ZsTmk5VG5YN0d3QnkxTGVsT1QxL25aYzYzbzZpWll0b3RC?=
 =?utf-8?B?eFJNZ0ZVay8xZk5CclJqekErbXhJQ3UxN0dEMEVnMUJDaUR3b2JaL1RiUnUr?=
 =?utf-8?B?NjNMNitVMTFUSE9ZSTVBWEZLM0dpSkFPeTlUYWJjVTFIWHZuTW5zdGJCK08x?=
 =?utf-8?B?WURmdDJBWVhXaytSb3o5WnVEQTdrV3haZ2twbk9CcGRHaUhNRWRRdndoWHBT?=
 =?utf-8?B?UnlPa2hJQkZjWFF3RlFtQ2FKSzJXeENGclZXU0hSTHNTM2NObGdLc0pNZ256?=
 =?utf-8?B?WUQ3cXY1S3A5bW9yd205RTFpQjVlTHBXOS9UdGVJbEdwcUlTQWczSmh6U1Qr?=
 =?utf-8?B?K0JEWmREekRsdFJ4M0V2TW1uYTVPUEYwQThFeHhDUDBIK2ZGT283c0NKYjBP?=
 =?utf-8?B?UlVYNU1RbU1JT2Z0cW9qNTRiaFJZU1YxckJxSFJYNVVPSEltWUNoa1BsQVQ1?=
 =?utf-8?B?d0NnbDB4cVlnWXhEL0tkMVR3VlN0UU5kcnJRSkVsRFJFSGpoYjBhYjR5SnQx?=
 =?utf-8?B?OTU1b0dFMklrczhVbjlSb0VqQ2JpMXQxODJPY0QxV0dXY3pVcmJ4cnVuejE1?=
 =?utf-8?B?RjlHb09tZXg2SHliaTluMlJTcGc2YW5CdTFWT1FmUjZpUkdlOEpPdENtMlg1?=
 =?utf-8?B?SlVUcnJFbE9QNFFBM1AxTkVkTU41dURRZTVzY1Y0blA2alFTektSKzdnLzJ1?=
 =?utf-8?B?M2d6RkNkV3RoN3lwaldrd2JOUFVOZE9MZUs0czBqZVZ3TDdDMjl6VnZ4ek1i?=
 =?utf-8?B?RXEyaE1oMDJuempUZkpYeFFhZDlwTUxWVGNTcGhhMDFEVFFzTEhJY0dDN01F?=
 =?utf-8?B?TmJhdy9xZ2lRM0tJbGZyajVlWkNzVkxGdmJLVGxJeVdsWHpUTlFxRHVDQ0pK?=
 =?utf-8?B?ck9HL1lZV1dyWEp5NERjSjhONytaS0o1RlFXcWg1TFBjVzFyVWJmK1BmQmg5?=
 =?utf-8?B?VmdYZ3RRdWJ3ejZlaCtNSFd0MFJvdEVIRjNIYUdnb1hFejVuaGVyNjAxbGJk?=
 =?utf-8?B?TlFKT0RCWitVMW5PNW5Pbmp0SllMaExDY1VSRWpVdGZXdnVHRkFCVCt0amxz?=
 =?utf-8?B?Z1U3bmFKZnFwZ0lpaFl5UjVEOVpRdnZIczlEektYdFI4TUc4SnBveGdOY3lS?=
 =?utf-8?B?d0R3QkZNcXptQ2JLLzNxQ3ZNVWpBZXVOTUYxbENFY3R0ZDRRVnJ3L0RTMG5D?=
 =?utf-8?B?b00rODFGZnZQMU9CL1NucEhZN2l1clRXMHZsQjczNE9zdElQNlovZHpQNWs5?=
 =?utf-8?B?WW95MDYyYnRqZUd6Q2FlWWswYzNidks3Z2ZPaHlEMzY2SzQ5cTZoTWtwMEJR?=
 =?utf-8?B?bkpqbDZwUDVaWG11Z1VnOW5Tdk1ILzhNK3pPVWd0MzlVSlNybkg4WWRvdWxQ?=
 =?utf-8?B?ek5zZnZOVzRhdjNnRUFQaGx5NnErQ2F2V2VPNnpXVm1VenpvZW01VmtNVFBa?=
 =?utf-8?B?OG1NbmJsQWpkeG55WVAvekkyNDhvRmpueEtnSkJEWExseG1HY1NTT21abXVp?=
 =?utf-8?B?ZDNsemJTdUR2WlJ1bnF1OE41ZmRjNUp4ZGFkK1Q5N0EwNmpUZVRjY3NybGhG?=
 =?utf-8?B?aCtEWFlTVnIwZktIWERJK3VrbVlFUDJJWTBEdWFDc1VRcVNERndHeU5wNVNY?=
 =?utf-8?B?OEp2by9aNmpTdFNhL1FyQjcwTENQb3VyRzRkQm91S0tsb29RMVhRWEdGN0N2?=
 =?utf-8?B?NjVud1pHMkl2TzcyRFpJZnhtNnVTSy9sVjFZa2ZpZDM5OHNaYStUTVd2dWdz?=
 =?utf-8?B?elZPcEU0aWF6ZEprbS81bmF0ZjJWMGRpWmNBV2RuNDBtdjZBYVBYQT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 1377bbc5-f72f-4afa-e3f5-08da1aa6708b
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 lIAnVEURDyqcVvSfLqbsEKk1c0mZEAKH4duOI+1pSYsuebFiaBnV7UuCglv0lWVuSuF2uckQQR86N0S0Q29Ufg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6307
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
 include:de._netblocks.mimecast.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: c0nVkUYeT_gnuoG2f4hHMFzkVWy-sWGF
X-Proofpoint-GUID: c0nVkUYeT_gnuoG2f4hHMFzkVWy-sWGF
Reporting-Meta:
 AAE+Z6g5ZI+ItrDFDzbE6oxGBapocoAIAE8ZUV14J13UwqVmDHwW6kZzZiqKpaji
 ydMDATowQqLOE+7kLZ9jPTgpWZXdMJsQWZUkvAmnnekI3W6Yl6EktzMMKsWYOJin
 dnO4KRc/Lpg2b9Mtdzw3bf6hnS65R7Y0R37NLnuW8JTs4LGJrAzrk/6DtJp7KX8j
 GxNwOSBWNgvEvx9iOkE7rDauUv3IH699aF+q7tGJ8tOVVYlvBMHg8cIk2upbZ0FP
 xLhX+31Pr0/jXmckR0GRlKLWiYAeSS0wavt6SudRvIiML2m7AOvQTg57PSy+9IED
 JbE+D0sVuVGOBRnc+EubUOADmwI4565PFYN051QSTpL7DYeQnWhtnKsfL2vOlv2Z
 OZQ1+/OWq63DSYt3YqeVe3asXkY8wIxPOgeu70yDtOP0gm5YwKlvV0N/ykHyT7c0
 VWn0bItDsqDunZmlQw6KLdI6+/kxiOXSBceKifu8TySy8/kqKzZiW7dPMsBfmQEc
 6qHnpjhIy5jHdSEiYiVISZ01PJLqebNXt7cesFbVmjA=

On 4/9/22 21:46, Joseph Qi wrote:
> 
> 
> On 4/8/22 6:30 PM, Heming Zhao wrote:
>> After this patch, when error, ocfs2_fill_super doesn't take care to
>> release resources which are allocated in ocfs2_mount_volume.
>>
>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
>> ---
>>   fs/ocfs2/super.c | 32 ++++++++++++++++++++------------
>>   1 file changed, 20 insertions(+), 12 deletions(-)
>>
>> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
>> index 8443ba031dec..d4b7a29cb364 100644
>> --- a/fs/ocfs2/super.c
>> +++ b/fs/ocfs2/super.c
>> @@ -1803,11 +1803,10 @@ static int ocfs2_get_sector(struct super_block *sb,
>>   static int ocfs2_mount_volume(struct super_block *sb)
>>   {
>>   	int status = 0;
>> -	int unlock_super = 0;
>>   	struct ocfs2_super *osb = OCFS2_SB(sb);
>>   
>>   	if (ocfs2_is_hard_readonly(osb))
>> -		goto leave;
>> +		goto out;
>>   
>>   	mutex_init(&osb->obs_trim_fs_mutex);
>>   
>> @@ -1817,44 +1816,53 @@ static int ocfs2_mount_volume(struct super_block *sb)
>>   		if (status == -EBADR && ocfs2_userspace_stack(osb))
>>   			mlog(ML_ERROR, "couldn't mount because cluster name on"
>>   			" disk does not match the running cluster name.\n");
>> -		goto leave;
>> +		goto out;
>>   	}
>>   
>>   	status = ocfs2_super_lock(osb, 1);
>>   	if (status < 0) {
>>   		mlog_errno(status);
>> -		goto leave;
>> +		goto out_dlm;
>>   	}
>> -	unlock_super = 1;
>>   
>>   	/* This will load up the node map and add ourselves to it. */
>>   	status = ocfs2_find_slot(osb);
>>   	if (status < 0) {
>>   		mlog_errno(status);
>> -		goto leave;
>> +		goto out_super_lock;
>>   	}
>>   
>>   	/* load all node-local system inodes */
>>   	status = ocfs2_init_local_system_inodes(osb);
>>   	if (status < 0) {
>>   		mlog_errno(status);
>> -		goto leave;
>> +		goto out_super_lock;
>>   	}
>>   
>>   	status = ocfs2_check_volume(osb);
>>   	if (status < 0) {
>>   		mlog_errno(status);
>> -		goto leave;
>> +		goto out_system_inodes;
>>   	}
>>   
>>   	status = ocfs2_truncate_log_init(osb);
>> -	if (status < 0)
>> +	if (status < 0) {
>>   		mlog_errno(status);
>> +		goto out_journal_shutdown;
> 
> ocfs2_check_volume() not only does journal initialization,
> but also local alloc.

I agree and already handled this case. please read following explanation.




call flow:



ocfs2_fill_super

  ocfs2_mount_volume

   + ocfs2_init_local_system_inodes //[1]

   + ocfs2_check_volume

      ocfs2_load_local_alloc //may fail



If ocfs2_load_local_alloc fails, only "//local_alloc:%04d" is bad.

And other alloced inodes (from [1]) still exist.


also note, the sys inodes release function is ocfs2_release_system_inodes(),

which could handle both osb->global_system_inodes[] & osb->local_system_inodes
[]
are NULL pointer case.



the cleanup job will be done in both places:
- ocfs2_mount_volume (patch 4/5)

- ocfs2_fill_super (patch 5/5)



related code with patch 4/5:



```ocfs2_mount_volume()


     ... ...

     status = ocfs2_check_volume(osb);

     if (status < 0) {

         mlog_errno(status);



         //need to release global/local sys inodes (by ocfs2_release_system_inodes())

         // which alloced by above [1].


         goto out_system_inodes;

     }

     status = ocfs2_truncate_log_init(osb);

     if (status < 0) {

         mlog_errno(status);



         //need to release journal: by ocfs2_journal_shutdown()

         //need to release global/local sys inodes: by ocfs2_release_system_inodes()

         goto out_journal_shutdown;

     }

     ocfs2_super_unlock(osb, 1);

     return 0;


out_journal_shutdown:

     ocfs2_journal_shutdown(osb); //through to label "out_system_inodes".

out_system_inodes:

     ocfs2_release_system_inodes(osb);

out_super_lock:

     ocfs2_super_unlock(osb, 1);

out_dlm:

     ocfs2_dlm_shutdown(osb, 0);

out:
     return status;

}

```

> 
>> +	}
>>   
>> -leave:
>> -	if (unlock_super)
>> -		ocfs2_super_unlock(osb, 1);
>> +	ocfs2_super_unlock(osb, 1);
>> +	return status;
> Explicitly return 0 may be better, which means this is the
> normal path.

OK

Thanks,
Heming

> 
>>
>> +out_journal_shutdown:
>> +	ocfs2_journal_shutdown(osb);
>> +out_system_inodes:
>> +	ocfs2_release_system_inodes(osb);
>> +out_super_lock:
>> +	ocfs2_super_unlock(osb, 1);
>> +out_dlm:
>> +	ocfs2_dlm_shutdown(osb, 0);
>> +out:
>>   	return status;
>>   }
>>   
> 


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
