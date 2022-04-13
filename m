Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7565EC433F5
	for <ocfs2-devel@archiver.kernel.org>; Wed, 13 Apr 2022 13:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Y62SUQLb1EGnJWfwYNCeecbzvZIpAgGW7SlEaYQHmXc=;
 b=GnFpD1rNPkplBGrxXHGqGC3z1/QWl2CBWjm5SMxyHT6q15LyA2Pq/v01Q4cIsvEB/jT952zIm87U
   Mi3U7dxS2VVBSo6dT37/zLJG/mEUzG1x1rXC5W1iMVl9gbMotEy2LOSe3wuZ0lPxuRwNVORBzKJu
   7saoUuYg1z3iC3qx8gkpF01EtSy1K8Br4q4MjU4HtqHwHLjiCDc0SVIto+vFztMhxH6yR3wF+Ea0
   3i0nCilDLaoPihb0LobmaSaFX1TygL2lZo7OnXYidLlzFyfnMmh+RDRoDof9h+OkcVUEVim7e2pX
   4YmP+M7R6Ub8yQTvD0u15lbRiniTIBiMFVTs5w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Y62SUQLb1EGnJWfwYNCeecbzvZIpAgGW7SlEaYQHmXc=;
 b=G+4bDZH4t8ojDWeDk/EUNK7O5g5+02S/YWDJAmoQRjvCDpEZ93Zp1nNyKRLJmu6S6titqXogp7D6
   G9Dbqy2dCTsv6MxhZKUUHUcjjlf3wGUT3PWtmuoh3OhGsIXSp/rEpvje9KzMtMWpFx4tkuXCxWen
   GbEj8CF3O9/hyy/E6NKf1BXpLIdxTNK1SiZb73Em1d/PImMZCmeAVf46yB+7XDG0CcGrug1fq/mG
   GzuSLKngUOgAy4HUuOUCh87CLpH1cqImYF1MglhuW+P245g5BYF/zKXsGe9mvZAtfkXK3HM/gy1l
   hcTA/t3PzW+rL9ZOAGCP/k3h3tFgtJdZjxnlpQ==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RAA0017750A6WB0@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 13 Apr 2022 13:19:22 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com;
 s=mimecast20200619; t=1649855948;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=mI+J73U6FkfPjEitOoB7+tW69ReaB06RSWXSnwDYnLs=;
 b=lIJx5gh82YBHpJRVuAfT0tS7IbQ5N2ESctaq3UIW/gxZBBhO3HnIJFklB2EJrg9LL61WdU
 2Uef1szwql7Uwt8nbiDdq2JQBYe+I2XVTxb9vQcmW/kSvhpULgXKqb779ZmFEmBZx2OFaf
 PWsUideIa9E4SbXXM49doiIXfrb7CFA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bqXTyEA64nsDiZSyWirb5Lkdi6f4fue540zyIb6lpe10qGJBBLFgX3q0opeDm7LAlpu6DBzXuJkEoPvf6+22elQoY9eedLZiO1/7YjMYxmDf2lx4TrThORY7gTRNq9WEyBQ/hq9B1NRCu/MH9/Jl+7kcG+RKWkOQ+ajuw03JbPnw6pxJ5JP98fSDZBlrAbdy+JOO9ezMdhsH5yiujYcBL6WVH1rO+EAamMUonrcDzDOWo41gjUsGi15RxL9iy2I+yuZ7VGU8AShf236EfmhLyVdpOpKfzvsqFpfYCRB88fIj/Q2qPSDuNGOeSeaSrTcriJx5/o+v2Yok2ibeNVDPAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mI+J73U6FkfPjEitOoB7+tW69ReaB06RSWXSnwDYnLs=;
 b=DrUZkKPiM36KFdiYiob1l1uhq/kGhn1/L9EHIM1vdbgqaYHB19/28S4LxnJKO5biT+APbJTv32Cq4alZOiMQYz10Abi6p8filgiaVXbRu2jZx3wrRSevuFMwKRit+ixSV4AurzjfCGLSFdFDVKyN8s99mk/goG75orAR4z8UEL89ZyZD+N4JNhwWb6u+9T1iYk1V6SowE/EKuXlZbupk8dk0cVdPu4a8919lp4LCQsw+HkyUq1VP0PCG4fOvsgrVEHNtcfnmPUYiEqnLaURiLAliI1gHoGP6g015mQmPBEbhhMZ2qTI7W5ecJAgZnarlh6Pnf8UrdyZyqWmLVKt7RA==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
Message-id: <954c1a03-b7bf-a2a8-a990-45114a330ca3@suse.com>
Date: Wed, 13 Apr 2022 21:18:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-language: en-US
To: Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@oss.oracle.com
References: <20220413082957.28774-1-heming.zhao@suse.com>
 <20220413082957.28774-2-heming.zhao@suse.com>
 <5d25b0a7-2de8-c1fc-0d8c-506ca0b20a95@linux.alibaba.com>
In-reply-to: <5d25b0a7-2de8-c1fc-0d8c-506ca0b20a95@linux.alibaba.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(38100700002)(8676002)(31686004)(36756003)(66946007)(2906002)(31696002)(26005)(66476007)(86362001)(316002)(6512007)(186003)(66556008)(53546011)(6506007)(508600001)(2616005)(6666004)(8936002)(83380400001)(6486002)(5660300002)(45980500001)(43740500002);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2022 13:19:04.6958 (UTC)
X-Source-IP: 194.104.111.102
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10315
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 mlxlogscore=999 spamscore=0 clxscore=185 phishscore=0 priorityscore=78
 malwarescore=0 adultscore=0 lowpriorityscore=0 suspectscore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204130071
Subject: Re: [Ocfs2-devel] [PATCH v2 1/5] ocfs2: fix mounting crash if journal
 is not alloced
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
X-MC-Unique: WfZcYh3CNRiErLyNI4IE-g-1
X-ClientProxiedBy: TY2PR01CA0002.jpnprd01.prod.outlook.com
 (2603:1096:404:a::14) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6e8fa515-2dab-4f04-2865-08da1d502e9e
X-MS-TrafficTypeDiagnostic: AM5PR04MB3137:EE_
X-Microsoft-Antispam-PRVS:
 <AM5PR04MB31373C22BFE351FEC001A6A797EC9@AM5PR04MB3137.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 LItdMEvW3+iqwQTdMQxry+TlK5vN6aMudaqwZMPQiYVpH0iXYso+D3+k5uyPuT41O9gxoJC2aDdJ8tz9Vo3EoWwV3MwIsw0jK3DA41pd5RC91dna9j0ST4Jc/BgkqIWZwiQ5m4hlyEGP57zSsIoSZw+FrehKMbNnFf05Si/LPMMRO06uPca6g9dP94EYikj8DTVhoiuAh7H0TsKtfxPuHejKCc4YRPAy27vIIbwKhEeKkk87svG9hNuwdMa03hhwZdqdVt3OH0Z4lUH10e/4DoxHkcYNyqrjyKbR/1+Ts0VRfmiFNICU4rHOHbWDUg0C4+Eb6wHPXWGdmq60dbl8qLv0Bnn1+i+NlryeSsuC3AijkEJuVra2wkXJ8A7P3PyGC/9eIVjDjDmpx1qCBHxuYWtpWiLQtulnpCMV/sOuj6qxJesQxjCDJsRDQOhB4XWSsNdao3uSJcxZdWR47WvZj3gk46SKU6vKIekw10Q2vRey/IAyxhPy9LmUMukgDU9XNGhkr3y8mSVyDKp5Kf5i8KpvX29CUkKbz9FkKmMjF8ZPRvIooYSPDLEv/nWU4AYhLv668Z350jVf/+JFSu7dFMNkCfX3JfRZAqSYmB7IzYqScQ82tUwUMgYGNlmYqcNtWmpnT8/NsKDAXzZzdc/3+Ug41KUPB9Zu4Y4gQnenIV6/2KNTajY9SEVoFe2kokI0RBrDH1egYcFnm0CPZVjGxZYu8vxQwuDCnQdlwhdzBd4=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?c1Z6NHA4bWRtYXFuSjRJUVk5MkdjMDBjMTdSQWJFYjNhN1JlZEZROG1PZWRR?=
 =?utf-8?B?amF6b2hBU291SElxbDVyWFpCbVM1TEVlRzVkMVpDVmFZUlNaWEpSVW83bzFa?=
 =?utf-8?B?ZHJCV1JxRVdUOEFoeXY2UnR2cTduamEyRFRHanlyWVUxS2lZMGxiUm9rUDZJ?=
 =?utf-8?B?ZWtNRkJ5RjVqK2h2QkgxTlpMU2hqbnU2dm9YWHRXcmIwWDVoemhveDdmaTRy?=
 =?utf-8?B?Z0YycWhTZFVDdm9kbHlUYmRDdEFUUFJia05kU1ZYY3psTUlmd0tJUTY5NklB?=
 =?utf-8?B?UjlHeWZtOTJrWEtQT1pCMVo5bCtHMWxtWVZNV01jbmkrK1NTYWlrdHBiMiti?=
 =?utf-8?B?dlJVOTN1N3o1WTlrdElBU2tuclp1bDJqcWJKU3NhdkdBandLRUhFdDFncndz?=
 =?utf-8?B?UFJQYkJkOGhzTTFxOFd4VEpWcTNGNTdpKzI0SUN2RjVtdlBVWTdtMzZMYnRN?=
 =?utf-8?B?ZnBYVTRablh6RWlWRU1IdUM5OFozdW9lWHAyaVd1Y1IrYlRGeEJ5aEZFZDBx?=
 =?utf-8?B?MXFUZVdEcjUwdDRhaTYwSWFLSGdxTWdycWM4QXdmQ3JlRHNXVlpuamNqdjgy?=
 =?utf-8?B?N0F1Uk1wQmI2eW9Rb1hOOHJDbXRmdEVJN0tOaWFRaWI1UFhGUTkxRnJENlFw?=
 =?utf-8?B?NGFCRXFHQlNFU3VJTnJNZkZLODlOZTZxSEdqWFR0ak1XVmh4c09Lbis1VkRa?=
 =?utf-8?B?bTMxVlVRN1IrZWRqQ0QxQ2dDandJTCsvY1FzTFg0ZmFxOWxkeDIxQnhDVGFa?=
 =?utf-8?B?UHZjeUdoZDAxeGV6b1JlWmowTDUycDd4TE84Skd4bjlxNE1FbE9DRnd1anBV?=
 =?utf-8?B?ajU1UElpY0d3Y1lPUjYzZU93RkR6ZThUaXJOdkprOS9idG9ITlBxb3hROXlk?=
 =?utf-8?B?ZnNZZHpUbzlxazlPMW54KzZMNllsV0dFU3F6VXZRTys2OFpvWGt4SThEa0gx?=
 =?utf-8?B?eFBmYjMzb1I3NlF1MkFQWWNWRTNsaGZSUHBVQm10WTZqNWdwUFNMSWxKVnln?=
 =?utf-8?B?ZWUvQkhKNGRBdit2NmZyWDM3U09lRlFtcDRSMWJpbjd6U2lCQlE2YUZJVWFY?=
 =?utf-8?B?UDN4TTVJdktMQzlvOXdtQTU4blZVd2M0a2h2SFNqNWZjMDFPR2k4SVlIbEhv?=
 =?utf-8?B?ZnRBK09sMUNJeFRyVkRzVGgzd0NhVEcvSDhrQXlqVGhRTGl1Zkl3NEVYWTd5?=
 =?utf-8?B?dU9Pc1d0S1VsUnFmelJwZUN2ZXVnZ1MwOCt1UW5SNkpuNVBwOSt2Z2FuQVpD?=
 =?utf-8?B?Nm8ycWZsZGFRcGFqcXFZL251TDFoN3FaUmlhWGQwL2QvWXBreXVLS1l6cUFB?=
 =?utf-8?B?b2FzZHNneXE4VW55RFBERnZPUWVacUdtcno2blZYQ2hLVGJDc3Qxa296NzNP?=
 =?utf-8?B?U25BdmY5TEFxUVE1cGJ4V1puVXNseENtUk1va2JabUprN0tSeTQ0TytkV0xJ?=
 =?utf-8?B?cFdPcm5zM3Vxcjl1NjFiRmFadFh5QXl0WGppT1JIWTk2Vm9TSjBWczEyVnlJ?=
 =?utf-8?B?YzIrd0Iwc3lGZHRyaG9hNmNSMElUMUJPMFFUQ1JPb0hEVjhTaXlqQ2VWWTRs?=
 =?utf-8?B?NUo4Ujl0ajFZNnlFS055ZG9vOG83SWZqWlZuSG9DK0E2M1Q1Z0RBeCtWdy9a?=
 =?utf-8?B?andjWFBza2pLMTZJNjNLSXNsU1dzV0VVVzZHUjJpd3pTSkpvMUFKZmkvTVNS?=
 =?utf-8?B?aE5WbEN1UmpJREVza3RXV1Y3cHNOVkZ4Z01WK1lvMGtrcjUvWHhKZ1lxZVBi?=
 =?utf-8?B?Y243SEVPbzNwNTJia3ZpczhFM01sT242YXdYN0VmUlpPMytqamRuQ0ZEMXZs?=
 =?utf-8?B?SndWTHkwcGFhaWU3SmZzSXRWTit5ckY4dmlUeC9NWVd6SHYzVXdUVkJ6RmlQ?=
 =?utf-8?B?U1phbVowelVFK0tOeDR4bENXa240SGthS0pQUEgwUjdiUmd0K1dRdndyVmlu?=
 =?utf-8?B?S3pjVjNsbktHTzJrWWpmY2Jla1BiRzRzc2NMUTQ1TC84L2ZlYm1CckVIOU41?=
 =?utf-8?B?eWNRVi9MbEI3VUFLejFlTVFpRGxMc0Zpc0dvVmdROVd2ODFRanlRUzRhaStC?=
 =?utf-8?B?bjIydHJ5SWhRd0tKSnBSWXFXcGdMaDRycE1TTmJLN3YxWUlaNjdoTGcyUVRR?=
 =?utf-8?B?VFNPNTk5eDN6Yjc4RCsyNno3L1N5NCtRTElsdFA4Qm5uQ3RoOFkzQ2ZSZmtG?=
 =?utf-8?B?ZlZ4SkcwWlZqdDFONzY5Uk9GaURXZFQrYkNrQ0V4Uml5Y1ZDOHZwM3J4MkZs?=
 =?utf-8?B?R3M0WjZJY3RWOUd3emNkUm4zU1dXVDJWYzhsQ2lXMXNBYklGV0pYZFBIUmFS?=
 =?utf-8?B?NkZQQTF4TDlBNDIxL1RsbXlTWDZXanBSRmtsVHFiZnQ0T3VVYUF6eGhUK3N2?=
 =?utf-8?Q?4dgYE/PbzgKMHNiU=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 6e8fa515-2dab-4f04-2865-08da1d502e9e
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 4Hw7EPtKJ0u4Zxz6x4b32mJqLHy2svN5vNyk1FTJ0feIJkLTQErjgPao4MQjB8I4axSSM/JVYnzNyho+MEnA7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR04MB3137
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
 include:de._netblocks.mimecast.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: SttLmY1nrb0Lo20dn5ro9mJsAdNdODBJ
X-Proofpoint-GUID: SttLmY1nrb0Lo20dn5ro9mJsAdNdODBJ
Reporting-Meta:
 AAG/yAovmfNCDgNx3lDtSWiVaccvlUmnKZooBXALbcbibDk07yfUO+2uJCON+3dZ
 zr1JUpal4kGnEcHuSJIxukr3bF0EMp0WwFrGOJUUwg/oKCXuEtkPlPJNkDvcztql
 dKLgau5+eU8u81mdBVxq7+tfWKFjjZ9qbFT4ZwAsNW+gDiV0Fff4Et5215bBoCDa
 7WQJYYyUGx4evpijVyVCNsDiALVWkDot/9w8iJwdoPlbpVtYEo+dfAoxCsnWw65t
 F84klqhkafsugkBkwHG48f9feXy84TEkZ4eRytiL9KyNGCpdulhDtR0lt/h4MSzX
 JcbwmbApdb5ZKM8IjgjVIFP/V6ViEH9BqUd0QbhIC/mNKn8/iwMFBeuoKCevvLRU
 J8HpUutsLM2TpUdaEW/rfmkVFT2u22EukOtLCYqF2PUi/7nUZo+h346GyBNZXEKS
 xzS6+vic6QClHMFRfjQYkfRx3iywQqtS2slM+NZuJHxAmfqz0AcSw8bkaDMndcwj
 Bvqq0/56QkRWhhBGPKn2W2H7X2XO13Wemg21Mp15d5z/

On 4/13/22 18:54, Joseph Qi wrote:
> 
> 
> On 4/13/22 4:29 PM, Heming Zhao wrote:
>> After commit da5e7c87827e8 ("ocfs2: cleanup journal init and shutdown"),
>> journal init later than before, it makes NULL pointer access in free
>> routine.
>>
>> Crash flow:
>>
>> ocfs2_fill_super
>>   + ocfs2_mount_volume
>>   |  + ocfs2_dlm_init //fail & return, osb->journal is NULL.
>>   |  + ...
>>   |  + ocfs2_check_volume //no chance to init osb->journal
>>   |
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
>> For fixing, there are three solutions:
>>
>> 1> Partly revert commit da5e7c87827e8
>>
>> For avoiding kernel crash, this make sense for us. We only concerned
>> whether there has any non-system inode access before dlm init. The
>> answer is NO. And all journal replay/recovery handling happen after
>> dlm & journal init done. So this method is not graceful but workable.
>>
>> 2> Add osb->journal check in free inode routine (eg ocfs2_clear_inode)
>>
>> The fix code is special for mounting phase, but it will continue
>> working after mounting stage. In another word, this method adds useless
>> code in normal inode free flow.
>>
>> 3> Do directly free inode in mounting phase
>>
>> This method is brutal/complex and may introduce unsafe code, currently
>> maintainer didn't like.
>>
>> At last, we chose method <1> and did partly reverted job.
>> We reverted journal init codes, and kept cleanup codes flow.
>>
>> Fixes: da5e7c87827e8 ("ocfs2: cleanup journal init and shutdown")
>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
>> ---
>>   fs/ocfs2/inode.c   |  4 ++--
>>   fs/ocfs2/journal.c | 32 ++++++++++++++++++++++----------
>>   fs/ocfs2/super.c   | 16 ++++++++++++++++
>>   3 files changed, 40 insertions(+), 12 deletions(-)
>>
>> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
>> index 5739dc301569..bb116c39b581 100644
>> --- a/fs/ocfs2/inode.c
>> +++ b/fs/ocfs2/inode.c
>> @@ -125,6 +125,7 @@ struct inode *ocfs2_iget(struct ocfs2_super *osb, u64 blkno, unsigned flags,
>>   	struct inode *inode = NULL;
>>   	struct super_block *sb = osb->sb;
>>   	struct ocfs2_find_inode_args args;
>> +	journal_t *journal = osb->journal->j_journal;
>>   
>>   	trace_ocfs2_iget_begin((unsigned long long)blkno, flags,
>>   			       sysfile_type);
>> @@ -171,11 +172,10 @@ struct inode *ocfs2_iget(struct ocfs2_super *osb, u64 blkno, unsigned flags,
>>   	 * part of the transaction - the inode could have been reclaimed and
>>   	 * now it is reread from disk.
>>   	 */
>> -	if (osb->journal) {
>> +	if (journal) {
>>   		transaction_t *transaction;
>>   		tid_t tid;
>>   		struct ocfs2_inode_info *oi = OCFS2_I(inode);
>> -		journal_t *journal = osb->journal->j_journal;
>>   
>>   		read_lock(&journal->j_state_lock);
>>   		if (journal->j_running_transaction)
>> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
>> index 1887a2708709..49255fddce45 100644
>> --- a/fs/ocfs2/journal.c
>> +++ b/fs/ocfs2/journal.c
>> @@ -810,22 +810,20 @@ void ocfs2_set_journal_params(struct ocfs2_super *osb)
>>   	write_unlock(&journal->j_state_lock);
>>   }
>>   
>> -int ocfs2_journal_init(struct ocfs2_super *osb, int *dirty)
>> +/*
>> + * alloc & initialize skeleton for journal structure.
>> + * ocfs2_journal_init() will make fs have journal ability.
>> + */
>> +int ocfs2_journal_alloc(struct ocfs2_super *osb)
>>   {
>> -	int status = -1;
>> -	struct inode *inode = NULL; /* the journal inode */
>> -	journal_t *j_journal = NULL;
>> -	struct ocfs2_journal *journal = NULL;
>> -	struct ocfs2_dinode *di = NULL;
>> -	struct buffer_head *bh = NULL;
>> -	int inode_lock = 0;
>> +	int status = 0;
>> +	struct ocfs2_journal *journal;
>>   
>> -	/* initialize our journal structure */
>>   	journal = kzalloc(sizeof(struct ocfs2_journal), GFP_KERNEL);
>>   	if (!journal) {
>>   		mlog(ML_ERROR, "unable to alloc journal\n");
>>   		status = -ENOMEM;
>> -		goto done;
>> +		goto bail;
>>   	}
>>   	osb->journal = journal;
>>   	journal->j_osb = osb;
>> @@ -839,6 +837,20 @@ int ocfs2_journal_init(struct ocfs2_super *osb, int *dirty)
>>   	INIT_WORK(&journal->j_recovery_work, ocfs2_complete_recovery);
>>   	journal->j_state = OCFS2_JOURNAL_FREE;
>>   
>> +bail:
>> +	return status;
>> +}
>> +
>> +int ocfs2_journal_init(struct ocfs2_super *osb, int *dirty)
>> +{
>> +	int status = -1;
>> +	struct inode *inode = NULL; /* the journal inode */
>> +	journal_t *j_journal = NULL;
>> +	struct ocfs2_journal *journal = osb->journal;
>> +	struct ocfs2_dinode *di = NULL;
>> +	struct buffer_head *bh = NULL;
>> +	int inode_lock = 0;
>> +
> 
> Better to leave a BUG_ON(!journal) here like before.

OK. restore BUG_ON().
The reason I removed it: In theory it's absolutely impossible become NULL.
> 
>>   	/* already have the inode for our journal */
>>   	inode = ocfs2_get_system_file_inode(osb, JOURNAL_SYSTEM_INODE,
>>   					    osb->slot_num);
>> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
>> index 477cdf94122e..babec2c9d638 100644
>> --- a/fs/ocfs2/super.c
>> +++ b/fs/ocfs2/super.c
>> @@ -2015,6 +2015,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>>   	int i, cbits, bbits;
>>   	struct ocfs2_dinode *di = (struct ocfs2_dinode *)bh->b_data;
>>   	struct inode *inode = NULL;
>> +	struct ocfs2_journal *journal;
>>   	struct ocfs2_super *osb;
>>   	u64 total_blocks;
>>   
>> @@ -2195,6 +2196,15 @@ static int ocfs2_initialize_super(struct super_block *sb,
>>   
>>   	get_random_bytes(&osb->s_next_generation, sizeof(u32));
>>   
>> +	/*
>> +	 * FIXME
>> +	 * This should be done in ocfs2_journal_init(), but any inode
>> +	 * writes back operation will cause the filesystem to crash.
>> +	 */
>> +	status = ocfs2_journal_alloc(osb);
>> +	if (status)
> 
> Explicitly mark 'status < 0'?
> 

Sorry, my stupid mistake. I didn't compile & test v2 patch, and plan to test before v3.
For test, please check my comment in patch 5/5

- heming

> 
>> +		goto bail;
>> +
>>   	INIT_WORK(&osb->dquot_drop_work, ocfs2_drop_dquot_refs);
>>   	init_llist_head(&osb->dquot_drop_list);
>>   
>> @@ -2483,6 +2493,12 @@ static void ocfs2_delete_osb(struct ocfs2_super *osb)
>>   
>>   	kfree(osb->osb_orphan_wipes);
>>   	kfree(osb->slot_recovery_generations);
>> +	/* FIXME
>> +	 * This belongs in journal shutdown, but because we have to
>> +	 * allocate osb->journal at the middle of ocfs2_initialize_super(),
>> +	 * we free it here.
>> +	 */
>> +	kfree(osb->journal);
>>   	kfree(osb->local_alloc_copy);
>>   	kfree(osb->uuid_str);
>>   	kfree(osb->vol_label);
> 


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
