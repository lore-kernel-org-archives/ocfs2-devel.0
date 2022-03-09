Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BC14C433F5
	for <ocfs2-devel@archiver.kernel.org>; Wed,  9 Mar 2022 14:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=/A/9dHep86tzEB0Bzu6CzsnRC0Rz9pSBMmi3miqO4E0=;
 b=1d1idQOb3m538m5EZyPjPQt+Xh2ZhF7pgHw143djD2EKdv9hsP1dd2GcDUgBjH1M8rkjEuAhIrkn
   2B22dg8gbvqGs3Oc0Iq0bjvSHV+QIZB4BNt9BChSmdZkOCEJFQcdioGfADl8KkmDO2SQC6ZH/l+x
   RsFDagdeLs1Gsz6xvF8dvZCKgdqWWQo60JgLUlCaPXP8enp/2uDXirxvCQZxpOZJcf4DwPGLHb42
   UysxPdV8qshHrOpB/h3fSXDOSXUvK8ka6fqDL3u09Kzm1B55rebUHX4SAe8ex2d9GlgAAZcfgdrI
   Q90zWXQqkBmeFRpn56YZ7wXAPWDAG5pqsaN7MA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=/A/9dHep86tzEB0Bzu6CzsnRC0Rz9pSBMmi3miqO4E0=;
 b=t9munDR8sESGAZBHFXlAKYvEq4SBeFXGmw0XSdGAQdcvIVOInDWRPZ4bnvK7oUb5m5TQJpEvd9ti
   UyfV3ap/b4bD9VREfDVwBZs/oRteipjjE7XYxSOTCKmoUPgl8IECd4Y7QPIDXfblOLPomnneQ+Dv
   R72Bne/VFjLj3gSFJSnVXkw7v8hoU+410M+IqAR34LPNH7aKTKj/YVJ/gUBa0jlF8eAUEoDZt58I
   cLAMK10xmzrk7iNCl8Nu8v0g9Z/kL9tqbfeQVy47pApuXxB8A/hfjZa+hZ+owuU0Yn1gKRkyPnvw
   SgNyE6kqY5XkdgZwmJzIpjjVSy2/7iKlYGQ9+g==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220222 64bit (built Feb 22
 2022))
 with ESMTPS id <0R8H00HCNG8C3890@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 09 Mar 2022 14:57:48 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date :
 from : to : cc : subject : message-id : references : content-type :
 in-reply-to : mime-version; s=corp-2021-07-09;
 bh=quX1lhSA5ZRqagjU0YbwsW7KW+fFDNMtOy66b7z3yDE=;
 b=xHqfUeyo5TQbl57lCYcRTxQBm0Iy47QGeHlCA8yDFx5JBIWsao+Cbqy6XGqllNErvey/
 vZwdLWa+FRYWS/jbOO/BfB9tBNYG6ghnRK9Ut9KRhzXglP5Bpa1x2x5HiN5OIbgWue1F
 FWht2p4Agj2Q7BfZCaCtIYsVfyz1GGx8GDJFToI5Oydz/bfpfyOHfU0xfrcjp3SEuQQn
 +rJap7aaAtyD9NQwNRMaKu9w8swOaedqOGyRkt9eDyoWzNcuH8R8oRygh8Fq+sHFa+He
 905W3gXubhVLPFQCaGmeL90RIhoaonaU3ljVM5W4ULvNmqKtCJivorrN5LnLdV9dJc5C dQ==
Authentication-results: aserp3010.oracle.com; spf=softfail
 smtp.mailfrom=dan.carpenter@oracle.com; dkim=pass
 header.s=selector2-oracle-onmicrosoft-com header.d=oracle.onmicrosoft.com;
 dmarc=none header.from=oracle.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jq81S1IHAXu8V7ffrgh4fQ0bc/R8r3fyE0og3upVeFbYdeoYEph8FCZDqVWoympeCXjR0tls8gFRw2qmOnMQcVJnd9OCaqHI6r5q2cDHK5X4Ieb2B9qhpEpEtOXpukGMaIZddcu52vAVKZgmQgpvU3u+VgMXqkR3QK9iUB+zS/vjtqIQtUoKrzO5h54qqFUZqzmP8qzUhtWtKDPBsLwpglR/DKQ1bj5j0tJbFd1kfvlJkW/1rHeZvI4UrAZ5PSMw67uJqu2jzDyczdkP8oEz01e7yNOh/ZZkzFJY40lo3RN5rEbGdE1LyKlUDyDjM3CRG0/jwsKwdQlCqwudKeG+JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=quX1lhSA5ZRqagjU0YbwsW7KW+fFDNMtOy66b7z3yDE=;
 b=QdRqq3H1bt0uaLSTaSwqUnHMH6NL1Mi08/M8BXx7uaAPJqP8fOytGqVBjwSHl2IuH5rZYqAJ8MP8wOp7nanjAx5mswaO0mGzYjPExYi0Dld+f89yl6pdd5NadNZX9nvjUFyE9RPnkMaIo0uNbgsFmgxw2xQ9Cj8jZfZ3IYkd+vGyfKxTSQuQdI0Swq+r2V6ukVOu0xHv35080jfxNGyfnkDsrKGaVGMK/UhS2/PalKi/0MRmfu/9/sfd87Q/9Nh7dAVTbP7QA7vula4CabsgkGnhwkcgVVLu4YAWC3XCR/nsQPEa3WmaR7CzazwpS4I8dlvCNvuUY8bHYmxg9avBOw==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.onmicrosoft.com;
 s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=quX1lhSA5ZRqagjU0YbwsW7KW+fFDNMtOy66b7z3yDE=;
 b=p7+EkOy/3qowkGVL3dnhtZ+gZ/A3aVTsBJR8dwbeBdVgEYzhF3JOZ/MUyTXNS5I1P0ZbEMriMNpz7X9YAY7RV/55WH4L3kkNgqGHYmViteUpK8nwB1xy9JaiTHIQY+uEmHOVbs6nnl42l2ZOY9K6XK36xucJWd5Az+gcdvot3H8=
Date: Wed, 9 Mar 2022 17:57:17 +0300
To: Joseph Qi <jiangqi903@gmail.com>
Message-id: <20220309145717.GX3315@kadam>
References: <20220307145138.GA22641@kili>
 <82b26a4a-2351-f2b3-dd7c-265308e6b384@gmail.com>
Content-disposition: inline
In-reply-to: <82b26a4a-2351-f2b3-dd7c-265308e6b384@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:;
 IPV:NLI; SFV:SKI; H:MWHPR1001MB2365.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:; DIR:INB;
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2022 14:57:34.0433 (UTC)
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10281
 signatures=692062
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0 suspectscore=0
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203090083
Cc: Jakob Koschel <jakobkoschel@gmail.com>, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [bug report] ocfs2/dlm: Fix race in adding/removing
 lockres' to/from the tracking list
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
From: Dan Carpenter via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Dan Carpenter <dan.carpenter@oracle.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ClientProxiedBy: JNXP275CA0001.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:19::13)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7329526e-de97-44fc-51d3-08da01dd2452
X-MS-TrafficTypeDiagnostic: DM5PR10MB1947:EE_
X-Oracle-Tenancy: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 cJ0Zu/u6sSUuKHBfP9ylO2udlmugyh1qZwSdIYP1XgWcGJhDXD+NPzJV3bMFkNrtLTGhZ6Y3XmEhRCFnSP6eCjV7bttEtaWvCkpkyruR2qFY2zv93hJCUibWbMmWXEhs1YPcBCzCFb0LrM62e3KwE5bgOL2h2g52VdlH1VXQLUoxW7ZBrk6szt3UbZ3l8dWzo2ataaMs/L//l5457M5gCy5f+j0aMjtDg4mKxmRQEHSPu0ZdwSiCrIAd2/03l2sAddA6OTe0F2KaeH3wFuzXTAJmXlGxUYFPmlINYKSU1PuaXSz9yqr9rJe+5egensRbz3JH/xBhlcwN8QIUkDw2ppoLngDwCdsa8DpAg1yaoYpo7AJmA66yJQKgcH7VzLqEBSXv/i20Y+zAFo5vlns96tC3cdBuGI5K+LDyzPFuTPXBVwRQMdeKepqT2tfbkS+YdHT+NjFVkUL9ZlTrctbCcrk0/sdaoWWEXUKB9D+aJYknJNDEwerId2kvxlKz+QJBX+javE97NoaRz2lyQTxQa6FXkb1jNaZdAYSFH55JxTPvWqjhKxLGy5/wmX4auYdRBf2p1jsMESaKsEVjzeM7E1T9AKqFZpIfiua84Hzoxys=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 7329526e-de97-44fc-51d3-08da01dd2452
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 +G/H52TtMQWpoCUC+eJoqNebYcNJF6GuwWBYi4lMTgKXFWcWcb+THd78PkhC7HYJuuSEjeEwQ0TFhnvXT/YnfLaTtctpfPewtUAGboXm7YE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1947
X-MS-Exchange-CrossPremises-AuthSource:
 MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 06
X-MS-Exchange-CrossPremises-Mapi-Admin-Submission:
X-MS-Exchange-CrossPremises-MessageSource: StoreDriver
X-MS-Exchange-CrossPremises-BCC: Dan Carpenter <dan.carpenter@oracle.com>
X-MS-Exchange-CrossPremises-OriginalClientIPAddress: 62.8.65.185
X-MS-Exchange-CrossPremises-TransportTrafficType: Email
X-MS-Exchange-CrossPremises-Antispam-ScanContext: DIR:Originating; SFV:SKI;
 SKIP:0;
X-MS-Exchange-CrossPremises-SCL: -1
X-MS-Exchange-CrossPremises-Processed-By-Journaling: Journal Agent
X-OrganizationHeadersPreserved: DM5PR10MB1947.namprd10.prod.outlook.com
X-Proofpoint-ORIG-GUID: 8vhnKL_iOy1jANSxAk9sYWmsJqZr7gMM
X-Proofpoint-GUID: 8vhnKL_iOy1jANSxAk9sYWmsJqZr7gMM
Reporting-Meta:
 AAE67dLvFfC0GYABxwAvXkACjWcoBywT4ShCvfYoMfq3j6h3VytL/Gr5JQP4Ls4p
 6sOPwletcwNdSQiYCrJnjkncpiAn12JeJj5ULLCIkoRAtgdbZZluIgCNovKvPXWz
 j8eQkb7IRk81FWeCCnhJDcFfB6jitCjJEexVFOXQxJwPS4tqbxYaZ8nK/3LmvLAG
 gOkzf0cf5syKzIpEbfksJ2xKbvvtMfSi6vbVODRUeZwzwwmnJs84zX6VK+8BnFsA
 H3GFqvfcQZxhmp1D2CB4P/wYK/U6wc3Pzab9zYXTpwChbaOlX/bPC3IC8vLiufWB
 FjeGNr8gbR4zTVNMEGkIUk7n0TnZaN0H6mxOFV3IwhXYO2ZSzvuvNkiWKZOnnCRk
 yEabOX2GmQCcZt6WsJumY0u+CH7Sxu3f4YRe8iyU4sSlpnwwcFtM2c9yU6YESfZw
 FSRQTOzyKNbupFnmQPLQO0x4SpLQfCAocZFzj4qe2Pp+rkehsXvjrUDbyKKP70n3
 8swytqcJPgZW42hybNXmfwRBcA8gmSCA3vWvO5i+shXc

On Wed, Mar 09, 2022 at 03:46:11PM +0800, Joseph Qi wrote:
> 
> 
> On 3/7/22 10:51 PM, Dan Carpenter via Ocfs2-devel wrote:
> > Hello OCFS Devs,
> > 
> > There is a big push to re-write list_for_each_entry() so that you
> > can't use the list iterator outside the loop.  I wrote a check for that
> > but this code has me puzzled.
> > 
> > The patch b0d4f817ba5d: "ocfs2/dlm: Fix race in adding/removing
> > lockres' to/from the tracking list" from Dec 16, 2008, leads to the
> > following Smatch static checker warning:
> > 
> > 	fs/ocfs2/dlm/dlmdebug.c:573 lockres_seq_start()
> > 	warn: iterator used outside loop: 'res'
> > 
> > fs/ocfs2/dlm/dlmdebug.c
> >     539 static void *lockres_seq_start(struct seq_file *m, loff_t *pos)
> >     540 {
> >     541         struct debug_lockres *dl = m->private;
> >     542         struct dlm_ctxt *dlm = dl->dl_ctxt;
> >     543         struct dlm_lock_resource *oldres = dl->dl_res;
> >     544         struct dlm_lock_resource *res = NULL;
> >     545         struct list_head *track_list;
> >     546 
> >     547         spin_lock(&dlm->track_lock);
> >     548         if (oldres)
> >     549                 track_list = &oldres->tracking;
> >     550         else {
> >     551                 track_list = &dlm->tracking_list;
> >     552                 if (list_empty(track_list)) {
> >     553                         dl = NULL;
> >     554                         spin_unlock(&dlm->track_lock);
> >     555                         goto bail;
> >     556                 }
> > 
> > Why not do the list_empty() check after the else statement.  In the
> > current code if "&oldres->tracking" is empty it will lead to a crash.
> > 
> lockres will be added into tracking_list during initialize.
> 

I am not sure we understand each other.

This function is iterating over the list.  Nothing should be modifying
the list until after we have released the spinlock.  Any modifications
is a race condition.  Which initialize function are you talking about?

In the currect code if oldres is non-NULL and list_empty(&oldres->tracking)
is true then it leads to a crash.  There is no reason that we cannot do:

	if (oldres)
		track_list = &oldres->tracking;
	else
		track_list = &dlm->tracking_list;

	if (list_empty(track_list)) {
		dl = NULL;
		spin_unlock(&dlm->track_lock);
		goto bail;
	}

This is cleaner and now we do not have know from outside context
whether the &oldres->tracking list can be empty.

> 
> >     557         }
> >     558 
> >     559         list_for_each_entry(res, track_list, tracking) {
> >     560                 if (&res->tracking == &dlm->tracking_list)
> >                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > This should never be possible.  How is it possible?  If
> > &dlm->tracking_list is the list head the it's not possible without
> > memory corruption.  If &oldres->tracking is the list head then I do not
> > see how it is possible without memory corruption.  We can't mix different
> > types of list entries on the same list head?>
> In case of oldres, and the iterator points to dlm_ctxt.
> In this case, the lockres is not a valid one.

That doesn't make sense.  :/  This condition is doing pointer math.
The offset of ->tracking is 136 bytes and ->tracking list is 88 bytes
into the dlm struct.

	if ((void *)res + 136 == (void *)dlm_ctxt + 88)

Use algebra to subtract 88 from both sides.

	if ((void *)res + 48 == (void *)dlm_ctxt)

So dlm points to somewhere in the middle of "res" struct.

>  
> >     561                         res = NULL;
> >     562                 else
> >     563                         dlm_lockres_get(res);
> >     564                 break;
> > 

regards,
dan carpenter


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
