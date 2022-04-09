Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DED24C433F5
	for <ocfs2-devel@archiver.kernel.org>; Mon, 11 Apr 2022 09:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=FnNOVuA6Toss/MhWchM+VFCVjFB195rpVVtoZ8rBzDU=;
 b=nUvj1HyMdnj/4Mz18UIeMus4FSsVvHq+eNuuGG+aNaA6o9qGK31HGugZJ8T+CE9KKrH08rgUvWjW
   N251VBflizc/TVwOk8XOcym+2tvjoMSGrpqYq+6SQUQGbin5kiViWkgr44OOGyJ4jplJY8NJD2/c
   7FrzbHJ4+HPAysTI1Ro5xdZyIwluLOVMt3kGAw/QfY3vubW5P7gVAFhLwDwNH1vQsL0BGBAOzGsH
   o3fZ3v/DlcguKB/+YnjQmDuqAUUUsfVa6T74pGonkhhTvUZtdmNM/E2eWTFyYurlvjj5qrUg6Vf1
   ozgzntZU+IIh/PBf9Gu/7kW1fv54KDbjSNUH9Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=FnNOVuA6Toss/MhWchM+VFCVjFB195rpVVtoZ8rBzDU=;
 b=lx+UqRYaxGUsHeS2vbaDC5yzb3FeEae5o026HfrMOqEq8sEB7hfr0/ycGftQMbpfrSFPWMsX6Mm1
   43wDH8QtRZC64n2fYhocJb/0Ditb2RO+5zhiCbT9/HOcR/LnL/10FaxIDItcrvf8lA4l8O+oTrqv
   Gqke9UCuCZaMZI8f6fuFBdr70brJ/oqN1dBb8tH0id1upfaP/iM8YhPg7AGZ2VFxsmTLD52LjoSW
   UraSowaXF2jsu/SHqk3imA8rWscQ+zAxhzlEJ4oy0cpHK63402AmGXF58wPGhEICS8pAbIX3ELGh
   fU2SI1IOCRRqsYJVJwY+g5W45M+zpl+EN0nhCA==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RA600MCS3Y5WS40@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 11 Apr 2022 09:06:05 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com;
 s=mimecast20200619; t=1649522889;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=RPMWijaz9hRKxuxLIolZOGWDgsdsrA4oB0eQ5VaKyzk=;
 b=VXCEjFYPuk8ckezjnuMulykIBDXIt1nvy8hHgui73ufUwLzYlC9booqMlRkX0/u6Ok987F
 VI6qJjP1JdIUSUj5WVwTtP/6pqeBAiz1JgiCj1uTAoYoyx9X2T7vga+52zJ6KO+38RXLTE
 6q7slu8fOzKw/xOSNd3wIR7rHduU47M=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hO83b27MCSnfSwl2wz8KL9czFwGL0LCHWVGxLHIcR6LiUUc5k7AqLroP7boRJ9TPc+qToxHyrJzVMbdPglfoDELUDstQu9bGGvYN27psfbz06PBljdwsSCLL76ecqb+6eZkXz1KX8AOStO5QxL6pij7x7CDX4y1saf1rT+ve8nqzHVwMoae0Z/xir3HxPaRK4f3YfAft+flQSxImCOLTGx2vQ+GtAQJeTufN8b63W3XgButrJzZvNr2SDLiULaT10BGAtZ6NvO+/jB5Q2jDjkfXXSS+3QWcjmZO0Hw4hqQbOXj8fesWb1tOheiziAnGrB200J1kUsEAf1vv+h5SfOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RPMWijaz9hRKxuxLIolZOGWDgsdsrA4oB0eQ5VaKyzk=;
 b=aMCSq3zwx6/8m44QWPlPKTKParK1iG6vKbr+SFFtwCczGo667LeCbWQBJeLcRqOY/meej9TOKuBtpmuNAGlOp7IZvgFrh9hoMM7SHSqTNyIIuJY2EMaqCtD1Zjt4RimQfv3qrPkaHP32pDLBjElkYQLGUI/eG2LKKXvW58V/QlKJL8v2qVsj6/77KQUvO6OEI8QjqUwUodFtDtrPT/IQHx0xAmOLm0YVVFd/xhBDrNhzFBHgYUoYLE8BfMVe/qKnjXzGhttrRUnD6MS9TcWsIcA8IEK4kyaAMq+f46QYqnMenG8kNaUu9pa+zSq414Tzm5Onhly9P6jP37UPYreLJQ==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
Message-id: <4248f4f2-6212-247d-6d14-05a02d7bc249@suse.com>
Date: Sun, 10 Apr 2022 00:47:56 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-language: en-US
To: Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@oss.oracle.com
References: <20220408103012.1419-1-heming.zhao@suse.com>
 <20220408103012.1419-4-heming.zhao@suse.com>
 <4b574a02-626d-8cb8-6c2e-e8c824546c22@linux.alibaba.com>
In-reply-to: <4b574a02-626d-8cb8-6c2e-e8c824546c22@linux.alibaba.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(38100700002)(2906002)(5660300002)(86362001)(8936002)(31696002)(31686004)(2616005)(36756003)(316002)(508600001)(186003)(26005)(6666004)(6512007)(6506007)(53546011)(66476007)(8676002)(6486002)(66946007)(66556008)(83380400001)(45980500001)(43740500002);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2022 16:48:07.1187 (UTC)
X-Source-IP: 194.104.109.102
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10312
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 adultscore=0 mlxscore=0 priorityscore=216 suspectscore=0 mlxlogscore=999
 spamscore=0 bulkscore=0 malwarescore=0 impostorscore=0 lowpriorityscore=0
 clxscore=177 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204090110
Subject: Re: [Ocfs2-devel] [PATCH v1 3/5] ocfs2: ocfs2_initialize_super does
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
X-MC-Unique: 36NUmhtzM1-hEVITcvc8hg-1
X-ClientProxiedBy: HK2PR02CA0192.apcprd02.prod.outlook.com
 (2603:1096:201:21::28) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c1e2dd42-930c-4fb2-b299-08da1a48b8e5
X-MS-TrafficTypeDiagnostic: DB6PR04MB3159:EE_
X-Microsoft-Antispam-PRVS:
 <DB6PR04MB3159F0B6951FBEFB4D2AE6FD97E89@DB6PR04MB3159.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 MXujUX/DPWPwAuYbViwT0oQCI8mhi8bkaUt1mufijreR0uDLge1ZXao7uvUmDSzDLyNup/laouiSsk3wC6XUx0wYYXgmp26ohm4FRdNZlbQb030v0jwue62ItDi2bx0BcJTPhD1hOPzkHvBrSe7YY99lNlUk8XlFDoRHrZjSdX6dfJIIROOmQ5S7DtCV13rd0rlt2NEsV0V83RfI8yRpjG8coGP1vhHQzAwhsjMh8B/aEy1I78euUnzLC0/p/DKkO4gGYdmNhEl4LlmVzowuesn1SfwQlqlYyg4AVDqwnJ7DLR9MTj3w+HHTqdqqwUXfuUJE+aNK0/qfOCJ/B2rELGTEadjTv4eBiIiUJ/xmQndA4DZwDq3/BdnVx96S3TBp2RmlPO4cFnsqzwPjUOjw8NujvobNYib5JPKohU2WSbk09FjvtU2WJaMoYBeFRNR12/MJrVC6bdXXSbG3HPrhO4c1CvLNq8hrPvZi7TnxuSH6dp8LGetweiz5CxcFzf4Ar90Oqzj0nUv3JQgWx3njD7Jly73vIvKFWdPgdvo/uZbPR/GHq6ghy6SRfVEvX6nNCRvsytsZ62rr4HX8Mwpp6pjbtPXNdUbCvhoyitpNI2zUPuNBtEGec/O242QyDZabOZ4Vph9vxq4dJACFpvxxukB1G/kt/ERVqJw0MuSv/vpewkxB3AStr4ovKq3hD7+h0X8raeDylekfC+Sdy6fmGDYsmR1WrLhSU6qBZtpTc7U=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?VElZTkVhUHdNUkVlMXpaMXp2THp6bkt1azAwK0x1NzZHODF5QkdmRmYrcE50?=
 =?utf-8?B?NTZlYUFad3gzN0tMRW5sYkgrRmVaY3J6cFgySlJ2MnBmSkgrNFRPUTM1QW5Z?=
 =?utf-8?B?allvYks5WDN0UE1aUXAzYlFBQmRyVmIvL1FvYkJpUkp5a1JCWEVRTWUwVDFM?=
 =?utf-8?B?dUMzdWxKM1dLSEdCY0psNW5iU3lHeGhHQ1RjWWphNVhtUGRNOTluNlA4UUN0?=
 =?utf-8?B?TmErU1NyZFNKZVM0WTViYkMzWEo2cFJ6V0pGRWEvTU0zSHR4YVIybzN3bDN5?=
 =?utf-8?B?VDBOV3JOdko0L0FLWU91NGNpc1BTT1ZTWmVFaE9MS1ZaaTZtVXlsaVV4b3dT?=
 =?utf-8?B?bytDcHlEZUpPVTN1dGxWeTFsUjFKTmd0RzZ6c3B4NGZ2emRPTUUzRlRLTEk5?=
 =?utf-8?B?Q0tmdjMvSG93b2F4NFp3dnpmbjhBNDdhcDkzOFpSRjBrVmlaZzhyY05lb2pS?=
 =?utf-8?B?SHdkaXV2eU9KYWQ1UDdEc2o2elVweWlxdGZLNEhHU0VuWWNjWVk2b01Bb2lH?=
 =?utf-8?B?MGNyN1JwZW5ZNmpmL1R2eFd2cGlBUlh4dHgyN1VybjNyOXo4RVVYS3NKUEs1?=
 =?utf-8?B?SERpRGtETFZ6Z01VSyt4NU4vcWpHVmFEMDN0VHp3OEJBdndIN1ZZeU4yWk1y?=
 =?utf-8?B?MkluazhlZDM2UWhOdWFZOVVVYUtDTFU0OHpFVk5IUE9JLzFXN3NUNTB6WE5u?=
 =?utf-8?B?T0w3dUFSQnRnWjBLVjVZZTV5N2syQzA4Qmt4OGFJQktqL21FUEdZVmcyUkpT?=
 =?utf-8?B?b2JYUWptUy90QmY1T1Byc3p3WEpuU2RBc201MUl4NjcvZURYZXJtZjZyOTJq?=
 =?utf-8?B?TXRrb080TFQzeVlKaEh4QStrZ2FRUWhBd0ZvN2Q4V1ljV2tXU3FGazZVT2pL?=
 =?utf-8?B?YWtMRFU0cmZMa0dXcmNXRTRpR3gzcndjK20vRFlzSXgydHErMjVQbjlUMnFu?=
 =?utf-8?B?ZmNQUFFBUW80K3RGWjNvc0l5S2wvcmFoY1pnaHFKU1J2aEowV3l1Y0tzT2lN?=
 =?utf-8?B?UEdJbW16aUtQWXBWaWtzM3A0L3pSU1Y1ODVFNzdxVGlqMkZIbVNrbExQbGVQ?=
 =?utf-8?B?WGZsdjdQV0dTQ3pBRHJHQURzdTNFODJmSEhuTWNpOWoxeUI4TW9wWlU5R0hE?=
 =?utf-8?B?V1ZVN0xkc3R6SGlPVzZ5SXFmMjBxaW9oMkV3V1RLc3BIS3UxY3NFaTZQOTU2?=
 =?utf-8?B?bnYwNW9aeFVybENIaEk0a3p3M0dEZmZ2elBsbGxnQVNxMkJOdUduYktMUFE5?=
 =?utf-8?B?bURSaVFxdElKeW14NWRjUm5yOVdCN2lMTGJMQTdCb3cwUmFxZkVab3hYRXlw?=
 =?utf-8?B?RkdKZXZHdGU4S1NiZm0yZ05OaGdtSnk5NURaS1lOckQ4SHpFc1VDQmc0YWJn?=
 =?utf-8?B?dmVoL3ZURXdqUFJpcHFuRXA3U3pyTys0MWJwM1hkdysvajJobDQvUW41VkhJ?=
 =?utf-8?B?NXNsUnNWQkRLcUxjZkxDZlVhcDRMaGVWU1VPTStuTDdYcnhjcVlKMmdiSGkr?=
 =?utf-8?B?M1NpQThIOVhhRTcrWjc0STFmOUtzRGRPU2pLY0JEN1VUamREdzFIOTJ4aVp5?=
 =?utf-8?B?NTZ2WExkMEloZjlDL3A1ZllVNXdOQnRCSHJTZlZxNy9Vd1RDWVBWNVVMRDZh?=
 =?utf-8?B?cXhZL09oUU1GN1hLU0w4RDVtUllGTFpXUk9FOUVrY2V3WVBSODIxczdFMTl4?=
 =?utf-8?B?b2hlQUZLczZha3A0UTNqQmhYTDVXbWZpNHg5eEdIRmt1bzlVbGJrbk1qZTVK?=
 =?utf-8?B?YkFhNnJnQlROOUI4d29na29xZW5pMXNONlp3bmg1dFpBa25KdDk4cnBUZWVt?=
 =?utf-8?B?MU1TbUtuSnRIUWVoQkZZckJZbTZBdUJXc0taY3lNYzhRY2lwUUJIU3d1bmF6?=
 =?utf-8?B?ZWVPSnlwYTFWTmRzZS93c01nWG1sTWNZbnNkbmxrcExNT0VnRnUyMlpUaUhZ?=
 =?utf-8?B?STluM1dKZTNRYjRRZDZSaDZoM2VkWGlWQjU0dTkwbmVoY1Bza0VycjMrQTN6?=
 =?utf-8?B?cWszZTl2bXY3WDROOFRMM3pUeGFmZDAvbjdIWGt4T0xEVWdHajhxVkZWejNu?=
 =?utf-8?B?YXpHK0F2K2xlekVPMUxicGYrZ2RjK1Y0ZHhLcm9jYWFEWHBxZlJJaFVjaUwz?=
 =?utf-8?B?SDk2QkNJd0FDQk45M1FHeDB3NG1udnd0VXpVU0ZtbklFVFJtVndIYTJKSERt?=
 =?utf-8?B?dko5ZnVZSnRyQ1dUUHJaUlRvSmVBZWdFYmwwbGFrZVg1TWFTSzBoN2luQXpr?=
 =?utf-8?B?N0JQanpkL0xDS094U3pnL05HQit3Mzd4SnB5cmdkVldQNm5wRFNreGpNQnZK?=
 =?utf-8?B?V2hlaGdzbHhPUWpKTlk0VklBRFdJclNUR2pOZ0FvWTNqeTJUakxOUT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 c1e2dd42-930c-4fb2-b299-08da1a48b8e5
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 kDAehBGAOTV8++79X1UMVwuO77EQdKxwErCKTUwNmYpX66TcmR6WqiehxTdLHn/N/yTfj5VfVVtWuKrVb2Kh0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR04MB3159
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
 include:de._netblocks.mimecast.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: VyNzaRyF_qO9A0EbezVijS2QKW4QS7mc
X-Proofpoint-GUID: VyNzaRyF_qO9A0EbezVijS2QKW4QS7mc
Reporting-Meta:
 AAFGBoIIISjA1IH1ZbbI1eW+dJfdQMT/Q2qCe7KoRKsTfUEWaGH1dm4js4MsT/fz
 WsJq9vBnhZmRMb0Iprr+HH56217juwlMRK42lWmTQ3/tmdn5BlyUg0yq8pmIW0Q/
 Ka/ye7EqJdAOlEU92dCp9Vgrr9HoQsIWwUGjeB/9R1c2E3CjRR8LaOHMKp1DkIen
 8MrmjNOdIQc6RERdedfJNm0WJQHvxFrQu50QyN4/idjKTZTmNnIWDJDWWzADdjL9
 nrnIWIwIcSqmUHVHp/07Og5407PuAo192iqe90pmXgnejchn/brVgFlmb1//ZbAz
 KClpEV6x+2cC/JhdXpu1XcFBxNSvUBuxlNs+CZErKTje+AGpXSV32aIZShJG57ew
 rIHa7c5z15zATmkxa3yXYWMNQ8PpOo0egkKlw7qXH1YJYz5ZaWe0U2qzjcZsrQ9g
 IenhVCW0EkXQ7MAEHkVmBo4RM15jVQEvPn0v5b4Jn1GpPeXmNEfovVkVOCgaraSv
 NK62gFQhZIW93Cuh+hQOmFscQOQxQpuLp1Rn7SubrjNi

On 4/9/22 21:30, Joseph Qi wrote:
> 
> 
> On 4/8/22 6:30 PM, Heming Zhao wrote:
>> After this patch, when error, ocfs2_fill_super doesn't take care to
>> release resources which are allocated in ocfs2_initialize_super.
>>
>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
>> ---
>>   fs/ocfs2/super.c | 58 +++++++++++++++++++++++++++++++++---------------
>>   1 file changed, 40 insertions(+), 18 deletions(-)
>>
>> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
>> index f91c5510bc7e..8443ba031dec 100644
>> --- a/fs/ocfs2/super.c
>> +++ b/fs/ocfs2/super.c
>> @@ -2023,7 +2023,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>>   	if (!osb) {
>>   		status = -ENOMEM;
>>   		mlog_errno(status);
>> -		goto bail;
>> +		goto out;
>>   	}
>> ... ...
>>   
>> -bail:
>> +	return status;
>> +
>> +out_slot_info:
>> +	ocfs2_free_slot_info(osb);
>> +out_system_inodes:
>> +	ocfs2_release_system_inodes(osb);
>> +out_dlm_out:
>> +	ocfs2_put_dlm_debug(osb->osb_dlm_debug);
>> +out_uuid_str:
>> +	kfree(osb->uuid_str);
>> +out_journal:
>> +	kfree(osb->journal);
>> +out_orphan_wipes:
>> +	kfree(osb->osb_orphan_wipes);
>> +out_slot_recovery_gen:
>> +	kfree(osb->slot_recovery_generations);
>> +out_vol_label:
>> +	kfree(osb->vol_label);
>> +out_recovery_map:
>> +	kfree(osb->recovery_map);
>> +out:
>> +	kfree(osb);
> 
> Should set osb to NULL here to prevent UAF in ocfs2_fill_super().
> 

Your concern only valid with patch 1/5+2/5+3/5, but after 5/5, the UAF won't be
triggered. ocfs2_initialize_super() failure will directly jump (by "goto out")
to return.

Thanks,
Heming
> 
>>   	return status;
>>   }
>>   
> 


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
