Return-Path: <SRS0=/zwX=IR=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	HTML_MESSAGE,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B49D6C433C1
	for <ocfs2-devel@archiver.kernel.org>; Fri, 19 Mar 2021 15:41:22 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 37FAD61947
	for <ocfs2-devel@archiver.kernel.org>; Fri, 19 Mar 2021 15:41:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 37FAD61947
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12JFdPJN032085;
	Fri, 19 Mar 2021 15:41:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : date :
 message-id : references : in-reply-to : mime-version : cc : subject :
 list-id : list-unsubscribe : list-archive : list-post : list-help :
 list-subscribe : content-type : sender; s=corp-2020-01-29;
 bh=ce4UUkYoReKyw6VMTDMJBTL9ATIbdf/tnmeZQawZpdg=;
 b=Gd3FC4s6P9+hkBsCY8VMLcvTV+DO4fMfqIjKeSpQBFI9DbkxLhIZKonzTNIDGhpSbb5X
 Lom78VktNhReRN/ylRW4NxLSrA1Tx2sXyZvcxgL6nWq4xlKtk22FR0CfLpCBah3Qd7dn
 tbkvcXQaVFeVZL8UHTr0ERYPrUWNmnILUcW6odUdHLe64IpJ8MhJUJmLuKJoGwyOW5i1
 cC5mSsZ6VfGyMCa6WzB5LZ2RulVcmw/2lEbPxOOReKwT9SZqGky+vVcpk2z81EraLzKY
 wJEglZJ4dm/ubJ8X4fmiaFYwtvjlcD5lKgxlKw7GQEQ4m/GCGIulrZCldpexIRmIjEl9 ZQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by aserp2120.oracle.com with ESMTP id 378nbmkf5e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Mar 2021 15:41:21 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12JFdijW014596;
	Fri, 19 Mar 2021 15:41:20 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 37cf2bwvjh-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 19 Mar 2021 15:41:20 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lNHFW-0007A5-Qc; Fri, 19 Mar 2021 08:41:18 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <wen.gang.wang@oracle.com>) id 1lNHFT-00079g-JQ
	for ocfs2-devel@oss.oracle.com; Fri, 19 Mar 2021 08:41:15 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	12JFeDDw117929
	for <ocfs2-devel@oss.oracle.com>; Fri, 19 Mar 2021 15:41:15 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com
	(mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
	by userp3030.oracle.com with ESMTP id 3797b4ded1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 19 Mar 2021 15:41:15 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com (2603:10b6:805:45::20)
	by SN6PR10MB2717.namprd10.prod.outlook.com (2603:10b6:805:46::12)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18;
	Fri, 19 Mar 2021 15:41:13 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com
	([fe80::74cc:15dc:8911:4291]) by
	SN6PR10MB2701.namprd10.prod.outlook.com
	([fe80::74cc:15dc:8911:4291%4]) with mapi id 15.20.3955.023;
	Fri, 19 Mar 2021 15:41:13 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Thread-Topic: [PATCH] ocfs2: map flags directly in flags_to_o2dlm()
Thread-Index: AQHXHJDqL4a1+S+llkehLuRl9kvrUaqLc3IA
Date: Fri, 19 Mar 2021 15:41:13 +0000
Message-ID: <E41BBC66-034E-43A1-B688-803D269A5FF4@oracle.com>
References: <1616138664-35935-1-git-send-email-joseph.qi@linux.alibaba.com>
In-Reply-To: <1616138664-35935-1-git-send-email-joseph.qi@linux.alibaba.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.60.0.2.21)
authentication-results: linux.alibaba.com; dkim=none (message not signed)
	header.d=none;linux.alibaba.com; dmarc=none action=none
	header.from=oracle.com;
x-originating-ip: [71.198.166.82]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 53cef914-5a11-46bf-7bf1-08d8eaed6d4c
x-ms-traffictypediagnostic: SN6PR10MB2717:
x-ms-exchange-transport-forked: True
x-oracle-tenancy: 1
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Nmrm3fX9w4RRS0tED8Be51QcEFxFcxNayDwkAChW5AP6jI4/8/o4IwK0ybs5eE/O5cEg8tYyNDCBS8H6fU89Pf+IK4HuKzA8qttrBmY3kk22aH2P87Ue1fbvzT1z2wYf1J2cqeJ6fVk2tNlhgztFu78zzeKX449EzjHIXv25oz/FjmzJQDncPaJ9Nb0SIQ4+hKvQBE+/wnIN3C+AXGrgv9aG2VpnMpzLncn5SFzUEzXmjkYOolSwfiIqlfjBrTag7RrUQ9+moxwrkLG4DAqPv29pL4RF6qvWAA9Zc7EuMZl6+NSJ9Y8hpeUr9m0+Vrb21j/lDXG5p+5O7W2m5PSdAUcWS8Y0UFyM1kPnaPDicXF6agQRFo+cvczyFL/3nHtC0MAdIv3UR0q62s6bWUjtVfdd9CP/dgPxadFn5XPU1W4T8C1s3vNndKKj71c06g3VgW/hrUUhsUCn7K7nPwe/0BJiMNzub0Jq/7S2THdt/o/kq/J8qIpGIq9NOQ2kkoVV07XIw8GGyk6UV2hzTLIJ2ZHTSuhbtMhCnkSSHJznXPzaKqDW94dem5ygu3NYzPVi
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:; IPV:NLI; SFV:SKI;
	H:SN6PR10MB2701.namprd10.prod.outlook.com; PTR:; CAT:NONE; SFS:;
	DIR:INB; 
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?ptBsEgb1lqQUqu9LtTR+eldkB6yLfRzE+jeQV1i/B3oR13zzWMA0B14shbQ3?=
	=?us-ascii?Q?bcPn5gt6MIsMpIAD+kyWOyAATgTozi7L8oee9vsubNfd/PUKyhJQSr/dNag9?=
	=?us-ascii?Q?qMMSRFb6iwomU8Ws1z7ARTIkBWg2ahg/v5Gl0QZT2OiiB29z9oZwy1TZqhsD?=
	=?us-ascii?Q?4BJM33awAFJ8skK6UEZWsG7vfNDiFP6x98fLuPWsXSjReNhwINox9m0WXu/K?=
	=?us-ascii?Q?S8g1mDU1KE5d1koYSPDgssadvftz7CrWyNbUN7tYuVl5vw1qvy5oueilRduM?=
	=?us-ascii?Q?HknD0xfVTR9WFQv+mziC/BVhVO9d1ndzdceZCE8RZ83aEqs7XzIfuzwYzyFk?=
	=?us-ascii?Q?C9yqXSfm9rmoYy6YJDOc/1yHCtv4+mlxv7V/laLhm60NpFJDEP/SWwJsWRbe?=
	=?us-ascii?Q?1p/I8xyh2bo9PS0XNz8CQQu8OlsEQLFpJuh/Ee716ikm6t9aRap3qIgtNzLP?=
	=?us-ascii?Q?FINy9jLewriKVq2l48HJa8l4vPOeFbFAX3u17ZMU36ofHLuKlr2EUC/D1J1d?=
	=?us-ascii?Q?aM2RquueHPb5vvoxpqb7zZ1GM8z02ZAcOpgJDQZsQb5mdTlja/CnTncqEFpV?=
	=?us-ascii?Q?00l20ojq4KAP/pUeP52Cn99zVrZvGTGfN7DoHOtB8EGaUU+QHl1TulVr1cXC?=
	=?us-ascii?Q?5FdLZfdXJa49uV2YJz3xemFWcQ42xlbSXA5esSI+g81qdOC+jSNyXDz8Y9Zz?=
	=?us-ascii?Q?5os067rUv8okDd6z5goOP7O9jwT0vRPMBIK5LET2PZepL3kbOd62B4q3t76v?=
	=?us-ascii?Q?REbFkSRNFqJrEMgOxD9Zpuw3daCTh1IvDSDKqNqYlbv/m0pCqI5PtG5tztpW?=
	=?us-ascii?Q?zcbZrqhUJb+MDn/Fiw5DXYNEMg+M/FDCWor+ij6wMyPD4mrODaEY4wgXfz/O?=
	=?us-ascii?Q?ZsS2qVxlFenISxIRDlrk6416kAj7jZTNZaWxLXEL/53zLmY3LoigaakXzAvp?=
	=?us-ascii?Q?b5PFWMSlRlMH+t1JmcdFMSiPE0MeFe8BHz7/aLcaTQZUcGy/xvIIds6eOPY0?=
	=?us-ascii?Q?Yk1BQV6z/dxJRW2nFORp+w9p/6wZlFt1mRBnwb/Ltv2+vx7eqWxOqtA0/nov?=
	=?us-ascii?Q?RDSyNXhPBPTlplugsCtcMKmsaQQjwQy1lVjFO3tmcA6uhFx9PB7q72HdkjLu?=
	=?us-ascii?Q?TFPu/Q5UebxGB5ibVfltjTei9I554cnmNSn82+SNf/szKgxJhXJIV5GT7SSo?=
	=?us-ascii?Q?ZXCAfGP+/gsXrMJoAdZ2DioiM9bE6FCe3OvDGIOROOtNmflxO5UUiTiyRPNV?=
	=?us-ascii?Q?QJPr+YJWqOs+ftpoUVOCVTnAh9n1NTn0AN/Nm2AYUjM8xYmkeMD65+3iK7jW?=
	=?us-ascii?Q?Wt+mIh8hJjD17l/LGYaoiwk0?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53cef914-5a11-46bf-7bf1-08d8eaed6d4c
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Mar 2021 15:41:13.4003 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pOEKBGX6E8kaJ/dbPKI60/bRPtF0UqmHHuJCnS9WEsqtXs3Jv3DOBdTrwj6n8Zaq0sKgprj9ZONu8oF9MJo2wWvoNV1YlXAK6OTgkADU050=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2717
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 04
X-MS-Exchange-CrossPremises-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossPremises-TransportTrafficType: Email
X-MS-Exchange-CrossPremises-SCL: -1
X-MS-Exchange-CrossPremises-messagesource: StoreDriver
X-MS-Exchange-CrossPremises-BCC: 
X-MS-Exchange-CrossPremises-originalclientipaddress: 71.198.166.82
X-MS-Exchange-CrossPremises-transporttraffictype: Email
X-MS-Exchange-CrossPremises-antispam-scancontext: DIR:Originating; SFV:SKI;
	SKIP:0; 
X-MS-Exchange-CrossPremises-processed-by-journaling: Journal Agent
X-OrganizationHeadersPreserved: SN6PR10MB2717.namprd10.prod.outlook.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9928
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
	spamscore=0 bulkscore=0
	malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2103190110
Cc: Yang Li <yang.lee@linux.alibaba.com>,
        ocfs2-devel ML <ocfs2-devel@oss.oracle.com>, Gang He <GHe@suse.com>
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: map flags directly in
	flags_to_o2dlm()
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
Content-Type: multipart/mixed; boundary="===============1452810060525920534=="
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9928 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103190110
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9928 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 impostorscore=0
 malwarescore=0 adultscore=0 mlxscore=0 clxscore=1011 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 priorityscore=1501 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103190110

--===============1452810060525920534==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_E41BBC66034E43A1B688803D269A5FF4oraclecom_"

--_000_E41BBC66034E43A1B688803D269A5FF4oraclecom_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Looks good to me.

Reviewed-by: Wengang Wang <wen.gang.wang@oracle.com<mailto:wen.gang.wang@or=
acle.com>>

On Mar 19, 2021, at 12:24 AM, Joseph Qi <joseph.qi@linux.alibaba.com<mailto=
:joseph.qi@linux.alibaba.com>> wrote:

Use macro map_flag() is tricky and coccicheck outputs the following
warning:
fs/ocfs2/stack_o2cb.c:69:5-16: Unneeded variable: "o2dlm_flags".
So map flags directly in flags_to_o2dlm() to make coccicheck happy.
And remove BUG_ON() here as well to simplify code since it runs well
a long time.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com<mailto:joseph.qi@linu=
x.alibaba.com>>
---
fs/ocfs2/stack_o2cb.c | 36 ++++++++++++++++++------------------
1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/fs/ocfs2/stack_o2cb.c b/fs/ocfs2/stack_o2cb.c
index dbf8b57..f700120 100644
--- a/fs/ocfs2/stack_o2cb.c
+++ b/fs/ocfs2/stack_o2cb.c
@@ -59,31 +59,31 @@ static inline int mode_to_o2dlm(int mode)
return mode;
}

-#define map_flag(_generic, _o2dlm) \
- if (flags & (_generic)) { \
- flags &=3D ~(_generic); \
- o2dlm_flags |=3D (_o2dlm); \
- }
static int flags_to_o2dlm(u32 flags)
{
int o2dlm_flags =3D 0;

- map_flag(DLM_LKF_NOQUEUE, LKM_NOQUEUE);
- map_flag(DLM_LKF_CANCEL, LKM_CANCEL);
- map_flag(DLM_LKF_CONVERT, LKM_CONVERT);
- map_flag(DLM_LKF_VALBLK, LKM_VALBLK);
- map_flag(DLM_LKF_IVVALBLK, LKM_INVVALBLK);
- map_flag(DLM_LKF_ORPHAN, LKM_ORPHAN);
- map_flag(DLM_LKF_FORCEUNLOCK, LKM_FORCE);
- map_flag(DLM_LKF_TIMEOUT, LKM_TIMEOUT);
- map_flag(DLM_LKF_LOCAL, LKM_LOCAL);
-
- /* map_flag() should have cleared every flag passed in */
- BUG_ON(flags !=3D 0);
+ if (flags & DLM_LKF_NOQUEUE)
+ o2dlm_flags |=3D LKM_NOQUEUE;
+ if (flags & DLM_LKF_CANCEL)
+ o2dlm_flags |=3D LKM_CANCEL;
+ if (flags & DLM_LKF_CONVERT)
+ o2dlm_flags |=3D LKM_CONVERT;
+ if (flags & DLM_LKF_VALBLK)
+ o2dlm_flags |=3D LKM_VALBLK;
+ if (flags & DLM_LKF_IVVALBLK)
+ o2dlm_flags |=3D LKM_INVVALBLK;
+ if (flags & DLM_LKF_ORPHAN)
+ o2dlm_flags |=3D LKM_ORPHAN;
+ if (flags & DLM_LKF_FORCEUNLOCK)
+ o2dlm_flags |=3D LKM_FORCE;
+ if (flags & DLM_LKF_TIMEOUT)
+ o2dlm_flags |=3D LKM_TIMEOUT;
+ if (flags & DLM_LKF_LOCAL)
+ o2dlm_flags |=3D LKM_LOCAL;

return o2dlm_flags;
}
-#undef map_flag

/*
 * Map an o2dlm status to standard errno values.
--
1.8.3.1



--_000_E41BBC66034E43A1B688803D269A5FF4oraclecom_
Content-Type: text/html; charset="us-ascii"
Content-ID: <38C2F955930E594AB794437095A4B5C3@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
</head>
<body style=3D"word-wrap: break-word; -webkit-nbsp-mode: space; line-break:=
 after-white-space;" class=3D"">
Looks good to me.
<div class=3D""><br class=3D"">
</div>
<div class=3D"">Reviewed-by: Wengang Wang &lt;<a href=3D"mailto:wen.gang.wa=
ng@oracle.com" class=3D"">wen.gang.wang@oracle.com</a>&gt;<br class=3D"">
<div><br class=3D"">
<blockquote type=3D"cite" class=3D"">
<div class=3D"">On Mar 19, 2021, at 12:24 AM, Joseph Qi &lt;<a href=3D"mail=
to:joseph.qi@linux.alibaba.com" class=3D"">joseph.qi@linux.alibaba.com</a>&=
gt; wrote:</div>
<br class=3D"Apple-interchange-newline">
<div class=3D"">
<div class=3D"">Use macro map_flag() is tricky and coccicheck outputs the f=
ollowing<br class=3D"">
warning:<br class=3D"">
fs/ocfs2/stack_o2cb.c:69:5-16: Unneeded variable: &quot;o2dlm_flags&quot;.<=
br class=3D"">
So map flags directly in flags_to_o2dlm() to make coccicheck&nbsp;happy.<br=
 class=3D"">
And remove BUG_ON() here as well to simplify code since it runs well<br cla=
ss=3D"">
a long time.<br class=3D"">
<br class=3D"">
Signed-off-by: Joseph Qi &lt;<a href=3D"mailto:joseph.qi@linux.alibaba.com"=
 class=3D"">joseph.qi@linux.alibaba.com</a>&gt;<br class=3D"">
---<br class=3D"">
fs/ocfs2/stack_o2cb.c | 36 ++++++++++++++++++------------------<br class=3D=
"">
1 file changed, 18 insertions(+), 18 deletions(-)<br class=3D"">
<br class=3D"">
diff --git a/fs/ocfs2/stack_o2cb.c b/fs/ocfs2/stack_o2cb.c<br class=3D"">
index dbf8b57..f700120 100644<br class=3D"">
--- a/fs/ocfs2/stack_o2cb.c<br class=3D"">
+++ b/fs/ocfs2/stack_o2cb.c<br class=3D"">
@@ -59,31 +59,31 @@ static inline int mode_to_o2dlm(int mode)<br class=3D""=
>
<span class=3D"Apple-tab-span" style=3D"white-space:pre"></span>return mode=
;<br class=3D"">
}<br class=3D"">
<br class=3D"">
-#define map_flag(_generic, _o2dlm)<span class=3D"Apple-tab-span" style=3D"=
white-space:pre">
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre"></span>\<br=
 class=3D"">
-<span class=3D"Apple-tab-span" style=3D"white-space:pre"> </span>if (flags=
 &amp; (_generic)) {<span class=3D"Apple-tab-span" style=3D"white-space:pre=
">
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre"></span>\<br=
 class=3D"">
-<span class=3D"Apple-tab-span" style=3D"white-space:pre"> </span><span cla=
ss=3D"Apple-tab-span" style=3D"white-space:pre"></span>flags &amp;=3D ~(_ge=
neric);<span class=3D"Apple-tab-span" style=3D"white-space:pre">
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre"></span>\<br=
 class=3D"">
-<span class=3D"Apple-tab-span" style=3D"white-space:pre"> </span><span cla=
ss=3D"Apple-tab-span" style=3D"white-space:pre"></span>o2dlm_flags |=3D (_o=
2dlm);<span class=3D"Apple-tab-span" style=3D"white-space:pre">
</span>\<br class=3D"">
-<span class=3D"Apple-tab-span" style=3D"white-space:pre"> </span>}<br clas=
s=3D"">
static int flags_to_o2dlm(u32 flags)<br class=3D"">
{<br class=3D"">
<span class=3D"Apple-tab-span" style=3D"white-space:pre"></span>int o2dlm_f=
lags =3D 0;<br class=3D"">
<br class=3D"">
-<span class=3D"Apple-tab-span" style=3D"white-space:pre"> </span>map_flag(=
DLM_LKF_NOQUEUE, LKM_NOQUEUE);<br class=3D"">
-<span class=3D"Apple-tab-span" style=3D"white-space:pre"> </span>map_flag(=
DLM_LKF_CANCEL, LKM_CANCEL);<br class=3D"">
-<span class=3D"Apple-tab-span" style=3D"white-space:pre"> </span>map_flag(=
DLM_LKF_CONVERT, LKM_CONVERT);<br class=3D"">
-<span class=3D"Apple-tab-span" style=3D"white-space:pre"> </span>map_flag(=
DLM_LKF_VALBLK, LKM_VALBLK);<br class=3D"">
-<span class=3D"Apple-tab-span" style=3D"white-space:pre"> </span>map_flag(=
DLM_LKF_IVVALBLK, LKM_INVVALBLK);<br class=3D"">
-<span class=3D"Apple-tab-span" style=3D"white-space:pre"> </span>map_flag(=
DLM_LKF_ORPHAN, LKM_ORPHAN);<br class=3D"">
-<span class=3D"Apple-tab-span" style=3D"white-space:pre"> </span>map_flag(=
DLM_LKF_FORCEUNLOCK, LKM_FORCE);<br class=3D"">
-<span class=3D"Apple-tab-span" style=3D"white-space:pre"> </span>map_flag(=
DLM_LKF_TIMEOUT, LKM_TIMEOUT);<br class=3D"">
-<span class=3D"Apple-tab-span" style=3D"white-space:pre"> </span>map_flag(=
DLM_LKF_LOCAL, LKM_LOCAL);<br class=3D"">
-<br class=3D"">
-<span class=3D"Apple-tab-span" style=3D"white-space:pre"> </span>/* map_fl=
ag() should have cleared every flag passed in */<br class=3D"">
-<span class=3D"Apple-tab-span" style=3D"white-space:pre"> </span>BUG_ON(fl=
ags !=3D 0);<br class=3D"">
+<span class=3D"Apple-tab-span" style=3D"white-space:pre"> </span>if (flags=
 &amp; DLM_LKF_NOQUEUE)<br class=3D"">
+<span class=3D"Apple-tab-span" style=3D"white-space:pre"> </span><span cla=
ss=3D"Apple-tab-span" style=3D"white-space:pre"></span>o2dlm_flags |=3D LKM=
_NOQUEUE;<br class=3D"">
+<span class=3D"Apple-tab-span" style=3D"white-space:pre"> </span>if (flags=
 &amp; DLM_LKF_CANCEL)<br class=3D"">
+<span class=3D"Apple-tab-span" style=3D"white-space:pre"> </span><span cla=
ss=3D"Apple-tab-span" style=3D"white-space:pre"></span>o2dlm_flags |=3D LKM=
_CANCEL;<br class=3D"">
+<span class=3D"Apple-tab-span" style=3D"white-space:pre"> </span>if (flags=
 &amp; DLM_LKF_CONVERT)<br class=3D"">
+<span class=3D"Apple-tab-span" style=3D"white-space:pre"> </span><span cla=
ss=3D"Apple-tab-span" style=3D"white-space:pre"></span>o2dlm_flags |=3D LKM=
_CONVERT;<br class=3D"">
+<span class=3D"Apple-tab-span" style=3D"white-space:pre"> </span>if (flags=
 &amp; DLM_LKF_VALBLK)<br class=3D"">
+<span class=3D"Apple-tab-span" style=3D"white-space:pre"> </span><span cla=
ss=3D"Apple-tab-span" style=3D"white-space:pre"></span>o2dlm_flags |=3D LKM=
_VALBLK;<br class=3D"">
+<span class=3D"Apple-tab-span" style=3D"white-space:pre"> </span>if (flags=
 &amp; DLM_LKF_IVVALBLK)<br class=3D"">
+<span class=3D"Apple-tab-span" style=3D"white-space:pre"> </span><span cla=
ss=3D"Apple-tab-span" style=3D"white-space:pre"></span>o2dlm_flags |=3D LKM=
_INVVALBLK;<br class=3D"">
+<span class=3D"Apple-tab-span" style=3D"white-space:pre"> </span>if (flags=
 &amp; DLM_LKF_ORPHAN)<br class=3D"">
+<span class=3D"Apple-tab-span" style=3D"white-space:pre"> </span><span cla=
ss=3D"Apple-tab-span" style=3D"white-space:pre"></span>o2dlm_flags |=3D LKM=
_ORPHAN;<br class=3D"">
+<span class=3D"Apple-tab-span" style=3D"white-space:pre"> </span>if (flags=
 &amp; DLM_LKF_FORCEUNLOCK)<br class=3D"">
+<span class=3D"Apple-tab-span" style=3D"white-space:pre"> </span><span cla=
ss=3D"Apple-tab-span" style=3D"white-space:pre"></span>o2dlm_flags |=3D LKM=
_FORCE;<br class=3D"">
+<span class=3D"Apple-tab-span" style=3D"white-space:pre"> </span>if (flags=
 &amp; DLM_LKF_TIMEOUT)<br class=3D"">
+<span class=3D"Apple-tab-span" style=3D"white-space:pre"> </span><span cla=
ss=3D"Apple-tab-span" style=3D"white-space:pre"></span>o2dlm_flags |=3D LKM=
_TIMEOUT;<br class=3D"">
+<span class=3D"Apple-tab-span" style=3D"white-space:pre"> </span>if (flags=
 &amp; DLM_LKF_LOCAL)<br class=3D"">
+<span class=3D"Apple-tab-span" style=3D"white-space:pre"> </span><span cla=
ss=3D"Apple-tab-span" style=3D"white-space:pre"></span>o2dlm_flags |=3D LKM=
_LOCAL;<br class=3D"">
<br class=3D"">
<span class=3D"Apple-tab-span" style=3D"white-space:pre"></span>return o2dl=
m_flags;<br class=3D"">
}<br class=3D"">
-#undef map_flag<br class=3D"">
<br class=3D"">
/*<br class=3D"">
&nbsp;* Map an o2dlm status to standard errno values.<br class=3D"">
-- <br class=3D"">
1.8.3.1<br class=3D"">
<br class=3D"">
</div>
</div>
</blockquote>
</div>
<br class=3D"">
</div>
</body>
</html>

--_000_E41BBC66034E43A1B688803D269A5FF4oraclecom_--


--===============1452810060525920534==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
--===============1452810060525920534==--

