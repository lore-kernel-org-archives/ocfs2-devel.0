Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37D5DC6FA83
	for <ocfs2-devel@archiver.kernel.org>; Tue, 27 Sep 2022 09:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=CHQNW0F4161MraQBgnCukFJWaeXtmfWtb3WhqwTr19U=;
 b=qQRj5xScz4zaZ9ZkE0XNuPdiFXJZ/fqI9iOV6Psx/1Ft1QY7DmmvzZGTuFSaUISdmKCltO0h2EZi
   eCxeTdZBzQKqCPhBHEA0AHuqxJzL0bPUT+hyTkS6Bm/QKdi8bgQhyljy/8bfI8XrjeCBnuTu6gdE
   /Iy7bPzp26KrDpQpw3oo7BLYfU33llP1T/o1EozioKU/yrJoRc+mH+M+SBbDWhMe77T82xWq4Hca
   UuwsgEeFQMB7R4+7ArBBPFTJ7XtMQMCfjAddoCWCDF7piNiYdMbfXpkHJuewJGs8rRKQGMu5R2Br
   /UKe6RqTK5zztBoEWQ0sOg9OM3j9VDiZ87iLYQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=CHQNW0F4161MraQBgnCukFJWaeXtmfWtb3WhqwTr19U=;
 b=d/ZTOs/3vAurcULH92nWX952yp0lSyfAG5smth6jzzW/+7W/qdyjy++sh06CWlsfXVDiA4obq+W3
   L3tUifdIEIRLT1kFm6fiYDCC6/MtcIyfongCfL4tSqVjthM6ZUjjKItLri/RuhJ40HmVYwpkH9Ru
   v+TWidht3chFnSkqSxk3r+jzwq3dqyuolmeEkYdJc+YDSkhHyUfvSUc9FxcyWTGg32yyPU41/1+6
   iUqp/3SW2ZtAk6RFqAJYCVmxXhqBf6AS9U0P/3TRphy+roc42aaVUHeVxsttJJvM2QlBm8DwhmsM
   CfQWe6aDRwK3tIZp+vaOGkchcXubfZtifwuOkA==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220914 64bit (built Sep 14
 2022))
 with ESMTPS id <0RIV00C3E36M2430@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 27 Sep 2022 09:18:22 +0000 (GMT)
To: Joseph Qi <joseph.qi@linux.alibaba.com>,
 "mark@fasheh.com" <mark@fasheh.com>, "jlbec@evilplan.org" <jlbec@evilplan.org>
Thread-topic: [PATCH] ocfs2: fix crash issue if access released lockres in
 debugfs
Thread-index: AdjSTgjzs68j6v4ZSxestKMYGpn8kQ==
Date: Tue, 27 Sep 2022 09:18:01 +0000
Message-id: <33c7f114b4ee498fbb5d233bb354e396@inspur.com>
Accept-Language: zh-CN, en-US
Content-language: zh-CN
X-MS-Has-Attach:
X-Originating-IP: [10.180.204.84]
MIME-version: 1.0
X-Complaints-to: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com
X-Source-IP: 210.51.61.248
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10482
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 lowpriorityscore=0 bulkscore=0 mlxscore=0 phishscore=0 spamscore=0
 adultscore=0 priorityscore=48 clxscore=396 impostorscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209270054
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: fix crash issue if access released
 lockres in debugfs
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
From: =?utf-8?B?Um9jayBMaSjmnY7lro/kvJ8p?= via Ocfs2-devel
 <ocfs2-devel@oss.oracle.com>
Reply-to: =?utf-8?B?Um9jayBMaSjmnY7lro/kvJ8p?= <lihongweizz@inspur.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-MS-TNEF-Correlator:
X-Abuse-Reports-To: service@corp-email.com
X-ServerName: ssh248.corpemail.net
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.corp-email.com
 include:spfb.corp-email.com ~all
X-Spam: Clean
X-Proofpoint-GUID: s_1nDM4NND1xDqWETJt8xZ68BWIfwHnO
X-Proofpoint-ORIG-GUID: s_1nDM4NND1xDqWETJt8xZ68BWIfwHnO
Reporting-Meta:
 AAHUK8zRSTMjdv6YQyWVKJsyFsyRFxCZAOCGF35RlCrs/gOx78agFuHOtWKwACRQ
 zRvvHUGsHZ4g142tA4X9oZr7hbFztZMCGTSafXphPtpwgZRfLNDah5gpk+7aZRWe
 mi/Op2ri8lQNiQp4JYh+o5qWMDQTmbsmgqufinsdgbVS5HppmZFx5llb3zVnZykR
 A4EFKOLEcBVnsFbKqayROQ/+93MlrLecO7wa2Q+aoU3e1R86NyH1CTAiQj7ieSpP
 5hHpzBHzL8QSxBQ7THbkiGqbmtv19Liu/VgompaaKyCSGoJx5iKc6VVvIcli7w3l
 ht06SQQOxnAKbd1wPGE8fA+3VZ5rdyQGEMh3P2qxFha4dkLLHZcA/tv8Xqeg+A5y
 Fv0Rvz2u466PwVLRv05hD9cK7VqCRDZXglBphNCGTWBLyzN8Ij1/buhi6j1nBwmw
 du8x25O7M7YH5QH2s61B2iqRND1QUd380PXpvvRSfMx//Vopma4/3unt+LnNkzQk
 pRwVMJb6C0VnT4PeLUvNYxYMQ8durt+LbZkuUlc3dkp0
tUid: 20229271718004bb7c0e07da3a80c9c3a277ef3517944
Abuse-Reports-To: service@corp-email.com

Hi Joseph,

Thanks for your reply. 
In our use case, a userspace daemon tool will periodically read /sys/kernel/debug/o2dlm/<uuid>/locking_state to check the lock request state. System crashes casually after a long time running. After analyzed the vmcore file, I found the daemon tool process is accessing an invalid pointer inside the seqfile iteration when reading locking_state. 

I need to correct my patch comment slightly that adding lockresA and removing lockresB do not have to be the same process, the key point is that the lock tracking list is changed during seqfile iteration.

Br,
Rock

> Re: [PATCH] ocfs2: fix crash issue if access released lockres in debugfs
> 
> Hi,
> Sorry for the late reply.
> It seems it is indeed an issue and I'll get into it more deeply.
> I'm curious about how you figure out this? Is it a real issue you've encountered?
> 
> Thanks,
> Joseph
> 
> On 9/20/22 3:36 PM, Rock Li wrote:
> > Access locking_state of dlm debugfs may cause crash as scene below:
> >
> > Proc A:                  Proc that access debuginfo:
> > add_lockres_tracking(lockresA)
> > ...
> >                          ocfs2_dlm_seq_next():
> >                            //priv->p_iter_res points to next
> >                            //lockres e.g. B. priv->p_tmp_res hold
> >                            //copy of lockres A before leave
> >                          ocfs2_dlm_seq_show() ...
> > remove_lockres_tracking(lockres B):
> >   //free lockres B, l_debug_list in
> >   //priv->p_ter_res is updated but not
> >   //priv->p_tmp_res
> > ...
> >                          ocfs2_dlm_seq_next():
> > 			                  //priv->p_tmp_res which holds a old copy of
> >                            //lockres A, the l_debug_list holds a
> >                            //out-of-date succeed pointer, which will
> >                            //cause crash as //access invalid memory
> >                            iter = v; //priv->p_tmp_res
> >                            iter = ocfs2_dlm_next_res(iter, priv)
> >
> > The root cause of this issue is that private->p_iter_res acts as the
> > agent of accessing lockres and is protected by ocfs2_dlm_tracking_lock
> > while p_tmp_res is only a copy of the lockres and will be out-of-dated
> > after leave critial region of ocfs2_dlm_tracking_lock. We should use
> > priv->p_ter_res as the forward iterater instead.
> >
> > Signed-off-by: Rock Li <lihongweizz@inspur.com>
> > ---
> >  fs/ocfs2/dlmglue.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c index
> > c28bc98..5d84350 100644
> > --- a/fs/ocfs2/dlmglue.c
> > +++ b/fs/ocfs2/dlmglue.c
> > @@ -3109,7 +3109,7 @@ static void *ocfs2_dlm_seq_next(struct seq_file
> *m, void *v, loff_t *pos)
> >  	struct ocfs2_lock_res *dummy = &priv->p_iter_res;
> >
> >  	spin_lock(&ocfs2_dlm_tracking_lock);
> > -	iter = ocfs2_dlm_next_res(iter, priv);
> > +	iter = ocfs2_dlm_next_res(dummy, priv);
> >  	list_del_init(&dummy->l_debug_list);
> >  	if (iter) {
> >  		list_add(&dummy->l_debug_list, &iter->l_debug_list);
_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
