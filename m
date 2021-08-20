Return-Path: <SRS0=dlQ5=NL=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 918C6C4338F
	for <ocfs2-devel@archiver.kernel.org>; Fri, 20 Aug 2021 19:46:24 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F1A3960F3A
	for <ocfs2-devel@archiver.kernel.org>; Fri, 20 Aug 2021 19:46:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org F1A3960F3A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17KJeegA031737;
	Fri, 20 Aug 2021 19:46:23 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3aje2j0qnp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Aug 2021 19:46:23 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17KJjEWE167761;
	Fri, 20 Aug 2021 19:46:22 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3aeqm2bfup-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 20 Aug 2021 19:46:21 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mHAT6-0005BS-Qk; Fri, 20 Aug 2021 12:46:20 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <viro@ftp.linux.org.uk>) id 1mHAT4-0005B1-3L
	for ocfs2-devel@oss.oracle.com; Fri, 20 Aug 2021 12:46:18 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17KJj8Aj155857
	for <ocfs2-devel@oss.oracle.com>; Fri, 20 Aug 2021 19:46:18 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by aserp3030.oracle.com with ESMTP id 3ae3vp4vwb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 20 Aug 2021 19:46:16 +0000
Received: from pps.filterd (m0246577.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	17KJhZTp023588
	for <ocfs2-devel@oss.oracle.com>; Fri, 20 Aug 2021 19:46:16 GMT
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [142.44.231.140])
	by mx0b-00069f01.pphosted.com with ESMTP id 3aj0qknd8p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Fri, 20 Aug 2021 19:46:15 +0000
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red
	Hat Linux)) id 1mHASE-00ESrA-C0; Fri, 20 Aug 2021 19:45:26 +0000
Date: Fri, 20 Aug 2021 19:45:26 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Jeff Layton <jlayton@kernel.org>
Message-ID: <YSAGVsTOc/Fw0x8l@zeniv-ca.linux.org.uk>
References: <20210820163919.435135-1-jlayton@kernel.org>
	<20210820163919.435135-3-jlayton@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210820163919.435135-3-jlayton@kernel.org>
X-Source-IP: 142.44.231.140
X-ServerName: zeniv-ca.linux.org.uk
X-Proofpoint-SPF-Result: None
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10082
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
	priorityscore=156 malwarescore=0
	bulkscore=0 mlxlogscore=999 clxscore=279 adultscore=0 mlxscore=0
	phishscore=0 lowpriorityscore=0 spamscore=0 impostorscore=0
	suspectscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000
	definitions=main-2108200111 domainage_hfrom=9150
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10082
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
	adultscore=0 mlxscore=0
	malwarescore=0 mlxlogscore=999 spamscore=0 bulkscore=0 phishscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108200111
Cc: bfields@fieldses.org, linux-nfs@vger.kernel.org, david@redhat.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        cluster-devel@redhat.com, linux-mm@kvack.org, rostedt@goodmis.org,
        ebiederm@xmission.com, luto@kernel.org, linux-fsdevel@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net, torvalds@linux-foundation.org,
        linux-afs@lists.infradead.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v3 2/2] fs: remove mandatory file locking
	support
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10082 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108200111
X-Proofpoint-GUID: oJ6R9EW1sSgzkhOeIw5xoRcR0e2yyxHu
X-Proofpoint-ORIG-GUID: oJ6R9EW1sSgzkhOeIw5xoRcR0e2yyxHu

On Fri, Aug 20, 2021 at 12:39:19PM -0400, Jeff Layton wrote:

> diff --git a/fs/locks.c b/fs/locks.c

> @@ -2857,8 +2744,7 @@ static void lock_get_status(struct seq_file *f, struct file_lock *fl,
>  			seq_puts(f, "POSIX ");
>  
>  		seq_printf(f, " %s ",
> -			     (inode == NULL) ? "*NOINODE*" :
> -			     mandatory_lock(inode) ? "MANDATORY" : "ADVISORY ");
> +			     (inode == NULL) ? "*NOINODE*" : "ADVISORY ");

Huh?

<looks>
        if (fl->fl_file != NULL)
		inode = locks_inode(fl->fl_file);

So basically that's fl->fl_file ? "ADVISORY" : "*NOINODE*"?

How could that trigger, though?  With locks_mandatory_area() gone, I don't
see how FL_POSIX file_lock with NULL ->fl_file could be ever found...
Confused...

Why is locks_copy_conflock() exported (hell, non-static), BTW?

> diff --git a/fs/namespace.c b/fs/namespace.c


> -#ifdef	CONFIG_MANDATORY_FILE_LOCKING
> -static bool may_mandlock(void)
> +static void warn_mandlock(void)
>  {
> -	pr_warn_once("======================================================\n"
> -		     "WARNING: the mand mount option is being deprecated and\n"
> -		     "         will be removed in v5.15!\n"
> -		     "======================================================\n");
> -	return capable(CAP_SYS_ADMIN);
> +	pr_warn_once("=======================================================\n"
> +		     "WARNING: The mand mount option has been deprecated and\n"
> +		     "         and is ignored by this kernel. Remove the mand\n"
> +		     "         option from the mount to silence this warning.\n"
> +		     "=======================================================\n");
>  }
> -#else
> -static inline bool may_mandlock(void)
> -{
> -	pr_warn("VFS: \"mand\" mount option not supported");
> -	return false;
> -}
> -#endif

Is there any point in having the previous patch not folded into this one?

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
