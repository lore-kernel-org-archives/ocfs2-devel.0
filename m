Return-Path: <SRS0=NiB8=JL=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	HTML_MESSAGE,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60024C433ED
	for <ocfs2-devel@archiver.kernel.org>; Wed, 14 Apr 2021 15:22:26 +0000 (UTC)
Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E970461158
	for <ocfs2-devel@archiver.kernel.org>; Wed, 14 Apr 2021 15:22:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E970461158
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
	by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13EFFSZG017380;
	Wed, 14 Apr 2021 15:22:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : date :
 message-id : references : in-reply-to : mime-version : cc : subject :
 list-id : list-unsubscribe : list-archive : list-post : list-help :
 list-subscribe : content-type : sender; s=corp-2020-01-29;
 bh=765B8PgAGglKSY8zRVeQE2WB2QmXRoz6ITSIhlX6CdA=;
 b=WiqEhmUVRiRra4ww+FcfsgmdULLKAkoudrFsV9bL3ZPG0HO7rtRtH1Bhtpvjz7XNmvye
 MnvAoCncvTh/i9vA2tsQf5lnDSkAjWIq7SDjai1apR9jEOlAB+Wi/Z3KenpOrmktFKKg
 joscofK22KpNOZ8UFCDykECbNKgm5BBB2tkrcuKksp3XTJQLSTGfdWy4WdhSZAvf3luR
 FF8wrbNYOFSnOYNB6OoYFb66CSjE8LRqXFgXslMeUL+s9CKs1QBvbn2vjAUaX+BasiJg
 I8ES6bQMOIwkEu3t5L6P37BHw3hslOogvglvT3erQtOSPv0JleUV1mEdErxpKMv+sf5h +Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by aserp2130.oracle.com with ESMTP id 37u1hbjxyd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Apr 2021 15:22:24 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13EFFXSM170201;
	Wed, 14 Apr 2021 15:22:23 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 37unsu4v6t-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Wed, 14 Apr 2021 15:22:23 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lWhLS-00007x-6O; Wed, 14 Apr 2021 08:22:22 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <wen.gang.wang@oracle.com>) id 1lWhLP-00007X-4C
	for ocfs2-devel@oss.oracle.com; Wed, 14 Apr 2021 08:22:19 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	13EFERmA085440
	for <ocfs2-devel@oss.oracle.com>; Wed, 14 Apr 2021 15:22:18 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com
	(mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
	by userp3030.oracle.com with ESMTP id 37unxyj9j4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 14 Apr 2021 15:22:18 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com (2603:10b6:805:45::20)
	by SA2PR10MB4682.namprd10.prod.outlook.com (2603:10b6:806:110::19)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21;
	Wed, 14 Apr 2021 15:22:16 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com
	([fe80::74cc:15dc:8911:4291]) by
	SN6PR10MB2701.namprd10.prod.outlook.com
	([fe80::74cc:15dc:8911:4291%4]) with mapi id 15.20.4020.023;
	Wed, 14 Apr 2021 15:22:16 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Thread-Topic: [Ocfs2-devel] [PATCH] ocfs2/dlm: remove unused function
Thread-Index: AQHXMPrTAI4buRwVw02vbH5vaM/iOqq0IfCA
Date: Wed, 14 Apr 2021 15:22:16 +0000
Message-ID: <78EEED8F-5F7E-496F-8E7C-C906AB4E53C6@oracle.com>
References: <1618382761-5784-1-git-send-email-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <1618382761-5784-1-git-send-email-jiapeng.chong@linux.alibaba.com>
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
x-ms-office365-filtering-correlation-id: 03a52a5c-ed80-4199-63cc-08d8ff591660
x-ms-traffictypediagnostic: SA2PR10MB4682:
x-ms-exchange-transport-forked: True
x-oracle-tenancy: 1
x-ms-oob-tlc-oobclassifiers: OLM:1091;
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ePVGfQYnRb05XedbzMVmye7rFhH9ZnN7gZVun2qE3IBHpwfyYB3C6uDDrKlRvyLbuBTbBbvx0AJSPah14rRzyhoeAzqCs7I6D+fHdlGTQgHsQBu2R7zazg9o6ujvvFWDRrAE6xLztVOO29z0nPwBK2gseuWnMnQudq0hwZEKohme+XMsk0JUy/ClekHgcC4PwbPX4fwILFhFGlr8obk/HxiqNU0/xyAGWYqOmJb83JJ7neDpY3r3ogY0M40sJweCXxTw7aJ/xPzomR8/3MhUSG3LfmfbKRgcwqYxy8WNoPeP1uZV0YS8wBmPuqJsO4b2m6o5LKJEeKNSDSPT5y3Vw+IP9oYGIfBT4Rd7ncFbklVFz7vGZhWhhziwKzpeUgn+J9/NmW9s4vl5JuTEjzaPhKHwTWQO0FzmnqWKrqw+pEQtp6Us6TGKO/+G/jxo2tQrEpuhUgHGzb46nStIplzozSCjZuuHkv8c+oJTNNIdMX+A2QXOEdbUXmuVArV62braybzp2f13Eafn+yNcsDxNqZPrAH3PvQ0pX6JuE54tddpErIZ63CYdaL2tb6QaIufifovCjwxuymbc35Ar2kkCQZcmQ1hgVmmINtz2HY7aX8oDfteF98MY/oG7+qgr392EbZV24O4QCEhoC+sK+GJr8A==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:; IPV:NLI; SFV:SKI;
	H:SN6PR10MB2701.namprd10.prod.outlook.com; PTR:; CAT:NONE; SFS:;
	DIR:INB; 
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?rdfHmqDATmQy1vrkVtr78JtOSItvkaPPPNWi/sX+raW3Vs/nthd9E2HfduGr?=
	=?us-ascii?Q?x9Lk9oujkk6vuYOM/RxMKH7Sw17SMFi4S+3rdrHVl7JrVz3CFvZrDdZkAh9G?=
	=?us-ascii?Q?pjsTRIwD4ZLOFDch1bShukkCYqaBVfkizgaPquPZzS6jOey8Hye16dOC60B6?=
	=?us-ascii?Q?FuDXk2idlkgpTo3GUYLiI5jypSQWafGnhEyrgL779bf6X3QlQxxxrWzc1m/D?=
	=?us-ascii?Q?xvQWgniJPWN13pas7jrjijKROZ5WpT7ELm3oEFJha06+RYAX+G7d27mU45Ao?=
	=?us-ascii?Q?7f7Z3lWuDnwt+jSLRK+a5dJ371qIU0RClujl0j2HrhFiZXSC5Z/dPWuiMDJi?=
	=?us-ascii?Q?ehtJdQ8gwwLGTc4GRvnI8y1GQYmEcXpa2CU9blC8/BmfQfh06jivk2hMVT1g?=
	=?us-ascii?Q?N0ccHYaUN+LBuuvYFX3dW/qlhZUjN6+RZYVpvlJlSwasXcMs8MR+0LS9BOdy?=
	=?us-ascii?Q?f/06aT8K3ot0iOOZzj/0ZAKytu6b9mUL42buTIeKvAF8HoLx2JtXWRKJQI+5?=
	=?us-ascii?Q?a68ugde3ANu0m386yGlj8/uy/F385DSIbahuebnpnr/NLLPUfduMyJZU8l1Z?=
	=?us-ascii?Q?WjGoxd72hwR9axo1CEy+I0a1eexcJMRbXyyq2nIMkxsVcmKUY1I4KMF+Hgo8?=
	=?us-ascii?Q?8x89zFXfVzKM4pLry7u4UTupwNVoYOWsejVy4ufJ9dvVxFRPO/FEvvEhlnTK?=
	=?us-ascii?Q?5gLFiXQX3jqmrEO3o2U2k7IaDYNVV72AmYXAJyL2Uxz5WGGrS6sowRvOiGp5?=
	=?us-ascii?Q?Xgb4B82/PsGL++OwGAT7+3GJx8mcBlVFtAnuqkVJOavPA/Br7mFU59o5p1U/?=
	=?us-ascii?Q?Jp/domvLYlA+16dUbA40uptBw4tYciib4pQf5Z4DbW/9/IpjEkeLh4DkaxQ5?=
	=?us-ascii?Q?A6a23Gi6UCSiPh2Va6FrKEATFyCa/SBNhf2OFZxyuz3BBS4iugULFQhJ5Ez+?=
	=?us-ascii?Q?vloHiCQF+rDDgp5aO01SQS61ZDxgqdpMc5Fb4wFpih+/OhhLGA7vonopz0OO?=
	=?us-ascii?Q?qPcCfuyvlQ4HtEDjJDTGUDqrTjb8K2LcMpW1t0D9HCxU4g3lj0Z5IRW6SfX7?=
	=?us-ascii?Q?W38mXVc2daKw2E1MGnYdH9u/5WyT3xVNhALFHdOxsmOUiXGFnzV8+YIqJO3a?=
	=?us-ascii?Q?cpx7p6Rof1PctD5oQXiol38EC7ILSkB/4vD9bxL0dAzMIyaiTED6rkttglVi?=
	=?us-ascii?Q?bfL8mJe7mVtSEAz95CzrJLrJ8FMy5RaAcfcA2vdpccfdZKpdtFCMx3H+wGLU?=
	=?us-ascii?Q?SWHpD/tBwTToBWqH75Plt351pn3jcQ3aoUHlJOCp8B7pPuolxyW+F0SQnE+9?=
	=?us-ascii?Q?6JIbIoV1GmaVY+O6VTR/g6tY?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03a52a5c-ed80-4199-63cc-08d8ff591660
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2021 15:22:16.4213 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G22Bu39Mvo8HKj7yxEnKSTYefdJBzCdRkZ14L7Djqk+YujjemRbEtZfQkq5qVsd49pVXDs1M8DXeWb75mme1VyG/ZTBaMyUsLlHj0dA7e3Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4682
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
X-OrganizationHeadersPreserved: SA2PR10MB4682.namprd10.prod.outlook.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9954
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
	bulkscore=0 malwarescore=0
	spamscore=0 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104060000 definitions=main-2104140103
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ocfs2-devel ML <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2/dlm: remove unused function
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
Content-Type: multipart/mixed; boundary="===============2163963869940631484=="
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9954 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104140103
X-Proofpoint-GUID: EAFTE-nCSbO3H7l8oB8rBTh_1f0kjQ5Z
X-Proofpoint-ORIG-GUID: EAFTE-nCSbO3H7l8oB8rBTh_1f0kjQ5Z
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9954 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 clxscore=1015 adultscore=0 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104140103

--===============2163963869940631484==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_78EEED8F5F7E496F8E7CC906AB4E53C6oraclecom_"

--_000_78EEED8F5F7E496F8E7CC906AB4E53C6oraclecom_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Reviewed-by: Wengang Wang <wen.gang.wang@oracle.com<mailto:wen.gang.wang@or=
acle.com>>


On Apr 13, 2021, at 11:46 PM, Jiapeng Chong <jiapeng.chong@linux.alibaba.co=
m<mailto:jiapeng.chong@linux.alibaba.com>> wrote:

Fix the following clang warning:

fs/ocfs2/dlm/dlmrecovery.c:129:20: warning: unused function
'dlm_reset_recovery' [-Wunused-function].

Reported-by: Abaci Robot <abaci@linux.alibaba.com<mailto:abaci@linux.alibab=
a.com>>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com<mailto:jiapen=
g.chong@linux.alibaba.com>>
---
fs/ocfs2/dlm/dlmrecovery.c | 7 -------
1 file changed, 7 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 4b566e8..afc5173 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -126,13 +126,6 @@ static inline void __dlm_reset_recovery(struct dlm_ctx=
t *dlm)
dlm_set_reco_master(dlm, O2NM_INVALID_NODE_NUM);
}

-static inline void dlm_reset_recovery(struct dlm_ctxt *dlm)
-{
- spin_lock(&dlm->spinlock);
- __dlm_reset_recovery(dlm);
- spin_unlock(&dlm->spinlock);
-}
-
/* Worker function used during recovery. */
void dlm_dispatch_work(struct work_struct *work)
{
--
1.8.3.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com<mailto:Ocfs2-devel@oss.oracle.com>
https://oss.oracle.com/mailman/listinfo/ocfs2-devel


--_000_78EEED8F5F7E496F8E7CC906AB4E53C6oraclecom_
Content-Type: text/html; charset="us-ascii"
Content-ID: <B4D0C3A824942641AE608E03104DBD48@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
</head>
<body style=3D"word-wrap: break-word; -webkit-nbsp-mode: space; line-break:=
 after-white-space;" class=3D"">
Reviewed-by: Wengang Wang &lt;<a href=3D"mailto:wen.gang.wang@oracle.com" c=
lass=3D"">wen.gang.wang@oracle.com</a>&gt;
<div class=3D""><br class=3D"">
<div><br class=3D"">
<blockquote type=3D"cite" class=3D"">
<div class=3D"">On Apr 13, 2021, at 11:46 PM, Jiapeng Chong &lt;<a href=3D"=
mailto:jiapeng.chong@linux.alibaba.com" class=3D"">jiapeng.chong@linux.alib=
aba.com</a>&gt; wrote:</div>
<br class=3D"Apple-interchange-newline">
<div class=3D"">
<div class=3D"">Fix the following clang warning:<br class=3D"">
<br class=3D"">
fs/ocfs2/dlm/dlmrecovery.c:129:20: warning: unused function<br class=3D"">
'dlm_reset_recovery' [-Wunused-function].<br class=3D"">
<br class=3D"">
Reported-by: Abaci Robot &lt;<a href=3D"mailto:abaci@linux.alibaba.com" cla=
ss=3D"">abaci@linux.alibaba.com</a>&gt;<br class=3D"">
Signed-off-by: Jiapeng Chong &lt;<a href=3D"mailto:jiapeng.chong@linux.alib=
aba.com" class=3D"">jiapeng.chong@linux.alibaba.com</a>&gt;<br class=3D"">
---<br class=3D"">
fs/ocfs2/dlm/dlmrecovery.c | 7 -------<br class=3D"">
1 file changed, 7 deletions(-)<br class=3D"">
<br class=3D"">
diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c<br cla=
ss=3D"">
index 4b566e8..afc5173 100644<br class=3D"">
--- a/fs/ocfs2/dlm/dlmrecovery.c<br class=3D"">
+++ b/fs/ocfs2/dlm/dlmrecovery.c<br class=3D"">
@@ -126,13 +126,6 @@ static inline void __dlm_reset_recovery(struct dlm_ctx=
t *dlm)<br class=3D"">
<span class=3D"Apple-tab-span" style=3D"white-space:pre"></span>dlm_set_rec=
o_master(dlm, O2NM_INVALID_NODE_NUM);<br class=3D"">
}<br class=3D"">
<br class=3D"">
-static inline void dlm_reset_recovery(struct dlm_ctxt *dlm)<br class=3D"">
-{<br class=3D"">
-<span class=3D"Apple-tab-span" style=3D"white-space:pre"> </span>spin_lock=
(&amp;dlm-&gt;spinlock);<br class=3D"">
-<span class=3D"Apple-tab-span" style=3D"white-space:pre"> </span>__dlm_res=
et_recovery(dlm);<br class=3D"">
-<span class=3D"Apple-tab-span" style=3D"white-space:pre"> </span>spin_unlo=
ck(&amp;dlm-&gt;spinlock);<br class=3D"">
-}<br class=3D"">
-<br class=3D"">
/* Worker function used during recovery. */<br class=3D"">
void dlm_dispatch_work(struct work_struct *work)<br class=3D"">
{<br class=3D"">
-- <br class=3D"">
1.8.3.1<br class=3D"">
<br class=3D"">
<br class=3D"">
_______________________________________________<br class=3D"">
Ocfs2-devel mailing list<br class=3D"">
<a href=3D"mailto:Ocfs2-devel@oss.oracle.com" class=3D"">Ocfs2-devel@oss.or=
acle.com</a><br class=3D"">
https://oss.oracle.com/mailman/listinfo/ocfs2-devel<br class=3D"">
</div>
</div>
</blockquote>
</div>
<br class=3D"">
</div>
</body>
</html>

--_000_78EEED8F5F7E496F8E7CC906AB4E53C6oraclecom_--


--===============2163963869940631484==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
--===============2163963869940631484==--

