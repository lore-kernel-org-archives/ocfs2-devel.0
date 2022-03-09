Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8E91C433F5
	for <ocfs2-devel@archiver.kernel.org>; Wed,  9 Mar 2022 07:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=L39zC1tjz+qkfs6Pv0gBEq0JGW/3Znt8ZCr9L2eZBiE=;
 b=XOgkWJWDIL4tJ+9DxbpqZBHt3QWBoTDKRQQgxct78mqYlEVaCxPxzjF4DAa+9Pe1jRg8fZX8gAJq
   uSTVwM7Sz2oPCoyc5cWXRRWl8ubs2ay7oe/z5vwFgOrKhPRku9mJChsJtLtKkYXxGOTICm8sOplf
   xxYfQue7Wqb40xXOsAia2kSfIf+ivfaIz4LrdOAY1LeRLKhf008/rVP+qAvhD18Uzg+4bjQceh0e
   QgyYcAa9DXJNwcW1wB6Q1ifNz7zPUi4Qd1tT6Zmqkm8Z5Ov+E6u29LNzklKTECZqPT+1SVCfqfHx
   cNtdyiiCbmPShcu6bnyanvRFsllqeruLteYfMQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=L39zC1tjz+qkfs6Pv0gBEq0JGW/3Znt8ZCr9L2eZBiE=;
 b=Wy2v6DNmoeQomx5kFMoJyqY/+Z+BaMVC5qcASVv009ZTS62n/LwmizSPifJA0Q2OMD3RqgQ0gyOD
   skSkfGam1y2giY2+o0k9/ZBLgZlG1ofR2n57nuOjDqEb8DC9UJyGbXtKEkG8r/WXZwwytikJJmby
   u7T3zdHgZLjNTEwylVNR/EKAExoO6ERNFBSnRtMXlN34KZ7hDjN0Ss68Njy2arqosTQnFNUT5V7l
   L2RDfzbSMf4jtkaxFtQ2czqnRNFndTf74tvWdsv3W6ynLgqSRteribqvqMLRwevQcm9dGXUzfs7U
   eKu3ElnOeCDL4Z89ZHZuI8TeoUrHSaeUmYUGfA==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220222 64bit (built Feb 22
 2022))
 with ESMTPS id <0R8G00FRFW9G3810@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 09 Mar 2022 07:46:28 +0000 (GMT)
Authentication-results: aserp3010.oracle.com; spf=softfail
 smtp.mailfrom=jiangqi903@gmail.com; dkim=pass header.s=20210112
 header.d=gmail.com; dmarc=pass header.from=gmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=message-id:date:mime-version:user-agent:subject:content-language:to
 :cc:references:from:in-reply-to:content-transfer-encoding;
 bh=PFXd3cAFyqQfHsH4RcxhTWYR8h4MdYvNbCJiC4ZU2oo=;
 b=ZK6ZeGa5hl3tn/W9/fBQSr7ZoIe5w7oiHPN+mzafGyuPvgBFnpgw9yWK+38gQy7cLF
 8VsD67Zs2BFoxegWhhSxs7e7Xj60H95cS4XcqdUGM7QBatSAWwFlioonr5970fSt1kmB
 Lc5mxVwrD+t2QJMOZIK5ykkLXC6h5zReIS6TOTr+lIyM0sXGwh+We95XcUrVEreewoIb
 fKX3CMpyj1GVAbfVpzUe4I//0l1/35ylC0hrOVNl3oMIcvr7btKNdzR64Cq7/C4yb3Zt
 oA6BWgWZ1YQdUYf5Lj1MmUi0NyJHWjifIEeblfpTvlutyWXmJwBPqP/38lKXc3u9G4Je XLZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding; bh=PFXd3cAFyqQfHsH4RcxhTWYR8h4MdYvNbCJiC4ZU2oo=;
 b=uz4SMP7oMhH2q8o7VqV9p4AKn8gm7kL1EHdXoEIccdzKi3xljb1Qcrch1qsjiNi8hA
 MRoch/FpupdfOFpto69zAuy42/cFVp7CEWVK1eYNPXFLkjMMOzjnZMbhs1NwLbIsyUxm
 hNb0UA/WMn5YS487ey6ON0iqDFIOWv4ghsuIVm4w4p7YHCUQk9FCZIjfCtTyTm4BgQGt
 /R+bQ/vEMognltC40t9fFRehtmtI0ioLQEzTqZshyS9eJe3757dKoyxoI6fcHZsKgZiX
 kFvDyez7fJ+IOp7173zRt0hcVMrkt175t9z/ZiDKsPN/bcaqXP52f+gY/t8GOOlpMaIp EUIA==
X-Gm-Message-State: AOAM530/oZhkgQtIlXCqeOAbLDG6rLnj/ubZ3cvVff7uIF6VIloSZe5s
 GPuxrqoc2wGirzzppm0UneO5VqTo/h8=
X-Received: by 2002:a63:ea53:0:b0:341:a28e:16b9 with SMTP id
 l19-20020a63ea53000000b00341a28e16b9mr17517707pgk.259.1646811976356; Tue,
 08 Mar 2022 23:46:16 -0800 (PST)
Message-id: <82b26a4a-2351-f2b3-dd7c-265308e6b384@gmail.com>
Date: Wed, 9 Mar 2022 15:46:11 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Content-language: en-US
To: Dan Carpenter <dan.carpenter@oracle.com>, ocfs2-devel@oss.oracle.com
References: <20220307145138.GA22641@kili>
In-reply-to: <20220307145138.GA22641@kili>
X-Source-IP: 209.85.215.178
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10280
 signatures=690848
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 priorityscore=349 suspectscore=0 phishscore=0 spamscore=0
 malwarescore=0 impostorscore=0 adultscore=0 mlxlogscore=999 clxscore=144
 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203090040 domainage_hfrom=9705
Cc: Jakob Koschel <jakobkoschel@gmail.com>
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
From: Joseph Qi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Joseph Qi <jiangqi903@gmail.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Google-Smtp-Source:
 ABdhPJznvNc9NUdAH89HGWwTpZ04qfMhuJR47IAvJNq57DfQGUTcd3NU8h9N4tb24uD+laiT+zCRWw==
X-ServerName: mail-pg1-f178.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 redirect=_spf.google.com
X-Spam: Clean
X-Proofpoint-ORIG-GUID: G4_mtnv8_Q3ZqfdIQkuocD-GY4-RgY79
X-Proofpoint-GUID: G4_mtnv8_Q3ZqfdIQkuocD-GY4-RgY79
Reporting-Meta:
 AAGni7Y1lCYVInAXfjvjIZNQZLpWO53KxvaEmgJyFb4FN5tPO5PVgagaxDErCPo6
 rFEyNLpqJWRLOONSqLUgsDqCFBz5T/Mleh5iA8pRuhyk9i4Ra7cG31IEEQ3jLlQy
 0Bzug77xE4W7qpJYBvZChePMQXSLDVYGw6puWqFo8ODOKm+lU2BI1u1lyE8z/Qqw
 xGDFl78H/m9GyeWFQ+KVye53XOvzni3Sp70U3IfpgFyM+0BgVa9N6VR7QHopffSg
 cTPBfjmPUGe1EwTkKWek8mMdAacl5Q+jNGEvJ/ot1L69CwAWv6Ss2g1bqVlVKAan
 KrbWD5BrTnad4hknlUYqio2128qHumiFEt8NyX+RC3I46GFq0n3A0K+TYe7knAQE
 rgTmf8L/eTPfFDHvpbJwczew1l96X7fgFdMSD25Y0RK32OtHxAfrOYP7p3Dfd+bA
 C3Ep++0ShYKtL1fe4WTZqjQ57uRNWYnBLxTwG7RwWAjI8svwzqle8T4/kJ6LEaBc
 AnSDXKxBectwMEG4MdrYkeqP321UeFvesgytoShtKI1H



On 3/7/22 10:51 PM, Dan Carpenter via Ocfs2-devel wrote:
> Hello OCFS Devs,
> 
> There is a big push to re-write list_for_each_entry() so that you
> can't use the list iterator outside the loop.  I wrote a check for that
> but this code has me puzzled.
> 
> The patch b0d4f817ba5d: "ocfs2/dlm: Fix race in adding/removing
> lockres' to/from the tracking list" from Dec 16, 2008, leads to the
> following Smatch static checker warning:
> 
> 	fs/ocfs2/dlm/dlmdebug.c:573 lockres_seq_start()
> 	warn: iterator used outside loop: 'res'
> 
> fs/ocfs2/dlm/dlmdebug.c
>     539 static void *lockres_seq_start(struct seq_file *m, loff_t *pos)
>     540 {
>     541         struct debug_lockres *dl = m->private;
>     542         struct dlm_ctxt *dlm = dl->dl_ctxt;
>     543         struct dlm_lock_resource *oldres = dl->dl_res;
>     544         struct dlm_lock_resource *res = NULL;
>     545         struct list_head *track_list;
>     546 
>     547         spin_lock(&dlm->track_lock);
>     548         if (oldres)
>     549                 track_list = &oldres->tracking;
>     550         else {
>     551                 track_list = &dlm->tracking_list;
>     552                 if (list_empty(track_list)) {
>     553                         dl = NULL;
>     554                         spin_unlock(&dlm->track_lock);
>     555                         goto bail;
>     556                 }
> 
> Why not do the list_empty() check after the else statement.  In the
> current code if "&oldres->tracking" is empty it will lead to a crash.
> 
lockres will be added into tracking_list during initialize.


>     557         }
>     558 
>     559         list_for_each_entry(res, track_list, tracking) {
>     560                 if (&res->tracking == &dlm->tracking_list)
>                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> This should never be possible.  How is it possible?  If
> &dlm->tracking_list is the list head the it's not possible without
> memory corruption.  If &oldres->tracking is the list head then I do not
> see how it is possible without memory corruption.  We can't mix different
> types of list entries on the same list head?>
In case of oldres, and the iterator points to dlm_ctxt.
In this case, the lockres is not a valid one.
 
>     561                         res = NULL;
>     562                 else
>     563                         dlm_lockres_get(res);
>     564                 break;
> 
> If we using list_first_entry() instead of open coding it then this
> function becomes a lot simpler.  See patch below:
> 
>     565         }
>     566         spin_unlock(&dlm->track_lock);
>     567 
>     568         if (oldres)
>     569                 dlm_lockres_put(oldres);
>     570 
>     571         dl->dl_res = res;
>     572 
> --> 573         if (res) {
>     574                 spin_lock(&res->spinlock);
> 
> Here is where the crash would happen if the &oldres->tracking list is
> empty.
> 
>     575                 dump_lockres(res, dl->dl_buf, dl->dl_len - 1);
>     576                 spin_unlock(&res->spinlock);
>     577         } else
>     578                 dl = NULL;
>     579 
>     580 bail:
>     581         /* passed to seq_show */
>     582         return dl;
>     583 }
> 
> Here is a patch which removes the "if (&res->tracking == &dlm->tracking_list)"
> and uses list_first_entry_or_null().  It removes 13 lines of code.
> 
> regards,
> dan carpenter
> 
> ---
>  fs/ocfs2/dlm/dlmdebug.c | 29 ++++++++---------------------
>  1 file changed, 8 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
> index d442cf5dda8a..fb61cdfe0d06 100644
> --- a/fs/ocfs2/dlm/dlmdebug.c
> +++ b/fs/ocfs2/dlm/dlmdebug.c
> @@ -547,37 +547,24 @@ static void *lockres_seq_start(struct seq_file *m, loff_t *pos)
>  	spin_lock(&dlm->track_lock);
>  	if (oldres)
>  		track_list = &oldres->tracking;
> -	else {
> +	else
>  		track_list = &dlm->tracking_list;
> -		if (list_empty(track_list)) {
> -			dl = NULL;
> -			spin_unlock(&dlm->track_lock);
> -			goto bail;
> -		}
> -	}
>  
> -	list_for_each_entry(res, track_list, tracking) {
> -		if (&res->tracking == &dlm->tracking_list)
> -			res = NULL;
> -		else
> -			dlm_lockres_get(res);
> -		break;
> -	}
> +	res = list_first_entry_or_null(track_list, struct dlm_lock_resource,
> +				       tracking);
>  	spin_unlock(&dlm->track_lock);
> +	if (!res)
> +		return NULL;
>  
>  	if (oldres)
>  		dlm_lockres_put(oldres);
>  
>  	dl->dl_res = res;
>  
> -	if (res) {
> -		spin_lock(&res->spinlock);
> -		dump_lockres(res, dl->dl_buf, dl->dl_len - 1);
> -		spin_unlock(&res->spinlock);
> -	} else
> -		dl = NULL;
> +	spin_lock(&res->spinlock);
> +	dump_lockres(res, dl->dl_buf, dl->dl_len - 1);
> +	spin_unlock(&res->spinlock);
>  
> -bail:
>  	/* passed to seq_show */
>  	return dl;
>  }

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
