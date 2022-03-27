Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3920CC433EF
	for <ocfs2-devel@archiver.kernel.org>; Sun, 27 Mar 2022 10:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=G2Xv6pIgoXZwO10BP1kkvdJhxSLdZ2aLrFI1e2Cqghk=;
 b=R+lDNyzO+Or2Hb5p1a1sBsHE/MrBcY35Ipa/gjy1Zn9+oTvEYqx0A+R5lDXgHoHq3CmOtq36XPhQ
   /EVlMb8ox7NIxpu3wNpxPDstB7oQ63vcEowXbhxK1xeHk8D0lT8sI7uQI+bcPVBvbuiP420IalRv
   fiPEvYL0q0lSLl1rfX4XfNOMfhdMwYx+2lbxYkQzv/r8DmVzCRmtS9qVNLtDfSCvnYOU/JOZfA4K
   eUPlmsi37b3e7VHyBu6cLVu0LTfndNd09gViZim5NAdlUMGtOyR7yw+7dW/BWVPugm6CQBy5P/Ph
   L1Tdv9eUgyhn3aGbmBv9vn0agLuqA2ltM80kSQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=G2Xv6pIgoXZwO10BP1kkvdJhxSLdZ2aLrFI1e2Cqghk=;
 b=pxIAv+GW46NqmsCqolg2l/UWzBbxD+DMtW5c4z9WGjye0BdLcs/RfXuj82sNBX58AAkZKNeh8G+7
   G18opwrqbD5SL6taM/FJWOug5VwRka5nN2dJNjZksOLN6mLXzewA7q/I65DZn6ZTFVSLRYpD6J/8
   yMXeHRhkcKQOs9WzGTLrvhxQ9xc1V5NJtsVPlYBzSwAXqYy4OuV7fZnRd5ie3pUhVtlMrcBv9Cl9
   SEp35d4selexb7oCxgNOpOiZZfAsTwGdw0l+fXTgKqIYANok34NJMKXSHrH3UH8QDPpkxx0JICTu
   Hguz1/f9p1ER185ZfisO1bIqgj3Ue/uf3v+IRQ==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220222 64bit (built Feb 22
 2022))
 with ESMTPS id <0R9E00F2AG7FNMC0@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 27 Mar 2022 10:38:03 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com;
 s=mimecast20200619; t=1648377457;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=lOfSn3flQEEAVZDgcSQTkID/FqvUgOsPgpqA67Xmibs=;
 b=LTqPIrvfHRbuxIFfD/fgCAC34FT2/bxfQs0kRPHOsPCTze2yGOrtmMYfLw1CpNEvv4ZCo9
 WEz0hTf0gXxHIAXOtXZVPW3ml0aNpTrTyXUAx/W3OwSIT13jqWnOFotCis5kQiCjcl5DEC
 8bfNg+icepHntcvjfHL9VOn0z4BEIBg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ob1ch/aOkqutXMZiKlGkKHXmaVZ3dlbhfT7z8wNOEBm+V5qt4is/lXWh4CleZAoWt3WCrNOHG9EvAd1gJZjCOxXF1V398HrVMcB1ZZnHfbzYvgJBCKHLACzDsHwxdNZybtshTAY49ZMvGoyHMd36CDShzMLNh6XEMuFAf6RHjqFVjb51WJnvf3gm4TCqFtUavpAbzAGzu5ip54O3jX1sKIWJ/ejOHx8GPxEtpY7y+TdUDpqatCWN/ytQRAx6Qk9sns/Rt9wc3azSbNXdidxyz0hg7AtolhH7dXuewnPDz4AcmaHiMt2Z70nfq1fHhp6xa47n2fcuQGvgNc7MTs9aUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lOfSn3flQEEAVZDgcSQTkID/FqvUgOsPgpqA67Xmibs=;
 b=Ww76hc4ZVYfsx0hmxB1X6pGYo0dqquYokd+7TPjQ70KC+eCnhc1Viebe11fXtRJzckEbgbqw6kapgXPIRhc55fM0OrUSSeNurq4z0zMxY7GAoyO8OtdRjDwwrqI7E4lt/mzdhHy9HYIC/QGT+w8hOHGhSZIvVASJijuds+Ac0Ay3QE8IpuzWpyWUpmlzrKB+o3hbC04WM2D64KgMDyPxLh+J82GN1dmPM2VkXQXEXGqdL8TVFUthMZTGp5ikQalWFADYl9Mukg0wmwu12x5m4b1metJibxvz2thVeY077tuebhuGBbvVdLOR8sV7w6IBZ7RXbzDYO6+98BTkggRxAQ==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
Message-id: <9efaf256-4f66-32ca-96ef-7b2617396c27@suse.com>
Date: Sun, 27 Mar 2022 18:37:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-language: en-US
To: Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@oss.oracle.com
References: <20220318150401.2411-1-heming.zhao@suse.com>
 <3e2bc324-cfc9-f25e-e5ff-0440f784256b@linux.alibaba.com>
In-reply-to: <3e2bc324-cfc9-f25e-e5ff-0440f784256b@linux.alibaba.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(8936002)(31686004)(6666004)(38100700002)(2906002)(5660300002)(36756003)(66476007)(6486002)(66946007)(83380400001)(186003)(2616005)(66556008)(86362001)(26005)(31696002)(316002)(53546011)(6512007)(4326008)(8676002)(6506007)(508600001)(45980500001)(43740500002); DIR:OUT;
 SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2022 10:37:34.5233 (UTC)
X-Source-IP: 194.104.111.102
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10298
 signatures=694973
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 priorityscore=95 impostorscore=0 mlxscore=0 mlxlogscore=999 clxscore=168
 suspectscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203270064
Cc: vvidic@valentin-vidic.from.hr
Subject: Re: [Ocfs2-devel] [Resend PATCH v3] ocfs2: fix kernel crash after
 mounting when journal doesn't ready
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
X-MC-Unique: W0xudCMkMXa6vc3zfSgYQQ-1
X-ClientProxiedBy: HK2PR0401CA0021.apcprd04.prod.outlook.com
 (2603:1096:202:2::31) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 578b1fbe-9f8b-4fb7-bbd0-08da0fddcddb
X-MS-TrafficTypeDiagnostic: VI1PR04MB5887:EE_
X-Microsoft-Antispam-PRVS:
 <VI1PR04MB58874597220BAC4005881D79971C9@VI1PR04MB5887.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 ixfHPowK5+8w0A+LiEbs95QbCUqpXh71r92qgLNzH/xYD0HVKpb1TxBzrFbYDaNKhr2H58C85Guv4umbVpwQDI7OUbaSQgi0Gqj+Jxgq46Lq5/PaJ8Btocb1RpydtPPQa8CVAe+fuwx8mUPn0u/GJyKRmaOYTMxTqHGU2rl0OXmQMAPEkol9EA4ZeaDH9PuV7P3pbZLrXpRk+ac9RxmM7hymsMhFz0RYza99meEgHyLqYuP2RhI/hzO5Oh+zb+qXMs9BZ2Yh/qEHodbtAmhVpMOhiBL11ZK8u9A2usJmeVVlcJHQAHWLZyEF5+xhEZoXW4a4hmyffb8QqmUyI7V8FjNOIlLTnHMF9tu3QruYBeqbol62iwKGS1n+bmTDJOh6VEve3nFHEJVAhQdMrEXguWnNJF3t8T0L+p+3yozeMwKBrEyzE+NY7S67OPZgVvkkYc/Ys8ITSqGb+x8Nwoalbpk2Sn+ZCs+FlFyqE5MgRQJW3Nxbdl/OMnVliWsnaEzNqZGFEb3ceDlnMyIaoeaXEzSvfiGxnPPt2CC3cv4WzRKyA4j9E/KKW5f99JVNm5szjytNakJxnXkivgUUNlJG2Pz4zu8Uk4iabKvDhroEPaWt+t5MbN3zzthzUSx9rNUCtl7BkYkzsh0qIfcRkjuE+5vkDLm7YTIUc85oaMjICx314e0sT2/QBCODQhY9PXQEJEhshv4F4TgPPt9G0CQpEKzW+xYq+ikE5/xd5l4kex0=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?UTZHZXpsekptWEI0TFFVQVVURWdmNlRDNkIzRnFZbXU3UjQyLzExalFMSmhY?=
 =?utf-8?B?TXczNGhBV0l6OGttT3dzZm90R09VWWpvRTdKcG03SVlRYVdWSmlJQnc2WGVl?=
 =?utf-8?B?VCtJVm1xdlY5eTZmYjh1MFp2eEpJVjFrMUZXOVEvUXMvVnZoVmxQSVE2aGNT?=
 =?utf-8?B?ekgvNTI5bEZVM1NUVjQ1Nkl2Qno4NTE3REZCN2t6Q2VVZlJWd2tlaFZLSVht?=
 =?utf-8?B?S0pOZFM2NktWaWJKZDluczl6L0Y2RXdQUGR6V3ovMk82MnlmMjk3cmxZeWh6?=
 =?utf-8?B?bXdsMGNiTkRCaytUb0FkYU8ydlJNMGR2RlFPZnFydXc3RXRRWjRqY2xpaTJH?=
 =?utf-8?B?ZjJVR0hnK2FhYzBZaWVDbDFxMHRXUFFtNkdFSE14T2taZ1NrTEpzY2hsS2tF?=
 =?utf-8?B?MEo3UzRIMUkxT3ZBMzdzWGlMRXpNeVhzQU5kSDUrR2xFV1RLSjh5SzdKUFFU?=
 =?utf-8?B?MTFNZnFTVG41dnI0ZnFKODVXRXhkNEY1Ni9OZytJS0o3VW1CbXZwUlNYYnQw?=
 =?utf-8?B?d1lpNVQ4c0lQRXBScEZjOFhuTDJLS2M0d3JrQUlycUh0blQvYjZFdUtYSWZC?=
 =?utf-8?B?K0pBMEdubWFZUWNNcnd3MmkwRldxUFRPdUo1RkRyYWtRMmlqei81cHhwR3Rm?=
 =?utf-8?B?TFFZQUpNWXQ4VzZ6OVJkN3g3c3lVOVYvY0Y1Z0U4RG9XTzlySW9aVkRMb2hL?=
 =?utf-8?B?WW1nWUcwSlNoVlVEemg4bW5aUmYxSFRQK2NnbnZnRmpWZ1plN251WHJnOFJL?=
 =?utf-8?B?bzhVMkRmVkUzOVEvSG92ZC8xQlpaREo5OGd2OEZoNUVCb3pZWHVWNm1uUXRZ?=
 =?utf-8?B?TW82VFdDaVU5V2JsL2tZRGhvY3FZR1k2cE9RckFJWk5EckRxQzN4TDg5aTgv?=
 =?utf-8?B?SFIvRUxEQzRSMnE3SXpjTFBZUkRpUUJWM0tralV4NmhIV0NRQjVleFdmdDNz?=
 =?utf-8?B?d0ppTWZzQ2FBdXhYVzlwaXhhc2FIWThNVjF0V3JhemNQRkM2RDRBdHpJL3JC?=
 =?utf-8?B?djVQWGVUdGRyQlRZR0RNMTlHNWo1Q1VTYnd5MVdpNTJTbVZLKzlXWEUzVmdI?=
 =?utf-8?B?Zzc0bkQ0NTV4THdVb0k2bUhneXVRb2tGcm84dmlvNmNBUkFZT2RiSGc4RmJh?=
 =?utf-8?B?Nlg4TnJWREdpMEJ4OHprdFUySzhSbUJ4cVZJRGJONzN5YzE5UUMybDZrV0RN?=
 =?utf-8?B?UUM4ZGY4Vmd3b0dscTNma3RobXF4aW1GZkowQlcvQThlcEJHcm9wYkJyTlpE?=
 =?utf-8?B?UVJDeTRGb3F6SkhGbkc4djlHV1lqSEtjdEhnTVJTU0ZMQlVBRFBZaFN5d2l3?=
 =?utf-8?B?ejJhaUxzV3RvK0krSG1lbm1mbFR0Y1N3MWtGYXoyemYvR0xTS09DWVZjZnVS?=
 =?utf-8?B?Y0ptU2FJYWVKR1RydXhCUE9RWG5IREpvYWhjQy9EVHJUTG9HRVo1TWNFYVNo?=
 =?utf-8?B?MWZpNTVhWmlMbXcwR2RMMEFBOEI5T3NsV1N4UVZCMWVoNTVJY1dGK2VpcWRn?=
 =?utf-8?B?YWVlUmt0L0l4N05yYUVaT1RUMkFDRitzZzRiL2QzQXpxRWtzQUlIZXdKRzlY?=
 =?utf-8?B?MGtsL0hFeVlaaDFUdFdkQlpHVXBVMFRQdVp5OHpzaW8rbmpaeFpxOU1hNjhi?=
 =?utf-8?B?b2ZYQzRNeVVtak9tbXZRUzRGR2oyMVFOczZBaVlJR1IvVmltQXA2aVFlZ3Fy?=
 =?utf-8?B?VWlsWnN6WU54ZVZWblVoMVRKTUxMQWJGdjlBZzQ0T0h0Y0dqT2V2VmVFMjVm?=
 =?utf-8?B?WUw3MVNDZEtEaVI2R3dEMHVEam1LRXlhMkZUdkg3T1RsbEhLV2VLMkhaZzdy?=
 =?utf-8?B?Ujd0YXc5L1hNU3dmeXNpOEsya245Qkc2WjZQdkFQazVWMXhaQkdOQVp2R0ZS?=
 =?utf-8?B?eE9waEJQQ0pOWks5K2NXcmxKWVNnUzFxOW1zdjdTV2huUGJTZ0NZbS9iRTRT?=
 =?utf-8?B?T3c1WVRlUTdadXFXdkovMTBmRXNibUova2RWdWhrVzNGa2R6eHdlTld1eitm?=
 =?utf-8?B?QkRjb09OSDZSSi9GT0g0QkdNVXRydVBoQUJHbEFpK2M1em9hN2Q5MkdQelds?=
 =?utf-8?B?SDB2QzNxM3owdFV1NHA1ajhhOW9VVHRJUkxLb2xnVmo5bEVlY2U1U041ekZ5?=
 =?utf-8?B?QjROaFA1cnVVOWljWUtCcWpXOWw3TURWaTdyQ0o0bXB5VDEyM1FUemo0WWta?=
 =?utf-8?B?T0t1OWw5eEZKNzNXaktVMEVmdmpESXlSN2pTSTdjMUtsWURsWmhKa1F4NEk3?=
 =?utf-8?B?cUVGcVcwZnhOQkJQMGxPY0NXL2ZJUU5BQXdUaUkrWXlGZW1BdDdZS0xzTDJq?=
 =?utf-8?B?T1g3blk2SFowbFBTVGhYTmRMT0tRWHcvSE9xNnlyNWIwTFo0U0JuZz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 578b1fbe-9f8b-4fb7-bbd0-08da0fddcddb
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 bb7UBDFVHrg1GZszHDpsTpiEBaLdM6VV3enKocMv651wjhqXRMm6b0sfHNV4raW3RmT0rz4CWhv9d1Azr77TiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5887
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
 include:de._netblocks.mimecast.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: 5ZXS14s3oeK6_AynlZwsCRrBExXMEpcZ
X-Proofpoint-GUID: 5ZXS14s3oeK6_AynlZwsCRrBExXMEpcZ
Reporting-Meta:
 AAF3Xh/QCz0LRK8a+u+XHJA7/N0D3i1A/QrqGZTA92jQMl6/iY8aF0sfUnFNe05d
 NEUFy/WsKibLYEqy5oyA5S9GYdm7pVIB85KbChiS/giceh6RAUAEOkuddzZhAJ9E
 3ObmY77O/qWKaZhQHZW0z9BdKggA6WCsHniGw8ziRDW4cdm9vWLZXVy/++3Yvm+F
 pUXp8n9yqaW1fIxYYYg9XFA8BwEg9nTggo8Gd59fqThiuf5ilEECEY/BNU+e9Uoq
 Tdyn39Z9ydhAI3SVxZYkIVeYapfAAPaUfP3m4H3SyQA/p00ucyMg+LYk8DgIlCMp
 DAhNwe6pldmTkJFFr3Ae5zEJJrZ6NsBtYifqDjaB8whBr8iNgeIAaPdgR+j8SiJZ
 7OQDHqNrae3xduc2RmW2RPBiwt1544ej7WkB4e+51hQ0lENa56sen+4xdw9HU1wM
 qGSYs4qKNJdlhRbOM4R+yOwqMrCz6aExDQpZ5dF0MaLu8bQXDv5f35BUzrjDzRu6
 O158LD02GbBHSrjjr+0irGeGr0GovjioPifbWh+Q1ZXM

Hello Joseph,

Could we speed up this crash fixing? I could trigger this kind of crash at least two ways.
Do you have another alternative patch?

On 3/20/22 21:51, Joseph Qi wrote:
> I don't think it deserves a complex fix like this.
> iput() is a common action and we don't want to re-create a private flow
> in ocfs2. Also I think it's not safe.
> I suggest we take the way to make sure ocfs2 journal is there as a
> prerequisite.

let's image the journal init before any inode operations. and then there will
create a gap between "journal init" and "dlm init". for a rule, any inode operation
should be under dlm lock protecting. if there is a failed before dlm init.
how to handle locking consistency?
the correct code logic should do journal init after dlm lock init. IMO the commit
ccd979bdbce9f ("OCFS2: The Second Oracle Cluster Filesystem") made the locking
mistake on first code version. But author wrote comment to explain the reason.

     ```
     /* FIXME
      * This should be done in ocfs2_journal_init(), but unknown
      * ordering issues will cause the filesystem to crash.
      * If anyone wants to figure out what part of the code
      * refers to osb->journal before ocfs2_journal_init() is run,
      * be my guest.
      */
     ```

We don't simply turn back to pick up the problematic code logic. we should
find a new method.

- Heming

> 
> On 3/18/22 11:04 PM, Heming Zhao wrote:
>> Call trace:
>>
>>    ocfs2: Registered cluster interface user
>>    dlm: no local IP address has been set
>>    dlm: cannot start dlm lowcomms -107
>>    (mount.ocfs2,2225,0):ocfs2_dlm_init:3355 ERROR: status = -107
>>    (mount.ocfs2,2225,0):ocfs2_mount_volume:1817 ERROR: status = -107
>>    (mount.ocfs2,2225,0):ocfs2_fill_super:1186 ERROR: status = -107
>>    BUG: kernel NULL pointer dereference, address: 0000000000000030
>>    #PF: supervisor read access in kernel mode
>>    #PF: error_code(0x0000) - not-present page
>>    PGD 0 P4D 0
>>    Oops: 0000 [#1] PREEMPT SMP NOPTI
>>    CPU: 0 PID: 2225 Comm: mount.ocfs2 Not tainted 5.16.2-1-default #1
>> openSUSE Tumbleweed b40...e84
>>    Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS ...
>>    RIP: 0010:ocfs2_clear_inode+0x2e9/0x720 [ocfs2]
>>    ...
>>    Call Trace:
>>     <TASK>
>>     ? ocfs2_evict_inode+0x1fe/0x630 [ocfs2 411bc..281]
>>     evict+0xc0/0x1c0
>>     ocfs2_release_system_inodes+0x21/0xc0 [ocfs2 411bc..281]
>>     ocfs2_dismount_volume+0x10b/0x2d0 [ocfs2 411bc..281]
>>     ocfs2_fill_super+0xaf/0x19e0 [ocfs2 411bc..281]
>>     mount_bdev+0x182/0x1b0
>>     ? ocfs2_initialize_super.isra.0+0xf50/0xf50 [ocfs2 411bc..281]
>>     legacy_get_tree+0x24/0x40
>>     vfs_get_tree+0x22/0xb0
>>     path_mount+0x465/0xac0
>>     __x64_sys_mount+0x103/0x140
>>     do_syscall_64+0x59/0x80
>>     ? syscall_exit_to_user_mode+0x18/0x40
>>     ? do_syscall_64+0x69/0x80
>>     ? syscall_exit_to_user_mode+0x18/0x40
>>     ? do_syscall_64+0x69/0x80
>>     ? exc_page_fault+0x68/0x150
>>     entry_SYSCALL_64_after_hwframe+0x44/0xae
>>
>> How to trigger:
>>
>>    tb-ocfs1 # dd if=/dev/zero of=/dev/vdb bs=1M count=20 oflag=direct
>>    tb-ocfs1 # mkfs.ocfs2 --cluster-stack=pcmk -N 4 /dev/vdb \
>>               --cluster-name=ocfstst
>>
>>               == there is no dlm running ==
>>    tb-ocfs1 # mount -t ocfs2 /dev/vdb /mnt
>>               == kernel crash ==
>>
>> Analysis:
>>
>> After commit da5e7c87827e8 ("ocfs2: cleanup journal init and shutdown"),
>> Journal init later than before, it makes NULL pointer access in free
>> routine.
>>
>> ocfs2_fill_super
>>   + ocfs2_mount_volume
>>   |  ocfs2_dlm_init //failed, osb->journal still NULL.
>>   + ...
>>   + ocfs2_dismount_volume
>>      ocfs2_release_system_inodes
>>        ...
>>         evict
>>          ...
>>           ocfs2_clear_inode
>>            ocfs2_checkpoint_inode
>>             ocfs2_ci_fully_checkpointed
>>              time_after(journal->j_trans_id, ci->ci_last_trans)
>>               + journal is empty, crash!
>>
>> How to fix:
>>
>> create a new function _inode_direct_free() to handle journal non-exist
>> case.
>>
>> Fixes: da5e7c87827e8 ("ocfs2: cleanup journal init and shutdown")
>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
>> ---
>> v3: change patch subject
>>      change fix method:
>>      - v1/v2 focused on the points of accessing osb->journal.
>>      - v3 directly free inodes
>> v2: revise commit log
>>      add checking in ocfs2_dismount_volume()
>> ---
>>   fs/ocfs2/localalloc.c | 12 ++++++++
>>   fs/ocfs2/super.c      | 67 ++++++++++++++++++++++++++++++++++++++++---
>>   2 files changed, 75 insertions(+), 4 deletions(-)
>> ...
> 


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
