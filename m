Return-Path: <SRS0=dlQ5=NL=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84D51C432BE
	for <ocfs2-devel@archiver.kernel.org>; Fri, 20 Aug 2021 09:39:25 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0BAF860F45
	for <ocfs2-devel@archiver.kernel.org>; Fri, 20 Aug 2021 09:39:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0BAF860F45
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17K9RI2G020493;
	Fri, 20 Aug 2021 09:39:24 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ahsxd1w8n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Aug 2021 09:39:23 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17K9PAS0062532;
	Fri, 20 Aug 2021 09:39:22 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3aeqm1cr9a-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 20 Aug 2021 09:39:22 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mH0we-0005Lc-Dc; Fri, 20 Aug 2021 02:36:12 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <swhiteho@redhat.com>) id 1mH0wA-0005Kh-AF
	for ocfs2-devel@oss.oracle.com; Fri, 20 Aug 2021 02:35:42 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17K9P1HR086405
	for <ocfs2-devel@oss.oracle.com>; Fri, 20 Aug 2021 09:35:42 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by aserp3020.oracle.com with ESMTP id 3ae5nd90jd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 20 Aug 2021 09:35:41 +0000
Received: from pps.filterd (m0246580.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	17K9SET4006966
	for <ocfs2-devel@oss.oracle.com>; Fri, 20 Aug 2021 09:35:40 GMT
Received: from us-smtp-delivery-124.mimecast.com
	(us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by mx0b-00069f01.pphosted.com with ESMTP id 3ahvfv91cx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 20 Aug 2021 09:35:40 +0000
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
	[209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-434-18YGFLf6N3uTlLJT0aRa8g-1; Fri, 20 Aug 2021 05:35:38 -0400
X-MC-Unique: 18YGFLf6N3uTlLJT0aRa8g-1
Received: by mail-ed1-f71.google.com with SMTP id
	b16-20020a0564022790b02903be6352006cso4241736ede.15
	for <ocfs2-devel@oss.oracle.com>; Fri, 20 Aug 2021 02:35:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
	:references:organization:user-agent:mime-version
	:content-transfer-encoding;
	bh=iOshKb+VI6w5HeR93LIwfnAK1TNKUlOuLigWenEisc0=;
	b=eAuiGcvtPeTjbwl3WqHvqCp7sIJq5H9/dPKXdn/WyPnaxHa0Dq7N9jUxLcd0iGQrVj
	PGEWHPKpx0E6JsV72eEJX6nIHpUkbNJRyF83U35A2e2ozK5uQEjcZv6Ggbiw54DZlFzn
	pknXtJytadkac9kmEKSeJ9mFTi3GZouD3nuRAoA9+/GYsC9xlriS4AD/uo3BDVksvr2Q
	uUmS9zi5LCaqCl030dCn5OCFNm1LsiqUtN/9bZCuf3KcclH0Vd3rZt+bmJdcRmLM47tC
	0AB1ZdZ5RwpYpwyV83C83mUFOFau/h8KKihjbuz1JQS9CfKLpKo8TtecOAri/gI9XaSA
	6/+Q==
X-Gm-Message-State: AOAM533QkTTwtR9LxTg7rUPhTG/CxhjgCqOgJhpeCYo7cMPHRafPDFFG
	9C3He1mhn5d9Ih7Lu3pgncYPWFbrSvjOfXdLQ2/moruNN/WL6GW3Vlge4AqI3SOiVObDx72c7Tp
	1KXqKSLMN+amPEsLCgClYSA==
X-Received: by 2002:a17:906:1bb1:: with SMTP id
	r17mr20835788ejg.533.1629452137216; 
	Fri, 20 Aug 2021 02:35:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxU0BYwDp21JOo3XDG4R7Z+3mBDO0R4qJcJcDV9AMMuqy6tXSCow7q67PuA08Xb9jrEh8Fr7Q==
X-Received: by 2002:a17:906:1bb1:: with SMTP id
	r17mr20835768ejg.533.1629452136959; 
	Fri, 20 Aug 2021 02:35:36 -0700 (PDT)
Received: from
	0.7.3.c.2.b.0.0.0.3.7.8.9.5.0.2.0.0.0.0.a.d.f.f.0.b.8.0.1.0.0.2.ip6.arpa
	(0.7.3.c.2.b.0.0.0.3.7.8.9.5.0.2.0.0.0.0.a.d.f.f.0.b.8.0.1.0.0.2.ip6.arpa.
	[2001:8b0:ffda:0:2059:8730:b2:c370])
	by smtp.gmail.com with ESMTPSA id r2sm3242450edv.78.2021.08.20.02.35.36
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 20 Aug 2021 02:35:36 -0700 (PDT)
Message-ID: <5e8a20a8d45043e88013c6004636eae5dadc9be3.camel@redhat.com>
From: Steven Whitehouse <swhiteho@redhat.com>
To: Andreas Gruenbacher <agruenba@redhat.com>,
        Linus Torvalds
	<torvalds@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <djwong@kernel.org>
Date: Fri, 20 Aug 2021 10:35:35 +0100
In-Reply-To: <20210819194102.1491495-11-agruenba@redhat.com>
References: <20210819194102.1491495-1-agruenba@redhat.com>
	<20210819194102.1491495-11-agruenba@redhat.com>
Organization: Red Hat UK Ltd
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31)
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=swhiteho@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:103.23.64.2 ip4:103.23.65.2
	ip4:103.23.66.26 ip4:103.23.67.26
	ip4:107.21.15.141 ip4:108.177.8.0/21 ip4:128.17.0.0/20
	ip4:128.17.128.0/20
	ip4:128.17.192.0/20 ip4:128.17.64.0/20 ip4:128.245.0.0/20
	ip4:128.245.64.0/20 ip4:13.110.208.0/21 ip4:13.110.216.0/22
	ip4:13.111.0.0/16 ip4:136.147.128.0/20 ip4:136.147.176.0/20
	include:spf1.redhat.com -all
X-Proofpoint-SPF-VenPass: Allowed
X-Source-IP: 170.10.133.124
X-ServerName: us-smtp-delivery-124.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:103.23.64.2 ip4:103.23.65.2
	ip4:103.23.66.26 ip4:103.23.67.26
	ip4:107.21.15.141 ip4:108.177.8.0/21 ip4:128.17.0.0/20
	ip4:128.17.128.0/20
	ip4:128.17.192.0/20 ip4:128.17.64.0/20 ip4:128.245.0.0/20
	ip4:128.245.64.0/20 ip4:13.110.208.0/21 ip4:13.110.216.0/22
	ip4:13.111.0.0/16 ip4:136.147.128.0/20 ip4:136.147.176.0/20
	include:spf1.redhat.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10081
	signatures=668682
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10081
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
	adultscore=0 bulkscore=0
	suspectscore=0 mlxlogscore=999 phishscore=0 mlxscore=0 spamscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108200053
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
        cluster-devel@redhat.com, linux-fsdevel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [Cluster-devel] [PATCH v6 10/19] gfs2: Introduce
 flag for glock holder auto-demotion
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10081 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108200053
X-Proofpoint-GUID: MVIj_BJblyarBmCVRrpG0WUEGAqeNTyu
X-Proofpoint-ORIG-GUID: MVIj_BJblyarBmCVRrpG0WUEGAqeNTyu

Hi,

On Thu, 2021-08-19 at 21:40 +0200, Andreas Gruenbacher wrote:
> From: Bob Peterson <rpeterso@redhat.com>
> 
> This patch introduces a new HIF_MAY_DEMOTE flag and infrastructure
> that
> will allow glocks to be demoted automatically on locking conflicts.
> When a locking request comes in that isn't compatible with the
> locking
> state of a holder and that holder has the HIF_MAY_DEMOTE flag set,
> the
> holder will be demoted automatically before the incoming locking
> request
> is granted.
> 
I'm not sure I understand what is going on here. When there are locking
conflicts we generate call backs and those result in glock demotion.
There is no need for a flag to indicate that I think, since it is the
default behaviour anyway. Or perhaps the explanation is just a bit
confusing...

> Processes that allow a glock holder to be taken away indicate this by
> calling gfs2_holder_allow_demote().  When they need the glock again,
> they call gfs2_holder_disallow_demote() and then they check if the
> holder is still queued: if it is, they're still holding the glock; if
> it
> isn't, they need to re-acquire the glock.
> 
> This allows processes to hang on to locks that could become part of a
> cyclic locking dependency.  The locks will be given up when a (rare)
> conflicting locking request occurs, and don't need to be given up
> prematurely.
This seems backwards to me. We already have the glock layer cache the
locks until they are required by another node. We also have the min
hold time to make sure that we don't bounce locks too much. So what is
the problem that you are trying to solve here I wonder?

> 
> Signed-off-by: Bob Peterson <rpeterso@redhat.com>
> ---
>  fs/gfs2/glock.c  | 221 +++++++++++++++++++++++++++++++++++++++----
> ----
>  fs/gfs2/glock.h  |  20 +++++
>  fs/gfs2/incore.h |   1 +
>  3 files changed, 206 insertions(+), 36 deletions(-)
> 
> diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
> index f24db2ececfb..d1b06a09ce2f 100644
> --- a/fs/gfs2/glock.c
> +++ b/fs/gfs2/glock.c
> @@ -58,6 +58,7 @@ struct gfs2_glock_iter {
>  typedef void (*glock_examiner) (struct gfs2_glock * gl);
>  
>  static void do_xmote(struct gfs2_glock *gl, struct gfs2_holder *gh,
> unsigned int target);
> +static void __gfs2_glock_dq(struct gfs2_holder *gh);
>  
>  static struct dentry *gfs2_root;
>  static struct workqueue_struct *glock_workqueue;
> @@ -197,6 +198,12 @@ static int demote_ok(const struct gfs2_glock
> *gl)
>  
>  	if (gl->gl_state == LM_ST_UNLOCKED)
>  		return 0;
> +	/*
> +	 * Note that demote_ok is used for the lru process of disposing
> of
> +	 * glocks. For this purpose, we don't care if the glock's
> holders
> +	 * have the HIF_MAY_DEMOTE flag set or not. If someone is using
> +	 * them, don't demote.
> +	 */
>  	if (!list_empty(&gl->gl_holders))
>  		return 0;
>  	if (glops->go_demote_ok)
> @@ -379,7 +386,7 @@ static void do_error(struct gfs2_glock *gl, const
> int ret)
>  	struct gfs2_holder *gh, *tmp;
>  
>  	list_for_each_entry_safe(gh, tmp, &gl->gl_holders, gh_list) {
> -		if (test_bit(HIF_HOLDER, &gh->gh_iflags))
> +		if (!test_bit(HIF_WAIT, &gh->gh_iflags))
>  			continue;
>  		if (ret & LM_OUT_ERROR)
>  			gh->gh_error = -EIO;
> @@ -393,6 +400,40 @@ static void do_error(struct gfs2_glock *gl,
> const int ret)
>  	}
>  }
>  
> +/**
> + * demote_incompat_holders - demote incompatible demoteable holders
> + * @gl: the glock we want to promote
> + * @new_gh: the new holder to be promoted
> + */
> +static void demote_incompat_holders(struct gfs2_glock *gl,
> +				    struct gfs2_holder *new_gh)
> +{
> +	struct gfs2_holder *gh;
> +
> +	/*
> +	 * Demote incompatible holders before we make ourselves
> eligible.
> +	 * (This holder may or may not allow auto-demoting, but we
> don't want
> +	 * to demote the new holder before it's even granted.)
> +	 */
> +	list_for_each_entry(gh, &gl->gl_holders, gh_list) {
> +		/*
> +		 * Since holders are at the front of the list, we stop
> when we
> +		 * find the first non-holder.
> +		 */
> +		if (!test_bit(HIF_HOLDER, &gh->gh_iflags))
> +			return;
> +		if (test_bit(HIF_MAY_DEMOTE, &gh->gh_iflags) &&
> +		    !may_grant(gl, new_gh, gh)) {
> +			/*
> +			 * We should not recurse into do_promote
> because
> +			 * __gfs2_glock_dq only calls handle_callback,
> +			 * gfs2_glock_add_to_lru and
> __gfs2_glock_queue_work.
> +			 */
> +			__gfs2_glock_dq(gh);
> +		}
> +	}
> +}
> +
>  /**
>   * find_first_holder - find the first "holder" gh
>   * @gl: the glock
> @@ -411,6 +452,26 @@ static inline struct gfs2_holder
> *find_first_holder(const struct gfs2_glock *gl)
>  	return NULL;
>  }
>  
> +/**
> + * find_first_strong_holder - find the first non-demoteable holder
> + * @gl: the glock
> + *
> + * Find the first holder that doesn't have the HIF_MAY_DEMOTE flag
> set.
> + */
> +static inline struct gfs2_holder
> +*find_first_strong_holder(struct gfs2_glock *gl)
> +{
> +	struct gfs2_holder *gh;
> +
> +	list_for_each_entry(gh, &gl->gl_holders, gh_list) {
> +		if (!test_bit(HIF_HOLDER, &gh->gh_iflags))
> +			return NULL;
> +		if (!test_bit(HIF_MAY_DEMOTE, &gh->gh_iflags))
> +			return gh;
> +	}
> +	return NULL;
> +}
> +
>  /**
>   * do_promote - promote as many requests as possible on the current
> queue
>   * @gl: The glock
> @@ -425,15 +486,27 @@ __acquires(&gl->gl_lockref.lock)
>  {
>  	const struct gfs2_glock_operations *glops = gl->gl_ops;
>  	struct gfs2_holder *gh, *tmp, *first_gh;
> +	bool incompat_holders_demoted = false;
>  	int ret;
>  
> -	first_gh = find_first_holder(gl);
> +	first_gh = find_first_strong_holder(gl);
>  
>  restart:
>  	list_for_each_entry_safe(gh, tmp, &gl->gl_holders, gh_list) {
> -		if (test_bit(HIF_HOLDER, &gh->gh_iflags))
> +		if (!test_bit(HIF_WAIT, &gh->gh_iflags))
>  			continue;
>  		if (may_grant(gl, first_gh, gh)) {
> +			if (!incompat_holders_demoted) {
> +				demote_incompat_holders(gl, first_gh);
> +				incompat_holders_demoted = true;
> +				first_gh = gh;
> +			}
> +			/*
> +			 * The first holder (and only the first holder)
> on the
> +			 * list to be promoted needs to call the
> go_lock
> +			 * function. This does things like
> inode_refresh
> +			 * to read an inode from disk.
> +			 */
>  			if (gh->gh_list.prev == &gl->gl_holders &&
>  			    glops->go_lock) {
>  				spin_unlock(&gl->gl_lockref.lock);
> @@ -459,6 +532,11 @@ __acquires(&gl->gl_lockref.lock)
>  			gfs2_holder_wake(gh);
>  			continue;
>  		}
> +		/*
> +		 * If we get here, it means we may not grant this
> holder for
> +		 * some reason. If this holder is the head of the list,
> it
> +		 * means we have a blocked holder at the head, so
> return 1.
> +		 */
>  		if (gh->gh_list.prev == &gl->gl_holders)
>  			return 1;
>  		do_error(gl, 0);
> @@ -1373,7 +1451,7 @@ __acquires(&gl->gl_lockref.lock)
>  		if (test_bit(GLF_LOCK, &gl->gl_flags)) {
>  			struct gfs2_holder *first_gh;
>  
> -			first_gh = find_first_holder(gl);
> +			first_gh = find_first_strong_holder(gl);
>  			try_futile = !may_grant(gl, first_gh, gh);
>  		}
>  		if (test_bit(GLF_INVALIDATE_IN_PROGRESS, &gl-
> >gl_flags))
> @@ -1382,7 +1460,8 @@ __acquires(&gl->gl_lockref.lock)
>  
>  	list_for_each_entry(gh2, &gl->gl_holders, gh_list) {
>  		if (unlikely(gh2->gh_owner_pid == gh->gh_owner_pid &&
> -		    (gh->gh_gl->gl_ops->go_type != LM_TYPE_FLOCK)))
> +		    (gh->gh_gl->gl_ops->go_type != LM_TYPE_FLOCK) &&
> +		    !test_bit(HIF_MAY_DEMOTE, &gh2->gh_iflags)))
>  			goto trap_recursive;
>  		if (try_futile &&
>  		    !(gh2->gh_flags & (LM_FLAG_TRY | LM_FLAG_TRY_1CB)))
> {
> @@ -1478,51 +1557,83 @@ int gfs2_glock_poll(struct gfs2_holder *gh)
>  	return test_bit(HIF_WAIT, &gh->gh_iflags) ? 0 : 1;
>  }
>  
> -/**
> - * gfs2_glock_dq - dequeue a struct gfs2_holder from a glock
> (release a glock)
> - * @gh: the glock holder
> - *
> - */
> +static inline bool needs_demote(struct gfs2_glock *gl)
> +{
> +	return (test_bit(GLF_DEMOTE, &gl->gl_flags) ||
> +		test_bit(GLF_PENDING_DEMOTE, &gl->gl_flags));
> +}
>  
> -void gfs2_glock_dq(struct gfs2_holder *gh)
> +static void __gfs2_glock_dq(struct gfs2_holder *gh)
>  {
>  	struct gfs2_glock *gl = gh->gh_gl;
>  	struct gfs2_sbd *sdp = gl->gl_name.ln_sbd;
>  	unsigned delay = 0;
>  	int fast_path = 0;
>  
> -	spin_lock(&gl->gl_lockref.lock);
>  	/*
> -	 * If we're in the process of file system withdraw, we cannot
> just
> -	 * dequeue any glocks until our journal is recovered, lest we
> -	 * introduce file system corruption. We need two exceptions to
> this
> -	 * rule: We need to allow unlocking of nondisk glocks and the
> glock
> -	 * for our own journal that needs recovery.
> +	 * This while loop is similar to function
> demote_incompat_holders:
> +	 * If the glock is due to be demoted (which may be from another
> node
> +	 * or even if this holder is GL_NOCACHE), the weak holders are
> +	 * demoted as well, allowing the glock to be demoted.
>  	 */
> -	if (test_bit(SDF_WITHDRAW_RECOVERY, &sdp->sd_flags) &&
> -	    glock_blocked_by_withdraw(gl) &&
> -	    gh->gh_gl != sdp->sd_jinode_gl) {
> -		sdp->sd_glock_dqs_held++;
> -		spin_unlock(&gl->gl_lockref.lock);
> -		might_sleep();
> -		wait_on_bit(&sdp->sd_flags, SDF_WITHDRAW_RECOVERY,
> -			    TASK_UNINTERRUPTIBLE);
> -		spin_lock(&gl->gl_lockref.lock);
> -	}
> -	if (gh->gh_flags & GL_NOCACHE)
> -		handle_callback(gl, LM_ST_UNLOCKED, 0, false);
> +	while (gh) {
> +		/*
> +		 * If we're in the process of file system withdraw, we
> cannot
> +		 * just dequeue any glocks until our journal is
> recovered, lest
> +		 * we introduce file system corruption. We need two
> exceptions
> +		 * to this rule: We need to allow unlocking of nondisk
> glocks
> +		 * and the glock for our own journal that needs
> recovery.
> +		 */
> +		if (test_bit(SDF_WITHDRAW_RECOVERY, &sdp->sd_flags) &&
> +		    glock_blocked_by_withdraw(gl) &&
> +		    gh->gh_gl != sdp->sd_jinode_gl) {
> +			sdp->sd_glock_dqs_held++;
> +			spin_unlock(&gl->gl_lockref.lock);
> +			might_sleep();
> +			wait_on_bit(&sdp->sd_flags,
> SDF_WITHDRAW_RECOVERY,
> +				    TASK_UNINTERRUPTIBLE);
> +			spin_lock(&gl->gl_lockref.lock);
> +		}
> +
> +		/*
> +		 * This holder should not be cached, so mark it for
> demote.
> +		 * Note: this should be done before the check for
> needs_demote
> +		 * below.
> +		 */
> +		if (gh->gh_flags & GL_NOCACHE)
> +			handle_callback(gl, LM_ST_UNLOCKED, 0, false);
>  
> -	list_del_init(&gh->gh_list);
> -	clear_bit(HIF_HOLDER, &gh->gh_iflags);
> -	if (list_empty(&gl->gl_holders) &&
> -	    !test_bit(GLF_PENDING_DEMOTE, &gl->gl_flags) &&
> -	    !test_bit(GLF_DEMOTE, &gl->gl_flags))
> -		fast_path = 1;
> +		list_del_init(&gh->gh_list);
> +		clear_bit(HIF_HOLDER, &gh->gh_iflags);
> +		trace_gfs2_glock_queue(gh, 0);
> +
> +		/*
> +		 * If there hasn't been a demote request we are done.
> +		 * (Let the remaining holders, if any, keep holding
> it.)
> +		 */
> +		if (!needs_demote(gl)) {
> +			if (list_empty(&gl->gl_holders))
> +				fast_path = 1;
> +			break;
> +		}
> +		/*
> +		 * If we have another strong holder (we cannot auto-
> demote)
> +		 * we are done. It keeps holding it until it is done.
> +		 */
> +		if (find_first_strong_holder(gl))
> +			break;
> +
> +		/*
> +		 * If we have a weak holder at the head of the list, it
> +		 * (and all others like it) must be auto-demoted. If
> there
> +		 * are no more weak holders, we exit the while loop.
> +		 */
> +		gh = find_first_holder(gl);
> +	}
>  
>  	if (!test_bit(GLF_LFLUSH, &gl->gl_flags) && demote_ok(gl))
>  		gfs2_glock_add_to_lru(gl);
>  
> -	trace_gfs2_glock_queue(gh, 0);
>  	if (unlikely(!fast_path)) {
>  		gl->gl_lockref.count++;
>  		if (test_bit(GLF_PENDING_DEMOTE, &gl->gl_flags) &&
> @@ -1531,6 +1642,19 @@ void gfs2_glock_dq(struct gfs2_holder *gh)
>  			delay = gl->gl_hold_time;
>  		__gfs2_glock_queue_work(gl, delay);
>  	}
> +}
> +
> +/**
> + * gfs2_glock_dq - dequeue a struct gfs2_holder from a glock
> (release a glock)
> + * @gh: the glock holder
> + *
> + */
> +void gfs2_glock_dq(struct gfs2_holder *gh)
> +{
> +	struct gfs2_glock *gl = gh->gh_gl;
> +
> +	spin_lock(&gl->gl_lockref.lock);
> +	__gfs2_glock_dq(gh);
>  	spin_unlock(&gl->gl_lockref.lock);
>  }
>  
> @@ -1693,6 +1817,7 @@ void gfs2_glock_dq_m(unsigned int num_gh,
> struct gfs2_holder *ghs)
>  
>  void gfs2_glock_cb(struct gfs2_glock *gl, unsigned int state)
>  {
> +	struct gfs2_holder mock_gh = { .gh_gl = gl, .gh_state = state,
> };
>  	unsigned long delay = 0;
>  	unsigned long holdtime;
>  	unsigned long now = jiffies;
> @@ -1707,6 +1832,28 @@ void gfs2_glock_cb(struct gfs2_glock *gl,
> unsigned int state)
>  		if (test_bit(GLF_REPLY_PENDING, &gl->gl_flags))
>  			delay = gl->gl_hold_time;
>  	}
> +	/*
> +	 * Note 1: We cannot call demote_incompat_holders from
> handle_callback
> +	 * or gfs2_set_demote due to recursion problems like:
> gfs2_glock_dq ->
> +	 * handle_callback -> demote_incompat_holders -> gfs2_glock_dq
> +	 * Plus, we only want to demote the holders if the request
> comes from
> +	 * a remote cluster node because local holder conflicts are
> resolved
> +	 * elsewhere.
> +	 *
> +	 * Note 2: if a remote node wants this glock in EX mode,
> lock_dlm will
> +	 * request that we set our state to UNLOCKED. Here we mock up a
> holder
> +	 * to make it look like someone wants the lock EX locally. Any
> SH
> +	 * and DF requests should be able to share the lock without
> demoting.
> +	 *
> +	 * Note 3: We only want to demote the demoteable holders when
> there
> +	 * are no more strong holders. The demoteable holders might as
> well
> +	 * keep the glock until the last strong holder is done with it.
> +	 */
> +	if (!find_first_strong_holder(gl)) {
> +		if (state == LM_ST_UNLOCKED)
> +			mock_gh.gh_state = LM_ST_EXCLUSIVE;
> +		demote_incompat_holders(gl, &mock_gh);
> +	}
>  	handle_callback(gl, state, delay, true);
>  	__gfs2_glock_queue_work(gl, delay);
>  	spin_unlock(&gl->gl_lockref.lock);
> @@ -2096,6 +2243,8 @@ static const char *hflags2str(char *buf, u16
> flags, unsigned long iflags)
>  		*p++ = 'H';
>  	if (test_bit(HIF_WAIT, &iflags))
>  		*p++ = 'W';
> +	if (test_bit(HIF_MAY_DEMOTE, &iflags))
> +		*p++ = 'D';
>  	*p = 0;
>  	return buf;
>  }
> diff --git a/fs/gfs2/glock.h b/fs/gfs2/glock.h
> index 31a8f2f649b5..9012487da4c6 100644
> --- a/fs/gfs2/glock.h
> +++ b/fs/gfs2/glock.h
> @@ -150,6 +150,8 @@ static inline struct gfs2_holder
> *gfs2_glock_is_locked_by_me(struct gfs2_glock *
>  	list_for_each_entry(gh, &gl->gl_holders, gh_list) {
>  		if (!test_bit(HIF_HOLDER, &gh->gh_iflags))
>  			break;
> +		if (test_bit(HIF_MAY_DEMOTE, &gh->gh_iflags))
> +			continue;
>  		if (gh->gh_owner_pid == pid)
>  			goto out;
>  	}
> @@ -325,6 +327,24 @@ static inline void glock_clear_object(struct
> gfs2_glock *gl, void *object)
>  	spin_unlock(&gl->gl_lockref.lock);
>  }
>  
> +static inline void gfs2_holder_allow_demote(struct gfs2_holder *gh)
> +{
> +	struct gfs2_glock *gl = gh->gh_gl;
> +
> +	spin_lock(&gl->gl_lockref.lock);
> +	set_bit(HIF_MAY_DEMOTE, &gh->gh_iflags);
> +	spin_unlock(&gl->gl_lockref.lock);
> +}
> +
> +static inline void gfs2_holder_disallow_demote(struct gfs2_holder
> *gh)
> +{
> +	struct gfs2_glock *gl = gh->gh_gl;
> +
> +	spin_lock(&gl->gl_lockref.lock);
> +	clear_bit(HIF_MAY_DEMOTE, &gh->gh_iflags);
> +	spin_unlock(&gl->gl_lockref.lock);
> +}
> +
This looks a bit strange... bit operations are atomic anyway, so why do
we need that spinlock here?

Steve.

>  extern void gfs2_inode_remember_delete(struct gfs2_glock *gl, u64
> generation);
>  extern bool gfs2_inode_already_deleted(struct gfs2_glock *gl, u64
> generation);
>  
> diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
> index 5c6b985254aa..e73a81db0714 100644
> --- a/fs/gfs2/incore.h
> +++ b/fs/gfs2/incore.h
> @@ -252,6 +252,7 @@ struct gfs2_lkstats {
>  
>  enum {
>  	/* States */
> +	HIF_MAY_DEMOTE		= 1,
>  	HIF_HOLDER		= 6,  /* Set for gh that "holds" the
> glock */
>  	HIF_WAIT		= 10,
>  };


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
