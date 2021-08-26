Return-Path: <SRS0=tkcu=NR=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55231C432BE
	for <ocfs2-devel@archiver.kernel.org>; Thu, 26 Aug 2021 05:59:34 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BD71B610A1
	for <ocfs2-devel@archiver.kernel.org>; Thu, 26 Aug 2021 05:59:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BD71B610A1
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17Q5ZwNH003849;
	Thu, 26 Aug 2021 05:59:32 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ap4xv0169-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Aug 2021 05:59:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17Q5tXxq037330;
	Thu, 26 Aug 2021 05:59:31 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3akb8ybvfq-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 26 Aug 2021 05:59:30 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mJ8QB-0007bV-Ig; Wed, 25 Aug 2021 22:59:27 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ghe@suse.com>) id 1mJ8Pf-0007aZ-LQ
	for ocfs2-devel@oss.oracle.com; Wed, 25 Aug 2021 22:58:55 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17Q5wLdp018911
	for <ocfs2-devel@oss.oracle.com>; Thu, 26 Aug 2021 05:58:55 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by aserp3030.oracle.com with ESMTP id 3ajqhj00qh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 26 Aug 2021 05:58:21 +0000
Received: from pps.filterd (m0246580.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id
	17Q3kmUm019562
	for <ocfs2-devel@oss.oracle.com>; Thu, 26 Aug 2021 05:56:28 GMT
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102])
	by mx0b-00069f01.pphosted.com with ESMTP id 3ap3b78vc0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 26 Aug 2021 05:56:28 +0000
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
	(mail-db3eur04lp2053.outbound.protection.outlook.com [104.47.12.53])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-29-dz0vez9HMemWzjKPjmsvww-1; Thu, 26 Aug 2021 07:56:25 +0200
X-MC-Unique: dz0vez9HMemWzjKPjmsvww-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
	b=iYp5n+Ha3+5Do4p4aLB9/bOwSgw/eYawn7LECojV0ciGZpxW1JAj9FbKPgI3FBr7bkni6DDEedsMaCHXXX7n1xUQUnGxBWamHn1Ii8R8APGpJNjTOzdz6QDv3sF8dxTCUNZnVjo8vpHyjv/EUmB9/llmGeKFh52xeDOCTkDt+Aaz37NaXKjRJKXWxOptemlpQ6hiHEnpaGGo7JPsnqEBBFjSNxXki2rsJx4mBHTOLSNF8cWnC/DpL7TYqYjBdP3TbBNFR7kyqIHCNSyPSQtBixdF74XvUvkRipAUzPNEmxjkbxsuVx45PbtobyjmAxHuW1Mn1lWo973ceLchJWbuEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
	s=arcselector9901;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
	bh=Rkya9VPMtHw2rs0l+ZXcEAX+aLkbF1yms1CC7GcH74o=;
	b=isQcPlwHB49EOK8GK9cyudXLmZh9Rr2TGQkR591RaGXF+2DtnZjvaWHPSuElI/IqQf5JjtTVeRoVrBiqEdNtFtVgAl9QNnw+L7+ICrbSwPShKGhgJnSnqKFcaXtnV3w14W8E+bh5tjSrcUbAP3AzdNIgRr74Rb/AM1njzih7+Uv+14IIxjLZgMD/ogfyKVAN2oqW9mfXQ5HWhAaBwLRfJjMzboB/dfsuAjV9KC6k+PLZ0KIk69UhQ3aPeE+0NgNhUsqSF5EPrMmjxPIlpsnOa9WfFHojzF0QkHEAi2HjWLw10OCfM/5I08kmyINw3QUmWNqHgvnxFsBIerh4m08Gmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
	smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
	dkim=pass header.d=suse.com; arc=none
Authentication-Results: oss.oracle.com; dkim=none (message not signed)
	header.d=none; oss.oracle.com;
	dmarc=none action=none header.from=suse.com; 
Received: from AM6PR04MB6488.eurprd04.prod.outlook.com (2603:10a6:20b:f8::21)
	by AS8PR04MB7736.eurprd04.prod.outlook.com (2603:10a6:20b:2af::20)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19;
	Thu, 26 Aug 2021 05:56:23 +0000
Received: from AM6PR04MB6488.eurprd04.prod.outlook.com
	([fe80::793c:6276:4f2a:4d71]) by
	AM6PR04MB6488.eurprd04.prod.outlook.com
	([fe80::793c:6276:4f2a:4d71%4]) with mapi id 15.20.4457.017;
	Thu, 26 Aug 2021 05:56:23 +0000
From: Gang He <ghe@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>, mark@fasheh.com,
        jlbec@evilplan.org, Wengang Wang <wen.gang.wang@oracle.com>
References: <20210729110230.18983-1-ghe@suse.com>
	<5821fd0f-2018-dc1b-a5c0-f948a7debff4@linux.alibaba.com>
	<c7e1f0a7-e75c-d1e0-870d-dc480d070079@suse.com>
	<71608a14-58f4-dba0-d695-fee65de89192@linux.alibaba.com>
	<801438f5-655a-c708-aa25-343d54a2f11e@suse.com>
	<86e3d724-3147-ccaa-998f-0f857c575f7e@linux.alibaba.com>
	<a0a9710f-461a-99c8-92f6-a99bb11b3a4e@suse.com>
	<4ba3b404-824b-90a3-ef43-9ab6510ee073@linux.alibaba.com>
	<5a1af56c-3eab-5baf-62a3-1c98bac104ba@suse.com>
Message-ID: <db7119a5-f120-cebe-42a1-dc2f64db620d@suse.com>
Date: Thu, 26 Aug 2021 13:56:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
	Thunderbird/78.13.0
In-Reply-To: <5a1af56c-3eab-5baf-62a3-1c98bac104ba@suse.com>
Content-Language: en-US
X-ClientProxiedBy: FR0P281CA0087.DEUP281.PROD.OUTLOOK.COM
	(2603:10a6:d10:1e::12) To AM6PR04MB6488.eurprd04.prod.outlook.com
	(2603:10a6:20b:f8::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.67.20.87] (60.251.47.115) by
	FR0P281CA0087.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:1e::12)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.6
	via Frontend Transport; Thu, 26 Aug 2021 05:56:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cfc5b075-f122-444c-2c03-08d968563be1
X-MS-TrafficTypeDiagnostic: AS8PR04MB7736:
X-Microsoft-Antispam-PRVS: <AS8PR04MB7736FC037A78B80D3B841437CFC79@AS8PR04MB7736.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /RuLYiOIfTYfnPtZjgKhWMHNxcKg7Qhs3APnoUHD3AYFruQOdh/4mOccb565NVwG8sCKh/OknJPOBT70beUa4H2kBvHpkb+ud40WMOommSc1gsvRLdSuffoLQQA1ooYR1w6Si/jiDsWveS7pjot8cJ2f2gQ3r8EtVB+WKk72OO+gYd/PVWRVy8BUjht21uVp3flzbe/RBM7Boq5FmLsFQw9S7MQTXNNty5q5Ae9GnrJGatxhEIEe8gPAChakeHwGS3nd+wOuEJXrnHgwCOWwuQK5mvl7ikgejiBZVRLKCzM7AaBTH5LNYwUJHm229Oyoie7eKlBzqI3WDz8Y5+DjzpApGfOIVrflf4PvI+uapGu2F4mryTlDesq3NOvRbH9S+pq0OiDD6v9ctqeEHwRXnRgfXTRkgcx1KslXV7rN2IT7CM2tQjQHgLDrL54M9fzeNST0TVfBdL56TeCgcIC55PKdiTSeu+JRMkqmFftapdkgCob85dzKDR5P09xpI/r+UJEH6BokeT/5JfLYe4DihYWxSNy1r0ep2LHOSv6EOLaAF2/ZQcewy6j8HDYQfVFQx8l5QIr+19CXxzwedhKo48cTT39hdqah+AwYbpvKRrMzRzkHj5vXCpmdoV9TdDlDTnfcWBoa0YXfwS3BxXNn/RbrIr7yPo5WqkvMQRmMYblOC2Fq9NPvn7S2UreHrBluJBT1AwWw24fz1Jhl+EAcj0mKBvdpjIzI3r5MbuWY96Nu7bf9vgQYJsf+3D2s9QwfUUA/17RpZzHj7AydAHkW97a4kERnwJBhKVwn614PSZCN7xwi2aNRyo7uZjzz7ppu
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:; IPV:NLI; SFV:NSPM;
	H:AM6PR04MB6488.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
	SFS:(366004)(966005)(83380400001)(2616005)(66556008)(66476007)(8676002)(38100700002)(4326008)(6486002)(86362001)(31686004)(31696002)(36756003)(26005)(53546011)(6666004)(55236004)(186003)(2906002)(16576012)(110136005)(498600001)(5660300002)(66946007)(956004)(8936002)(45980500001)(43740500002);
	DIR:OUT; SFP:1101; 
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NzR3CFH340gJjAVUmuSYt72XMAWETfe13TGwsR4ihQYRXG3wC8BoPQkGEktT?=
	=?us-ascii?Q?wGCAgzSMM/5qAAakLpFPeiqSbCV451wT4+fDiaHs3CHEO0nt1Fp0fxQiNBSw?=
	=?us-ascii?Q?OuB972LgIn885TeiQSkkrYfxw8RYfj6hFSMe2e3ErI/l+arpQRwHP6qviJgM?=
	=?us-ascii?Q?lLarYJ4EwSK3vPR0SJQJT2AykEuFkZPJX84CDUOjperBTdDzL77e9SqlwVqg?=
	=?us-ascii?Q?1fpvL+OCHRxoeHgp+YlD2Ak8AUliAKNNQ9XfxqNLPra5Ego7gCfbAdVRMvvm?=
	=?us-ascii?Q?OS4C+JXs9FnqeZkK8PfxmHoePebBerBr1tEG3T6OH8t1pDNaiMLDU2krdzjb?=
	=?us-ascii?Q?Daz4hYWp4nk54nizCNPWgV8pny3iArgXj0o2MCsX3x60RPZBjeRkpRn66Eab?=
	=?us-ascii?Q?0YbJnX9mQeo5gty46LdppuR8xOj0ljKWYgsLYwN15MxaI5v0BA29bfu+TlW6?=
	=?us-ascii?Q?McsShMkTMozWCo1zR04wshgmEyKj4c/C59dTOqGGg8niNty+XcdUg9HfRD5N?=
	=?us-ascii?Q?6J8tyTLia8h3GaTCyfpz1IqpiQoxrMN3GMzKUxvZKC4PPL4J/FLJEECuONzv?=
	=?us-ascii?Q?7HrcseRNRdQ8Kfp/DNM2IW2EpvdIOFF+/hN7INi71OTvLHMiaLTHFiTzTJSX?=
	=?us-ascii?Q?8Rh5t30LXd+2S72GbMlwTJmsbxcoGtUakoscdg4tnD4q48Zfbfs5QJEusibB?=
	=?us-ascii?Q?BCcFt3aSX6VG/2aR4jg8of3JUTC3yRmu1rIvpsUfDifuHHmtlsa2zuDemazv?=
	=?us-ascii?Q?pRZVCz+W+duizx8W2hEsxMQzCev9JjBS8/mDFukOFGWJMWkciydBamXRMdLS?=
	=?us-ascii?Q?znI9wqEgG1S8no6LsgO+QMP3aHmGa3tiFg6JnYHcs0RmdaHtBVVv2WJbH15X?=
	=?us-ascii?Q?vIIglB6wXVjKqEd6H/Cjn0tWV2GGLGLg9xkGN0hwjN7DZnmZ9NaLWFMa7F+V?=
	=?us-ascii?Q?mdVZNCxou1cq6WFl0LLYQNb2ZZxbi0wroEaPBs80DG0OJzHquGg3Jo6Mx+Li?=
	=?us-ascii?Q?alAf8ZyYCcSs3ym8NPe1e6JbWLaxLZNqs0TxSVmBLUekWQixVKIVtVf7DMP+?=
	=?us-ascii?Q?FNuenWlohmAZlFTpOgLlTLOdjC2xCt89xlYPkYyy4JkeEd+4TL8h2qS+WGIw?=
	=?us-ascii?Q?40nTW/SZJcXsYpKsWW2SL0k8ZQbfaK+SY1fVnCk3byxVczwTgIYpgBkuINWn?=
	=?us-ascii?Q?YAKctLnw9r6ctDUuyaZaRHdURzO8P7eJMgAiu+olQaari4/YBa0Yj4SeFoqZ?=
	=?us-ascii?Q?PSTxNkh/BVgshqXAuUnwPmo2CL0HxZQRQ7lxSaZ8UpyIeY/LxwBALqfo4O2g?=
	=?us-ascii?Q?sGpYn9jFmV1pRZD5n6JIsmuz?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfc5b075-f122-444c-2c03-08d968563be1
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB6488.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2021 05:56:23.3602 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tp7eb/kwMwv43NeacWCEtxMsz+XHfeOh13XZ8C8cXE/YMU1r2qoucP8JbW7j0zC5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7736
X-Source-IP: 194.104.109.102
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
	include:de._netblocks.mimecast.com
	include:amazonses.com include:spf.protection.outlook.com
	include:_spf.qemailserver.com include:_spf.salesforce.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10087
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=210
	malwarescore=0
	adultscore=0 mlxscore=0 lowpriorityscore=0 spamscore=0 phishscore=0
	priorityscore=146 mlxlogscore=999 suspectscore=0 impostorscore=0
	bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108260035
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10087
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
	bulkscore=0 malwarescore=0
	spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108260035
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: reflink deadlock when clone file
 to the same directory simultaneously
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.9
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10087 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108260035
X-Proofpoint-ORIG-GUID: lcdssPTy8YoETeeSAVKTYBk7uVZCda3N
X-Proofpoint-GUID: lcdssPTy8YoETeeSAVKTYBk7uVZCda3N

CgpPbiAyMDIxLzgvMTkgMTQ6MzEsIEdhbmcgSGUgd3JvdGU6Cj4gCj4gCj4gT24gMjAyMS84LzE5
IDEwOjAyLCBKb3NlcGggUWkgd3JvdGU6Cj4+Cj4+Cj4+IE9uIDgvMTkvMjEgOTo1MSBBTSwgR2Fu
ZyBIZSB3cm90ZToKPj4+Cj4+Pgo+Pj4gT24gMjAyMS84LzE4IDE5OjIwLCBKb3NlcGggUWkgd3Jv
dGU6Cj4+Pj4KPj4+Pgo+Pj4+IE9uIDgvMTgvMjEgNToyMCBQTSwgR2FuZyBIZSB3cm90ZToKPj4+
Pj4KPj4+Pj4KPj4+Pj4gT24gMjAyMS84LzEzIDE3OjU0LCBKb3NlcGggUWkgd3JvdGU6Cj4+Pj4+
Pgo+Pj4+Pj4KPj4+Pj4+IE9uIDgvOS8yMSA2OjA4IFBNLCBHYW5nIEhlIHdyb3RlOgo+Pj4+Pj4+
IEhpIEpvc2VwaCBhbmQgQWxsLAo+Pj4+Pj4+Cj4+Pj4+Pj4gVGhlIGRlYWRsb2NrIGlzIGNhdXNl
ZCBieSBzZWxmLWxvY2tpbmcgb24gb25lIG5vZGUuCj4+Pj4+Pj4gVGhlcmUgaXMgdGhyZWUgbm9k
ZSBjbHVzdGVyIChtb3VudGVkIHRvIC9tbnQvc2hhcmVkKSwgdGhlIHVzZXIgcnVuIHJlZmxpbmsg
Y29tbWFuZCB0byBjbG9uZSB0aGUgZmlsZSB0byB0aGUgc2FtZSBkaXJlY3RvcnkgcmVwZWF0ZWRs
eSwKPj4+Pj4+PiBlLmcuCj4+Pj4+Pj4gICDCoMKgwqByZWZsaW5rICIvbW50L3NoYXJlZC90ZXN0
IiBcCj4+Pj4+Pj4gICDCoMKgwqAiL21udC9zaGFyZWQvLnNuYXBzaG90cy90ZXN0LmBkYXRlICsl
bSVkJUglTSVTYC5gaG9zdG5hbWVgIgo+Pj4+Pj4+Cj4+Pj4+Pj4gQWZ0ZXIgYSB3aGlsZSwgdGhl
IHJlZmxpbmsgcHJvY2VzcyBvbiBlYWNoIG5vZGUgaXMgaHVuZywgdGhlIGZpbGUgc3lzdGVtIGNh
bm5vdCBiZSBsaXN0ZWQuCj4+Pj4+Pj4gVGhlIHByb2JsZW1hdGljIHJlZmxpbmsgY29tbWFuZCBw
cm9jZXNzIGlzIGJsb2NrZWQgYnkgaXRzZWxmLCBlLmcuIHRoZSByZWZsaW5rIHByb2Nlc3MgaXMg
aHVuZyBhdCBnaGUtc2xlMTVzcDItbmQyLAo+Pj4+Pj4+IGtlcm5lbDogdGFzazpyZWZsaW5rwqDC
oMKgwqDCoMKgwqDCoCBzdGF0ZTpEIHN0YWNrOsKgwqDCoCAwIHBpZDoxNjk5MiBwcGlkOsKgIDQ1
MzAKPj4+Pj4+PiBrZXJuZWw6IENhbGwgVHJhY2U6Cj4+Pj4+Pj4ga2VybmVsOsKgIF9fc2NoZWR1
bGUrMHgyZmQvMHg3NTAKPj4+Pj4+PiBrZXJuZWw6wqAgPyB0cnlfdG9fd2FrZV91cCsweDE3Yi8w
eDRlMAo+Pj4+Pj4+IGtlcm5lbDrCoCBzY2hlZHVsZSsweDJmLzB4YTAKPj4+Pj4+PiBrZXJuZWw6
wqAgc2NoZWR1bGVfdGltZW91dCsweDFjYy8weDMxMAo+Pj4+Pj4+IGtlcm5lbDrCoCA/IF9fd2Fr
ZV91cF9jb21tb24rMHg3NC8weDEyMAo+Pj4+Pj4+IGtlcm5lbDrCoCB3YWl0X2Zvcl9jb21wbGV0
aW9uKzB4YmEvMHgxNDAKPj4+Pj4+PiBrZXJuZWw6wqAgPyB3YWtlX3VwX3ErMHhhMC8weGEwCj4+
Pj4+Pj4ga2VybmVsOsKgIF9fb2NmczJfY2x1c3Rlcl9sb2NrLmlzcmEuNDErMHgzYjUvMHg4MjAg
W29jZnMyXQo+Pj4+Pj4+IGtlcm5lbDrCoCA/IG9jZnMyX2lub2RlX2xvY2tfZnVsbF9uZXN0ZWQr
MHgxZmMvMHg5NjAgW29jZnMyXQo+Pj4+Pj4+IGtlcm5lbDrCoCBvY2ZzMl9pbm9kZV9sb2NrX2Z1
bGxfbmVzdGVkKzB4MWZjLzB4OTYwIFtvY2ZzMl0KPj4+Pj4+PiBrZXJuZWw6wqAgb2NmczJfaW5p
dF9zZWN1cml0eV9hbmRfYWNsKzB4YmUvMHgxZDAgW29jZnMyXQo+Pj4+Pj4+IGtlcm5lbDrCoCBv
Y2ZzMl9yZWZsaW5rKzB4NDM2LzB4NGMwIFtvY2ZzMl0KPj4+Pj4+PiBrZXJuZWw6wqAgPyBvY2Zz
Ml9yZWZsaW5rX2lvY3RsKzB4MmNhLzB4MzYwIFtvY2ZzMl0KPj4+Pj4+PiBrZXJuZWw6wqAgb2Nm
czJfcmVmbGlua19pb2N0bCsweDJjYS8weDM2MCBbb2NmczJdCj4+Pj4+Pj4ga2VybmVsOsKgIG9j
ZnMyX2lvY3RsKzB4MjVlLzB4NjcwIFtvY2ZzMl0KPj4+Pj4+PiBrZXJuZWw6wqAgZG9fdmZzX2lv
Y3RsKzB4YTAvMHg2ODAKPj4+Pj4+PiBrZXJuZWw6wqAga3N5c19pb2N0bCsweDcwLzB4ODAKPj4+
Pj4+Pgo+Pj4+Pj4+IEluIGZhY3QsIHRoZSBkZXN0aW5hdGlvbiBkaXJlY3RvcnkoLnNuYXBzaG90
cykgaW5vZGUgZGxtIGxvY2sgd2FzIGFjcXVpcmVkIGJ5IGdoZS1zbGUxNXNwMi1uZDIsIG5leHQg
dGhlcmUgaXMgYmFzdCBtZXNzYWdlIGZyb20gb3RoZXIgbm9kZXMgdG8gYXNrIGdoZS1zbGUxNXNw
Mi1uZDIgZG93bmNvbnZlcnQgbG9jaywgYnV0IHRoZSBvcGVyYXRpb24gZmFpbGVkLCB0aGUga2Vy
bmVsIG1lc3NhZ2UgaXMgcHJpbnRlZCBsaWtlLAo+Pj4+Pj4+IGtlcm5lbDogKG9jZnMyZGMtQUEz
NUREOSwyNTYwLDMpOm9jZnMyX2Rvd25jb252ZXJ0X2xvY2s6MzY2MCBFUlJPUjogRExNIGVycm9y
IC0xNiB3aGlsZSBjYWxsaW5nIG9jZnMyX2RsbV9sb2NrIG9uIHJlc291cmNlIE0wMDAwMDAwMDAw
MDAwMDAwMDQ2ZTAyMDAwMDAwMDAKPj4+Pj4+PiBrZXJuZWw6IChvY2ZzMmRjLUFBMzVERDksMjU2
MCwzKTpvY2ZzMl91bmJsb2NrX2xvY2s6MzkwNCBFUlJPUjogc3RhdHVzID0gLTE2Cj4+Pj4+Pj4g
a2VybmVsOiAob2NmczJkYy1BQTM1REQ5LDI1NjAsMyk6b2NmczJfcHJvY2Vzc19ibG9ja2VkX2xv
Y2s6NDMwMyBFUlJPUjogc3RhdHVzID0gLTE2Cj4+Pj4+Pj4KPj4+Pj4+PiBUaGVuLCB0aGUgcmVm
bGluayBwcm9jZXNzIHRyaWVzIHRvIGFjcXVpcmUgdGhpcyBkaXJlY3RvcnkgaW5vZGUgZGxtIGxv
Y2ssIHRoZSBwcm9jZXNzIGlzIGJsb2NrZWQsIHRoZSBkbG0gbG9jayByZXNvdXJjZSBpbiBtZW1v
cnkgbG9va3MgbGlrZQo+Pj4+Pj4+Cj4+Pj4+Pj4gICDCoMKgwqDCoMKgIGxfbmFtZSA9ICJNMDAw
MDAwMDAwMDAwMDAwMDA0NmUwMjAwMDAwMDAwIiwKPj4+Pj4+PiAgIMKgwqDCoMKgwqAgbF9yb19o
b2xkZXJzID0gMCwKPj4+Pj4+PiAgIMKgwqDCoMKgwqAgbF9leF9ob2xkZXJzID0gMCwKPj4+Pj4+
PiAgIMKgwqDCoMKgwqAgbF9sZXZlbCA9IDUgJ1wwMDUnLAo+Pj4+Pj4+ICAgwqDCoMKgwqDCoCBs
X3JlcXVlc3RlZCA9IDAgJ1wwMDAnLAo+Pj4+Pj4+ICAgwqDCoMKgwqDCoCBsX2Jsb2NraW5nID0g
NSAnXDAwNScsCj4+Pj4+Pj4gICDCoMKgwqDCoMKgIGxfdHlwZSA9IDAgJ1wwMDAnLAo+Pj4+Pj4+
ICAgwqDCoMKgwqDCoCBsX2FjdGlvbiA9IDAgJ1wwMDAnLAo+Pj4+Pj4+ICAgwqDCoMKgwqDCoCBs
X3VubG9ja19hY3Rpb24gPSAwICdcMDAwJywKPj4+Pj4+PiAgIMKgwqDCoMKgwqAgbF9wZW5kaW5n
X2dlbiA9IDY0NTk0OCwKPj4+Pj4+Pgo+Pj4+Pj4+Cj4+Pj4+Pj4gU28gZmFyLCBJIGRvIG5vdCBr
bm93IHdoYXQgbWFrZXMgZGxtIGxvY2sgZnVuY3Rpb24gZmFpbGVkLCBpdCBhbHNvIGxvb2tzIHdl
IGRvIG5vdCBoYW5kbGUgdGhpcyBmYWlsdXJlIGNhc2UgaW4gZGxtZ2x1ZSBsYXllciwgYnV0IEkg
YWx3YXlzIHJlcHJvZHVjZSB0aGlzIGhhbmcgd2l0aCBteSB0ZXN0IHNjcmlwdCwgZS5nLgo+Pj4+
Pj4+Cj4+Pj4+Pj4gICDCoMKgwqAgbG9vcD0xCj4+Pj4+Pj4gICDCoMKgwqAgd2hpbGUgKChsb29w
KyspKSA7IGRvCj4+Pj4+Pj4gICDCoMKgwqDCoMKgwqDCoMKgwqAgZm9yIGkgaW4gYHNlcSAxIDEw
MGA7IGRvCj4+Pj4+Pj4gICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJlZmxpbmsgIi9tbnQvc2hh
cmVkL3Rlc3QiICIvbW50L3NoYXJlZC8uc25hcHNob3RzIC90ZXN0LiR7bG9vcH0uJHtpfS5gZGF0
ZSArJW0lZCVIJU0lU2AuYGhvc3RuYW1lYCIKPj4+Pj4+PiAgIMKgwqDCoMKgwqDCoMKgwqDCoCBk
b25lCj4+Pj4+Pj4gICDCoMKgwqDCoMKgwqDCoMKgwqAgdXNsZWVwIDUwMDAwMAo+Pj4+Pj4+ICAg
wqDCoMKgwqDCoMKgwqDCoMKgIHJtIC1mIC9tbnQvc2hhcmVkLy5zbmFwc2hvdHMvdGVzdG5vZGUx
LnFjb3cyLiouYGhvc3RuYW1lYAo+Pj4+Pj4+ICAgwqDCoMKgIGRvbmUKPj4+Pj4+Pgo+Pj4+Pj4+
IE15IHBhdGNoIGNoYW5nZXMgbXVsdGlwbGUgYWNxdWlyaW5nIGRlc3QgZGlyZWN0b3J5IGlub2Rl
IGRsbSBsb2NrIGR1cmluZyBpbiBvY2ZzMl9yZWZsaW5rIGZ1bmN0aW9uLCBpdCBhdm9pZHMgdGhl
IGhhbmcgaXNzdWUgaGFwcGVuIGFnYWluLlRoZSBjb2RlIGNoYW5nZSBhbHNvIGNhbiBpbXByb3Zl
IHJlZmxpbmsgcGVyZm9ybWFuY2UgaW4gdGhpcyBjYXNlLgo+Pj4+Pj4+Cj4+Pj4+Pj4gVGhhbmtz
Cj4+Pj4+Pj4gR2FuZwo+Pj4+Pj4KPj4+Pj4+ICdzdGF0dXMgPSAtMTYnIGltcGxpZXMgRExNX0NB
TkNFTEdSQU5ULgo+Pj4+Pj4gRG8geW91IHVzZSBzdGFjayB1c2VyIGluc3RlYWQgb2YgbzJjYj8g
SWYgeWVzLCBjYW4geW91IHRyeSBvMmNiIHdpdGgKPj4+Pj4+IHlvdXIgcmVwcm9kdWNlcj8KPj4+
Pj4KPj4+Pj4gSSBzZXR1cCBvMmNiIGJhc2VkIG9jZnMyIGNsdXN0ZXJzIHdpdGggc2xlMTVzcDIg
YW5kIG9yYWNsZUxpbnV4OHU0Lgo+Pj4+PiBBZnRlciB0d28gZGF5IHRlc3Rpbmcgd2l0aCB0aGUg
c2FtZSBzY3JpcHQsIEkgZGlkIG5vdCBlbmNvdW50ZXIgZGxtX2xvY2sgZG93bmNvbnZlcnQgZmFp
bHVyZSwgdGhlIGhhbmcgaXNzdWUgZGlkIG5vdCBoYXBwZW4uCj4+Pj4+IEFmdGVyIG15IHBhdGNo
IHdhcyBhcHBsaWVkLCB0aGVyZSB3YXMgbm90IGFueSBzaWRlIGVmZmVjdCwgdGhlIHJlZmxpbmsg
cGVyZm9ybWFuY2Ugd2FzIGRvdWJsZWQgaW4gdGhlIGNhc2UuCj4+Pj4+Cj4+Pj4KPj4+PiBEbyB5
b3UgbWVhbiB0aGUgaGFuZyBvbmx5IGhhcHBlbnMgb24gc3RhY2sgdXNlcj8KPj4+IFllcy4KPj4+
IFdoeT8gc2luY2UgbzJjYiBiYXNlZCBkbG1fbG9jayBkaWQgbm90IHJldHVybiBlcnJvciAtMTYg
d2hlbiBkb3duY292ZXJ0IGRsbSBsb2NrIGR1cmluZyB0aGUgd2hvbGUgdGVzdGluZy4KPj4+IEJ1
dCBwbWNrIGJhc2VkIGRsbV9sb2NrIHJldHVuZWQgZXJyb3IgLTE2IGR1cmluZyB0aGUgdGVzdGlu
ZywgdGhlbiB3ZSBkaWQgbm90IGhhbmRsZSB0aGlzIGVycm9yIGZ1cnRoZXIgaW4gZGxtZ2x1ZSBs
YXllciwgbmV4dCBlbmNvdW50ZXIgdGhlIGhhbmcgaXNzdWUgd2hlbiBkbG1fbG9jayBhY3F1aXJl
IHRoZSBsb2NrLiBNYXliZSB0aGVyZSBpcyBhIHJhY2UgY29uZGl0aW9uIHdoZW4gdXNpbmcgZGxt
X2xvY2svZGxtX3VubG9jayhjYW5jZWwpIGluIGRsbWdsdWUgbGF5ZXIuCj4+PiBBbnl3YXksIHRo
ZSBwcm9ibGVtIGJlbG9uZ3MgdG8gb2NmczIgb3duIHBhcnRzLgo+Pj4KPj4gSSBtZWFudCBpZiBE
TE1fQ0FOQ0VMR1JBTlQgaXMgbm90IHRoZSBleHBlY3RlZCByZXR1cm4gY29kZSwgd2UnZAo+PiBi
ZXR0ZXIgZml4IHRoZSBpc3N1ZSBpbiBzdGFja191c2VyLmMgYnV0IG5vdCBkbG1nbHVlLCBlLmcu
IHNvbWUgc3BlY2lmaWMKPj4gd3JhcHBlci4KPiBXZSBjYW5ub3Qgd3JhcHBlcihvciBpZ25vcmUp
IHRoaXMgZXJyb3IgaW4gc3RhY2tfdXNlciwgb3RoZXJ3aXNlIGl0IHdpbGwKPiBsZWFkIHRvIGEg
aGFuZyBwcm9ibGVtIHdoZW4gdGhlIG5leHQgZGxtX2xvY2sgaXMgaW52b2tlZC4KPiBCYXNlZCBv
biBjb21tZW50cyBmcm9tIGZzL2RsbSBtYWludGFpbmVyLCB0aGUgZXJyb3IgLTE2IGlzIHJldHVy
bmVkIGJ5Cj4gZGxtX2xvY2sgaW4gY2FzZSBvY2ZzMiBjYWxscyBkbG1fdW5sb2NrKENBTkNFTCkg
dG8gY2FuY2VsIGFuIGluLXByb2dyZXNzCj4gZGxtX2xvY2soKSByZXF1ZXN0Lgo+IEluIGZhY3Qs
IGlmIHlvdSByZWFkIHRoZSBjb2RlIGNvbW1lbnRzIGluIGRsbWdsdWUuYywgaXQgYWxzbyB0YWxr
ZWQKPiBhYm91dCB0aGUgc2ltaWxhciBzaXR1YXRpb24sIGJ1dCBJIGZlZWwgdGhlIGN1cnJlbnQg
Y29kZSBzaG91bGQgc3RpbGwKPiBoYXMgYSByYWNlIGNvbmRpdGlvbiwgdGhlbiB0cmlnZ2VyIGRs
bV9sb2NrIHJldHVybiAtMTYgZXJyb3IuCj4gRm9yIG8yY2Igc3RhY2ssIGl0J3MgZGxtX2xvY2sg
ZGlkIG5vdCBleHBvc2UgdGhpcyBlcnJvciwgbWF5YmUgaXQgaXMKPiBkaWZmZXJlbnQgaW4gZGxt
IGltcGxlbWVudGF0aW9uLgoKQmFzZWQgb24gbXkgZnVydGhlciBhbmFseXNpcyBhbmQgQkFTVFMg
dHJhY2VzLCBJIGZvdW5kIHRoZXJlIGFyZSBzb21lIApkaWZmZXJlbmNlcyBpbiBiZWhhdmlvciBi
ZXR3ZWVuIG8yZGxtIGFuZCBmc2RsbS4KVXN1YWxseSwgb2NmczJfZG93bmNvbnZlcnRfbG9jaygp
IGZ1bmN0aW9uIGFsd2F5cyBkb3duY29udmVydHMKZGxtIGxvY2sgdG8gdGhlIGV4cGVjdGVkIGxl
dmVsIGZvciBzYXRpc2Z5IGRsbSBiYXN0IHJlcXVlc3RzCmZyb20gdGhlIG90aGVyIG5vZGVzLgpC
dXQgdGhlcmUgaXMgYSByYXJlIHNpdHVhdGlvbi4gV2hlbiBkbG0gbG9jayBjb252ZXJzaW9uIGlz
IGJlaW5nCmNhbmNlbGVkLCBvY2ZzMl9kb3duY29udmVydF9sb2NrKCkgZnVuY3Rpb24gd2lsbCBy
ZXR1cm4gLUVCVVNZLgpZb3UgbmVlZCB0byBiZSBhd2FyZSB0aGF0IG9jZnMyX2NhbmNlbF9jb252
ZXJ0KCkgZnVuY3Rpb24gaXMKYXN5bmNocm9ub3VzIGluIGZzZGxtIGltcGxlbWVudGF0aW9uLCB0
aGF0IG1lYW5zIG9jZnMyX2NhbmNlbF9jb252ZXJ0KCkKd2lsbCByZXR1cm4gZGlyZWN0bHksIHRo
ZW4gdGhlIGFjdHVhbCBkbG0gbG9jayBjYW5jZWwgaXMgZXhlY3V0ZWQgaW4gCmJhY2tncm91bmQu
CkZvciBvMmRsbSBpbXBsZW1lbnRhdGlvbiwgb2NmczJfY2FuY2VsX2NvbnZlcnQoKSBmdW5jdGlv
biBpcyAKc3luY2hyb25vdXMsIHRoYXQgbWVhbnMgdGhpcyBmdW5jdGlvbiB3aWxsIHJldHVybiBh
ZnRlciB0aGUgZGxtIGxvY2sgaXMKY2FuY2VsbGVkIGFuZCBhc3QgY2FsbGJhY2sgZnVuY3Rpb24g
aXMgaW52b2tlZC4KCklmIHdlIGRvZXMgbm90IHJlcXVldWUgdGhpcyBsb2NrcmVzIGVudHJ5LCBv
Y2ZzMiBkb3duY29udmVydAp0aHJlYWQgbm8gbG9uZ2VyIGhhbmRsZXMgdGhpcyBkbG0gbG9jayBi
YXN0IHJlcXVlc3QuIFRoZW4sIHRoZQpvdGhlciBub2RlcyB3aWxsIG5vdCBnZXQgdGhlIGRsbSBs
b2NrIGFnYWluLCB0aGUgY3VycmVudCBub2RlJ3MKcHJvY2VzcyB3aWxsIGJlIGJsb2NrZWQgd2hl
biBhY3F1aXJlIHRoaXMgZGxtIGxvY2sgYWdhaW4uCgpTbywgSSB3aWxsIHNlbmQgYSBuZXcgcGF0
Y2ggdG8gZml4IHRoaXMgZGVhZGxvY2sgcHJvYmxlbSB2aWEgZGxtZ2x1ZSBsYXllci4KRm9yIHRo
aXMgcGF0Y2gsIEkgd2FudCB0byBjaGFuZ2UgdGhlIHBhdGNoIGNvbW1lbnRzIGFzIGEgcmVmbGlu
ayAKaW1wcm92ZW1lbnQgcGF0Y2guCgpUaGFua3MKR2FuZwoKCgo+IAo+IFRoYW5rcwo+IEdhbmcK
PiAKPj4KPj4gVGhhbmtzLAo+PiBKb3NlcGgKPj4KPiAKPiAKPiBfX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fXwo+IE9jZnMyLWRldmVsIG1haWxpbmcgbGlzdAo+
IE9jZnMyLWRldmVsQG9zcy5vcmFjbGUuY29tCj4gaHR0cHM6Ly9vc3Mub3JhY2xlLmNvbS9tYWls
bWFuL2xpc3RpbmZvL29jZnMyLWRldmVsCj4gCgoKX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX18KT2NmczItZGV2ZWwgbWFpbGluZyBsaXN0Ck9jZnMyLWRldmVs
QG9zcy5vcmFjbGUuY29tCmh0dHBzOi8vb3NzLm9yYWNsZS5jb20vbWFpbG1hbi9saXN0aW5mby9v
Y2ZzMi1kZXZlbA==
