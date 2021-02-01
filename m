Return-Path: <SRS0=MDmv=HD=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77ED9C433E0
	for <ocfs2-devel@archiver.kernel.org>; Mon,  1 Feb 2021 17:21:12 +0000 (UTC)
Received: from userp2130.oracle.com (userp2130.oracle.com [156.151.31.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 13C9964E56
	for <ocfs2-devel@archiver.kernel.org>; Mon,  1 Feb 2021 17:21:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 13C9964E56
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
	by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 111HE8eJ014358;
	Mon, 1 Feb 2021 17:21:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : references :
 from : message-id : date : in-reply-to : mime-version : subject : list-id
 : list-unsubscribe : list-archive : list-post : list-help : list-subscribe
 : content-type : content-transfer-encoding : sender; s=corp-2020-01-29;
 bh=DxLQBsJhv0pCr/CuNfFyqxDgG7uSCEE06SSRUQYLYjM=;
 b=STOxsx7m0YcmlLx9dCKEqEncIVoW22IZ+Fil4t1UgROPZzjz0dUMebSrJ1aLeua9ua3F
 zQnZbaZfpdPMG8I8YeMwjS7RZN8LBJcFGXMuYhqPEcVXs1kT/A7TKTFXqKrrkEFTcevs
 KZSca5R8YFaGRy+oPQAksvPfSDkgJhpALw+ryR38wh2Kd3pLe8q+KC3laWUxY+mjTZPj
 OIDRMDX0BsBgJsfQljuVgqpjlHbKso6YXEgZhWJ4yrtVPOdckWHMbkibTFMLtIh1O9KL
 LzFbAEgjZH8lmdPGRyMp7R6rnd9QPUaH3N7NdJrkYQKaXUnAEZR44PBZMBO+MWdg5RLX lQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by userp2130.oracle.com with ESMTP id 36cxvqxgqk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 01 Feb 2021 17:21:11 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 111HA9wJ196024;
	Mon, 1 Feb 2021 17:21:10 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 36dh7q1mtm-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Mon, 01 Feb 2021 17:21:10 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1l6csu-0001oG-FB; Mon, 01 Feb 2021 09:21:08 -0800
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <wen.gang.wang@oracle.com>) id 1l6csX-0001nQ-8W
	for ocfs2-devel@oss.oracle.com; Mon, 01 Feb 2021 09:20:45 -0800
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	111HBPFx189375
	for <ocfs2-devel@oss.oracle.com>; Mon, 1 Feb 2021 17:20:45 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com
	(mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
	by aserp3030.oracle.com with ESMTP id 36dh1mpbcp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 01 Feb 2021 17:20:45 +0000
Authentication-Results: oss.oracle.com; dkim=none (message not signed)
	header.d=none; oss.oracle.com;
	dmarc=none action=none header.from=oracle.com; 
Received: from SN6PR10MB2701.namprd10.prod.outlook.com (2603:10b6:805:45::20)
	by SN6PR10MB2511.namprd10.prod.outlook.com (2603:10b6:805:41::30)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.19;
	Mon, 1 Feb 2021 17:20:43 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com
	([fe80::d47:b19:f750:c969]) by SN6PR10MB2701.namprd10.prod.outlook.com
	([fe80::d47:b19:f750:c969%7]) with mapi id 15.20.3805.025;
	Mon, 1 Feb 2021 17:20:43 +0000
To: Gang He <ghe@suse.com>, ocfs2-devel@oss.oracle.com
References: <AM6PR04MB6488440A41759D9FF9A3C5A6CFB99@AM6PR04MB6488.eurprd04.prod.outlook.com>
	<3E55B25E-76CC-4FFE-BF98-0637BCB4D9CC@ORACLE.COM>
	<ce23a917-0cb1-065a-59b1-3e4789fb0d79@suse.com>
	<e0d299d1-21f1-0738-ff73-7cc3031cd581@oracle.com>
	<34a041e3-1db5-d8fe-f683-08978f23ebf9@suse.com>
From: Wengang Wang <wen.gang.wang@oracle.com>
Message-ID: <060582fa-3137-8431-1172-35e1eb68df94@oracle.com>
Date: Mon, 1 Feb 2021 09:20:40 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
	Gecko/20100101 Thunderbird/78.7.0
In-Reply-To: <34a041e3-1db5-d8fe-f683-08978f23ebf9@suse.com>
Content-Language: en-US
X-Originating-IP: [71.198.166.82]
X-ClientProxiedBy: BYAPR07CA0094.namprd07.prod.outlook.com
	(2603:10b6:a03:12b::35) To SN6PR10MB2701.namprd10.prod.outlook.com
	(2603:10b6:805:45::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dhcp-10-159-232-148.vpn.oracle.com (71.198.166.82) by
	BYAPR07CA0094.namprd07.prod.outlook.com (2603:10b6:a03:12b::35)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16
	via Frontend Transport; Mon, 1 Feb 2021 17:20:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fde02284-5b84-4e04-98f3-08d8c6d5b424
X-MS-TrafficTypeDiagnostic: SN6PR10MB2511:
X-MS-Exchange-Transport-Forked: True
X-Oracle-Tenancy: 1
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JXeGrV79d5I3qJWA6oqBgRpIC024FLFwakcKb66b8G8YX1CTYRzVGiT1D5PzNDGP/POG9DR3IIgRYEIRwkq7gr27fZRjCorbtHqaYcrJHQ7wU2PmVIssUHEgsr1gmzqCP+qRjabPUYDYnRH+g61rv+D8CtLGH3oV/PG0Tmsgj3rGEad8c29D4zHbXGHrmoJ3vWrdQrqg2WiF7WfJKv0WDD57K1BE3hNeGVXybyBY/VnfeE0XuBN4FBkbAtxt/gSPBEAgPO3QYuZs/mWP1rBReEkt3ADfz1EWL6aUNWOunu1aRyNxByKmmklRxD8PmySvT6vWS21oIzSWwiNtdTiB/ShGBRGdOKVrDFXvn0pmKv0ztPsSmm0P6/qm39/sdI+RFRFecNBULW3fegMjpZOpZ4fcmyvkV3s0GHFfz2WxCTq3NDRF1fnu3n1h+OlnvwXLo6Ft2zmqsKmylQpHvJrB/y/v1Nk+TLEMBCOMNKjt+T4=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:; IPV:NLI; SFV:SKI;
	H:SN6PR10MB2701.namprd10.prod.outlook.com; PTR:; CAT:NONE; SFS:;
	DIR:INB; 
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?eU9wNzB4L2Jzckc1TlJVVnl6N09KcEk2aXdLeXBaaHN6VGdRTEhuT0NFU21Z?=
	=?utf-8?B?ZzRobjZwUjlIWDZmd0JmRlZHSU5PQ1FEVkRzMWw0ODgxRFpXRU5wNno5Qmx5?=
	=?utf-8?B?aU5LMmJVNE51THAydHBIclZXMU1oaW4vSExRbHd1QU4xa3ZXT1lKNlZPOEpz?=
	=?utf-8?B?Q1NkTEdhb25DYTVRaVR3QU1iODNiY3dFOXZJWGJsYU9OVEljYURzbmNvcit6?=
	=?utf-8?B?UjNESi8rNWVHcWdkSjVzM3RDcEZWZ2taQ3k5c1R3WnA1TUFBdS8rc0JpWVBI?=
	=?utf-8?B?NWVFcytoNmxnSW01Nm96ODl2OXk3YTNkS0pRU3ZvUVF2RVROc1JRd2pTUVFz?=
	=?utf-8?B?QmRiTVlXLzRMb3k1bTNNbUx5UVp3RVlVRVhudDJ3c1RSRDExaW9FTWR2YUVM?=
	=?utf-8?B?azJLdzVnZ1hmTlJrTDBzMU5BMHBmU3F6Z1plUGF0MzNCS0JGZjJVMnozVTR4?=
	=?utf-8?B?M2dPcCsybzBsKzdXVHdMNlNYdHU5RlRZdTA2K2cyTnIxZVVPeS9qamJSTmox?=
	=?utf-8?B?Mlg5OFpSRGFmUi9KdThxRlJrbFRud3hzcGNiVERVV2o3UFF2a2VLK3ZVVThF?=
	=?utf-8?B?VXNuV1d5cVR6NDlqc2FDVjlWa1k2ZDNtSDdZVEFSQmZTam50bWNKMFdaNmZs?=
	=?utf-8?B?WDFUUHRndzlqTnR5dnJTYU1paWpOUTdYd1VwbWNwYXAydGRtQnJQSUJCbmdM?=
	=?utf-8?B?Z3VQUm96S0Z3aHNaTGo0WEhjK2kzdFRPV0x5UUxrZHhBMmZZYTVOYWxwY1Zh?=
	=?utf-8?B?S0RGeGFsSFR6QTFNTGVSQm01bG83TnZFcUp3R2tnRjN3WG5sOUF5cGJKRmFK?=
	=?utf-8?B?d2h3SHdKejFKSG1sYzJuYWVVdEtvSDRUZmJHNzJVMko5ZVg0OEdzWnYxdnh4?=
	=?utf-8?B?SStLNG9LYkkxcmZSVXNWTWhTOWFybFQvQXRWcHU4YllFQTFOd0Y5cTFnVHIw?=
	=?utf-8?B?RERqYWs5Uzk1S2NWK2FDZDI3N29jWkFnREtZVWpHb0xORlBFK3gvQXc1aWxB?=
	=?utf-8?B?QnhjY2ppOFphU1ZTbnh5K2tWZ3N4RUxQRHpmd2JvY2cyTzZ6YVlyZG1WNFJv?=
	=?utf-8?B?NUNHZmpjNThJUDNVL1I5bVkreGhHRzBBS0dhZE81Sk9OSjllZENCVEVDaWpx?=
	=?utf-8?B?QmJGM0t0UkRvTzdTdlR6N0pHZ3NuNGpiTHB2NnpSUklDbUJsK1NBV29HS25Q?=
	=?utf-8?B?NWNLZzdoZklPVFBRNStoZG85NWtOOFdXYnBCNUJCNHV0VTd6ZXc5emR2Zjd2?=
	=?utf-8?B?d2NiU09aTWVSd3drNEtXc1N4dFZkcXlaRk1IL2NCWTE4TVJZamVZTFJzbE15?=
	=?utf-8?B?MmhIakpNall1NmxMeTZNQmlBOGsxQ0ZTQzJDUDhsaTljRU9OOWlFTjJrUXRD?=
	=?utf-8?B?bWNWM2lJWUsrbXM4NURCbFpncXFobzhzZktnVjZ4TnUrS3dOaFhwcDRKSU9i?=
	=?utf-8?Q?s8Ijlsgl?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fde02284-5b84-4e04-98f3-08d8c6d5b424
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2021 17:20:42.9993 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KS6mO3M5E2Jf378NfM8EeZmwInMLagb6wCOQmodcRontVPkK1J+XwspwaMIPaJE/nC2AiBbZ7KTcvptO5xUSNWUFKYcM62QHF8+yEN/fMR0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2511
X-MS-Exchange-CrossPremises-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 06
X-MS-Exchange-CrossPremises-Mapi-Admin-Submission: 
X-MS-Exchange-CrossPremises-MessageSource: StoreDriver
X-MS-Exchange-CrossPremises-BCC: 
X-MS-Exchange-CrossPremises-OriginalClientIPAddress: 71.198.166.82
X-MS-Exchange-CrossPremises-TransportTrafficType: Email
X-MS-Exchange-CrossPremises-Antispam-ScanContext: DIR:Originating;SFV:SKI;SKIP:0;
X-MS-Exchange-CrossPremises-SCL: -1
X-MS-Exchange-CrossPremises-Processed-By-Journaling: Journal Agent
X-OrganizationHeadersPreserved: SN6PR10MB2511.namprd10.prod.outlook.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9882
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
	spamscore=0 phishscore=0
	suspectscore=0 mlxlogscore=884 bulkscore=0 mlxscore=0 malwarescore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2102010088
Subject: Re: [Ocfs2-devel] About the status of reflink-tools
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9882 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102010088
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9882 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 mlxscore=0 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015
 suspectscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102010088


On 1/31/21 7:42 PM, Gang He wrote:
> Hi Wengang,
>
> Thank for your information.
> According to Darrick's mail, the reflink related tools have been merged
> into coreutils project, that means we can forget reflink-tools project.

OK, good to know.

Wengang


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
