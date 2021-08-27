Return-Path: <SRS0=bb4f=NS=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3BB4C432BE
	for <ocfs2-devel@archiver.kernel.org>; Fri, 27 Aug 2021 05:51:29 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 71E7260FD7
	for <ocfs2-devel@archiver.kernel.org>; Fri, 27 Aug 2021 05:51:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 71E7260FD7
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17QNX8UY016247;
	Fri, 27 Aug 2021 05:51:29 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ap0xpb2d7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Aug 2021 05:51:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17R5njRT128520;
	Fri, 27 Aug 2021 05:51:27 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3ajpm42b7t-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 27 Aug 2021 05:51:27 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mJUlx-00028t-G8; Thu, 26 Aug 2021 22:51:25 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ghe@suse.com>) id 1mJUlQ-0001xr-Qm
	for ocfs2-devel@oss.oracle.com; Thu, 26 Aug 2021 22:50:52 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17R5nkBM128530
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 05:50:52 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by userp3030.oracle.com with ESMTP id 3ajpm42aj5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 05:50:50 +0000
Received: from pps.filterd (m0246580.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id
	17R2kJKb021984
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 05:50:49 GMT
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102])
	by mx0b-00069f01.pphosted.com with ESMTP id 3apqhxskjn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 05:50:49 +0000
Received: from EUR02-HE1-obe.outbound.protection.outlook.com
	(mail-he1eur02lp2055.outbound.protection.outlook.com [104.47.5.55])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-13-4RXrjSXyPIKdh7D7E7pllA-2; Fri, 27 Aug 2021 07:50:46 +0200
X-MC-Unique: 4RXrjSXyPIKdh7D7E7pllA-2
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
	b=QQJBtezb/L2O2lv80GZV37Qkpne0adgl+W56pZLwDrom1F0Ykye3jJ4SJT/r8epCCbVB0dNo8Zw4LrKoPSFcO3ssE25KmW1mjs+N+JChkLRZfmyvLB/vTFTDlYy21hL2F5+qnFQ8fcho2/bl6BWcSmy05Ablw26Sis+6T37TCCmKdDKAb8WIQ2fqNsY9jVTOt+6itX89lM3RF1zvgDJiaCUXEpfaEFtAepNzMYaW0Nq0FT1zTVybHuHh6577xuqtzgvngRU0oI3Pf0dB9hBM0R6UVoE5WEQj5S3hYfUz8Z5CVM/Ni51UdnN7HjSy+rr5wEziE9Y1vqHAzpMW9vzFCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
	s=arcselector9901;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
	bh=fR783+xsxL/ZEw7sNi2Wkku3r10wNqRSxxBWpbYH+Qo=;
	b=oOmtlrpOPFG4iVfhcQywxZdUVd2DzZlX2+Z5vmcU5DDx7HH0/ga0vpa4UcmNd2Gz0d/8SgILhfJm8Lm3j9YKGTa4zyfFgm/Y06YlslQ3bPxEF7n4Er5i6WJXVB7BWlG9+0NZErEUpjTjgOPkv+eJWsvQKPvN4a3uiLZaxNng3As6Laa7/7yk9cp561iqxK90puoNTaVwH48ld/+wkkTKG7iVgQxxNPmdLppbTa7XQHoDgW2Yo88p/ryK8s4lFPfg6txw0z7t2gg3M+idiZZn8XqB0OvpU0cOwbrwTxIY3qtcYQHEORs9aLMgghPOSvH7GLAqUnljJ9yKH1MgCc3XQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
	smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
	dkim=pass header.d=suse.com; arc=none
Authentication-Results: linux-foundation.org; dkim=none (message not signed)
	header.d=none;linux-foundation.org; dmarc=none action=none
	header.from=suse.com;
Received: from AM6PR04MB6488.eurprd04.prod.outlook.com (2603:10a6:20b:f8::21)
	by AM6PR04MB4839.eurprd04.prod.outlook.com (2603:10a6:20b:10::17)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19;
	Fri, 27 Aug 2021 05:50:44 +0000
Received: from AM6PR04MB6488.eurprd04.prod.outlook.com
	([fe80::793c:6276:4f2a:4d71]) by
	AM6PR04MB6488.eurprd04.prod.outlook.com
	([fe80::793c:6276:4f2a:4d71%4]) with mapi id 15.20.4457.017;
	Fri, 27 Aug 2021 05:50:44 +0000
To: Joseph Qi <joseph.qi@linux.alibaba.com>, mark@fasheh.com,
        jlbec@evilplan.org
References: <20210826061038.22295-1-ghe@suse.com>
	<b3f498eb-7de5-8a7f-0f52-01c1e2caa5d8@linux.alibaba.com>
	<7795ed72-8b77-14ea-cf18-78870e58f429@suse.com>
	<0a8db668-b6f4-4b33-086a-2b522b343cf1@linux.alibaba.com>
From: Gang He <ghe@suse.com>
Message-ID: <f19462cc-b816-ac40-e86a-a1900611c371@suse.com>
Date: Fri, 27 Aug 2021 13:50:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
	Thunderbird/78.13.0
In-Reply-To: <0a8db668-b6f4-4b33-086a-2b522b343cf1@linux.alibaba.com>
Content-Language: en-US
X-ClientProxiedBy: HK0PR03CA0097.apcprd03.prod.outlook.com
	(2603:1096:203:b0::13) To AM6PR04MB6488.eurprd04.prod.outlook.com
	(2603:10a6:20b:f8::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.67.20.87] (60.251.47.115) by
	HK0PR03CA0097.apcprd03.prod.outlook.com (2603:1096:203:b0::13)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.18
	via Frontend Transport; Fri, 27 Aug 2021 05:50:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ca525c7-2881-4afd-7e96-08d9691e9c42
X-MS-TrafficTypeDiagnostic: AM6PR04MB4839:
X-Microsoft-Antispam-PRVS: <AM6PR04MB483935C4813D8B6292D90B95CFC89@AM6PR04MB4839.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gu/iMKM9EMNpr3TruvpQcY8+bglY8Egq31CAU5zIBK42M3O1V+0jXa7G8OAJ6s6ZoF0IbLwm74WZ2RA7pKykSZFXI8dmirMW4AzsA0WVN3QKIgsLETRLr6NEJAkGgEZ2mG08deARhv59v9/fOVHWUOEoHSayrfPqmAsbimK15uFHKSaCoyWR21L9t3EPI9hwKbrVEJGl5c3/SlLlqurtsOvxHs3q7S+bmcD0Qitm+iX3fkf09lVaVEmE6Ee9nzQZYxYweEz7e3IgWQoxZGnJcCpS5Rb681I3Bf+vgCGzCi6l+LwR/zx2EznqqvpIgD4LrZFTVDzkNvYKjxotlngA7jNtR8usTh42NJpK40JJ7WVVLHutokSi7SQirF5gAAsMsxq+fe7C67G+ZlxdRwwuULWt62CU23ziYoJz7pQPQavEn1X7Tebt2KonuVH5sOXs2bN/id7M5SZpthcseqfguDFqUeSbtntfFH/rZbnbHjvn/c6y1TsffBYrFCJr4GxPQs8oTMlI8GAiSOBPYLbWecq/BhAivJ7u0XqhizAJGU43K44WZ1DY8bvcx5UAK6otbwezOTg41xMRLYMihQO3umIM4R8+eJ/2fukcKB9p2DB92ICGWPMrt2Yp2lGrm3wSncfvTuxrj53RnaVwIR/42wvBsQQ3iPmEmdvxfJl1peQTkqHUd9NkEQdbqzDzrFzMQm7/Xp3eRk9FqRBTmr3GE/Wp8mFS7iUzo4Wz7rh75BU=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:; IPV:NLI; SFV:NSPM;
	H:AM6PR04MB6488.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
	SFS:(136003)(366004)(396003)(376002)(39860400002)(346002)(4326008)(6486002)(6666004)(5660300002)(478600001)(8936002)(66476007)(31696002)(38100700002)(53546011)(2906002)(2616005)(55236004)(86362001)(8676002)(186003)(36756003)(66556008)(31686004)(956004)(316002)(26005)(66946007)(16576012)(83380400001)(45980500001)(43740500002);
	DIR:OUT; SFP:1101; 
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kh4rMFHT3g090S62WUViEt0+/uTmgpiZ7OIzr8r99omsUup+IqT1DGyS2TsJ?=
	=?us-ascii?Q?pS9+LH3qPG9Ewb82fSxtdh2ac83jiK2Yi/r+e2yBAx9SJa2okMEe6gI6N8rt?=
	=?us-ascii?Q?VXSsQGUb64CyBwrf9nlAIpQCsIMUmQ/Xf9zKujcYpAJhvcf+0/WorZrurIo8?=
	=?us-ascii?Q?hdB+jkDoZhUAU+3Fg9IBcYdr9Efks1hGuRDYnVEYCkxpxPwOhtCGuEIzDBUI?=
	=?us-ascii?Q?FE5IP4p5PcHjrUvlVukRZ1Aqzx99/XuCDnNZVQ5yrM/hFiNcTqVNHCrDbvkp?=
	=?us-ascii?Q?Wny5sOZHf8EijGCtVci3zqfHzRVq69TtEsnjOqxB6u0ayWXgeXsR5ijax2Dn?=
	=?us-ascii?Q?MuwdtbsoBWyOFoUf+D7HElsshqOjBJob3WbesuVL4it0+vZ7eeozeKDf7vtR?=
	=?us-ascii?Q?NJO/yAFI491j6mm56bmhYX0x3jqpjN9mqYUt5wjRE11DD7g3NAdJAYq7CyXz?=
	=?us-ascii?Q?LG2esRZZR8+gflyAu5pjLCL4rVzijzgsFApraB1mO0thxiclnhdOqpDy9C7M?=
	=?us-ascii?Q?HXxYrs79SMULYu76p6jZVnNsUisLyuRydPiMmeUK7nfyG0+X8WKedYjR6WrV?=
	=?us-ascii?Q?GkHkEEDnhpqlhjc+BibOMbtoThizA4o1H5AGZCsvhtBg1LRsTv/WgtyPMl+h?=
	=?us-ascii?Q?KCoUuIdIuGNveYDgAkvKsC0lm7W7psTSlqK7OhjllqWh9Orne+s5g0f7/R+7?=
	=?us-ascii?Q?00THvNoH5TDbleCn3EI/PIYs0/2EigzblXlYP/6OEcjrusxCw3OljwiCIccH?=
	=?us-ascii?Q?OEdVNvBJnz6BnAoAybg0HiN7DJtYG5gkCELKtxCwRk1Nd4TaniKDvvfYbohL?=
	=?us-ascii?Q?MGm5VJY9xoHLWS+wX8rwGlWxeN52lx2x44TTT9miw0SHZkLw/NPAfclLz0/c?=
	=?us-ascii?Q?jTq/YY/MN/jR5G6sjTocZ5tBIrz0sEYj/IdlX7EdGSgzhc/pR2obPE341Us5?=
	=?us-ascii?Q?tZMqQhfW6/Phk6wKxdB2dhl7Uv04JUiAsMgA9dWy1RZZvegVVy2LlbdVpp6H?=
	=?us-ascii?Q?sCGcnKbzpvEbFWYxmDN34YtFntvlvPFHo3v+5n+2WjbPj0UOVVSRopCtcKJw?=
	=?us-ascii?Q?Bu7UiqMO+m/FepjZRXoDIk2FXpTtBn6c4HDVn+jQG0nMscw5VLrL6nRRp/cS?=
	=?us-ascii?Q?blF1iaoI1iic+/P4J349q7xNsWQErUsaQ0/iWvrvr2I0hJJOVJZsVxepb9cc?=
	=?us-ascii?Q?D1sVwBVuRXkzb41CzXELTcue4m+Ch6ojGfDYVIUJYIjAZ7DeBaH4fjCW0mkX?=
	=?us-ascii?Q?QC0tgXyDsntVVATobWpStCHsy86PjXWWicTIjKdxAOEVOS4r7+YvJIQpa9DQ?=
	=?us-ascii?Q?Mn1lTPjwha1U2aRaAdy0H02U?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ca525c7-2881-4afd-7e96-08d9691e9c42
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB6488.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2021 05:50:44.2843 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xy2tIHIavO+jUUjI5mZ26k+/FdvcBJPi9zF3/Ea8sAJX2Pn3eBcRmItv0UJsfW7F
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4839
X-Source-IP: 194.104.109.102
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
	include:de._netblocks.mimecast.com
	include:amazonses.com include:spf.protection.outlook.com
	include:_spf.qemailserver.com include:_spf.salesforce.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10088
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
	phishscore=0 adultscore=0
	suspectscore=0 clxscore=268 lowpriorityscore=0 mlxscore=0
	malwarescore=0
	impostorscore=0 spamscore=0 priorityscore=148 mlxlogscore=999
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108270036
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10088
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
	phishscore=0 malwarescore=0
	mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108270036
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: ocfs2_downconvert_lock failure
	results in deadlock
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10088 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108270036
X-Proofpoint-GUID: 857czG9icLXEgAGLK6H3TA88Q_JaH-gl
X-Proofpoint-ORIG-GUID: 857czG9icLXEgAGLK6H3TA88Q_JaH-gl

CgpPbiAyMDIxLzgvMjYgMTc6NTUsIEpvc2VwaCBRaSB3cm90ZToKPiAKPiAKPiBPbiA4LzI2LzIx
IDQ6NDUgUE0sIEdhbmcgSGUgd3JvdGU6Cj4+IEhpIEpvc2VwaCwKPj4KPj4gT24gMjAyMS84LzI2
IDE2OjIzLCBKb3NlcGggUWkgd3JvdGU6Cj4+Pgo+Pj4KPj4+IE9uIDgvMjYvMjEgMjoxMCBQTSwg
R2FuZyBIZSB3cm90ZToKPj4+PiBVc3VhbGx5LCBvY2ZzMl9kb3duY29udmVydF9sb2NrKCkgZnVu
Y3Rpb24gYWx3YXlzIGRvd25jb252ZXJ0cwo+Pj4+IGRsbSBsb2NrIHRvIHRoZSBleHBlY3RlZCBs
ZXZlbCBmb3Igc2F0aXNmeSBkbG0gYmFzdCByZXF1ZXN0cwo+Pj4KPj4+IHMvZm9yL3RvCj4+Pgo+
Pj4+IGZyb20gdGhlIG90aGVyIG5vZGVzLgo+Pj4+IEJ1dCB0aGVyZSBpcyBhIHJhcmUgc2l0dWF0
aW9uLiBXaGVuIGRsbSBsb2NrIGNvbnZlcnNpb24gaXMgYmVpbmcKPj4+PiBjYW5jZWxlZCwgb2Nm
czJfZG93bmNvbnZlcnRfbG9jaygpIGZ1bmN0aW9uIHdpbGwgcmV0dXJuIC1FQlVTWS4KPj4+PiBZ
b3UgbmVlZCB0byBiZSBhd2FyZSB0aGF0IG9jZnMyX2NhbmNlbF9jb252ZXJ0KCkgZnVuY3Rpb24g
aXMKPj4+PiBhc3luY2hyb25vdXMgaW4gZnNkbG0gaW1wbGVtZW50YXRpb24uCj4+Pj4gSWYgd2Ug
ZG9lcyBub3QgcmVxdWV1ZSB0aGlzIGxvY2tyZXMgZW50cnksIG9jZnMyIGRvd25jb252ZXJ0Cj4+
Pj4gdGhyZWFkIG5vIGxvbmdlciBoYW5kbGVzIHRoaXMgZGxtIGxvY2sgYmFzdCByZXF1ZXN0LiBU
aGVuLCB0aGUKPj4+PiBvdGhlciBub2RlcyB3aWxsIG5vdCBnZXQgdGhlIGRsbSBsb2NrIGFnYWlu
LCB0aGUgY3VycmVudCBub2RlJ3MKPj4+PiBwcm9jZXNzIHdpbGwgYmUgYmxvY2tlZCB3aGVuIGFj
cXVpcmUgdGhpcyBkbG0gbG9jayBhZ2Fpbi4KPj4+Pgo+Pj4+IFNpZ25lZC1vZmYtYnk6IEdhbmcg
SGUgPGdoZUBzdXNlLmNvbT4KPj4+PiAtLS0KPj4+PiAgwqAgZnMvb2NmczIvZGxtZ2x1ZS5jIHwg
MTMgKysrKysrKysrLS0tLQo+Pj4+ICDCoCAxIGZpbGUgY2hhbmdlZCwgOSBpbnNlcnRpb25zKCsp
LCA0IGRlbGV0aW9ucygtKQo+Pj4+Cj4+Pj4gZGlmZiAtLWdpdCBhL2ZzL29jZnMyL2RsbWdsdWUu
YyBiL2ZzL29jZnMyL2RsbWdsdWUuYwo+Pj4+IGluZGV4IDQ4ZmQzNjljMjlhNC4uYzQ1NGMyMThm
YmZlIDEwMDY0NAo+Pj4+IC0tLSBhL2ZzL29jZnMyL2RsbWdsdWUuYwo+Pj4+ICsrKyBiL2ZzL29j
ZnMyL2RsbWdsdWUuYwo+Pj4+IEBAIC0zNjcxLDEzICszNjcxLDExIEBAIHN0YXRpYyBpbnQgb2Nm
czJfZG93bmNvbnZlcnRfbG9jayhzdHJ1Y3Qgb2NmczJfc3VwZXIgKm9zYiwKPj4+PiAgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIE9DRlMyX0xPQ0tfSURfTUFYX0xFTiAtIDEp
Owo+Pj4+ICDCoMKgwqDCoMKgIGxvY2tyZXNfY2xlYXJfcGVuZGluZyhsb2NrcmVzLCBnZW5lcmF0
aW9uLCBvc2IpOwo+Pj4+ICDCoMKgwqDCoMKgIGlmIChyZXQpIHsKPj4+PiAtwqDCoMKgwqDCoMKg
wqAgb2NmczJfbG9nX2RsbV9lcnJvcigib2NmczJfZGxtX2xvY2siLCByZXQsIGxvY2tyZXMpOwo+
Pj4+ICvCoMKgwqDCoMKgwqDCoCBpZiAocmV0ICE9IC1FQlVTWSkKPj4+PiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCBvY2ZzMl9sb2dfZGxtX2Vycm9yKCJvY2ZzMl9kbG1fbG9jayIsIHJldCwgbG9j
a3Jlcyk7Cj4+Pgo+Pj4gRG8gd2UgaGF2ZSB0byB0cmVhdCBFQlVTWSBhcyBhIG5vcm1hbCBjYXNl
Pwo+PiBZZXMsIHRoaXMgcmV0dXJuIGNvZGUgaXMgZXhwZWN0ZWQgd2hlbiBjYWxsIGRsbV9sb2Nr
KCkgdG8gY29udmVydCBhIGRsbSBsb2NrIHRvIGFub3RoZXIgbGV2ZWwsIGJ1dCB0aGlzIGRsbSBs
b2NrIGlzIGJlaW5nIGNhbmNlbGxlZC4KPj4gQXMgSSBzYWlkIGluIGFub3RoZXIgbWFpbCwgZm9y
IGZzZGxtIGltcGxlbWVudGF0aW9uLG9jZnMyX2NhbmNlbF9jb252ZXJ0Cj4+IHdpbGwgcmV0dXJu
IGltbWVkaWF0ZWx5LCBidXQgdGhlIHJlbGF0ZWQgZGxtIGxvY2sgd2lsbChpcykgYmUgY2FuY2Vs
bGVkIGluIGJhY2tncm91bmQuIEZvciBvMmRsbSBpbXBsZW1lbnRhdGlvbixvY2ZzMl9jYW5jZWxf
Y29udmVydCB3aWxsIHJldHVybiBhZnRlciB0aGUgZGxtIGxvY2sgaXMgY2FuY2VsbGVkIGFuZCBp
dCdzIGFzdCBpcyBpbnZva2VkLCB0aGF0IGlzIHdoeSBvMmNiIGJhc2VkIG9jZnMyIGRvZXMgbm90
IGVuY291bnRlciAtRUJVU1kgcmV0dXJuIGNvZGUgaW4gbXkgdGVzdCBzY3JpcHQsIG9mIGNvdXJz
ZSwgdGhpcyBraW5kIG9mIGltcGxlbWVudGF0aW9uIHdpbGwgYmxvY2sgb3RoZXIgbG9ja3JlcyBl
bnRyaWVzIHRvIGJlIGhhbmRsZWQgZm9yIGEgbGl0dGxlIHRpbWUgaW4gZG93bi1jb252ZXJ0IHRo
cmVhZC4KPiAKPiBCZXR0ZXIgdG8gbGVhdmUgdGhpcyBsb2cgZm9yIGxhdGVyIGlzc3VlIHRyYWNr
aW5nLgo+IEknbSB3b3JyeWluZyBhYm91dCBpZiB0aGVyZSBhcmUgb3RoZXIgY2FzZXMgaGVyZS4K
T0sKCj4gCj4+Cj4+Pgo+Pj4+ICDCoMKgwqDCoMKgwqDCoMKgwqAgb2NmczJfcmVjb3Zlcl9mcm9t
X2RsbV9lcnJvcihsb2NrcmVzLCAxKTsKPj4+PiAtwqDCoMKgwqDCoMKgwqAgZ290byBiYWlsOwo+
Pj4+ICDCoMKgwqDCoMKgIH0KPj4+PiAgwqAgLcKgwqDCoCByZXQgPSAwOwo+Pj4+IC1iYWlsOgo+
Pj4+ICDCoMKgwqDCoMKgIHJldHVybiByZXQ7Cj4+Pj4gIMKgIH0KPj4+PiAgwqAgQEAgLTM5MTIs
NiArMzkxMCwxMyBAQCBzdGF0aWMgaW50IG9jZnMyX3VuYmxvY2tfbG9jayhzdHJ1Y3Qgb2NmczJf
c3VwZXIgKm9zYiwKPj4+PiAgwqDCoMKgwqDCoCBzcGluX3VubG9ja19pcnFyZXN0b3JlKCZsb2Nr
cmVzLT5sX2xvY2ssIGZsYWdzKTsKPj4+PiAgwqDCoMKgwqDCoCByZXQgPSBvY2ZzMl9kb3duY29u
dmVydF9sb2NrKG9zYiwgbG9ja3JlcywgbmV3X2xldmVsLCBzZXRfbHZiLAo+Pj4+ICDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBnZW4pOwo+Pj4+ICvCoMKgwqAg
Lyogb2NmczJfY2FuY2VsX2NvbnZlcnQoKSBpcyBpbiBwcm9ncmVzcywgdHJ5IGFnYWluIGxhdGVy
ICovCj4+Pj4gK8KgwqDCoCBpZiAocmV0ID09IC1FQlVTWSkgewo+Pj4+ICvCoMKgwqDCoMKgwqDC
oCBjdGwtPnJlcXVldWUgPSAxOwo+Pj4+ICvCoMKgwqDCoMKgwqDCoCBtbG9nKE1MX0JBU1RTLCAi
bG9ja3JlcyAlcywgUmVROiBEb3duY29udmVydCBidXN5XG4iLAo+Pj4+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgbG9ja3Jlcy0+bF9uYW1lKTsKPj4+PiArwqDCoMKgwqDCoMKgwqAgcmV0ID0g
MDsKPj4+Cj4+PiBEaXR0by4gSWYgRUJVU1kgaXMgbm90IGEgbm9ybWFsIGNhc2UsIEknZCBsaWtl
IGp1c3QgcmVxdWV1ZSBpdCBidXQgbm90Cj4+PiBjaGFuZ2UgaXQgdG8gbm9ybWFsIHJldHVybiBj
b2RlLgo+Pj4gWW91IGtub3cgTUxfQkFTVFMgaXMgYWx3YXlzIHN3aXRjaGVkIG9mZiBpbiBwcm9k
dWN0aW9uIGVudmlyb25tZW50Lgo+PiBTaW5jZSB0aGlzIGNhc2Ugc2hvdWxkIGJlIGNvbnNpZGVy
ZWQgYXMgYSBub3JtYWwgY2FzZSwgYWx0aG91Z2ggaXQncyByYXJlLgo+PiBXZSBzaG91bGQgbm90
IHByaW50IGFueSBlcnJvciBtZXNzYWdlIHRvIGtlcm5lbCBqb3VybmFsLCBidXQgaWYgdGhlIHVz
ZXIKPj4gdHVybiBvbiB0aGUgQkFTVFMgdHJhY2UsIGhlIHNob3VsZCB3YXRjaCB0aGlzIHRyYWNl
IGZvciBkZWJ1Z2dpbmcuCj4+Cj4gCj4gT2theSwgc2luY2Ugd2UgbGVhdmUgYW4gZXJyb3IgbWVz
c2FnZSBhYm92ZSwgd2UgY2FuIHJldHVybiBub3JtYWwgdG8KPiBjYWxsZXIuIEFuZCBub3cgY2Fs
bGVyIG9ubHkgcHJpbnQgYSBzaW1wbGUgZXJyb3Igd2hpY2ggZG9lc24ndCBoYXZlCj4gbXVjaCBt
ZWFuaW5nLgo+IAo+IEJUVywgY291bGQgd2UgY2hhbmdlIGl0IGxpa2U6Cj4gCj4gcmV0ID0gb2Nm
czJfZG93bmNvbnZlcnRfbG9jaygpOwo+IGlmIChyZXQgPT0gLUVCVVNZKSB7Cj4gCW1sb2coTUxf
QkFTVFMsIC4uLik7Cj4gCS8qIERlc2NyaWJlIHRoZSBjYXNlIHdoeSB3ZSBoYXZlIHRvIHJlcXVl
dWUgKi8KPiAJZ290byByZXF1ZXVlOwo+IH0KCkFjY29yZGluZyB0byB0aGUgY3VycmVudCBjb2Rl
LCBpdCBpcyBlYXN5IHRvCmdvdG8gbGVhdmUgbGFiZWwgd2l0aCBzZXQgY3RsLT5yZXF1ZXVlID0g
MSBmb3IgcmVxdWV1ZTsKCgpUaGFua3MKR2FuZwoKPiAKPiAuLi4KPiByZXF1ZXVlOgo+IAljdGwt
PnJlcXVldWUgPSAxOwo+IAlyZXR1cm4gMDsKPiAKPiAKCgpfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXwpPY2ZzMi1kZXZlbCBtYWlsaW5nIGxpc3QKT2NmczIt
ZGV2ZWxAb3NzLm9yYWNsZS5jb20KaHR0cHM6Ly9vc3Mub3JhY2xlLmNvbS9tYWlsbWFuL2xpc3Rp
bmZvL29jZnMyLWRldmVs
