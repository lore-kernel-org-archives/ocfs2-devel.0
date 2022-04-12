Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3535AC433F5
	for <ocfs2-devel@archiver.kernel.org>; Tue, 12 Apr 2022 09:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=QPBmwid2rNhOmXguo370rJyt8786S5N47wxeBigimlg=;
 b=W5+XAjyaX4LkK0jvBY3AKWSpYBJLgeepH80l9fPWtScvLYgxKjGoXNdm7S80SBAMoyMD6Ck50AZH
   zuRiCuanjBjnQ8u0pfzibCCeRZvK94K8GTUjsNolcOaIsW6uBdsASb9k2H/VvCnv7peIvvPexZYl
   vrLf/H396yhYot9USqgr7e+08s9gcyIElIYMTCtTGI5EtJl+PWMCP4i8+I9iEv8rz5SCuGzrb+1q
   4b5ooeVdeLwYlvqZPsfT9WiY8VNGIbLrL1tRBOgveIvdPQxz/4QCt3dQGkWKvzpFbp8Er/1FDgm+
   WSGCn8P5CN+eHGa0gET14qa1QIl82Y2I93ASQQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=QPBmwid2rNhOmXguo370rJyt8786S5N47wxeBigimlg=;
 b=jsCFDHH+xfcor52PPTLo7GTFILL3tt1PNGHP/rnLc8yuYIa8JmjqfqBLhfRTCT0L0sNaGmPJmxdn
   tCW/hBeZi+eG+zs16o3z3w7NyEffm6akZJ95+uq5RVLxEiwKCWIOVqxCQofROeWEZH18/x/DlHf/
   tneE/W5UPS649NIav3utKb5QXYWXbosz7mooaLJp9oFc2zIZQxNIO3ut2m1FJeREns8xdBqHxR1p
   OQLyPEGtIVVx9etfZvxDLV19XZ///pZGWFlxnOrIPNYx+eiHxXZ6yyR0NtRvl2Cm4W6QTfgM2XZf
   +EE98lJy3skvc0M594TWt15G9En2tEadNkXMiQ==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RA800C4Y0QIYM70@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 12 Apr 2022 09:51:54 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com;
 s=mimecast20200619; t=1649751785;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=ZegOB4lFvnAwPCNRZaGJB+lVfeg88kmCz9jm8D8XuLw=;
 b=BdyXcSqxIAKc6e7S3Im1TPkhQwAYPdTwGA1Y5uzSx/RILqbZKoM2IYTQoY7rNDS24NKXp9
 35hV6HZWMBvMh2AOu4SrKqCbpEkExEyTYNr+ea+Ri9njnY9BCCvhmK6YwGwQAAkCbEWJm1
 1YjM0ejaYVqbKCc5iz59eMt3UKMUnHY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gaUiJlLR/X9wMgXTTmsD7PfWWfiwmujAWQW0pYt51fM87a/ejfSXYhpxvb2ljXtNHBHiRl1vv6C536JZDhnfUF+HgYHw09rToh7iHC2htUOKBYGMKxEtLwbbG4lSvT/Sh3KPol1dG0rgDnqnSj+fmAaRUm6VXuSfyUc+fxXTVcOqtUiCCk8pezpadmR3XXcnQd01Gj1vOEy+th8ownOv8Uu/IFcjj57nObX5af2KBa3vlM7MGeY0E9AlcEpWccA7axGCMV5Y2rFmZET/tRgwez835UBPAQ9s/Y4HknNuUL/DubN75niKHlWp+hiZw5AssNINE6IJlIby9M6ttwNqpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZegOB4lFvnAwPCNRZaGJB+lVfeg88kmCz9jm8D8XuLw=;
 b=ZnTDCFMRhaY4X4GKWbVMldLWvrjBJKNMDC9FOnU/sNCVKrlxyPFomHJXWL6BbzYYONo/8R6SgjEThY0vulw0SagSME6zzh2T8iKJ/+UfxwpBJ1vW+0EHaO1/gyeQhln3m4jgUZbGeBcTMO/KjHj5IoFKt/T9EtI25FdJXc86W+zhO6OgAvvxpP3eUwd3isBQwzuzM/pw2IK3galNo3YPl+4yE29KJYbktcwuq7tniWiF0+fhUr8ohy/TJ3uiNtu4GLvXpDF2/lI52LvI2cpvwOZMD7UDKwsGVzezH+Hu0TDXECVFYSzNIPp+GaZuc/l6vMzEdi72iCRMWiiwfQatIw==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
Date: Tue, 12 Apr 2022 16:22:48 +0800
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-id: <20220412082248.qzacxmvexkpwqhua@c73>
References: <20220408103012.1419-1-heming.zhao@suse.com>
 <20220408103012.1419-5-heming.zhao@suse.com>
 <5bd3a683-b0bd-b6b9-32c0-b57026f109aa@linux.alibaba.com>
Content-disposition: inline
In-reply-to: <5bd3a683-b0bd-b6b9-32c0-b57026f109aa@linux.alibaba.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(7916004)(366004)(86362001)(1076003)(66476007)(66946007)(66556008)(26005)(2906002)(53546011)(3716004)(186003)(9686003)(83380400001)(6666004)(6506007)(6512007)(44832011)(316002)(508600001)(5660300002)(6916009)(33716001)(6486002)(8676002)(38100700002)(4326008)(8936002); DIR:OUT;
 SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 08:23:02.9348 (UTC)
X-Source-IP: 194.104.109.102
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10314
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 suspectscore=0 clxscore=185 spamscore=0 adultscore=0
 bulkscore=0 priorityscore=168 phishscore=0 mlxscore=0 malwarescore=0
 impostorscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2204120039
Cc: ocfs2-devel@oss.oracle.com
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
From: Heming Zhao via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Heming Zhao <heming.zhao@suse.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-MC-Unique: 82pu278QPRmesVRm9MqSHQ-2
X-ClientProxiedBy: OSBPR01CA0077.jpnprd01.prod.outlook.com
 (2603:1096:604:2d::17) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9ba2b68b-49af-4873-fcc5-08da1c5da978
X-MS-TrafficTypeDiagnostic: VI1PR04MB4333:EE_
X-Microsoft-Antispam-PRVS:
 <VI1PR04MB4333F7660A5E45494523A63B97ED9@VI1PR04MB4333.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 u/y6F1UZAMvWig/QHeFJvob+eTNUilDTTuG0quxjcyYFHv2+1eTYCOLjx9OAKAPBgU7hqR4hicGy5g5/tn/jFktaD8mL1VIu6KFQ2hj4SlW0kltxFqtz99576kCH8LWMHvhzyv1gTUKk7a0OK1rCvMNIDINtElGxxK4eVKGjfLjg3Kf/7sSUFot1BRBby8RSr210E5fmAsntrZLbwnQp42eqZSJtlECJ5OT9Jm8wodwP/9Cjr7MmiB+ldUW2S4QaZcIr1XaeT+xyaGauAUldOJmBVpO5HANFunovnyBUyDp01iDs3mrVw22HMuOBrlQNiJEP6za9FUAw7AcWg9KW9dTN/mO9LME3FKC7f8ZC0FutDvRqIMxap0RHAHPoBP5CsS+qFUzCjLdwyflwPSh3QQFtVMnvV+3iakkQYyC1aj6FdNNHZyh5bm5quM+GxjjbRkkxTWVEZVTh7mLhQpSrJTQwN/y0hgE0u1fHh/qfO6RI2QuLNkWiqheoCOPeKDnyYtncym1tJ1kst3k/U/BECtJLbWhIbA0BRDcIzSD9vVd4JwNbD+FucYZ2GwDYz0/hvFtD6kuT0J6ZNI1ulgvu0S+sNKwKUr+8ZWnI8WUYFNIViV/+EFsrZPqB3+P8W2PYyjw8YGDmp6N0s/PGAaGhnw==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?Oa041jNml7X8B5AR9NK+Dgk5+5+H5OZvSo0GHMSWLbI0K5U8J+/+ICOpG0RD?=
 =?us-ascii?Q?OCSP+h5XX99m2aaFAyhHTKItzABDzRajo2KKGGFw9AOMHwQvBmBBgn7g2J0F?=
 =?us-ascii?Q?zuMAiUkTemvOJdNTx9SdlyUMUJv3+TpH8pwkIf0+nGFZXdTRwlkE915DoyWs?=
 =?us-ascii?Q?RGTUMKEwyRMtmd7BD135OtuAXYnz3+9x60cziT9FflJPRY/uXQjhGXxjJQJP?=
 =?us-ascii?Q?mS4YUzjUGRzpMSYaEtUcnvbY/1jmttbqWReJrmkAuL1OrHk8Gq1tS3S2X5c0?=
 =?us-ascii?Q?qlrqMiknvSnBEkQ1BVCigt1jo3CrviUCClNCsVbBiPDn74uShvtpXivSRKCi?=
 =?us-ascii?Q?QQxEzaOLZ+dwidXVG0thXcmWkBGrW229Ncgp15dt0AMbaFSrdeViK4IBxrLI?=
 =?us-ascii?Q?0R4wzRlWTLuiBuyOrCqN6qzzUk2pe3IpNOTF6CFFOEiwM54iAkWfxfIi8Q9N?=
 =?us-ascii?Q?L6KmXBcPt9qm9jEvP2nkPZ5UqKnJh4UKczJj8zkl0J1s1nld3jViFuS80Mm9?=
 =?us-ascii?Q?1WkYnTJSh2hcEVfYfEFPQ1+F28GIIK2cwT2fxeGZy87dmIjXpDGtA58o6EeI?=
 =?us-ascii?Q?Wox2qFoIeS5dkDKmORwp1lwHhjOs6krdndQvRSFr06pprS1GDKqozzTLsIpX?=
 =?us-ascii?Q?fpxYND2ez2CKvFtWFuY3kYxyea9VfQ1gSn2pwt1igAUncKno0EWZTIOGtCT7?=
 =?us-ascii?Q?u8HI6bBvNsdr2uA5dPLMIEBkEwRbmL01aGY/jypl2Xx9wfZ00CJvYE3tDEDY?=
 =?us-ascii?Q?AiYnYFGq1wqujTK2GqH1KVq7dZtuGycaOfKNuJx4YaBrOzEPaZCZ4U9+rh3N?=
 =?us-ascii?Q?tG5YHGDwmTXrw7rPg1UBGtGlz40RWAuY5cnU9gw1mbTaJvkQYZ2s4YanHK6/?=
 =?us-ascii?Q?CallPEJNeA8ZS0AaLtjTQ7KZhTcwW7DTsPHM/hjC8H1Np5MTPe/pJuvD62NT?=
 =?us-ascii?Q?305o1+fD+y+FUXwOYXk4M926cPCMTEGuxqJm/GV4jLY/SL67S/rA5asyMpub?=
 =?us-ascii?Q?sPWiQS7ekuZjNU34Vl3246R7pLed5KsVcjdW07bggudqajh6LE9x+UM22Hyg?=
 =?us-ascii?Q?mIQYT8cHSspZyzrkSyZZhTYKqxN2LlJQ2DgSMqqNxvvdHkOxsrB3aSyTFAsf?=
 =?us-ascii?Q?7x6xq44i5Bk2ENy93PkKfWVWf+Oee9+ylWqdwC+CLhhysdmyrUPayLeKWL1C?=
 =?us-ascii?Q?bZhdmZVhlwyOkePU8z63tcq6hqh+7F6NmGcayTKHKA78n+Sd7B0yvdChoTtU?=
 =?us-ascii?Q?4S3CspiabEdyMMSQeOkIwdSl0zwszE+MZQpsqg71On+txDbsJsIkRaUGdgHd?=
 =?us-ascii?Q?HbuJ9LcdCkhkqxvkrbL+f/WJXavh7JOvdsClMle97aHG1GXoXFTcb2bWuLva?=
 =?us-ascii?Q?7hy/BCLdEDyqj6FtqPorm5ouXgIkVWb34L/Jqd+xq67gcfdKQa32wdvKYQ13?=
 =?us-ascii?Q?x+mLqQ6srAATRYC00MfjcK+JIJkjMOzAxgXpkuW+oeIct+o1ykwU9eml/FaW?=
 =?us-ascii?Q?JGYkxYHqEDDJZqN6iw1gxY96J11Nn0mr3uvWetd82Y6TcUUgHi/3ggvD2Rj0?=
 =?us-ascii?Q?wHgJShmpXE/L2vTpE7ES9KAw+BEGiAkwaILVCWNWtiYm7orhVMYxKSUchB8X?=
 =?us-ascii?Q?xrCepfotclI44r+ml8zm5syOlcwZvGbr19ULQniUSBLPBVbjAoefaeWc2X5M?=
 =?us-ascii?Q?2R5MABZr322tUFoIS0bG2uwBdf1cjyE6Z+rp2pklPYFGSIwc1GRgOlwHQyqD?=
 =?us-ascii?Q?RBWIeamOwQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 9ba2b68b-49af-4873-fcc5-08da1c5da978
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 btqvVU32HNufe8IiiCp13jSoBT//AfJR57ufbRIxmdqVcBAmr5fbe0uNIL1ccr0BAewRHlOhexMhOLE7QBHPGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4333
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
 include:de._netblocks.mimecast.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: 6f3wX2nqOpKpdEqxWBsJVQZrM5YvvkTG
X-Proofpoint-ORIG-GUID: 6f3wX2nqOpKpdEqxWBsJVQZrM5YvvkTG
Reporting-Meta:
 AAEK0TjmceQ+ZUVFruPxETfvBl5zeggDEwfsmpV4EvBzQ822RsSAiok7Pnwv+mvt
 R55CVgkyNnpb6mRYHhb8Af98EinuOaIagkfP/n63y97irfG/Utfsd6l4yr5HkwxS
 aRx2FVGX/8yzXEUR3HNqhO0jk8tq4ujK/wH/bYZFDGMXTzoKt8d/kdjhY6eYchGA
 ZUlUmu9bbFp8Uqk+Psi7cGF8W8p9b9yWAH0+BaGsXx1QGoVAbBADRscG/iPM+mMd
 0wOvonPTYah9girP+YxSTHqnBD8hTjijOHecVYe1QbU0/9jIv61oc7oxNr2qvWPf
 oreBCvOA05S02BYtS11GdYFGlKZw16oRLWcOXxHP6wAvzjJlUfDpxzo9mNQdGQbA
 JEUTtSnctodMT11B5vawI2NYUhVWs3XyiTBYATUsSgV1CinUTMM6qgw1qF57EyUf
 3MM84ckC+yCk3ZyDtq6jObKE9X3vRYVaDdHzuBmsjR3iZvNaSrir9ukPi3sDuPwH
 EtTcr+752p1SMK+H7aRm7u1rOedI8BWqYboem36LC6uJ

My last reply (on 4.10) had messy format, because thunderbird automatically
add '\r' after '\n'. For easy review, I use neomutt to resend my replay.
Please check my comments in below.

On Sat, Apr 09, 2022 at 09:46:19PM +0800, Joseph Qi wrote:
> 
> 
> On 4/8/22 6:30 PM, Heming Zhao wrote:
> > After this patch, when error, ocfs2_fill_super doesn't take care to
> > release resources which are allocated in ocfs2_mount_volume.
> > 
> > Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> > ---
> >  fs/ocfs2/super.c | 32 ++++++++++++++++++++------------
> >  1 file changed, 20 insertions(+), 12 deletions(-)
> > 
> > diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> > index 8443ba031dec..d4b7a29cb364 100644
> > --- a/fs/ocfs2/super.c
> > +++ b/fs/ocfs2/super.c
> > @@ -1803,11 +1803,10 @@ static int ocfs2_get_sector(struct super_block *sb,
> >  static int ocfs2_mount_volume(struct super_block *sb)
> >  {
> >  	int status = 0;
> > -	int unlock_super = 0;
> >  	struct ocfs2_super *osb = OCFS2_SB(sb);
> >  
> >  	if (ocfs2_is_hard_readonly(osb))
> > -		goto leave;
> > +		goto out;
> >  
> >  	mutex_init(&osb->obs_trim_fs_mutex);
> >  
> > @@ -1817,44 +1816,53 @@ static int ocfs2_mount_volume(struct super_block *sb)
> >  		if (status == -EBADR && ocfs2_userspace_stack(osb))
> >  			mlog(ML_ERROR, "couldn't mount because cluster name on"
> >  			" disk does not match the running cluster name.\n");
> > -		goto leave;
> > +		goto out;
> >  	}
> >  
> >  	status = ocfs2_super_lock(osb, 1);
> >  	if (status < 0) {
> >  		mlog_errno(status);
> > -		goto leave;
> > +		goto out_dlm;
> >  	}
> > -	unlock_super = 1;
> >  
> >  	/* This will load up the node map and add ourselves to it. */
> >  	status = ocfs2_find_slot(osb);
> >  	if (status < 0) {
> >  		mlog_errno(status);
> > -		goto leave;
> > +		goto out_super_lock;
> >  	}
> >  
> >  	/* load all node-local system inodes */
> >  	status = ocfs2_init_local_system_inodes(osb);
> >  	if (status < 0) {
> >  		mlog_errno(status);
> > -		goto leave;
> > +		goto out_super_lock;
> >  	}
> >  
> >  	status = ocfs2_check_volume(osb);
> >  	if (status < 0) {
> >  		mlog_errno(status);
> > -		goto leave;
> > +		goto out_system_inodes;
> >  	}
> >  
> >  	status = ocfs2_truncate_log_init(osb);
> > -	if (status < 0)
> > +	if (status < 0) {
> >  		mlog_errno(status);
> > +		goto out_journal_shutdown;
> 
> ocfs2_check_volume() not only does journal initialization,
> but also local alloc.
> 

I agree and already handled this case. Please read following explanation.

Call flow:

ocfs2_fill_super
 ocfs2_mount_volume
  + ocfs2_init_local_system_inodes //[1]
  + ocfs2_check_volume
     ocfs2_load_local_alloc //may fail

If ocfs2_load_local_alloc fails, only "//local_alloc:%04d" is bad.
And other alloced inodes (from [1]) still exist.

Also note, the sys inodes release function is ocfs2_release_system_inodes(),
which could handle both osb->global_system_inodes[] & osb->local_system_inodes[]
are NULL pointer case.

The cleanup job will be done in both places:
- ocfs2_mount_volume (patch 4/5)
- ocfs2_fill_super (patch 5/5)

Related code after patched 4/5:
(please check my comment start with "hm:")
```
static int ocfs2_mount_volume(struct super_block *sb)
{
	... ...
	
	status = ocfs2_check_volume(osb);
	if (status < 0) {
		mlog_errno(status);
		
		//hm:
		//need to release global/local sys inodes (by //ocfs2_release_system_inodes())
		//which are alloced by above [1].
		goto out_system_inodes;
	}
	
	status = ocfs2_truncate_log_init(osb);
	if (status < 0) {
		mlog_errno(status);
		
		//hm:
		//need to release journal: by ocfs2_journal_shutdown()
		//need to release global/local sys inodes: byocfs2_release_system_inodes()
		goto out_journal_shutdown;
	}
	
	ocfs2_super_unlock(osb, 1);
	return status; //<== hm: will change to 0 under next comment
	
out_journal_shutdown:
	ocfs2_journal_shutdown(osb); //hm: through to label "out_system_inodes".
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

> > +	}
> >  
> > -leave:
> > -	if (unlock_super)
> > -		ocfs2_super_unlock(osb, 1);
> > +	ocfs2_super_unlock(osb, 1);
> > +	return status;
> Explicitly return 0 may be better, which means this is the
> normal path.
> 

OK.

- Heming
> 
> >
> > +out_journal_shutdown:
> > +	ocfs2_journal_shutdown(osb);
> > +out_system_inodes:
> > +	ocfs2_release_system_inodes(osb);
> > +out_super_lock:
> > +	ocfs2_super_unlock(osb, 1);
> > +out_dlm:
> > +	ocfs2_dlm_shutdown(osb, 0);
> > +out:
> >  	return status;
> >  }
> >  
> 


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
